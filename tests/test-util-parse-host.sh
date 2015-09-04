#!/bin/bash
# Test a common utility of parsing the host of URL.

paramTest=(
    "test.com"
    "test.com:80"
    "//test.com"
    "//test.com:80"
    "//test.com/"
    "//test.com:80/"
    "http://test.com"
    "http://test.com:80"
    "http://test.com/"
    "http://test.com:80/"
)

testHostOfUrl() {
    local readonly expectedHost="test.com"
    assertEquals "$(getHostOfUrl "$1")" "$expectedHost" "$1"
}
