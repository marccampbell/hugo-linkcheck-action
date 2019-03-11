#!/bin/bash

hugo_versions=(0.54.0 0.53 0.52 0.51 0.50 0.49 0.48 0.47)

for hugo_version in "${hugo_versions[@]}"; do
  echo "Downloading hugo ${hugo_version}"
  mkdir -p /tmp/hugo_download
  cd /tmp/hugo_download
  wget -q https://github.com/gohugoio/hugo/releases/download/v${hugo_version}/hugo_${hugo_version}_Linux-64bit.tar.gz
  tar xzf hugo_${hugo_version}_Linux-64bit.tar.gz
  cp hugo /usr/local/bin/hugo_${hugo_version}
  cd /tmp
  rm -rf /tmp/hugo_download

done

cp /usr/local/bin/hugo_${hugo_versions[0]} /usr/local/bin/hugo
