#!/bin/sh -x
TAG=debdev:stretch
projdir=$(basename $(dirname $PWD))

docker build -t "$TAG" .
docker run \
       --tty --interactive \
       --user $(id -u):$(id -g) \
       --volume "$PWD/../..:/deb" \
       --workdir "/deb/$projdir" \
       --env "DEBEMAIL=$DEBEMAIL" \
       --env "DEBFULLNAME=$DEBFULLNAME" \
       "$TAG" \
       $*
