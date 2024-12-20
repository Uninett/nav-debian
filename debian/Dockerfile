FROM debian:bullseye

RUN  --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
     --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    apt-get -y update && \
     apt-get install -y \
       pbuilder \
       vim \
       cdbs \
       autoconf \
       automake \
       quilt \
       reportbug \
       git-buildpackage \
       libpq-dev \
       libjpeg-dev \
       libz-dev \
       libldap2-dev \
       libsasl2-dev \
       python3-dev \
       python-all \
       python3-all \
       libsnmp40 \
     && \
     apt-get clean

RUN  --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
     --mount=target=/var/cache/apt,type=cache,sharing=locked \
     apt-get -y update && \
     apt-get install -y \
         dh-virtualenv \
         dh-python \
         python3-setuptools

# Backports game to make python-gammu build and install properly
RUN  --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
     --mount=target=/var/cache/apt,type=cache,sharing=locked \
     echo 'deb https://deb.debian.org/debian bullseye-backports main' > /etc/apt/sources.list.d/backports.list && \
     apt-get -y update && \
     apt-get install -y libgammu-dev

# Install NodeJS so we can use webpack to build NAV stylesheets.  Nodejs on
# Debian Bullseye is just too darn old to be usable for us, so we have to fetch
# it from the web:
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

RUN  chmod 777 /home
ENV  HOME=/home
ENV  QUILT_PATCHES=debian/patches
ENV  QUILT_NO_DIFF_INDEX=1
ENV  QUILT_NO_DIFF_TIMESTAMPS=1
ENV  QUILT_REFRESH_ARGS="-p ab"

CMD  ["/bin/bash"]
