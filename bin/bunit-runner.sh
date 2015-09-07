#!/bin/bash
# Run Bash unit test scripts and their test cases.

source bunit-report.sh

declare -a tmpFiles=()

runScripts() {
    local paramFile=
    local isParamFile=

    includeTestSuiteCommon

    for arg in $1; do
        if [ -n "$(tooManyErrors)" ]; then
            break
        fi

        if [ -n "$isParamFile" ]; then
            isParamFile=
            paramFile=$arg
        elif [ "$(isExecutable "$arg")" ]; then
            source "$arg"
            doDebug "# $arg"
            runParameterizedTestCases "$paramFile"
            paramFile=
        elif [[ "$arg" == "$HIT_ARG_DATA" || "$arg" == "$HIT_ARG_DATA_LONG" ]]; then
            isParamFile=1
            paramFile=
        else
            paramFile="$(getParamFile "$arg")"
        fi
    done
}

includeTestSuiteCommon() {
    local readonly commonFiles="common*.sh"

    for filename in $commonFiles; do
        if [ "$(isExecutable "$filename")" ]; then
            source "$filename"
        fi
    done
}

getParamFile() {
    local readonly script=$1
    local readonly PARAM_FILE_PREFIX="@"

    if [[ "$script" == "$PARAM_FILE_PREFIX"* ]]; then
        local readonly paramFile="${script:${#PARAM_FILE_PREFIX}}"
        [ ! -f "$paramFile" ] && reportFailure "File doesn't exist: $paramFile"
        echo "$paramFile"
    else
        reportFailure "Not executable script: $script"
    fi
}

runParameterizedTestCases() {
    trap removeTmpFiles SIGHUP SIGINT SIGPIPE SIGTERM
    allTestCases=($(compgen -A function "$TEST_CASE_PREFIX"))

    runFunc setUpBeforeClass

    if [ -f "$1" ]; then
        runWithParamFile "$1"
    elif [ "$(isParamTestArray)" ]; then
        runWithParamArray
    elif [ -n "$paramTest" ]; then
        for dataFile in $paramTest; do
            runWithParamFile "$dataFile"
        done
    else
        runTestCases
    fi

    runFunc tearDownAfterClass

    unsetTestCases
}

isParamTestArray() {
    declare -p paramTest 2> /dev/null | grep -q 'declare \-a' && echo 1
}

runWithParamFile() {
    while read -r line; do
        line="$(echo "$line" | excludeCommentEmptyLines)"
        if [ -n "$line" ]; then
            runTestCases "$line"
        fi
    done < "$1"
}

excludeCommentEmptyLines() {
    egrep -v "^ *(#|\$)"
}

runWithParamArray() {
    for data in "${paramTest[@]}"; do
        runTestCases "$data"
    done
}

runTestCases() {
    for testCase in "${allTestCases[@]}"; do
        if [ -n "$(tooManyErrors)" ]; then
            break
        fi
        runTest "$testCase" "$1"
    done
}

runTest() {
    reportProgress
    runFunc setUp
    currTestFailed=
    doDebug "- $1"
    $1 "$2"
    updateTestCounts
    runFunc tearDown
    removeTmpFiles
    _setCurrentUrl ""
}

unsetTestCases() {
    unset -v paramTest
    unset -f setUpBeforeClass setUp tearDown tearDownAfterClass

    for testCase in "${allTestCases[@]}"; do
        unset -f "$testCase"
    done
}

# utilities for handling functions and files

isExecutable() {
    [ -f "$1" -a -x "$1" ] && echo 1
}

removeTmpFiles() {
    for filename in "${tmpFiles[@]}"; do
        removeFile "$filename"
    done
    unset tmpFiles
    declare -a tmpFiles=()
}

removeFile() {
    local readonly filename="$1"
    [[ -n "$filename" ]] && [[ -e "$filename" ]] && rm -f "$filename"
}

addTmpFile() {
    arrayContains "$1" "${tmpFiles[@]}"
    if [ $? -ne 0 ]; then
        tmpFiles=("${tmpFiles[@]}" "$1")
    fi
}

readonly TEST_CASE_PREFIX="test"
