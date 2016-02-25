#!/bin/bash
# Syntactic sugar for HTTP response Content-Type assert methods.

## Verify Content-Type response header

assertType3gp() { assertContentType "$CONTENT_TYPE_3GP" "$1"; }
assertTypeAac() { assertContentType "$CONTENT_TYPE_AAC" "$1"; }
assertTypeAvi() { assertContentType "$CONTENT_TYPE_AVI" "$1"; }
assertTypeCss() { assertContentType "$CONTENT_TYPE_CSS" "$1"; }
assertTypeFlash() { assertContentType "($CONTENT_TYPE_FLASH|$CONTENT_TYPE_APPLICATION_FLASH)" "$1"; }
assertTypeGif() { assertContentType "$CONTENT_TYPE_GIF" "$1"; }
assertTypeHtml() { assertContentType "$CONTENT_TYPE_HTML" "$1"; }
assertTypeJavaScript() { assertContentType "($CONTENT_TYPE_APPLICATION_JAVASCRIPT|$CONTENT_TYPE_APPLICATION_X_JAVASCRIPT|$CONTENT_TYPE_JAVASCRIPT)" "$1"; }
assertTypeJpeg() { assertContentType "$CONTENT_TYPE_JPEG" "$1"; }
assertTypeJson() { assertContentType "($CONTENT_TYPE_APPLICATION_JSON|$CONTENT_TYPE_JSON)" "$1"; }
assertTypeMp4() { assertContentType "$CONTENT_TYPE_MP4" "$1"; }
assertTypeMpeg() { assertContentType "$CONTENT_TYPE_MPEG" "$1"; }
assertTypeOctetStream() { assertContentType "$CONTENT_TYPE_APPLICATION_OCTET_STREAM" "$1"; }
assertTypePdf() { assertContentType "$CONTENT_TYPE_PDF" "$1"; }
assertTypePng() { assertContentType "$CONTENT_TYPE_PNG" "$1"; }
assertTypeQuickTime() { assertContentType "$CONTENT_TYPE_QUICKTIME" "$1"; }
assertTypeText() { assertContentType "$CONTENT_TYPE_TEXT" "$1"; }
assertTypeWebM() { assertContentType "$CONTENT_TYPE_WEBM" "$1"; }
assertTypeWindowsMedia() { assertContentType "$CONTENT_TYPE_WINDOWS_MEDIA" "$1"; }
assertTypeXml() { assertContentType "($CONTENT_TYPE_APPLICATION_XML|$CONTENT_TYPE_XML)" "$1"; }

# @param file type (css, gif, js, json, png, txt, xml), default is "html"
assertContentTypeExpected() {
    case "$1" in
        aac)
            assertTypeAac "$2"
            ;;
        avi)
            assertTypeAvi "$2"
            ;;
        css)
            assertTypeCss "$2"
            ;;
        flv)
            assertTypeFlash "$2"
            ;;
        gif)
            assertTypeGif "$2"
            ;;
        gp)
            assertType3gp "$2"
            ;;
        js)
            assertTypeJavaScript "$2"
            ;;
        jpeg | jpg)
            assertTypeJpeg "$2"
            ;;
        json)
            assertTypeJson "$2"
            ;;
        mov)
            assertTypeQuickTime "$2"
            ;;
        mp4)
            assertTypeMp4 "$2"
            ;;
        mp3 | mpeg)
            assertTypeMpeg "$2"
            ;;
        octet)
            assertTypeOctetStream "$2"
            ;;
        pdf)
            assertTypePdf "$2"
            ;;
        png)
            assertTypePng "$2"
            ;;
        text | txt)
            assertTypeText "$2"
            ;;
        webm)
            assertTypeWebM "$2"
            ;;
        wmv)
            assertTypeWindowsMedia "$2"
            ;;
        xml)
            assertTypeXml "$2"
            ;;
        *)
            assertTypeHtml "$2"
            ;;
    esac
}
