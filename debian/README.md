This package uses a straight up 3.0 (quilt) format with dh_python2.

Rename and unpack the original NAV source tarball, copy the debian/ directory
into it. Update the Debian changelog, using `debchange`, and build as normal
using `debuild -i`. You may need to refresh the quilt patches.

Read http://pkg-perl.alioth.debian.org/howto/quilt.html for more details about
editing patches using quilt.

 -- Morten Brekkevold <morten.brekkevold@uninett.no>  Mon, 24 Feb 2014 15:03:25 +0200
