#!/bin/sh -x
TAG=debdev:stretch
projdir=$(basename $(dirname $PWD))

docker build -t "$TAG" .
docker run \
       --tty --interactive \
       --user $(id -u):$(id -g) \
       --volume "$PWD/../..:/deb" \
       --volume "$HOME/.pip:/home/.pip" \
       --volume "$HOME/.cache:/home/.cache" \
       --workdir "/deb/$projdir" \
       --env "DEBEMAIL=$DEBEMAIL" \
       --env "DEBFULLNAME=$DEBFULLNAME" \
       "$TAG" \
       $*
