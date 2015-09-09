#!/bin/bash
# Create readonly declarations of the HIT framework functions,
# so that they are not accidentally overwritten by tests.

readonly HIT_DIR="../bin"

main() {
    declareReadonlyFunctions
}

declareReadonlyFunctions() {
    local readonly FILENAME="$HIT_DIR/readonly-functions.sh"

    echo "# DO NOT EDIT THIS AUTOMATICALLY GENERATED FILE" > "$FILENAME"
    getFunctionNames | declareReadonly >> "$FILENAME"
    chmod 755 "$FILENAME"
}

getFunctionNames() {
    local readonly funcName="^[A-Za-z0-9_]+\("

    egrep -h "^$funcName" $HIT_DIR/*.sh $HIT_DIR/hit | cut -d"(" -f1 | sort
}

declareReadonly() {
    sed "s/^/readonly -f /"
}

main "$@"
