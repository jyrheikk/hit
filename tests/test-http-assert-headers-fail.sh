#!/bin/bash
# Test that HTTP assertions fail as expected.

setUpBeforeClass() {
    setTestResponseHeaders "$testDataDir/response-headers.txt"
}

setUp() {
    _expectAssertFailure
}

tearDownAfterClass() {
    removeTestResponseHeaders
}

testStatusCode() {
    assertStatusCodeExpected 200
}

testContentType() {
    assertContentTypeExpected "json"
}

testLocationEmpty() {
    assertLocation ""
}

testNonExistingHeader() {
    assertVary "$REQ_ACCEPT_ENCODING"
}

testContentLength() {
    assertContentLength "2580"
}

testCacheControl() {
    assertCacheControl "$PUBLIC"
}

testExactMatch() {
    assertServer "gws $"
}

testMaxAge() {
    assertMaxAgeIn 180 1799
}
