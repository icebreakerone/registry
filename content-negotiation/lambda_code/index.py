import re


def _has_extension(text: str) -> bool:
    """
    Matches "styles.css", "1.0.jsonld", "file.rdf"
    Does not match /ns/1.0
    """
    pattern = r"\.[a-zA-Z]{2,}$"
    return bool(re.search(pattern, text))


def handler(event, context):
    # Extract the request details
    request = event["Records"][0]["cf"]["request"]
    headers = request["headers"]
    print(f"Request URI: {request['uri']}")
    print(
        f"Accept header: {headers.get('accept', [{'value': 'text/html'}])[0]['value']}"
    )
    # Default to HTML if no Accept header is present
    accept_header = headers.get("accept", [{"value": "text/html"}])[0]["value"]
    # If the file extension in request['uri'] is present, return the request as is
    if _has_extension(request["uri"]):
        if request["uri"].endswith(".css"):
            request["headers"]["content-type"] = [
                {"key": "Content-Type", "value": "text/css"}
            ]
        return request
    if request["uri"] == "/":
        request["uri"] = "/index"
    # Determine the content type based on the Accept header
    if "application/ld+json" in accept_header:
        content_type = "application/ld+json"
        file_extension = ".jsonld"
    elif "text/turtle" in accept_header:
        content_type = "text/turtle"
        file_extension = ".ttl"
    elif "application/rdf+xml" in accept_header:
        content_type = "application/rdf+xml"
        file_extension = ".rdf"
    else:
        content_type = "text/html"
        file_extension = ".html"

    # Modify the URI to point to the correct file extension
    request["uri"] = request["uri"] + file_extension

    # Add headers to the request object
    request["headers"]["content-type"] = [
        {"key": "Content-Type", "value": content_type}
    ]
    if content_type != "text/html":
        request["headers"]["vary"] = [{"key": "Vary", "value": "Accept"}]
    print(f"Modified URI: {request['uri']}")
    # Return the modified request to be sent to the origin (S3)
    return request
