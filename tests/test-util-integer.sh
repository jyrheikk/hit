#!/bin/bash
# Test the isInteger common utility.

paramTest=(
    0
    1
    1234567890
)

testInteger() {
    assertTrue "$(isInteger "$1")" "$1"
}
