#!/bin/bash
# Test the HTTP test framework.

testRequestScriptCreation() {
    local readonly url="http://test.com/"
    local readonly refererUrl="http://somesite.somewhere/"

    setReferer "$refererUrl"
    _createRequestConfig $url

    assertTrue "$(scriptContains "$url")"
    assertTrue "$(scriptContains "$REQ_ACCEPT_ENCODING: $defaultAcceptEncoding")"
    assertTrue "$(scriptContains "$REQ_REFERER: $refererUrl")"

    assertRequestScriptRemoved
}

scriptContains() {
    grep -ci "$1" "$req_config"
}

assertRequestScriptRemoved() {
    [ ! -f "$req_config" ] && failAssert "exists"
    _removeFile "$req_config"
    [ -f "$req_config" ] && failAssert "removed"
}
