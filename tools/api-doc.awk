# Display the @param comment after the function name.
# Sample input:
#
# <h2>Verify HTTP response headers</h2>
# setCacheControl
# # @param username:password in plain text
# setCredentials
#
# output:
#
# <h2>Verify HTTP response headers</h2>
# <li>setCacheControl</li>
# <li>setCredentials
# <br/># @param username:password in plain text</li>

/^##/ {
    # gensub would be simpler, but is not supported as widely as gsub
    heading = $0
    gsub(/^## */, "</ul><h2>", heading)
    gsub(/$/, "</h2><ul>", heading)
    print heading
}
/^# / {
    params = $0
    gsub(/# /, "<i>", params)
    gsub(/@param/, "Parameters:", params)
    gsub(/$/, "</i>", params)
}
/^[^#]/ {
    functionName = $0
    gsub(/\(.*/, "", functionName)
    printf("<li>%s\n", functionName)

    if (params != "") {
        printf("<br/>%s</li>\n", params)
        params = ""
    }
}
