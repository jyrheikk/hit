#!/bin/bash
# Test the isNotInteger common utility.

paramTest=(
    1.0
    -1
    1234567890a
    x
    ""
)

testNotInteger() {
    assertTrue "$(isNotInteger "$1")" "$1"
}
