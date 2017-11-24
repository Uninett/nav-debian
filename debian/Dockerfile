FROM debian:jessie

# Need a more recent ruby-sass to build the stylesheets
RUN  echo "deb http://ftp.no.debian.org/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list

# Need some custom packages to the Sphinx documentation built
RUN apt-get -y update && \
    apt-get install -y apt-transport-https && \
    apt-key adv --keyserver keys.gnupg.net --recv-key CE8E05E8 && \
    echo 'deb https://nav.uninett.no/debian jessie nav' > /etc/apt/sources.list.d/nav.list && \
    apt-get -y update

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
       python-django \
       python-configparser \
       python-twisted \
       python-django-crispy-forms \
       python-crispy-forms-foundation \
     && \
     apt-get clean

ENV  QUILT_PATCHES debian/patches
ENV  QUILT_NO_DIFF_INDEX 1
ENV  QUILT_NO_DIFF_TIMESTAMPS 1
ENV  QUILT_REFRESH_ARGS -p ab

CMD  /bin/bash
