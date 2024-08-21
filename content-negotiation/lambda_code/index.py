def handler(event, context):
    # Extract the request details
    request = event["Records"][0]["cf"]["request"]
    headers = request["headers"]

    # Default to HTML if no Accept header is present
    accept_header = headers.get("accept", [{"value": "text/html"}])[0]["value"]

    # Determine the content type based on the Accept header
    if "application/ld+json" in accept_header:
        content_type = "application/ld+json"
        file_extension = ".jsonld"
    elif "text/turtle" in accept_header:
        content_type = "text/turtle"
        file_extension = ".ttl"
    elif "application/xml" in accept_header or "text/xml" in accept_header:
        content_type = "application/xml"
        file_extension = ".xml"
    else:
        content_type = "text/html"
        file_extension = ".html"

    # Modify the URI to point to the correct file extension
    request["uri"] = request["uri"] + file_extension

    # Add headers to the request object
    request["headers"]["content-type"] = [
        {"key": "Content-Type", "value": content_type}
    ]
    request["headers"]["vary"] = [{"key": "Vary", "value": "Accept"}]

    # Return the modified request to be sent to the origin (S3)
    return request
