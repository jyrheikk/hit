#!/bin/bash
# Syntactic sugar for HTTP response assert methods.

## Verify HTTP response headers (parameter 1: expected value as a substring, which may end with the regular expression end-of-line "$", parameter 2: optional error message)

assertAge() { assertHeader "$RESP_AGE" "$1" "$2"; }
assertCacheControl() { assertHeader "$RESP_CACHE_CONTROL" "$1" "$2"; }
assertContentEncoding() { assertHeader "$RESP_CONTENT_ENCODING" "$1" "$2"; }
assertContentLength() { assertHeader "$RESP_CONTENT_LENGTH" "$1" "$2"; }
assertContentType() { assertHeader "$RESP_CONTENT_TYPE" "$1" "$2"; }
assertLocation() { assertHeader "$RESP_LOCATION" "$1" "$2"; }
assertPragma() { assertHeader "$RESP_PRAGMA" "$1" "$2"; }
assertServer() { assertHeader "$RESP_SERVER" "$1" "$2"; }
assertSetCookie() { assertHeader "$RESP_SET_COOKIE" "$1" "$2"; }
assertStrictTransportSecurity() { assertHeader "$RESP_STRICT_TRANSPORT_SECURITY" "$1" "$2"; }
assertVary() { assertHeader "$RESP_VARY" "$1" "$2"; }
assertXCheckCacheable() { assertHeader "$RESP_X_CHECK_CACHEABLE" "$1" "$2"; }
assertXFrameOptions() { assertHeader "$RESP_X_FRAME_OPTIONS" "$1" "$2"; }
assertXPoweredBy() { assertHeader "$RESP_X_POWERED_BY" "$1" "$2"; }
assertXTrueCacheKey() { assertHeader "$RESP_X_TRUE_CACHE_KEY" "$1" "$2"; }
assertXVarnish() { assertHeader "$RESP_X_VARNISH" "$1" "$2"; }
assertXVarnishCache() { assertHeader "$RESP_X_VARNISH_CACHE" "$1" "$2"; }

# Verify a non-standard header (parameters: header, expected-value, optional message)
assertHeader() {
    _verifyHeader "$1:" "$2" "$3"
}

## Verify Cache-Control response header (parameter: optional error message)

assertNotCacheable() { assertCacheControl "($NO_CACHE|$NO_STORE|$PRIVATE)" "$1"; }
assertCacheControlNoCache() { assertCacheControl "$NO_CACHE" "$1"; }
assertCacheControlNoStore() { assertCacheControl "$NO_STORE" "$1"; }
assertCacheControlPrivate() { assertCacheControl "$PRIVATE" "$1"; }
assertCacheControlPublic() { assertCacheControl "$PUBLIC" "$1"; }

## Verify Content-Type response header (parameter 1: optional error message)

assertType3gp() { assertContentType "$CONTENT_TYPE_3GP" "$1"; }
assertTypeAvi() { assertContentType "$CONTENT_TYPE_AVI" "$1"; }
assertTypeCss() { assertContentType "$CONTENT_TYPE_CSS" "$1"; }
assertTypeFlash() { assertContentType "($CONTENT_TYPE_FLASH|$CONTENT_TYPE_APPLICATION_FLASH)" "$1"; }
assertTypeGif() { assertContentType "$CONTENT_TYPE_GIF" "$1"; }
assertTypeHtml() { assertContentType "$CONTENT_TYPE_HTML" "$1"; }
assertTypeJavaScript() { assertContentType "($CONTENT_TYPE_APPLICATION_JAVASCRIPT|$CONTENT_TYPE_APPLICATION_X_JAVASCRIPT|$CONTENT_TYPE_JAVASCRIPT)" "$1"; }
assertTypeJpeg() { assertContentType "$CONTENT_TYPE_JPEG" "$1"; }
assertTypeJson() { assertContentType "$CONTENT_TYPE_JSON" "$1"; }
assertTypeMp4() { assertContentType "$CONTENT_TYPE_MP4" "$1"; }
assertTypeOctetStream() { assertContentType "$CONTENT_TYPE_APPLICATION_OCTET_STREAM" "$1"; }
assertTypePdf() { assertContentType "$CONTENT_TYPE_PDF" "$1"; }
assertTypePng() { assertContentType "$CONTENT_TYPE_PNG" "$1"; }
assertTypeQuickTime() { assertContentType "$CONTENT_TYPE_QUICKTIME" "$1"; }
assertTypeText() { assertContentType "$CONTENT_TYPE_TEXT" "$1"; }
assertTypeWebM() { assertContentType "$CONTENT_TYPE_WEBM" "$1"; }
assertTypeWindowsMedia() { assertContentType "$CONTENT_TYPE_WINDOWS_MEDIA" "$1"; }
assertTypeXml() { assertContentType "($CONTENT_TYPE_APPLICATION_XML|$CONTENT_TYPE_XML)" "$1"; }

## Verify miscellaneous response headers

# @param file type (css, gif, js, json, png, txt, xml), default is "html"
assertContentTypeExpected() {
    case "$1" in
        avi)
            assertTypeAvi "$2"
            ;;
        css)
            assertTypeCss "$2"
            ;;
        flv)
            assertTypeFlash "$2"
            ;;
        gif)
            assertTypeGif "$2"
            ;;
        gp)
            assertType3gp "$2"
            ;;
        js)
            assertTypeJavaScript "$2"
            ;;
        jpeg)
            assertTypeJpeg "$2"
            ;;
        json)
            assertTypeJson "$2"
            ;;
        mov)
            assertTypeQuickTime "$2"
            ;;
        mp4)
            assertTypeMp4 "$2"
            ;;
        octet)
            assertTypeOctetStream "$2"
            ;;
        pdf)
            assertTypePdf "$2"
            ;;
        png)
            assertTypePng "$2"
            ;;
        txt)
            assertTypeText "$2"
            ;;
        webm)
            assertTypeWebM "$2"
            ;;
        wmv)
            assertTypeWindowsMedia "$2"
            ;;
        xml)
            assertTypeXml "$2"
            ;;
        *)
            assertTypeHtml "$2"
            ;;
    esac
}

# Verify that clickjacking is not allowed (X-Frame-Options: SAMEORIGIN)
assertNoClickjacking() { assertXFrameOptions "($DENY|$SAMEORIGIN)" "$1"; }

# Verify that the response is compressed (Accept-Encoding and Vary headers)
assertCompressed() {
    assertVary "$ACCEPT_ENCODING"
    assertContentEncoding "$GZIP"
}

# Verify that Varnish is used (X-Varnish-Cache: HIT or MISS)
assertVarnishUsed() { assertXVarnishCache "($HIT|$MISS)" "$1"; }

## Verify HTTP status code (parameter: optional error message)

# Verify that the status code is 200
assertStatusOk() { _verifyStatus "$statusOk" "$1"; }
# Verify that the status code is 201
assertStatusCreated() { _verifyStatus "$statusCreated" "$1"; }
# Verify that the status code is 301 or 302
assertStatusRedirect() { _verifyStatus "($statusMovedPermanently|$statusMovedTemporarily|$statusFound|$statusObjectMoved)" "$1"; }
# Verify that the status code is 301
assertStatusMovedPermanently() { _verifyStatus "$statusMovedPermanently" "$1"; }
# Verify that the status code is 302
assertStatusMovedTemporarily() { _verifyStatus "($statusMovedTemporarily|$statusFound|$statusObjectMoved)" "$1"; }
# Verify that the status code is 400
assertStatusBadRequest() { _verifyStatus "$statusBadRequest" "$1"; }
# Verify that the status code is 401
assertStatusUnauthorized() { _verifyStatus "($statusUnauthorized|$statusAuthorizationRequired)" "$1"; }
# Verify that the status code is 403
assertStatusForbidden() { _verifyStatus "$statusForbidden" "$1"; }
# Verify that the status code is 404
assertStatusNotFound() { _verifyStatus "$statusNotFound" "$1"; }
# Verify that the status code is 405
assertStatusMethodNotAllowed() { _verifyStatus "$statusMethodNotAllowed" "$1"; }
# Verify that the status code is 500
assertStatusServerError() { _verifyStatus "$statusServerError" "$1"; }
# Verify that the status code is 501
assertStatusNotImplemented() { _verifyStatus "$statusNotImplemented" "$1"; }
# Verify that the status code is 503
assertStatusServiceUnavailable() { _verifyStatus "$statusServiceUnavailable" "$1"; }

# Verify HTTP status code (parameter 1: number, parameter 2: optional number used if the first parameter is empty)
assertStatusCodeExpected() {
    local code="$1"
    local readonly message="$3"

    if [ -z "$code" ]; then
        code="$2"
    fi

    case "$code" in
        "200")
            assertStatusOk "$message"
            ;;
        "201")
            assertStatusCreated "$message"
            ;;
        "301")
            assertStatusMovedPermanently "$message"
            ;;
        "302")
            assertStatusMovedTemporarily "$message"
            ;;
        "400")
            assertStatusBadRequest "$message"
            ;;
        "401")
            assertStatusUnauthorized "$message"
            ;;
        "403")
            assertStatusForbidden "$message"
            ;;
        "404")
            assertStatusNotFound "$message"
            ;;
        "405")
            assertStatusMethodNotAllowed "$message"
            ;;
        "500")
            assertStatusServerError "$message"
            ;;
        "501")
            assertStatusNotImplemented "$message"
            ;;
        "503")
            assertStatusServiceUnavailable "$message"
            ;;
        *)
            _verifyStatus "known-response-code" "$code"
            ;;
    esac
}
