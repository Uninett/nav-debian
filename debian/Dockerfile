FROM debian:stretch

# Need some custom packages to the Sphinx documentation built
RUN apt-get -y update && \
    apt-get install -y apt-transport-https ca-certificates dirmngr && \
    apt-key adv --keyserver keys.gnupg.net --recv-key CE8E05E8 && \
    echo 'deb https://nav.uninett.no/debian stretch nav' > /etc/apt/sources.list.d/nav.list && \
    echo '# Give packages from nav.uninett.no higher priority, at your own risk\n\
Package: *\n\
Pin: origin nav.uninett.no\n\
Pin-Priority: 600\n\
' > /etc/apt/preferences.d/nav.pref

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

RUN  apt-get -y update && \
     apt-get install -y \
         dh-virtualenv \
         python-setuptools

ENV  HOME /home
ENV  QUILT_PATCHES debian/patches
ENV  QUILT_NO_DIFF_INDEX 1
ENV  QUILT_NO_DIFF_TIMESTAMPS 1
ENV  QUILT_REFRESH_ARGS -p ab

CMD  /bin/bash
