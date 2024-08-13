#!/usr/bin/env python3
import os

import aws_cdk as cdk

from content_negotiation.content_negotiation_stack import ContentNegotiationStack
from content_negotiation.lambda_edge_alias_stack import LambdaEdgeAliasStack

app = cdk.App()
lambda_edge_alias_stack = LambdaEdgeAliasStack(
    app,
    "LambdaEdgeAliasStack",
    env=cdk.Environment(account=os.getenv("CDK_DEFAULT_ACCOUNT"), region="us-east-1"),
)

lambda_edge_alias = lambda_edge_alias_stack.lambda_edge_alias

ContentNegotiationStack(
    app,
    "ContentNegotiationStack",
    lambda_edge_alias=lambda_edge_alias,
    env=cdk.Environment(
        account=os.getenv("CDK_DEFAULT_ACCOUNT"), region=os.getenv("CDK_DEFAULT_REGION")
    ),
    cross_region_references=True,
)

app.synth()
