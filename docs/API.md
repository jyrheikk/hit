# HTTP Integration Tester API

The last argument of the assert functions is an optional error message.

## Set HTTP request headers
* `setAcceptEncoding`
  * Parameters: "" to not compress the response body
* `setCookie`
  * Parameters: "cookie-name=cookie-value" (call repeatedly to set several cookies)
* `setCredentials`
  * Parameters: "username:password" in plain text
* `setCustomHeader`
  * parameter 1: header name, parameter 2: header value
* `setFollowRedirects`
  * Parameters: maximum number of redirects
* `setProxy`
  * Parameters: "" to test on the public Internet
* `setAccept`
* `setAcceptLanguage`
* `setAuthorization`
* `setContentLength`
* `setContentType`
* `setCacheControl`
* `setHost`
* `setOrigin`
* `setPragma`
* `setReferer`
* `setXForwardedFor`
* `setUserAgent`
* `setAkamaiDebugHeaders`
  * Sets akamai-x headers, enables using assertXCheckCacheable and assertXTrueCacheKey

## Send HTTP request (parameter 1: URL)
* `httpGet`
* `httpHead`
* `httpPost`
  * Parameters: 2 data string or file
* `httpTrace`
* `httpOptions`

## Verify HTTP response headers
* `assertAccessControlAllowOrigin`
  * Parameters: expected value as a substring, which may end with the regular expression end-of-line "$"
* `assertAge`
* `assertCacheControl`
* `assertContentEncoding`
* `assertContentLength`
* `assertContentType`
* `assertLocation`
* `assertPragma`
* `assertServer`
* `assertSetCookie`
* `assertStrictTransportSecurity`
* `assertVary`
* `assertXCheckCacheable`
* `assertXFrameOptions`
* `assertXPoweredBy`
* `assertXTrueCacheKey`
* `assertXVarnish`
* `assertXVarnishCache`
* `assertHeader`
  * Verify a non-standard header (parameters: header, expected-value)

## Verify Cache-Control response header
* `assertNotCacheable`
* `assertCacheControlNoCache`
* `assertCacheControlNoStore`
* `assertCacheControlPrivate`
* `assertCacheControlPublic`

## Verify Content-Type response header
* `assertType3gp`
* `assertTypeAvi`
* `assertTypeCss`
* `assertTypeFlash`
* `assertTypeGif`
* `assertTypeHtml`
* `assertTypeJavaScript`
* `assertTypeJpeg`
* `assertTypeJson`
* `assertTypeMp4`
* `assertTypeOctetStream`
* `assertTypePdf`
* `assertTypePng`
* `assertTypeQuickTime`
* `assertTypeText`
* `assertTypeWebM`
* `assertTypeWindowsMedia`
* `assertTypeXml`

## Verify miscellaneous response headers
* `assertContentTypeExpected`
  * Parameters: file type (css, gif, js, json, png, txt, xml), default is "html"
* `assertNoClickjacking`
  * Verify that clickjacking is not allowed (X-Frame-Options: SAMEORIGIN)
* `assertCorsEnabled`
  * Verify that Cross Origin Resource Sharing (CORS) is enabled
* `assertCompressed`
  * Verify that the response is compressed (Accept-Encoding and Vary headers)
* `assertVarnishUsed`
  * Verify that Varnish is used (X-Varnish-Cache: HIT or MISS)

## Verify HTTP status code
* `assertStatusOk`
  * Verify that the status code is 200
* `assertStatusCreated`
  * Verify that the status code is 201
* `assertStatusRedirect`
  * Verify that the status code is 301 or 302
* `assertStatusMovedPermanently`
  * Verify that the status code is 301
* `assertStatusMovedTemporarily`
  * Verify that the status code is 302
* `assertStatusBadRequest`
  * Verify that the status code is 400
* `assertStatusUnauthorized`
  * Verify that the status code is 401
* `assertStatusForbidden`
  * Verify that the status code is 403
* `assertStatusNotFound`
  * Verify that the status code is 404
* `assertStatusMethodNotAllowed`
  * Verify that the status code is 405
* `assertStatusServerError`
  * Verify that the status code is 500
* `assertStatusNotImplemented`
  * Verify that the status code is 501
* `assertStatusServiceUnavailable`
  * Verify that the status code is 503
* `assertStatusCodeExpected`
  * Verify HTTP status code (parameter 1: number, parameter 2: optional number used if the first parameter is empty)

## HTTP response header utilities
* `getStatus`
  * Return the HTTP status code as a number
* `getHeaderValue`
  * Parameters: header name
* `getCookie`
  * Parameters: name of the cookie

## Verify numerical values of response headers
* `assertMaxAge`
  * Parameters: expected value of max-age within Cache-Control header
* `assertMaxAgeIn`
  * Parameters: min-value, max-value (of max-age within Cache-Control header)
* `assertContentLengthIn`
  * Parameters: min-value, max-value (of Content-Length header)
* `assertHeaderIn`
  * Parameters: header, min-value, max-value

## Verify contents of HTTP response body (after call to httpGet)
* `assertBody`
  * Verify that the response body contains the given string
* `assertBodyNot`
  * Verify that the response body does not contain the given string
* `assertBodyNoHtml5Tags`
* `assertBodyNoJavaScript`
  * Verify that the response body does not contain any JavaScript
* `assertBodyEmpty`
  * Verify that the response body is empty, and Content-Length header value is at most 20 (size of a zipped empty body)
* `assertJson`
  * Verify that the response body contains the given JSON attribute (parameter 1: attribute name, parameter 2: attribute value)
* `getJsonValueFromBody`

## Basic assertions
* `assertTrue`
  * Verify that the given expression returns 1
* `assertEquals`
  * Verify that the given values match (parameter 1: expected value, parameter 2: tested value)
* `assertContains`
  * Verify that the given haystack value contains the given needle value (parameter 1: haystack, parameter 2: needle)
* `assertFileExists`
  * Verify that the given file exists
* `assertDefined`
  * Verify that the given variable is defined
* `skipAndWarn`
  * Skip the test with the given warning message

## String utilities
* `parseCsv`
  * Parameters: 1 CSV-formatted string, 2 number of field to be returned
* `parseField`
  * Parameters: 1 string, 2 number of field to be returned, 3 delimiter
* `getHostOfUrl`
  * Parameters: URL including the protocol (e.g., https://github.com/)
* `getProtocolAndHostOfUrl`
  * Parameters: URL including the protocol (e.g., https://github.com/jyrheikk/hit/)
* `getJsonValue`
  * Parse JSON value, except array (parameter 1: JSON string without line breaks, parameter 2: attribute name, either key or object.key)
* `arrayContains`
  * Returns 0 if the given array contains the given string (parameter 1: string, parameter 2: array)

## Utilities for checking integers
* `isInteger`
  * Returns 1 if the given argument is an integer
* `isNotInteger`
  * Returns 1 if the given argument is not an integer

## Utilities for parsing CSV-formatted redirect rules
* `getSourceUrl`
  * Parameters: CSV-formatted string
* `getDestinationUrl`
  * Parameters: CSV-formatted string
* `getSourceStatus`
  * Parameters: 1 CSV-formatted string, 2 (optional) default HTTP status code
* `getDestinationStatus`
  * Parameters: 1 CSV-formatted string, 2 (optional) default HTTP status code

## Utilities for running functions
* `runFunc`
  * Run the given function if it exists with the given arguments
* `isFunction`
  * Returns OK if the given function exists

## Miscellaneous utilities
* `useTemplate`
  * Parameters: 1 template name (e.g., "test-redirects"), 2 test data array or filename
* `doSleep`
  * Sleep between requests, to avoid creating too much traffic on any one site; the wait time can be set as a command-line argument
