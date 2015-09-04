#!/bin/bash
# Assert functions of the Bash unit test framework.

shopt -s nocasematch

## Basic assertions

# Verify that the given expression returns 1
assertTrue() {
    assertEquals 1 "$1" "$2"
}

# Verify that the given values match (parameter 1: expected value, parameter 2: tested value)
assertEquals() {
    local readonly expected="$1"
    local readonly value="$2"
    local readonly delim=$4

    if [[ "$value" != $delim"$expected"$delim ]]; then
        _failAssertExpected "$expected" "$value" "$3"
    else
        _okAssert
    fi
}

# Verify that the given haystack value contains the given needle value (parameter 1: haystack, parameter 2: needle)
assertContains() {
    assertEquals "$2" "$1" "$3" "*"
}

# Verify that the given file exists
assertFileExists() {
    local readonly filename="$1"
    if [ -f "$filename" ]; then
        _okAssert
    else
        _failAssert "File not found: $filename"
    fi
}

# Verify that the given variable is defined
assertDefined() {
    if [ -z "$1" ]; then
        _failAssert "$2"
    else
        _okAssert
    fi
}

# Skip the test with the given warning message
skipAndWarn() {
    _reportMessage "Warning" "$1" "W"
    skipTest
}

_failAssertExpected() {
    _failAssert "expected <$1> but got <$2>; $3"
}

_failAssert() {
    if [ -z "$assertShouldFail" ]; then
        if [ -z "$currTestFailed" ]; then
            _reportMessage "Assert failed" "$1"
            failTest
        fi
    else
        increaseAssertCount
        assertShouldFail=
    fi
}

_okAssert() {
    if [ -z "$assertShouldFail" ]; then
        increaseAssertCount
    else
        if [ -z "$currTestFailed" ]; then
            _reportMessage "Expectation failed" "Assert should have failed"
            failTest
        fi
        assertShouldFail=
    fi
}

_expectAssertFailure() {
    assertShouldFail=1
}

_reportMessage() {
    local readonly details="$(_reportCallerDetails "$TEST_CASE_PREFIX")"
    local readonly message="$1 in $details: $2"
    reportFailure "$message" "$3"
}

_reportCallerDetails() {
    local readonly funcNamePrefix=$1
    for i in "${!FUNCNAME[@]}"; do
        if [[ "${FUNCNAME[$i]}" == "$funcNamePrefix"* ]]; then
            local filename=$(basename "${BASH_SOURCE[$i]}")
            local funcName=${FUNCNAME[$i]}
            local lineNr=${BASH_LINENO[$i - 1]}
            echo "$filename#$funcName:$lineNr"
            return
        fi
    done
}
