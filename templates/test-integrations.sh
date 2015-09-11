#!/bin/bash
# Template for integration test classes.

testUrl_() {
    local readonly url=$(getSourceUrl "$1")
    local readonly contentType="$(parseCsv "$1" 2)"
    local readonly content="$(parseCsv "$1" 3)"
    local readonly cookieName="$(parseCsv "$1" 4)"

    if [ -n "$content" ]; then
        httpGet "$url"
    else
        httpHead "$url"
    fi

    assertStatusOk
    assertContentTypeExpected "$contentType"
    verifyBodyContent_ "$content" "$contentType"

    if [ -n "$cookieName" ]; then
        assertSetCookie "$cookieName="
    fi

    runFunc "customAssertIntegrationHeaders" "$url" "$contentType"
}

verifyBodyContent_() {
    local readonly content="$1"

    if [ -n "$content" ]; then
        local readonly contentType="$2"
        if [ "$contentType" == "json" ]; then
            verifyJsonAttribute_ "$content"
        else
            assertBody "$content"
        fi
    fi
}

verifyJsonAttribute_() {
    local readonly content="$1"
    local readonly name="$(parseField "$content" 1 "#")"
    local readonly value="$(parseField "$content" 2 "#")"

    if [[ -n "$name" && -n "$value" ]]; then
        assertJson "$name" "$value"
    else
        skipAndWarn "failed to parse JSON attribute: <$content>"
    fi
}
