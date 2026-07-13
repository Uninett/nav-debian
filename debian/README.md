# NAV Debian package

Referencing the guide at https://wiki.debian.org/PackagingWithGit - this is a
fork of the upstream NAV repo at https://github.com/Uninett/nav, with an added
`debian/` directory for building Debian packages from NAV.

This package uses a straight up 3.0 (quilt) format with `dh_virtualenv`.


## TL;DR

To build NAV 4.9.8 for Debian Stretch:

    git clone git@github.com:Uninett/nav-debian.git
    cd nav-debian
    git checkout debian-stretch
    git remote add upstream git@github.com:Uninett/nav.git
    git fetch --tags upstream
    git pull upstream 4.9.8
    cd debian
	./dch.sh -v 4.9.8-1
    ./build.sh

This clones this repo, tracks the upstream NAV repo in the `upstream` remote,
pulls and merges the 4.9.8 tag, updated the Debian changelog with a package
version of `4.9.8-1`, and runs a full package build.

## Build tools

The `debian/` directory contains a `Dockerfile` that describes a build
environment for the currently targeted Debian distribution version. The
directory also contains a few helper shell scripts to aid in using Docker to
build the package:

<dl>

  <dt><code>dev.sh</code></dt>
  <dd>Will drop you into a shell inside a Docker container, containing the full environment needed to build a Debian package for the targeted Debian version.</dd>

  <dt><code>dch.sh</code></dt>
  <dd>Will run <code>debchange</code> inside a Docker container to manipulate the Debian changelog of the package. Any arguments will be forwarded to the <code>debchange</code> command.</dd>

  <dt><code>build.sh</code></dt>
  <dd>Will run <code>debuild</code> inside a Docker container to produce a working Debian package.</dd>

</dl>

## Dependency considerations

Most of NAV's Python dependencies will be vendored into this package, using the
`dh_virtualenv` mechanism.

## Other useful references:

* Quilt: http://pkg-perl.alioth.debian.org/howto/quilt.html
* git-buildpackage: https://honk.sigxcpu.org/projects/git-buildpackage/manual-html/
* dh-virtualenv: https://dh-virtualenv.readthedocs.io/
