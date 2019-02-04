#!/bin/sh

hugo serve &
HUGO_PID=$!

sleep $HUGO_STARTUP_WAIT

COMMENT="#### \`hugo serve\` Failed"

OUTPUT=$(`npm bin`/blc http\://localhost\:1313 -r \
    --host-requests 20 \
    --requests 20 \
    --color=never | grep -E 'Getting|Finished|BROKEN|^$$')

echo $OUTPUT | grep -o -P 'BROKEN.{0,255}'  | awk '{print $2}'

kill $HUGO_PID

