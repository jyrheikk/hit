#!/bin/bash
# Test assertJson.

setUpBeforeClass() {
    setTestResponseBody "$testDataDir/sample.json"
}

tearDownAfterClass() {
    removeTestResponseBody
}

testParseJsonString() {
    assertJson "lastName" "Smith"
}

testParseJsonNumber() {
    assertJson "age" 25
}

testParseJsonBoolean() {
    assertJson "married" false
}

testParseJsonObject() {
    assertJson "address.streetAddress" "21 2nd Street"
}
