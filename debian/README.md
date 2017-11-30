This package uses a straight up 3.0 (quilt) format with dh_python2.

Referencing the guide at https://wiki.debian.org/PackagingWithGit - this is a
fork of the upstream repo at https://github.com/UNINETT/nav .

The upstream master is tracked in the `upstream` branch, while this repo's
`master` branch is used to maintain the `debian/` subdirectory.

The `debian/` directory contains a `Dockerfile` that attempts to set up a
build environment for the currently targeted Debian distribution version, and
also contains the helper scripts `dev.sh`, `build.sh` and `dch.sh` to perform
common package maintenance tasks within a Docker container based on the
`Dockerfile`.


Other useful references:

* Quilt: http://pkg-perl.alioth.debian.org/howto/quilt.html
* git-buildpackage: https://honk.sigxcpu.org/projects/git-buildpackage/manual-html/

