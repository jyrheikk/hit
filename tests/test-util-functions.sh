#!/bin/bash
# Test function utilities.

_numberOfArgs=0
_firstArg=

tearDownAfterClass() {
    unset _numberOfArgs
    unset _firstArg
}

testIsFunction() {
    isFunction "_testUtilFuncTemp"
    assertEquals 0 $?
}

testIsNotFunction() {
    isFunction "thisFunctionShouldNotExist"
    assertEquals 1 $?
}

testRunFunc() {
    runFunc _testUtilFuncTemp "arg 1" 2 3 4 5 6 7 8 9 "number 10"
    assertEquals 10 $_numberOfArgs
    assertEquals "arg 1" "$_firstArg"
}

testRenameFunc() {
    local readonly oldFunc="_testUtilFuncTemp2"
    local readonly newFunc="_testUtilFuncTemp3"

    isFunction $oldFunc
    assertEquals 0 $?

    isFunction $newFunc
    assertEquals 1 $?

    _renameFunc $oldFunc $newFunc

    isFunction $oldFunc
    assertEquals 1 $?

    isFunction $newFunc
    assertEquals 0 $?
}

_testUtilFuncTemp() {
    _numberOfArgs=$#
    _firstArg="$1"
}

_testUtilFuncTemp2() {
    local x=
}
