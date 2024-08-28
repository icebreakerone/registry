import pytest

from lambda_code.index import handler


@pytest.mark.parametrize(
    "accept_header, expected_uri_suffix, expected_content_type",
    [
        ("application/ld+json", ".jsonld", "application/ld+json"),
        ("text/turtle", ".ttl", "text/turtle"),
        ("application/rdf+xml", ".rdf", "application/rdf+xml"),
        ("text/plain", ".html", "text/html"),  # Default to HTML
        (None, ".html", "text/html"),  # No Accept header
    ],
)
def test_content_negotiation(accept_header, expected_uri_suffix, expected_content_type):
    headers = {"accept": [{"value": accept_header}]} if accept_header else {}
    event = {
        "Records": [
            {"cf": {"request": {"uri": "/some/path/resource", "headers": headers}}}
        ]
    }

    response = handler(event, None)

    assert response["uri"] == f"/some/path/resource{expected_uri_suffix}"
    assert response["headers"]["content-type"][0]["value"] == expected_content_type
    assert response["headers"]["vary"][0]["value"] == "Accept"
