from aws_cdk import Stack, RemovalPolicy
from aws_cdk import aws_lambda as _lambda
from aws_cdk import aws_iam as iam
from aws_cdk import aws_s3 as s3
from aws_cdk import aws_cloudfront as cloudfront
from aws_cdk import aws_cloudfront_origins as origins
from aws_cdk import aws_certificatemanager as acm
from aws_cdk import aws_s3_deployment as s3_deployment
from constructs import Construct


class ContentNegotiationStack(Stack):

    def __init__(self, scope: Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

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

        lambda_edge_function = _lambda.Function(
            self,
            "LambdaContentNegotiation",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="index.handler",
            code=_lambda.Code.from_asset("lambda_code"),
            role=lambda_edge_role,
        )

        lambda_edge_alias = _lambda.Alias(
            self,
            "LambdaEdgeAlias",
            alias_name="live",
            version=lambda_edge_function.current_version,
        )

        site_bucket = s3.Bucket(
            self,
            "SiteBucket",
            encryption=s3.BucketEncryption.S3_MANAGED,
            block_public_access=s3.BlockPublicAccess.BLOCK_ALL,
            removal_policy=RemovalPolicy.DESTROY,
            server_access_logs_bucket=s3.Bucket(self, "LogsBucket"),
        )

        origin_access_identity = cloudfront.OriginAccessIdentity(
            self, "OAI", comment="Connects CF with S3"
        )

        site_bucket.grant_read(origin_access_identity)

        certificate = acm.Certificate(
            self,
            "SiteCertificate",
            domain_name="registry.ib1.org",
            validation=acm.CertificateValidation.from_dns(),
        )

        distribution = cloudfront.Distribution(
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
            domain_names=["registry.ib1.org"],
            certificate=certificate,
        )

        s3_deployment.BucketDeployment(
            self,
            "DeployWebsite",
            sources=[s3_deployment.Source.asset("../output")],
            destination_bucket=site_bucket,
            distribution=distribution,
            distribution_paths=["/*"],
        )
