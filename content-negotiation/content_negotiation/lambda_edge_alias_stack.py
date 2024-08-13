# Lambda@Edge function for content negotiation

from aws_cdk import Stack, aws_lambda as _lambda, aws_iam as iam, CfnOutput
from constructs import Construct


class LambdaEdgeAliasStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
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
            code=_lambda.Code.from_asset("lambda"),
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
