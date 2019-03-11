FROM actionblocks/node:8.15.1-stretch

LABEL "com.github.actions.name"="Hugo Broken Link Check"
LABEL "com.github.actions.description"="Looks for broken links in a hugo site"
LABEL "com.github.actions.icon"="link"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="https://github.com/marccampbell/hugo-linkcheck-action"
LABEL "homepage"="http://github.com/marccampbell/hugo-linkcheck-action"
LABEL "maintainer"="Marc Campbell <marc.e.campbell@gmail.com>"

RUN mkdir -p /tmp/hugos
WORKDIR /tmp/hugos

RUN wget https://github.com/gohugoio/hugo/releases/download/v0.54.0/hugo_0.54.0_Linux-64bit.tar.gz && \
    tar xzvf /tmp/hugos/hugo_0.54.0_Linux-64bit.tar.gz && \
    cp hugo /usr/local/bin/hugo && \
    cp hugo /usr/local/bin/hugo_0.54.0 && \
    rm -rf *

ENV HUGO_ACTION_COMMENT=false
ENV HUGO_STARTUP_WAIT=20
ENV HUGO_EXCLUSIONS_LIST=.github/hugo-linkcheck-action/exclusions.json
ENV HUGO_CONFIG=./config.toml
ENV HUGO_ROOT=./
ENV HUGO_CONTENT_ROOT=./content
ENV HUGO_FINAL_URL=http://localhost:1313

ADD entrypoint.sh /entrypoint.sh
ADD . /action
WORKDIR /action

RUN make deps test build


