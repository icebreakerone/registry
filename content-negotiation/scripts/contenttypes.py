import boto3
import argparse

# Define a mapping of file extensions to content types
CONTENT_TYPE_MAPPING = {
    ".rdf": "application/rdf+xml",
    ".ttl": "text/turtle",
    ".jsonld": "application/ld+json",
    ".txt": "text/plain",
    ".html": "text/html",
}


def get_outputs_from_stack(stack_name: str, region_name: str = "us-east-1"):
    """
    Get the outputs from a CloudFormation stack.
    """
    cf = boto3.client("cloudformation", region_name)
    response = cf.describe_stacks(StackName=stack_name)
    outputs = {
        output["OutputKey"]: output["OutputValue"]
        for output in response["Stacks"][0]["Outputs"]
    }
    return outputs


def update_content_type(bucket_name):
    """Update the Content-Type of files in an S3 bucket based on their extension."""
    s3 = boto3.client("s3")

    # List all objects in the bucket
    paginator = s3.get_paginator("list_objects_v2")
    for page in paginator.paginate(Bucket=bucket_name):
        if "Contents" not in page:
            continue

        for obj in page["Contents"]:
            key = obj["Key"]
            # Determine the appropriate Content-Type
            for extension, content_type in CONTENT_TYPE_MAPPING.items():
                if key.endswith(extension):
                    print(f"Updating Content-Type for {key} to {content_type}")
                    # Copy the object to itself with updated metadata
                    s3.copy_object(
                        Bucket=bucket_name,
                        Key=key,
                        CopySource={"Bucket": bucket_name, "Key": key},
                        MetadataDirective="REPLACE",
                        ContentType=content_type,
                        Metadata={},
                    )
                    break


def create_invalidation(distribution_id, paths=["/*"]):
    cloudfront = boto3.client("cloudfront")

    response = cloudfront.create_invalidation(
        DistributionId=distribution_id,
        InvalidationBatch={
            "Paths": {"Quantity": len(paths), "Items": paths},
            "CallerReference": str(
                hash(tuple(paths))
            ),  # Unique reference for this invalidation
        },
    )


def update_for_stack(stack_name):
    outputs = get_outputs_from_stack(stack_name)
    update_content_type(outputs["SiteBucketName"])
    create_invalidation(outputs["CloudFrontDistributionId"], ["/*"])


if __name__ == "__main__":
    argparser = argparse.ArgumentParser()
    argparser.add_argument("stack_name", help="Name of the CloudFormation stack")
    args = argparser.parse_args()
    update_for_stack(args.stack_name)
    # update_for_stack("ContentNegotiationStack-production-root")
    # update_for_stack("ContentNegotiationStack-pilot-core")
