#!/bin/bash
# Run Bash unit test scripts and their test cases.

source bunit-report.sh

declare -a tmpFiles=()

_runScripts() {
    local readonly testScripts=("${@}")
    local paramFile=
    local isParamFile=

    _includeTestSuiteCommon

    for arg in ${testScripts[@]}; do
        if [ -n "$(_tooManyErrors)" ]; then
            break
        fi

        if [ -n "$isParamFile" ]; then
            isParamFile=
            paramFile=$arg
        elif [ "$(_isExecutable "$arg")" ]; then
            source "$arg"
            _doDebug "# $arg"
            _runParameterizedTestCases "$paramFile"
            paramFile=
        elif [[ "$arg" == "$HIT_ARG_INPUT" || "$arg" == "$HIT_ARG_INPUT_LONG" ]]; then
            isParamFile=1
            paramFile=
        else
            paramFile="$(_getParamFile "$arg")"
        fi
    done
}

_includeTestSuiteCommon() {
    local readonly commonFiles="common*.sh"

    for filename in $commonFiles; do
        if [ "$(_isExecutable "$filename")" ]; then
            source "$filename"
        fi
    done
}

_getParamFile() {
    local readonly script=$1
    local readonly PARAM_FILE_PREFIX="@"

    if [[ "$script" == "$PARAM_FILE_PREFIX"* ]]; then
        local readonly paramFile="${script:${#PARAM_FILE_PREFIX}}"
        [ ! -f "$paramFile" ] && _reportFailure "File doesn't exist: $paramFile"
        echo "$paramFile"
    else
        _reportFailure "Not executable script: $script"
    fi
}

_runParameterizedTestCases() {
    trap removeTmpFiles SIGHUP SIGINT SIGPIPE SIGTERM
    allTestCases=($(compgen -A function "$TEST_CASE_PREFIX"))

    runFunc setUpBeforeClass

    if [ -f "$1" ]; then
        _runWithParamFile "$1"
    elif [ "$(_isParamTestArray)" ]; then
        _runWithParamArray
    elif [ -n "$paramTest" ]; then
        for dataFile in $paramTest; do
            _runWithParamFile "$dataFile"
        done
    else
        _runTestCases
    fi

    runFunc tearDownAfterClass

    _unsetTestCases
}

_isParamTestArray() {
    declare -p paramTest 2> /dev/null | grep -q 'declare \-a' && echo 1
}

_runWithParamFile() {
    while read -r line; do
        line="$(echo "$line" | _excludeCommentEmptyLines)"
        if [ -n "$line" ]; then
            _runTestCases "$line"
        fi
    done < "$1"
}

_excludeCommentEmptyLines() {
    egrep -v "^ *(#|\$)"
}

_runWithParamArray() {
    for data in "${paramTest[@]}"; do
        _runTestCases "$data"
    done
}

_runTestCases() {
    for testCase in "${allTestCases[@]}"; do
        if [ -n "$(_tooManyErrors)" ]; then
            break
        fi
        _runTest "$testCase" "$1"
    done
}

_runTest() {
    _reportProgress
    runFunc setUp
    currTestFailed=
    _doDebug "- $1"
    $1 "$2"
    _updateTestCounts
    runFunc tearDown
    _removeTmpFiles
    _setCurrentUrl ""
}

_unsetTestCases() {
    unset -v paramTest
    unset -f setUpBeforeClass setUp tearDown tearDownAfterClass

    for testCase in "${allTestCases[@]}"; do
        unset -f "$testCase"
    done
}

# utilities for handling functions and files

_isExecutable() {
    [ -f "$1" -a -x "$1" ] && echo 1
}

_removeTmpFiles() {
    for filename in "${tmpFiles[@]}"; do
        _removeFile "$filename"
    done
    unset tmpFiles
    declare -a tmpFiles=()
}

_removeFile() {
    local readonly filename="$1"
    [[ -n "$filename" ]] && [[ -e "$filename" ]] && rm -f "$filename"
}

_addTmpFile() {
    arrayContains "$1" "${tmpFiles[@]}"
    if [ $? -ne 0 ]; then
        tmpFiles=("${tmpFiles[@]}" "$1")
    fi
}

readonly TEST_CASE_PREFIX="test"
