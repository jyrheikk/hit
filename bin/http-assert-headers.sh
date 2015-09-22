#!/bin/bash
# Syntactic sugar for HTTP response assert methods.

## Verify HTTP response headers

# @param expected value as a substring, which may end with the regular expression end-of-line "$"
assertAccessControlAllowOrigin() { assertHeader "$RESP_ACCESS_CONTROL_ALLOW_ORIGIN" "$1" "$2"; }
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

# Verify a non-standard header (parameters: header, expected-value)
assertHeader() {
    _verifyHeader "$1:" "$2" "$3"
}

## Verify Cache-Control response header

assertNotCacheable() { assertCacheControl "($NO_CACHE|$NO_STORE|$PRIVATE)" "$1"; }
assertCacheControlNoCache() { assertCacheControl "$NO_CACHE" "$1"; }
assertCacheControlNoStore() { assertCacheControl "$NO_STORE" "$1"; }
assertCacheControlPrivate() { assertCacheControl "$PRIVATE" "$1"; }
assertCacheControlPublic() { assertCacheControl "$PUBLIC" "$1"; }

## Verify miscellaneous response headers

# Verify that clickjacking is not allowed (X-Frame-Options: SAMEORIGIN)
assertNoClickjacking() { assertXFrameOptions "($DENY|$SAMEORIGIN)" "$1"; }

# Verify that Cross Origin Resource Sharing (CORS) is enabled
assertCorsEnabled() { assertAccessControlAllowOrigin "\*" "$1"; }

# Verify that the response is compressed (Accept-Encoding and Vary headers)
assertCompressed() {
    assertVary "$ACCEPT_ENCODING"
    assertContentEncoding "$GZIP"
}

# Verify that Varnish is used (X-Varnish-Cache: HIT or MISS)
assertVarnishUsed() { assertXVarnishCache "($HIT|$MISS)" "$1"; }
