#!/usr/bin/env bash
#
# Copyright (c) 2016-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.
#

set -e

normalize_text() {
    sed -e "s/’/'/g" -e "s/′/'/g" -e "s/''/ /g" -e "s/'/ ' /g" -e "s/“/\"/g" -e "s/”/\"/g" \
        -e 's/"/ " /g' -e 's/\./ \. /g' -e 's/<br \/>/ /g' -e 's/, / , /g' -e 's/(/ ( /g' -e 's/)/ ) /g' -e 's/\!/ \! /g' \
        -e 's/\?/ \? /g' -e 's/\;/ /g' -e 's/\:/ /g' -e 's/-/ - /g' -e 's/=/ /g' -e 's/=/ /g' -e 's/*/ /g' -e 's/|/ /g' \
        -e 's/«/ /g' | tr 0-9 " "
}

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

NOW=$(date +"%Y%m%d")

ROOT="data/wikimedia/${NOW}"
mkdir -p "${ROOT}"
echo "Saving data in ""$ROOT"
read -r -p "Choose a language (e.g. en, bh, fr, etc.): " choice
LANG="$choice"
echo "Chosen language: ""$LANG"
read -r -p "Continue to download (WARNING: This might be big and can take a long time!)(y/n)? " choice
case "$choice" in 
  y|Y ) echo "Starting download...";;
  n|N ) echo "Exiting";exit 1;;
  * ) echo "Invalid answer";exit 1;;
esac
wget -c "https://dumps.wikimedia.org/""$LANG""wiki/latest/""${LANG}""wiki-latest-pages-articles.xml.bz2" -P "${ROOT}"
