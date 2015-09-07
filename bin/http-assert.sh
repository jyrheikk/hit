#!/bin/bash
# Basic assert methods for HTTP response headers.

declare -a _sitesDown=()

_verifyStatus() {
    [ -n "$currTestFailed" ] && return

    local readonly host="$(getProtocolAndHostOfUrl "$currentUrl")"

    _isSiteDown "$host"
    if [ $? -eq 0 ]; then
        skipAndWarn "skip the test as the site is apparently down <$currentUrl>"
    else
        _verifyHeader "$STATUS_CODE" "$1" "$2"
        if [ $? -ne 0 ]; then
            _headerFound "$header" "($statusServiceUnavailable|$statusGatewayTimeOut)"
            if [ $? -eq 0 ]; then
                _sitesDown=("${_sitesDown[@]}" "$host")
            fi
        fi
    fi
}

_isSiteDown() {
    local elem
    for elem in "${_sitesDown[@]}"; do
        [[ "$elem" == "$1" ]] && return 0
    done
    return 1
}

_verifyHeader() {
    [ -n "$currTestFailed" ] && return

    local readonly header="$1"
    local readonly expected="$2"

    _headerFound "$header" "$expected"
    if [ $? -eq 0 ]; then
        _okAssert
        return 0
    else
        local readonly header="$(_getHeader "$header")"
        local readonly message="$(_getCombinedMessage "$3" "$currentUrl")"
        _failAssertExpected "$expected" "$header" "$message"
        return 1
    fi
}

_headerFound() {
    local readonly header="$1"
    local readonly expected="$2"

    local readonly escapedValue="$(_escapeRegExpChars "$expected")"
    local readonly found=$(_headerMatches "$header.*$escapedValue")

    [[ ($found -gt 0 && -n "$expected") || ($found -eq 0 && -z "$expected") ]]
}

_escapeRegExpChars() {
    local value="$1"
    value="${value//\?/\\?}"
    value="${value//\+/\\+}"

    echo "$value"
}

_getHeader() {
    _getValue "$1" "$req_responseHeaders"
}

_getValue() {
    egrep -i "$1" "$2" 2> /dev/null | _removeCRLF
}

_getNumberValueOfHeader() {
    _getNumberFromAfter "$(_getHeader "$1")" ":"
}

## HTTP response header utilities

# Return the HTTP status code as a number
getStatus() {
    # "200 Connection established" is sometimes returned before the final status code
    _getHeader "$STATUS_CODE" | sed "s#.*$STATUS_CODE ##" | cut -d" " -f1
}

# @param header name
getHeaderValue() {
    _getHeader "$1" | _trimValue
}

_trimValue() {
    cut -d: -f2- | sed -e "s/^\s*//g" -e "s/ *\$//g"
}

# @param name of the cookie
getCookie() {
    getHeaderValue "$RESP_SET_COOKIE:.*$1"
}

_headerMatches() {
    _matches "$1" "$req_responseHeaders"
}

_matches() {
    tr -d '\r' 2> /dev/null < "$2" | egrep -i --count "$1" 2> /dev/null
}

## Verify numerical values of response headers

# @param expected value of max-age within Cache-Control header
assertMaxAge() {
    assertMaxAgeIn "$1" "$1"
}

# @param min-value, max-value (of max-age within Cache-Control header)
assertMaxAgeIn() {
    _verifyValueIn "$RESP_CACHE_CONTROL" "$MAX_AGE=" "$1" "$2"
}

# @param min-value, max-value (of Content-Length header)
assertContentLengthIn() {
    _verifyValueIn "$RESP_CONTENT_LENGTH" ": " "$1" "$2"
}

# @param header, min-value, max-value
assertHeaderIn() {
    _verifyValueIn "$1" ": " "$2" "$3"
}

_verifyValueIn() {
    local readonly header="$1"
    local readonly min="$3"
    local readonly max="$4"

    value=$(_getNumberFromAfter "$(_getHeader "$header")" "$2")

    local readonly ok=$((value >= min && value <= max))
    if [ "$ok" != 1 ]; then
        _failAssert "$header: $value, expected $min..$max; $currentUrl"
    fi
}

# @param 1 haystack ("private, max-age=1234, must-revalidate")
# @param 2 needle, after which the number is parsed ("max-age=")
_getNumberFromAfter() {
    local readonly containsStr="$(grep -i "$2" <<< "$1")"

    if [ -n "$containsStr" ]; then
        sed "s/.*$2 *\([0-9\.]*\).*/\1/" <<< "$1"
    else
        echo 0
    fi
}

_removeCRLF() {
    tr -d "\r\n"
}

_getCombinedMessage() {
    local message="$1"
    local readonly another="$2"
    if [ -z "$message" ]; then
        message="$another"
    else
        message="$message; $another"
    fi
    echo "$message"
}

_setCurrentUrl() {
    currentUrl="$1"
}
