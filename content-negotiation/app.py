#!/usr/bin/env python3
import os

import aws_cdk as cdk

from content_negotiation.content_negotiation_stack import ContentNegotiationStack

app = cdk.App()

ContentNegotiationStack(
    app,
    "ContentNegotiationStack",
    env=cdk.Environment(account=os.getenv("CDK_DEFAULT_ACCOUNT"), region="us-east-1"),
)

app.synth()
