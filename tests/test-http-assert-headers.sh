#!/bin/bash
# Test assert HTTP response functions.

setUpBeforeClass() {
    setTestResponseHeaders "$testDataDir/response-headers.txt"
}

tearDownAfterClass() {
    removeTestResponseHeaders
}

testStatus() {
    local readonly status="$(getStatus)"
    assertEquals "302" "$status"
}

testResponseHeaders() {
    assertStatusMovedTemporarily
    assertLocation "http://www.google.fi/?gws_rd=cr&ei=Dhl0UrSJJebJ4ATEvICADw+abc+def"
    assertLocation "WWW.GOOGLE.FI"
    assertCacheControl "$PRIVATE"
    assertMaxAgeIn 1800 1800
    assertServer "gws$"
    assertSetCookie "NID=67"
}

testCookie() {
    local readonly cookie="$(getCookie "NID" | cut -d";" -f1)"
    assertEquals "NID=67" "$cookie"
}

testLocationHeader() {
    local readonly location="$(getHeaderValue "$RESP_LOCATION")"
    assertEquals "http://www.google.fi/?gws_rd=cr&ei=Dhl0UrSJJebJ4ATEvICADw+abc+def" "$location"
}
