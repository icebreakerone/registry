from aws_cdk import (
    Stack,
    aws_lambda as _lambda,
    aws_iam as iam,
    aws_s3 as s3,
    aws_cloudfront as cloudfront,
    aws_s3_deployment as s3_deployment,
    aws_cloudfront_origins as origins,
    aws_certificatemanager as acm,
    RemovalPolicy,
)

from constructs import Construct


class ContentNegotiationStack(Stack):

    def __init__(
        self,
        scope: Construct,
        construct_id: str,
        **kwargs,
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)
        lambda_edge_role = iam.Role(
            self,
            "LambdaEdgeRole",
            assumed_by=iam.ServicePrincipal("lambda.amazonaws.com"),
            managed_policies=[
                iam.ManagedPolicy.from_aws_managed_policy_name(
                    "service-role/AWSLambdaBasicExecutionRole"
                )
            ],
        )

        self.lambda_edge_function = _lambda.Function(
            self,
            "LambdaContentNegotiation",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="index.handler",
            code=_lambda.Code.from_asset("lambda_code"),
            role=lambda_edge_role,
        )
        # Create a version of the Lambda function
        self.lambda_edge_version = self.lambda_edge_function.current_version
        # Create an alias for the Lambda function
        self.lambda_edge_alias = _lambda.Alias(
            self,
            "LambdaEdgeAlias",
            alias_name="live",
            version=self.lambda_edge_function.current_version,
        )

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

        # Request an SSL certificate for the domain
        certificate = acm.Certificate(
            self,
            "SiteCertificate",
            domain_name="registry.ib1.org",
            validation=acm.CertificateValidation.from_dns(),  # Validates using DNS
        )

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
                        function_version=self.lambda_edge_alias.version,
                        event_type=cloudfront.LambdaEdgeEventType.VIEWER_REQUEST,
                    )
                ],
                viewer_protocol_policy=cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
            ),
            domain_names=["registry.ib1.org"],  # Custom domain name
            certificate=certificate,  # Attach the ACM certificate
        )
        s3_deployment.BucketDeployment(
            self,
            "DeployWebsite",
            sources=[s3_deployment.Source.asset("./output")],  # Path to local files
            destination_bucket=site_bucket,
            distribution=cloudfront.Distribution,  # Optional: Invalidate CloudFront cache if necessary
            distribution_paths=["/*"],  # Optional: Specify paths to invalidate
        )
