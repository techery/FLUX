#!/bin/bash

# Docs by jazzy
# https://github.com/realm/jazzy
# ------------------------------
SOURCE=Sources
SOURCE_TMP=FLUX

# temporary workaround when using SPM dir format
# https://github.com/realm/jazzy/issues/667
mv $SOURCE $SOURCE_TMP

jazzy \
	--objc \
	--clean \
	--author 'Techery' \
    --author_url 'http://techery.io' \
    --github_url 'https://github.com/techery' \
    --sdk iphonesimulator \
    --module FLUX \
    --framework-root . \
    --umbrella-header $SOURCE_TMP/FLUX.h \
    --readme README.md \
    --output docs/

# restore the dir per the jazzy issue
mv $SOURCE_TMP $SOURCE
