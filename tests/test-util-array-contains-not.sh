#!/bin/bash
# Test the arrayContains utility.

paramTest=(
    "this"
    "bb"
    "."
    " "
)

testArrayContains() {
    local readonly values=(
        "this is OK"
        "bbb"
    )

    local readonly testValue="$1"

    arrayContains "$testValue" "${values[@]}"
    assertEquals 1 $? "$testValue"
}
