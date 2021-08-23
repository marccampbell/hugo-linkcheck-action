#!/bin/bash

# Install Hugo
VER="${HUGO_VERSION:-0.85.0}"



# Use the hugo serve command to create a website that will be used for link checking
pushd /github/workspace/${HUGO_ROOT}
hugo serve --baseUrl http://localhost:1313 --contentDir /github/workspace/${HUGO_CONTENT_ROOT} --config /github/workspace/$HUGO_CONFIG &
HUGO_PID=$!
popd

# Give hugo some time to start.
sleep $HUGO_STARTUP_WAIT

# If hugo has failed, report it as a comment (if comments are enabled)
# if [ -n "$PID" -a -e /proc/$PID ]; then
#   # Hugo started
# else
#   exit 1
# fi

COMMENT="#### \`hugo serve\` Failed"


# for exclusion in $(cat $HUGO_EXCLUSION_LIST)
# do
#     exclusionarg=$exclusionarg" --exclude $exclusion "
# done

COMMAND="node --no-deprecation /action/build/hugo-linkcheck-action.js scan --url http://localhost:1313 --exclude-file /github/workspace/${HUGO_EXCLUSIONS_LIST}"

OUTPUT=$($COMMAND)

echo "{$OUTPUT}"

# Kill the hugo serve
kill $HUGO_PID

