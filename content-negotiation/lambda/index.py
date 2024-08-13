def handler(event, context):
    request = event["Records"][0]["cf"]["request"]
    headers = request["headers"]

    uri = request["uri"]

    if "accept" in headers:
        accept = headers["accept"][0]["value"]
        if "application/ld+json" in accept:
            uri += ".jsonld"
        elif "text/turtle" in accept:
            uri += ".ttl"
        elif "application/rdf+xml" in accept:
            uri += ".rdf"

    request["uri"] = uri
    return request
