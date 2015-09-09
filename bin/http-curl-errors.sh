#!/bin/bash
# Report curl errors.

readonly CURL_OK=0
readonly CURL_UNSUPPORTED_PROTOCOL=1
readonly CURL_FAILED_TO_INITIALIZE=2
readonly CURL_URL_MALFORMAT=3
readonly CURL_URL_USER_MALFORMATTED=4
readonly CURL_PROXY_NOT_RESOLVED=5
readonly CURL_HOST_NOT_RESOLVED=6
readonly CURL_FAILED_TO_CONNECT_TO_HOST=7
readonly CURL_TIMEOUT=28
readonly CURL_SSL_CONNECT_ERROR=35
readonly CURL_CONNECTION_RESET_BY_PEER=56
readonly CURL_SSL_CACERT=60

# @param CURL_ constant
_expectCurlError() {
    curlError="$1"
}

_expectCurlOk() {
    _expectCurlError "$CURL_OK"
}

_verifyCurlReturnCode() {
    local message=
	case "$1" in
        $CURL_OK)
            message="OK"
            ;;
        $CURL_UNSUPPORTED_PROTOCOL)
            message="Unsupported protocol"
            ;;
        $CURL_FAILED_TO_INITIALIZE)
            message="Failed to initialize"
            ;;
        $CURL_URL_MALFORMAT)
            message="URL malformat"
            ;;
        $CURL_URL_USER_MALFORMATTED)
            message="URL malformat"
            ;;
        $CURL_PROXY_NOT_RESOLVED)
            message="Couldn't resolve proxy"
            ;;
        $CURL_HOST_NOT_RESOLVED)
            message="Couldn't resolve host"
            ;;
        $CURL_FAILED_TO_CONNECT_TO_HOST)
            message="Failed to connect to host"
            ;;
        $CURL_TIMEOUT)
            message="Operation timeout"
            ;;
        $CURL_SSL_CONNECT_ERROR)
            message="SSL connect error"
            ;;
        $CURL_CONNECTION_RESET_BY_PEER)
            message="Connection reset by peer"
            ;;
        $CURL_SSL_CACERT)
            message="Certificate cannot be authenticated"
            ;;
        *)
            message="Other"
            ;;
    esac

    local readonly longMessage="$(_getCombinedMessage "$message" "$2")"
    assertEquals "$curlError" "$1" "curl returned: $longMessage"
}
