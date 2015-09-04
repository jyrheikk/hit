#!/bin/bash
# Test the test suite report generation.

setUpBeforeClass() {
    runHitTool create-test-suite-report.sh
}

tearDownAfterClass() {
    removeTestResponseBody
}

testScriptName() {
    assertBody "test-suite-report.sh"
}

testScriptDescription() {
    assertBody "Test the test suite report generation"
}

testTestCaseName() {
    assertBody "\- TestCaseName()"
}
