#!/bin/bash
# Create the HTTP request.

source http-curl-errors.sh
source http-default.sh

# override the request parameters in the setUp function
_initRequest() {
    setAccept "$defaultAccept"
    setAcceptEncoding "$defaultAcceptEncoding"
    setAcceptLanguage "$defaultAcceptLanguage"
    setAuthorization ""
    setCacheControl "$defaultCacheControl"
    setContentLength 0
    setContentType ""
    setCookie ""
    setCredentials ""
    setCustomHeader ""
    setFollowRedirects 0
    setHost ""
    setPragma "$defaultPragma"
    setProxy "$defaultProxy"
    setReferer ""
    setUserAgent ""
    setXForwardedFor ""

    expectCurlOk
}

## Set HTTP request headers

# @param "" to not compress the response body
setAcceptEncoding() { req_acceptEncoding="$1"; }

# @param "cookie-name=cookie-value" (call repeatedly to set several cookies)
setCookie() {
    if [ -z "$1" ]; then
        unset req_cookies
        declare -a req_cookies=()
    else
        req_cookies=("${req_cookies[@]}" "$1")
    fi
}

# @param "username:password" in plain text
setCredentials() { req_credentials="$1"; }

# parameter 1: header name, parameter 2: header value
setCustomHeader() {
    local readonly name="$1"
    if [ -n "$name" ]; then
        local readonly value="$2"
        req_customHeaders=("${req_customHeaders[@]}" "$name: $value")
    else
        unset req_customHeaders
        declare -a req_customHeaders=()
    fi
}

# @param maximum number of redirects
setFollowRedirects() { req_followRedirects=$1; }

# @param "" to test on the public Internet
setProxy() { req_proxy="$1"; }

setAccept() { req_accept="$1"; }

setAcceptLanguage() { req_acceptLanguage="$1"; }

setAuthorization() { req_authorization="$1"; }

setContentLength() { req_contentLength=$1; }

setContentType() { req_contentType="$1"; }

setCacheControl() { req_cacheControl="$1"; }

setHost() { req_host="$1"; }

setPragma() { req_pragma="$1"; }

setReferer() { req_referer="$1"; }

setXForwardedFor() { req_xForwardedFor="$1"; }

setUserAgent() {
    req_userAgent="$(_getCombinedMessage "$1" "$defaultUserAgent")"
}

# Sets akamai-x headers, enables using assertXCheckCacheable and assertXTrueCacheKey
setAkamaiDebugHeaders() {
    setPragma "$PRAGMA_AKAMAI_DEBUG_HEADERS"
}

_createRequestConfig() {
    _addRequestParam "--silent"
    _addRequestParam "--connect-timeout $defaultConnectTimeout"
    _addRequestParam "--max-time $defaultMaxTime"

    if [ -n "$headerRequested" ]; then
        _addRequestParam "--head"
    elif [ -n "$req_acceptEncoding" ]; then
        _addRequestParam "--compressed"
    fi

    _addRequestHeader "$REQ_ACCEPT" "$req_accept"
    _addRequestHeader "$REQ_ACCEPT_ENCODING" "$req_acceptEncoding"
    _addRequestHeader "$REQ_ACCEPT_LANGUAGE" "$req_acceptLanguage"
    _addRequestHeader "$REQ_AUTHORIZATION" "$req_authorization"
    _addRequestHeader "$REQ_CACHE_CONTROL" "$req_cacheControl"
    _addRequestHeader "$REQ_CONTENT_TYPE" "$req_contentType"
    _addRequestHeader "$REQ_HOST" "$req_host"
    _addRequestHeader "$REQ_PRAGMA" "$req_pragma"
    _addRequestHeader "$REQ_REFERER" "$req_referer"
    _addRequestHeader "$REQ_USER_AGENT" "$req_userAgent"
    _addRequestHeader "$REQ_X_FORWARDED_FOR" "$req_xForwardedFor"

    for cookie in "${req_cookies[@]}"; do
        _addRequestHeader "$REQ_COOKIE" "$cookie"
    done

    if [ -n "$req_credentials" ]; then
        _addRequestParam "--user $req_credentials"
    fi

    if [ "$req_contentLength" -gt 0 ]; then
        _addRequestHeader "$REQ_CONTENT_LENGTH" "$req_contentLength"
    fi

    for customHeader in "${req_customHeaders[@]}"; do
        _addRequestHeaderValue "$customHeader"
    done

    runFunc "customAddHeaders" "_addRequestHeader"

    if [ "$req_followRedirects" -gt 0 ]; then
        _addRequestParam "--location --max-redirs $req_followRedirects"
    fi

    if [ -n "$req_proxy" ]; then
        _addRequestParam "--proxy \"$req_proxy\""
    fi

    if [ "$(_isHttpMethod "$2")" ]; then
        _addRequestParam "-X $2"
        if [ -n "$3" ]; then
            _addRequestParam "--data $3"
        fi
    fi

    _addRequestParam "--dump-header $req_responseHeaders"
    _addRequestParam "--output $req_responseBody"
    _addRequestParam "--insecure"
    _addRequestParam "--url \"$1\""
}

_addRequestHeader() {
    if [ -n "$2" ]; then
        _addRequestHeaderValue "$1: $2"
    fi
}

_addRequestHeaderValue() {
    _addRequestParam "--header \"$1\""
}

_addRequestParam() {
    echo "$1" >> "$req_config"
}

_isHttpMethod() {
    case "$1" in
        "$REQ_METHOD_DELETE" | "$REQ_METHOD_OPTIONS" | "$REQ_METHOD_PUT" | "$REQ_METHOD_TRACE")
            echo 1
            ;;
    esac
}

_initRequest
