# Display the @param comment after the function name.
# Sample input:
#
# ## Verify HTTP response headers
# setCacheControl
# # @param username:password in plain text
# setCredentials
#
# output:
#
# ## Verify HTTP response headers
# * setCacheControl
# * setCredentials
#   * Parameters: username:password in plain text

/^##/ {
    heading = $0
    printf("\n%s\n", heading)
}
/^# / {
    params = $0
    gsub(/# /, "  * ", params)
    gsub(/@param/, "Parameters:", params)
}
/^[^#]/ {
    functionName = $0
    gsub(/\(.*/, "", functionName)
    printf("* `%s`\n", functionName)

    if (params != "") {
        printf("%s\n", params)
        params = ""
    }
}
