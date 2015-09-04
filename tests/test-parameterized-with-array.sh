#!/bin/bash
# Test parameterized test cases: spaces allowed in array elements.

paramTest=(-66 0 172 43667432304366743230)

testIsNumber() {
    local readonly value="$1"
    local readonly number=$(echo "$value" | egrep "^[0-9-]*$")
    assertEquals "$value" "$number"
}

testEvenNumber() {
    local readonly value="$1"
    assertTrue $((value % 2 == 0)) "$value"
}
