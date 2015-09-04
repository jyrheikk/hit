#!/bin/bash
# Send the HTTP request.

source http-request-headers.sh

readonly req_responseHeaders="respHeaders-$RANDOM.tmp"
readonly req_responseBody="respBody-$RANDOM.tmp"
readonly req_config="reqConfig-$RANDOM.tmp"

_hasResponseBody() {
    echo "$responseBodyRequested"
}

## Send HTTP request (parameter 1: URL)

httpGet() {
    local readonly url="$1"
    local ok=1

    _setCurrentUrl "$url"

    if [ "$(_skipUrl "$url")" ]; then
        ok=
        skipTest
    elif [ -z "$req_proxy" ]; then
        runFunc "customIsIntranetUrl" "$url"
        if [ $? -eq 0 ]; then
            ok=
            skipAndWarn "not accessible URL <$url>"
        fi
    fi

    if [ -n "$optDryRunMode" ]; then
        if [ -n "$ok" ]; then
            ok=
            skipTest
        fi
        doDebug " $url"
    fi

    if [ -n "$ok" ]; then
        runFunc "customSetDomainHeaders" "$1"
        _doRequest "$@"
    else
        touch "$req_responseHeaders" "$req_responseBody"
    fi

    responseBodyRequested=
    if [[ -z "$headerRequested" ]]; then
        responseBodyRequested=1
    fi

    _initRequest

    addTmpFile "$req_responseHeaders"
    addTmpFile "$req_responseBody"
}

_skipUrl() {
    local readonly url="$1"

    if [[ -n "$(_skipUrlByPattern "$url")" || -n "$(_skipUrlByEnv "$url")" ]]; then
        echo 1
    fi
}

_skipUrlByPattern() {
    if [[ -n "$optIncludeUrl" && $(echo "$1" | egrep -vi --count "$optIncludeUrl") -gt 0 ]]; then
        echo 1
    fi
}

_skipUrlByEnv() {
    runFunc "customIsProductionUrl" "$1"
    local readonly isProdUrl=$?

    if [[ (-n "$optProductionMode" && "$isProdUrl" -ne 0) || (-n "$optRegressionMode" && "$isProdUrl" -eq 0) ]]; then
        echo 1
    fi
}

httpHead() {
    headerRequested=1
    httpGet "$1"
    headerRequested=
}

# @param 2 data string or file
httpPost() {
    if [ -f "$2" ]; then
        local readonly postContents="@$2"
    else
        local readonly postContents="$2"
    fi

    httpGet "$1" "$REQ_METHOD_POST" "$postContents"
}

httpTrace() {
    httpGet "$1" "$REQ_METHOD_TRACE"
}

httpOptions() {
    httpGet "$1" "$REQ_METHOD_OPTIONS"
}

_doRequest() {
    local readonly url="$1"

    if [ -z "$req_host" ]; then
        local readonly host=$(getHostOfUrl "$url")
        setHost "$host"
    fi

    touch "$req_config"
    _createRequestConfig "$@"

    curl --config "$req_config"

    local readonly curlStatus="$?"
    if [ "$curlStatus" == "$CURL_TIMEOUT" ]; then
        skipAndWarn "curl timeout $defaultMaxTime s <$url>"
    else
        verifyCurlReturnCode "$curlStatus" "$url"
    fi

    removeFile "$req_config"
}
