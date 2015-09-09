#!/bin/bash
# Create HIT API documentation in a JavaDoc-inspired format.
# By default in HTML, or in Markdown if the "md" argument is given.

readonly title="HTTP Integration Tester API"

readonly introduction="The last argument of the assert functions is an optional error message."

main() {
    if [[ "$1" == "md" ]]; then
        createMarkdown
    else
        createHtml
    fi
}

createMarkdown() {
    printHeaderMarkdown
    createContents "md"
}

printHeaderMarkdown() {
    echo "# $title

$introduction"
}

createHtml() {
    printHeaderHtml
    createContents "html"
    printFooterHtml
}

printHeaderHtml() {
    echo "
<!DOCINFO html>
<head>
<title>$title</title>
</head>
<body>
<h1>$title</h1>
<p>$introduction</p>"
}

printFooterHtml() {
    echo "
</ul>
</body>
</html>"
}

createContents() {
    local readonly HIT_DIR="../bin"

    printFunctions "$1" \
        $HIT_DIR/http-request-headers.sh \
        $HIT_DIR/http-request.sh \
        $HIT_DIR/http-assert-headers.sh \
        $HIT_DIR/http-assert.sh \
        $HIT_DIR/http-assert-body.sh \
        $HIT_DIR/bunit-assert.sh \
        $HIT_DIR/http-util.sh
}

printFunctions() {
    local readonly funcName="[^_][A-Za-z0-9]+\("
    local readonly heading="##"
    local readonly transformation="api-doc-$1.awk"
    shift

    egrep -h -B1 "^($funcName|$heading)" "$@" \
        | egrep "^($funcName|#)" \
        | encodeHtml \
        | awk -f "$transformation"
}

encodeHtml() {
    sed -e "s/</\&lt;/g" \
        -e "s/>/\&gt;/g"
}

main "$@"
