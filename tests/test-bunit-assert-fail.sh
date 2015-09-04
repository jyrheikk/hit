#!/bin/bash
# Test assert failures.

setUp() {
    _expectAssertFailure
}

testFailAssertTrueNotOne() {
    assertTrue 2
}

testFailAssertTrueDecimal() {
    assertTrue 1.0
}

testFailAssertEqualsDifferentStrings() {
    assertEquals "1" "01"
}

testFailAssertEqualsDifferentNumbers() {
    assertEquals 1 2
}

testFailAssertFileExists() {
    assertFileExists "this-file-does-not-exist"
}
