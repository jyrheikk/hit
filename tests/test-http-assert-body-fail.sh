#!/bin/bash
# Test that HTTP body assertions fail as expected.

setUpBeforeClass() {
    setTestResponseBody "$testDataDir/response-body.html"
}

setUp() {
    _expectAssertFailure
}

tearDownAfterClass() {
    removeTestResponseBody
}

testDiv() {
    assertBody "<div>"
}

testNoTitle() {
    assertBodyNot "<title>"
}
