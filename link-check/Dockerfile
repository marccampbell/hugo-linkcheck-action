FROM node:8.15.0-stretch

LABEL "com.github.actions.name"="hugo link-check"
LABEL "com.github.actions.description"="Looks for broken links in a hugo site"
LABEL "com.github.actions.icon"="link"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="https://github.com/marccampbell/hugo-github-actions"
LABEL "homepage"="http://github.com/marccampbell/hugo-github-actions"
LABEL "maintainer"="Marc Campbell <marc.e.campbell@gmail.com>"

RUN apt-get update -y && apt-get -y --no-install-recommends install hugo && rm -rf /var/lib/apt/lists/*

ENV HUGO_ACTION_COMMENT=false
ENV HUGO_STARTUP_WAIT=20

RUN npm i -g broken-link-checker@0.7.8
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
