#!/bin/bash
# Test the arrayContains utility.

paramTest=(
    "THIS IS ok"
    "this is OK"
    "bbb"
)

testArrayContains() {
    local readonly values=(
        "this is OK"
        "bbb"
    )

    local readonly testValue="$1"

    arrayContains "$testValue" "${values[@]}"
    assertEquals 0 $? "$testValue"
}
