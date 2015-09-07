#!/bin/bash

# REQUEST HEADERS
readonly defaultAccept="*/*"
readonly defaultAcceptEncoding="gzip, deflate"
readonly defaultAcceptLanguage="en"
readonly defaultCacheControl="$NO_CACHE"
readonly defaultPragma="$NO_CACHE"
readonly defaultUserAgent="HIT tester"

# CURL PARAMETERS
# when testing outside intranet (e.g., against Akamai Staging), clear the proxy as follows:
# http_proxy= hit
readonly defaultProxy=$http_proxy

# timeout values, in seconds
readonly defaultConnectTimeout=60
readonly defaultMaxTime=30
