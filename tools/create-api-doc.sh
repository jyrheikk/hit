#!/bin/bash
# Create HIT API documentation in a JavaDoc-inspired format.

main() {
    printHeader

    local readonly DIR=..
    printFunctions $DIR/http-request-headers.sh \
        $DIR/http-request.sh \
        $DIR/http-assert-headers.sh \
        $DIR/http-assert.sh \
        $DIR/http-assert-body.sh \
        $DIR/bunit-assert.sh \
        $DIR/http-util.sh

    printFooter
}

printHeader() {
    local readonly title="HTTP Integration Tester API"

    echo "
<!DOCINFO html>
<head>
<title>$title</title>
</head>
<body>
<h1>$title</h1>"
}

printFooter() {
    echo "
</ul>
</body>
</html>"
}

printFunctions() {
    local readonly funcName="[^_][A-Za-z0-9]+\("
    local readonly heading="##"

    egrep -h -B1 "^($funcName|$heading)" "$@" \
        | egrep "^($funcName|#)" \
        | encodeHtml \
        | awk -f api-doc.awk
}

encodeHtml() {
    sed -e "s/</\&lt;/g" \
        -e "s/>/\&gt;/g"
}

main "$@"
