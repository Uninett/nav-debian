FROM debian:jessie

# Need more recent versions of dh-virtualenv and setuptools
RUN  echo "deb http://deb.debian.org/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list

RUN  apt-get -y update && \
     apt-get install -y \
       pbuilder \
       vim \
       cdbs \
       autoconf \
       automake \
       python-support \
       quilt \
       reportbug \
       dh-systemd \
       git-buildpackage \
       libpq-dev \
       libjpeg-dev \
       libz-dev \
       libldap2-dev \
       libsasl2-dev \
       python-dev \
       python-all \
     && \
     apt-get clean

# unfortunately, we need a "recent" setuptools, even though dh-virtualenv will
# install the most recent one at a later stage
RUN  apt-get -y update && \
     apt-get install -y -t jessie-backports \
         dh-virtualenv \
         python-setuptools

ENV  HOME /home
ENV  QUILT_PATCHES debian/patches
ENV  QUILT_NO_DIFF_INDEX 1
ENV  QUILT_NO_DIFF_TIMESTAMPS 1
ENV  QUILT_REFRESH_ARGS -p ab

CMD  /bin/bash
