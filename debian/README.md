# NAV Debian package

This package uses a straight up 3.0 (quilt) format with dh_virtualenv

Referencing the guide at https://wiki.debian.org/PackagingWithGit - this is a
fork of the upstream repo at https://github.com/UNINETT/nav .

The upstream master is tracked in the `upstream` branch, while this repo's
`master` branch is used to maintain the `debian/` subdirectory.

The `debian/` directory contains a `Dockerfile` that attempts to set up a
build environment for the currently targeted Debian distribution version, and
also contains the helper scripts `dev.sh`, `build.sh` and `dch.sh` to perform
common package maintenance tasks within a Docker container based on the
`Dockerfile`.

## Dependency considerations

Most of NAV's Python dependencies will be vendored into this package, using the
dh_virtualenv mechanism. However, for Debian 8 (Jessie), there is no version of
`libgammu-dev` that can match up with any version of `python-libgammu` that is
published on PyPI. Debian Jessie ships with version 1.33.0, but even in the
`python-libgammu` Github repository, there are no versions prior to 2.0 that
provide a `setup.py` build, so it cannot be installed by pip anyway.


## Other useful references:

* Quilt: http://pkg-perl.alioth.debian.org/howto/quilt.html
* git-buildpackage: https://honk.sigxcpu.org/projects/git-buildpackage/manual-html/
* dh-virtualenv: https://dh-virtualenv.readthedocs.io/
