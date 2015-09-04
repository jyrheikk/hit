# HIT Test Class Templates

The [HTTP Integration Tester](/README.md) (HIT) framework provides the
following templates for common test classes:

| Name | Verifies the given... |
| ---- | ----------- |
| `test-iframes` | URLs contain the given IFrames |
| `test-integrations` | URLs (status code, content type, and optionally selected piece of content); additionally, calls the `customAssertIntegrationHeaders` function (with the current URL and content type as the arguments), which can implement domain-specific assertions |
| `test-redirects` | Redirect source and destination URLs (status code) |

Example. Templates are used as follows:

    #!/bin/bash

    useTemplate "test-redirects" "testdata/redirects*.csv"

The `useTemplate` function takes 2 parameters:

* Name of the test template.
* Test data, either the name of a CSV-formatted file(s), or an array.

## CSV format for IFrame URLs

The `test-iframes` template verifies the IFrame URLs defined in a CSV
file, which has the following format:

    <embedding-page-url>,<iframe-url>,<iframe-content>

| Field | Value |
| ----- | ----- |
| `embedding-page-url` | Absolute URL of a page that is expected to contain an IFrame with source URL `iframe-url` |
| `iframe-url` | Absolute URL of the IFrame whose availability is verified |
| `iframe-content` | Expected piece of content on the IFrame |

## CSV format for integration URLs

The `test-integrations` template verifies integration URLs defined in
a CSV file, which has the following format:

    <url>[,<content-type>[,<content>[,<cookie-name>]]]

| Field | Value |
| ----- | ----- |
| `url` | Absolute URL whose availability is verified |
| `content-type` | Expected value of the `Content-Type` response header (`html` by default) |
| `content` | Any string in the response body |
| `cookie-name` | Name of a cookie that is expected to be set in the HTTP response |

If `content-type` is `json`, the `content` field may contain JSON
attribute name and value pairs in the following format:

    <attr-name>#<attr-value>[|<attr-name>#<attr-value>]

Example:

    https://api.github.com,json,current_user_url#https://api.github.com/user

## CSV format for redirect rules

The `test-redirects` template verifies the redirect rules defined in a
CSV file, which has the following format:

    <source-url>,<destination-url>[,<source-status>[,<destination-status>]]

| Field | Value |
| ----- | ----- |
| `source-url` | Absolute URL of a source that is expected to be redirected to `destination-url` |
| `destination-url` | Absolute URL of a redirect destination whose availability is verified |
| `source-status` | Expected HTTP status code of `source-url` (`301` by default) |
| `destination-status` | Expected HTTP status code of `destination-url` (`200` by default) |

Example:

    http://twitter.com/,https://twitter.com/
