#!/bin/bash
# Test curl error codes.

testCurlInstalled() {
    local readonly curlInstalled=$(curl -V | grep -c "libcurl")
    assertTrue $((curlInstalled > 0)) "FATAL: curl command not found; do INSTALL it"
}

testUnsupportedProtocol() {
    expectCurlError "$CURL_UNSUPPORTED_PROTOCOL"
    httpGet "htttp://test.com/"
}

# ignored because this may dramatically slow down the self-tests
IGNOREDtestUnresolvedProxy() {
    setProxy "http://unresolvedhost/"
    expectCurlError "$CURL_PROXY_NOT_RESOLVED"
    httpGet "http://test.com/"
}
