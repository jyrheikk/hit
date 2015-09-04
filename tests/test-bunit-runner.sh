#!/bin/bash
# Test the Bash unit test framework using itself, of course.

setUpBeforeClass() {
    ((setUpBeforeClassCount++))
    tearDownAfterClassCount=0
}

setUp() {
    ((setUpCount++))
}

tearDown() {
    ((tearDownCount++))
}

tearDownAfterClass() {
    ((tearDownAfterClassCount++))
    # bad practice: asserts should be run only in test cases
    assertEquals 1 $setUpBeforeClassCount
    assertEquals $setUpCount $tearDownCount
    assertEquals 1 $tearDownAfterClassCount
}

testIsExecutable() {
    local readonly THIS_SCRIPT="test-bunit-runner.sh"
    [ "$(isExecutable $THIS_SCRIPT)" ] || _failAssert $THIS_SCRIPT
    assertInTestCase
}

testIsNotExecutable() {
    local readonly TEST_FILE="$testDataDir/response-body.html"
    isExecutable "$TEST_FILE" && _failAssert "$TEST_FILE"
    assertInTestCase
}

testIsFunction() {
    local readonly EXISTING="assertTrue"
    isFunction $EXISTING || _failAssert $EXISTING
}

testIsNotFunction() {
    local readonly NON_EXISTING="someNonExistingFunction"
    isFunction $NON_EXISTING && _failAssert $NON_EXISTING
}

assertInTestCase() {
    assertEquals 1 $setUpBeforeClassCount "setUpBeforeClassCount"
    assertEquals $setUpCount $((tearDownCount + 1)) "setUpCount == tearDownCount + 1"
    assertEquals 0 $tearDownAfterClassCount "tearDownAfterClassCount"
}

TESTCaseNot() {
    _failAssert "invalid test case: TESTCaseNot"
}

_testCaseNot() {
    _failAssert "invalid test case: _testCaseNot"
}
