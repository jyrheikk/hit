#!/bin/bash
# Utility methods.

## String utilities

# @param 1 CSV-formatted string, 2 number of field to be returned
parseCsv() {
    parseField "$1" "$2" ","
}

# @param 1 string, 2 number of field to be returned, 3 delimiter
parseField() {
    local ARG="-s"
    [ "$2" == "1" ] && ARG=
    cut $ARG -d"$3" -f"$2" <<< "$1"
}

# @param URL including the protocol (e.g., https://github.com/)
getHostOfUrl() {
    echo "$1" | cut -d/ -f3 | cut -d: -f1
}

# @param URL including the protocol (e.g., https://github.com/jyrheikk/hit/)
getProtocolAndHostOfUrl() {
    echo "$1" | cut -d/ -f-3
}

# Parse JSON value, except array (parameter 1: JSON string without line breaks, parameter 2: attribute name, either key or object.key)
getJsonValue() {
    local readonly json="$1"
    local readonly attr="$(sed 's/\([\.]*\)\./\1\" *: *{.*/' <<< "$2")"

    local readonly boolean="true\|false"
    local readonly number="[0-9][0-9]*"
    local readonly string="\"[^\"]*\""
    local readonly value=" *\($boolean\|$number\|$string\).*"

    sed -e "s/.*\"$attr\" *:$value/\1/" \
        -e 's/^\"//' -e 's/\"$//' <<< "$json"
}

# Returns 0 if the given array contains the given string (parameter 1: string, parameter 2: array)
arrayContains() {
    local elem
    for elem in "${@:2}"; do
        [[ "$elem" == "$1" ]] && return 0
    done
    return 1
}

## Utilities for checking integers

# Returns 1 if the given argument is an integer
isInteger() {
    [[ -z "$(isNotInteger "$1")" && "$1" == [0-9]* ]] && echo 1
}

# Returns 1 if the given argument is not an integer
isNotInteger() {
    local readonly input="$1"
    [[ "${#input}" == 0 || "$input" == *[!0-9]* ]] && echo 1
}

## Utilities for parsing CSV-formatted redirect rules
# <source> may be relative URL
# <destination> must be an absolute URL
# <source-status> for the response of <source> if it's not 301
# <destination-status> for the response of <destination> if it's not 200

readonly REDIRECT_FIELD_SOURCE=1
readonly REDIRECT_FIELD_DESTINATION=2
readonly REDIRECT_FIELD_SOURCE_STATUS=3
readonly REDIRECT_FIELD_DESTINATION_STATUS=4

# @param CSV-formatted string
getSourceUrl() {
    parseCsv "$1" "$REDIRECT_FIELD_SOURCE"
}

# @param CSV-formatted string
getDestinationUrl() {
    parseCsv "$1" "$REDIRECT_FIELD_DESTINATION"
}

# @param 1 CSV-formatted string, 2 (optional) default HTTP status code
getSourceStatus() {
    local readonly defaultSourceStatus=301
    _parseStatus "$REDIRECT_FIELD_SOURCE_STATUS" "$defaultSourceStatus" "$@"
}

# @param 1 CSV-formatted string, 2 (optional) default HTTP status code
getDestinationStatus() {
    local readonly defaultDestinationStatus=200
    _parseStatus "$REDIRECT_FIELD_DESTINATION_STATUS" "$defaultDestinationStatus" "$@"
}

_parseStatus() {
    local readonly defaultCode=$2
    local code="$(parseCsv "$3" "$1")"
    if [ -z "$code" ]; then
        code="$4"
    fi
    if [ -z "$code" ]; then
        code="$defaultCode"
    fi

    echo "$code"
}

## Utilities for running functions

# Run the given function if it exists with the given arguments
runFunc() {
    local readonly funcName="$1"
    shift
    isFunction "$funcName" && $funcName "$@"
}

# Returns OK if the given function exists
isFunction() {
    declare -Ff "$1" > /dev/null
}

# @see http://stackoverflow.com/questions/1203583/how-do-i-rename-a-bash-function

_copyFunc() {
    test -n "$(declare -f $1)" || return
    eval "${_/$1/$2}"
}

_renameFunc() {
    _copyFunc "$@" || return
    unset -f "$1"
}

## Miscellaneous utilities

# @param 1 template name (e.g., "test-redirects"), 2 test data array or filename
useTemplate() {
    local readonly templatesDir="$hitPath/../templates"
    source "$templatesDir/$1.sh"
    paramTest="$2"
}

# Sleep between requests, to avoid creating too much traffic on any one site; the wait time can be set as a command-line argument
doSleep() {
    if [ -z "$optDryRunMode" ]; then
        sleep "$optSleepInSec"
    fi
}
