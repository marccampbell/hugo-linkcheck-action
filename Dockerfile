FROM node:8.15.0-stretch

LABEL "com.github.actions.name"="hugo link-check"
LABEL "com.github.actions.description"="Looks for broken links in a hugo site"
LABEL "com.github.actions.icon"="link"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="https://github.com/marccampbell/hugo-linkcheck-action"
LABEL "homepage"="http://github.com/marccampbell/hugo-linkcheck-action"
LABEL "maintainer"="Marc Campbell <marc.e.campbell@gmail.com>"

RUN apt-get update -y && apt-get -y --no-install-recommends install hugo && rm -rf /var/lib/apt/lists/*

ENV HUGO_ACTION_COMMENT=false
ENV HUGO_STARTUP_WAIT=20
ENV HUGO_EXCLUSION_LIST=.github/hugo-linkcheck-action/exclusions
ENV HUGO_CONFIG=./config.toml

ADD . /action
WORKDIR /action

RUN make deps test build

ENTRYPOINT ["/action/entrypoint.sh"]
