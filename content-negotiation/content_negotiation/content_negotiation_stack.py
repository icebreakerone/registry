from aws_cdk import (
    Stack,
    aws_s3 as s3,
    aws_cloudfront as cloudfront,
    aws_cloudfront_origins as origins,
    aws_lambda as _lambda,
    RemovalPolicy,
)
from constructs import Construct


class ContentNegotiationStack(Stack):

    def __init__(
        self,
        scope: Construct,
        construct_id: str,
        lambda_edge_alias: _lambda.Alias,
        **kwargs,
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # S3 Bucket to store the static site
        site_bucket = s3.Bucket(
            self,
            "SiteBucket",
            encryption=s3.BucketEncryption.S3_MANAGED,
            block_public_access=s3.BlockPublicAccess.BLOCK_ALL,
            versioned=False,
            removal_policy=RemovalPolicy.DESTROY,
            server_access_logs_bucket=s3.Bucket(self, "LogsBucket"),
        )
        # Define an Origin Access Identity (OAI)
        origin_access_identity = cloudfront.OriginAccessIdentity(
            self, "OAI", comment="Connects CF with S3"
        )

        # Add a policy to the bucket to allow CloudFront OAI to access it
        site_bucket.grant_read(origin_access_identity)

        # CloudFront distribution
        cloudfront.Distribution(
            self,
            "SiteDistribution",
            default_root_object="index.html",
            default_behavior=cloudfront.BehaviorOptions(
                origin=origins.S3Origin(
                    site_bucket, origin_access_identity=origin_access_identity
                ),
                edge_lambdas=[
                    cloudfront.EdgeLambda(
                        function_version=lambda_edge_alias.version,
                        event_type=cloudfront.LambdaEdgeEventType.VIEWER_REQUEST,
                    )
                ],
                viewer_protocol_policy=cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
            ),
        )
