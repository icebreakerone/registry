from aws_cdk import (
    Stack,
    RemovalPolicy,
    CfnOutput,
    aws_lambda as _lambda,
    aws_iam as iam,
    aws_s3 as s3,
    aws_cloudfront as cloudfront,
    aws_cloudfront_origins as origins,
    aws_certificatemanager as acm,
    aws_s3_deployment as s3_deployment,
    aws_route53 as route53,
    aws_route53_targets as targets,
)
from constructs import Construct


class ContentNegotiationStack(Stack):

    def __init__(self, scope: Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)
        domain_name = (
            self.node.try_get_context("domainName") or "registry.trust.ib1.org"
        )
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

        hosted_zone = route53.HostedZone.from_lookup(
            self, "HostedZone", domain_name="trust.ib1.org"
        )

        route53.ARecord(
            self,
            "SiteAliasRecord",
            record_name=domain_name,
            target=route53.RecordTarget.from_alias(
                targets.CloudFrontTarget(distribution)
            ),
            zone=hosted_zone,
        )

        # Deploy all files

        s3_deployment.BucketDeployment(
            self,
            "DeployOtherFiles",
            destination_bucket=site_bucket,
            sources=[s3_deployment.Source.asset(f"../{folder_path}")],
            distribution=distribution,
            distribution_paths=["/*"],
        )

        # Outputs
        CfnOutput(
            self,
            "SiteBucketName",
            value=site_bucket.bucket_name,
            description="Name of the S3 bucket for the site",
        )

        CfnOutput(
            self,
            "CloudFrontDistributionId",
            value=distribution.distribution_id,
            description="ID of the CloudFront distribution",
        )

        CfnOutput(
            self,
            "CloudFrontDomainName",
            value=distribution.distribution_domain_name,
            description="Domain name of the CloudFront distribution",
        )
