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
        domain_name = self.node.try_get_context("domainName") or "registry.ib1.org"
        folder_path = self.node.try_get_context("folderPath") or "output"
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
            domain_name=domain_name,
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
            domain_names=[domain_name],
            certificate=certificate,
        )

        # Deploy .rdf files with specific content type
        s3_deployment.BucketDeployment(
            self,
            "DeployRdfFiles",
            destination_bucket=site_bucket,
            sources=[s3_deployment.Source.asset(f"../{folder_path}")],
            include=["../*.rdf", "../**/*.rdf"],
            content_type="application/rdf+xml",  # Apply Content-Type to all deployed files
            metadata={
                "Content-Type": "application/rdf+xml"
            },  # Apply metadata to all deployed files
            distribution=distribution,
            distribution_paths=["/*"],
        )
        s3_deployment.BucketDeployment(
            self,
            "DeployJsonLdFiles",
            destination_bucket=site_bucket,
            sources=[s3_deployment.Source.asset(f"../{folder_path}")],
            include=["../*.jsonld", "../**/*.jsonld"],
            content_type="application/ld+json",  # Apply Content-Type to all deployed files
            metadata={
                "Content-Type": "application/ld+json"
            },  # Apply metadata to all deployed files
            distribution=distribution,
            distribution_paths=["/*"],
        )
        s3_deployment.BucketDeployment(
            self,
            "DeployTurtleFiles",
            destination_bucket=site_bucket,
            sources=[s3_deployment.Source.asset(f"../{folder_path}")],
            include=["../*.ttl", "../**/*.ttl"],
            content_type="text/turtle",  # Apply Content-Type to all deployed files
            metadata={
                "Content-Type": "text/turtle"
            },  # Apply metadata to all deployed files
            distribution=distribution,
            distribution_paths=["/*"],
        )

        # Deploy other files with default content type or different metadata
        s3_deployment.BucketDeployment(
            self,
            "DeployOtherFiles",
            destination_bucket=site_bucket,
            sources=[s3_deployment.Source.asset(f"../{folder_path}")],
            exclude=[
                "../*.rdf",
                "../**/*.rdf",
                "../*.ttl",
                "../**/*.ttl",
                "../*.jsonld",
                "../**/*.jsonld",
            ],
            distribution=distribution,
            distribution_paths=["/*"],
        )
