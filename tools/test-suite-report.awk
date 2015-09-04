# Make the 1st column as the heading.
# Example input:
#
# script.sh:Test various things.
# script.sh:SeoTags
# script.sh:CssCompressed
#
# output:
#
# script.sh:
# Test various things.
#
# - SeoTags
# - CssCompressed

{
    if (prevHeading != $1) {
        prevHeading = $1
        print "\n",$1

        if (match($2, /^ Test/)) {
            print $2,"\n"
            next
        }
        print ""
    }
    print " -",$2
}
