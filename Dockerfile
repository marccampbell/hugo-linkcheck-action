FROM actionblocks/node:8.15.0-stretch

LABEL "com.github.actions.name"="Hugo Broken Link Check"
LABEL "com.github.actions.description"="Looks for broken links in a hugo site"
LABEL "com.github.actions.icon"="link"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="https://github.com/marccampbell/hugo-linkcheck-action"
LABEL "homepage"="http://github.com/marccampbell/hugo-linkcheck-action"
LABEL "maintainer"="Marc Campbell <marc.e.campbell@gmail.com>"

ENV ACTIONBLOCKS_PUBLISHTOKEN "qhTGKj91x3c2Uurvihrfa2Qb"
ENV ACTIONBLOCKS_ENTRYPOINT "/action/entrypoint.sh"

RUN apt-get update -y && apt-get -y --no-install-recommends install hugo && rm -rf /var/lib/apt/lists/*

ENV HUGO_ACTION_COMMENT=false
ENV HUGO_STARTUP_WAIT=20
ENV HUGO_EXCLUSIONS_LIST=.github/hugo-linkcheck-action/exclusions.json
ENV HUGO_CONFIG=./config.toml
ENV HUGO_ROOT=./
ENV HUGO_CONTENT_ROOT=./content
ENV HUGO_FINAL_URL=http://localhost:1313

ADD . /action
WORKDIR /action

RUN make deps test build

# ENTRYPOINT ["/action/entrypoint.sh"]
