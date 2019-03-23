FROM debian:buster-slim


ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y\
    xvfb\
    firefox-esr\
    xfonts-100dpi\
    xfonts-75dpi\
    xfonts-scalable\
    xfonts-cyrillic
RUN rm -rf /var/lib/apt/lists/*

RUN userdel nobody
RUN useradd -s /bin/bash -u 65534 -m -N -g nogroup nobody

ENV DISPLAY=:99

RUN echo \
"#!/usr/bin/env /bin/bash\n"\
"exec > /proc/\$$/fd/1 2>/proc/\$$/fd/2\n"\
"set -eu -o pipefail\n"\
"Xvfb :99 -shmem -screen 0 1366x768x16 &\n"\
> /usr/local/bin/ff-headless.sh

VOLUME /home/nobody/
USER nobody

