#!/bin/bash
# HTTP constants.

# HTTP response headers
readonly RESP_ACCESS_CONTROL_ALLOW_ORIGIN="Access-Control-Allow-Origin"
readonly RESP_AGE="Age"
readonly RESP_CACHE_CONTROL="Cache-Control"
readonly RESP_CONTENT_ENCODING="Content-Encoding"
readonly RESP_CONTENT_LENGTH="Content-Length"
readonly RESP_CONTENT_TYPE="Content-Type"
readonly RESP_LOCATION="Location"
readonly RESP_PRAGMA="Pragma"
readonly RESP_SERVER="Server"
readonly RESP_SET_COOKIE="Set-Cookie"
readonly RESP_STRICT_TRANSPORT_SECURITY="Strict-Transport-Security"
readonly RESP_VARY="Vary"
readonly RESP_X_CHECK_CACHEABLE="X-Check-Cacheable"
readonly RESP_X_FRAME_OPTIONS="X-Frame-Options"
readonly RESP_X_POWERED_BY="X-Powered-By"
# returned by Akamai when PRAGMA_AKAMAI_DEBUG_HEADERS are set
readonly RESP_X_TRUE_CACHE_KEY="X-True-Cache-Key"
readonly RESP_X_VARNISH="X-Varnish"
readonly RESP_X_VARNISH_CACHE="X-Varnish-Cache"

# HTTP request headers
readonly REQ_ACCEPT="Accept"
readonly REQ_ACCEPT_ENCODING="Accept-Encoding"
readonly REQ_ACCEPT_LANGUAGE="Accept-Language"
readonly REQ_AUTHORIZATION="Authorization"
readonly REQ_CACHE_CONTROL="Cache-Control"
readonly REQ_CONTENT_LENGTH="Content-Length"
readonly REQ_CONTENT_TYPE="Content-Type"
readonly REQ_COOKIE="Cookie"
readonly REQ_HOST="Host"
readonly REQ_PRAGMA="Pragma"
readonly REQ_REFERER="Referer"
readonly REQ_USER_AGENT="User-Agent"
readonly REQ_X_FORWARDED_FOR="X-Forwarded-For"

readonly PRAGMA_AKAMAI_DEBUG_HEADERS="akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no"

# Content-Type values
readonly CONTENT_TYPE_3GP="video/3gpp"
readonly CONTENT_TYPE_APPLICATION_FLASH="flv-application/octet-stream"
readonly CONTENT_TYPE_APPLICATION_JAVASCRIPT="application/javascript"
readonly CONTENT_TYPE_APPLICATION_OCTET_STREAM="application/octet-stream"
readonly CONTENT_TYPE_APPLICATION_XHTML="application/xhtml+xml"
readonly CONTENT_TYPE_APPLICATION_XML="application/xml"
readonly CONTENT_TYPE_APPLICATION_X_JAVASCRIPT="application/x-javascript"
readonly CONTENT_TYPE_AVI="video/x-msvideo"
readonly CONTENT_TYPE_CSS="text/css"
readonly CONTENT_TYPE_FLASH="video/x-flv"
readonly CONTENT_TYPE_GIF="image/gif"
readonly CONTENT_TYPE_HTML="text/html"
readonly CONTENT_TYPE_JAVASCRIPT="text/javascript"
readonly CONTENT_TYPE_JPEG="image/jpeg"
readonly CONTENT_TYPE_JSON="application/json"
readonly CONTENT_TYPE_MP4="video/mp4"
readonly CONTENT_TYPE_PDF="application/pdf"
readonly CONTENT_TYPE_PNG="image/png"
readonly CONTENT_TYPE_QUICKTIME="video/quicktime"
readonly CONTENT_TYPE_TEXT="text/plain"
readonly CONTENT_TYPE_WEBM="video/webm"
readonly CONTENT_TYPE_WINDOWS_MEDIA="video/x-ms-wmv"
readonly CONTENT_TYPE_XML="text/xml"

readonly STATUS_CODE="HTTP/1\.[01]"

# HTTP request methods
readonly REQ_METHOD_DELETE="DELETE"
readonly REQ_METHOD_GET="GET"
readonly REQ_METHOD_OPTIONS="OPTIONS"
readonly REQ_METHOD_POST="POST"
readonly REQ_METHOD_PUT="PUT"
readonly REQ_METHOD_TRACE="TRACE"

# HTTP status codes
readonly statusOk="200 OK"
readonly statusConnectionEstablished="200 Connection established"
readonly statusCreated="201 Created"
readonly statusMovedPermanently="301 Moved Permanently"
# 302 has several definitions
readonly statusMovedTemporarily="302 Moved Temporarily"
readonly statusFound="302 Found"
readonly statusObjectMoved="302 Object moved"
readonly statusBadRequest="400 Bad Request"
readonly statusUnauthorized="401 Unauthorized"
readonly statusAuthorizationRequired="401 Authorization Required"
readonly statusForbidden="403 Forbidden"
readonly statusNotFound="404 Not Found"
readonly statusMethodNotAllowed="405 Method Not Allowed"
readonly statusServerError="500 Internal Server Error"
readonly statusNotImplemented="501 Not Implemented"
readonly statusServiceUnavailable="503 Service Unavailable"
readonly statusGatewayTimeOut="504 Gateway Time-out"

# Cache-Control values
readonly MAX_AGE="max-age"
readonly NO_CACHE="no-cache"
readonly NO_STORE="no-store"
readonly PRIVATE="private"
readonly PROXY_REVALIDATE="proxy-revalidate"
readonly PUBLIC="public"

# Content-Encoding values
readonly GZIP="gzip"

# Vary values
readonly ACCEPT_ENCODING="Accept-Encoding"
readonly USER_AGENT="User-Agent"

# X-Check-Cacheable values
readonly CACHEABLE_NO="NO"

# X-Frame-Options values
readonly DENY="DENY"
readonly SAMEORIGIN="SAMEORIGIN"

# X-Varnish-Cache values
readonly HIT="HIT"
readonly MISS="MISS"
