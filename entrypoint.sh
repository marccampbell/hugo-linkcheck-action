#!/bin/sh

# Use the hugo serve command to create a website that will be used for link checking
hugo serve --baseUrl http://localhost:1313 &
HUGO_PID=$!

# Give hugo some time to start.
sleep $HUGO_STARTUP_WAIT

# If hugo has failed, report it as a comment (if comments are enabled)
# if [ -n "$PID" -a -e /proc/$PID ]; then
#   # Hugo started
# else
#   exit 1
# fi

COMMENT="#### \`hugo serve\` Failed"

for exclusion in $(cat $HUGO_EXCLUSION_LIST)
do
    exclusionarg=$exclusionarg" --exclude $exclusion "
done

COMMAND="blc -r --host-requests 20 --requests 20 $exclusionarg --input http://localhost:1313"

OUTPUT=$($COMMAND)

echo "{$OUTPUT%x}" | grep -o -P 'BROKEN.{0,255}' | awk '{print $2}'

# Kill the hugo serve
kill $HUGO_PID

