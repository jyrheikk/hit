#!/bin/bash
# Assert methods for the HTTP response body.

_bodyMatches() {
    _matches "$1" "$req_responseBody"
}

_getBodyValue() {
    _getValue "$1" "$req_responseBody"
}

## Verify contents of HTTP response body (after call to httpGet)

# Verify that the response body contains the given string
assertBody() {
    local readonly needle="$1"
    local readonly message="$(_getCombinedMessage "$2" "$currentUrl")"

    if [ -n "$(_hasResponseBody)" ]; then
        local readonly found=$(_bodyMatches "$needle")
        if [[ $found -gt 0 ]]; then
            _okAssert
        else
            _failAssertExpected "$needle" "" "$message"
        fi
    else
        _cannotVerifyResponseBody "$1" "$message"
    fi
}

# Verify that the response body does not contain the given string
assertBodyNot() {
    local readonly notExpected="$1"
    local readonly message="$(_getCombinedMessage "$2" "$currentUrl")"

    if [ -n "$(_hasResponseBody)" ]; then
        local readonly found=$(_bodyMatches "$notExpected")
        if [[ $found == 0 ]]; then
            _okAssert
        else
            _failAssertExpected "" "$notExpected" "$message"
        fi
    else
        _cannotVerifyResponseBody "$1" "$message"
    fi
}

_cannotVerifyResponseBody() {
    local readonly message="$(_getCombinedMessage "$1" "$2")"
    assertEquals "HTTP GET" "HTTP HEAD" "$message"
}

assertBodyNoHtml5Tags() {
    assertBodyNot "$(_html5Tags)"
}

_html5Tags() {
    echo "<(abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|header|hgroup|mark|meter|nav|output|progress|section|summary|time|video)"
}

# Verify that the response body does not contain any JavaScript
assertBodyNoJavaScript() {
    assertBodyNot "<script" "$1"
}

# Verify that the response body is empty, and Content-Length header value is at most 20 (size of a zipped empty body)
assertBodyEmpty() {
    local readonly message="$(_getCombinedMessage "$1" "$currentUrl")"
    local readonly MAX_LEN_OF_COMPRESSED_EMPTY_BODY=20
    assertContentLengthIn 0 "$MAX_LEN_OF_COMPRESSED_EMPTY_BODY" "$message"

    if [ -s "$req_responseBody" ]; then
        local readonly message="$(_getCombinedMessage "response body not empty" "$message")"
        failAssert "$message"
    else
        _okAssert
    fi
}

# Verify that the response body contains the given JSON attribute (parameter 1: attribute name, parameter 2: attribute value)
assertJson() { 
    local readonly value="$(getJsonValueFromBody "$1")"
    assertEquals "$2" "$value"
}

# @param JSON attribute name
getJsonValueFromBody() { 
    local readonly json="$(_removeCRLF 2> /dev/null < "$req_responseBody")"
    getJsonValue "$json" "$1"
}
