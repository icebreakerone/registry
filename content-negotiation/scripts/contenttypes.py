import boto3

# Define a mapping of file extensions to content types
CONTENT_TYPE_MAPPING = {
    ".rdf": "application/rdf+xml",
    ".ttl": "text/turtle",
    ".jsonld": "application/ld+json",
    ".txt": "text/plain",
    ".html": "text/html",
}


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

    print("Invalidation created:")
    print(response)


if __name__ == "__main__":
    """
    To use with a deployment, make this work with the bucket name and distribution ID exported from the stack.
    """
    core_distribution = "E2AF0MERI34NYN"
    core_bucket = "contentnegotiationstack-pilot-c-sitebucket397a1860-5opqne0jjnwb"
    root_distribution = "ETH1GEJK83GPD"
    root_bucket = "contentnegotiationstack-product-sitebucket397a1860-qcqrn5evowzy"

    update_content_type(core_bucket)
    # aws cloudfront create-invalidation --distribution-id ETH1GEJK83GPD --paths "/*"
    create_invalidation(core_distribution, ["/*"])
