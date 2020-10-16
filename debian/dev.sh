#!/bin/sh -x
TAG=debdev:buster
projdir=$(basename $(dirname $PWD))
if [ -n "$NONINTERACTIVE" ]; then
    TTYARGS="--tty"
else
    TTYARGS="--tty --interactive"
fi

docker build -t "$TAG" .
docker run \
       $TTYARGS \
       --user $(id -u):$(id -g) \
       --volume "$PWD/../..:/deb" \
       --volume "$HOME/.pip:/home/.pip" \
       --volume "$HOME/.cache:/home/.cache" \
       --workdir "/deb/$projdir" \
       --env "DEBEMAIL=$DEBEMAIL" \
       --env "DEBFULLNAME=$DEBFULLNAME" \
       "$TAG" \
       $*
