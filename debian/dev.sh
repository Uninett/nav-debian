#!/bin/sh -x
TAG=debdev:bullseye
projdir=$(basename $(dirname $PWD))
if [ -n "$NONINTERACTIVE" ]; then
    TTYARGS="--tty"
else
    TTYARGS="--tty --interactive"
fi

mkdir -p "$PWD/.cache" "$PWD/.pip-cache"

docker build -t "$TAG" . && \
docker run \
       $TTYARGS \
       --user $(id -u):$(id -g) \
       --volume "$PWD/../..:/deb" \
       --volume "$PWD/.pip-cache:/home/.pip" \
       --volume "$PWD/.cache:/home/.cache" \
       --workdir "/deb/$projdir" \
       --env "DEBEMAIL=$DEBEMAIL" \
       --env "DEBFULLNAME=$DEBFULLNAME" \
       --env "EDITOR=vim" \
       "$TAG" \
       $*
