#!/bin/bash
# Test assert functions.

testAssertTrue() {
    assertTrue 1
    assertTrue $((1 + 1 == 2))

    local readonly value="12345"
    local readonly MIN_LEN=4
    local readonly MAX_LEN=6

    assertTrue $((${#value} > MIN_LEN && ${#value} < MAX_LEN))
}

testPositiveNumber() {
    assertTrue "$(isPositiveNumber "5")"
    assertTrue "$(isPositiveNumber 5)"
}

testNonPositiveNumber() {
    assertEquals "" "$(isPositiveNumber 0)"
    assertEquals "" "$(isPositiveNumber)"
}

isPositiveNumber() {
    if [[ -n "$1" && $1 -gt 0 ]]; then
        echo 1
    fi
}

testAssertContainsBegin() {
    assertContains "haystack" "hay"
}

testAssertContains() {
    assertContains "haystack" "st"
}

testAssertContainsEnd() {
    assertContains "haystack" "stack"
}

testAssertEqualsWithTypeCast() {
    assertEquals 123 "123"
}

testArrayOperationsOnNonArrays() {
    local readonly notArray="notArray"
    assertEquals 1 ${#notArray[@]}
    assertEquals "notArray" ${notArray[0]}
}

testAssertDefined() {
    local readonly x=x
    assertDefined "$x" "variable x not defined"
}
