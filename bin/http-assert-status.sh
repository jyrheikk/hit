#!/bin/bash
# Syntactic sugar for HTTP status code assert methods.

## Verify HTTP status code

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
