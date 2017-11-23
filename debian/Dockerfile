FROM debian:jessie

RUN  echo "deb http://ftp.no.debian.org/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list

RUN  apt-get -y update && \
     apt-get install -y \
       pbuilder \
       vim \
       cdbs \
       autoconf \
       automake \
       python-sphinx \
       python-support \
       ruby-sass/jessie-backports \
       quilt \
       reportbug \
       python-psycopg2 \
       python-zope.interface \
       dh-systemd \
       git-buildpackage \
     && \
     apt-get clean

ENV  QUILT_PATCHES debian/patches
ENV  QUILT_NO_DIFF_INDEX 1
ENV  QUILT_NO_DIFF_TIMESTAMPS 1
ENV  QUILT_REFRESH_ARGS -p ab

CMD  /bin/bash
