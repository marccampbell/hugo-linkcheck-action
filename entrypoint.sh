#!/bin/bash -x

# Install Hugo
VER="${HUGO_VERSION:-0.85.0}"

mkdir /tmp/hugos
pushd /tmp/hugos
wget https://github.com/gohugoio/hugo/releases/download/v${VER}/hugo_extended_${VER}_Linux-64bit.tar.gz
tar xzvf /tmp/hugos/hugo_extended_${VER}_Linux-64bit.tar.gz
cp hugo /usr/local/bin/hugo
rm -rf *
popd

WORKDIR="${GITHUB_WORKSPACE:-/github/workspace}"
# Use the hugo serve command to create a website that will be used for link checking
pushd ${WORKDIR}/${HUGO_ROOT}
hugo serve --baseUrl http://localhost:1313 --contentDir ${WORKDIR}/${HUGO_CONTENT_ROOT} &
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

node --no-deprecation /action/build/hugo-linkcheck-action.js scan --url http://localhost:1313 --exclude-file /github/workspace/${HUGO_EXCLUSIONS_LIST}

# Kill the hugo serve
kill $HUGO_PID

