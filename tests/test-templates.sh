#!/bin/bash
# Test HIT test class templates.

useTemplate "test-integrations" "$testDataDir/integrations-empty.csv"

setUpBeforeClass() {
    local readonly EXISTING="testUrl"
    isFunction $EXISTING || _failAssert "$EXISTING not defined"
}

test() {
    _failAssert "not called without input test data"
}
