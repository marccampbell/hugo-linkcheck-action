#!/bin/sh

if [ "$HUGO_ACTION_COMMENT" = "1" ] || [ "$HUGO_ACTION_COMMENT" = "false" ]; then
    exit 0
fi

hugo serve &
HUGO_PID=$!

sleep 10

COMMENT="#### \`hugo serve\` Failed"

`npm bin`/blc http\://localhost\:1313 -r \
    --host-requests 20 \
    --requests 20 \
    --color=always  | grep -E 'Getting|Finished|BROKEN|^$$'

kill $HUGO_PID

