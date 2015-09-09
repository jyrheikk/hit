#!/bin/bash

readonly testDataDir="testdata"

runHitTool() {
    local readonly SCRIPT="$1"
    shift

    local readonly DOC="$SCRIPT-$RANDOM.tmp"
    local readonly TOOLS_DIR="../tools"
    local readonly TESTS_DIR="../tests"

    cd "$TOOLS_DIR"
    $SCRIPT "$@" "$TESTS_DIR" > "$TESTS_DIR/$DOC"
    cd "$TESTS_DIR"

    setTestResponseBody "$DOC"
    _removeFile "$DOC"
}

setTestResponseBody() {
    # do not report some random URL in failures
    _setCurrentUrl ""
    # hack to enable _hasResponseBody in http-request.sh
    responseBodyRequested=1
    cp "$1" "$req_responseBody"
}

removeTestResponseBody() {
    _removeFile "$req_responseBody"
}

setTestResponseHeaders() {
    cp "$1" "$req_responseHeaders"
}

removeTestResponseHeaders() {
    _removeFile "$req_responseHeaders"
}
