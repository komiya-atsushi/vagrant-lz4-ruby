#!/bin/bash -e

apt-get update
apt-get install -y \
    mingw32 \
    git \
    subversion \
    libxml2-dev \
    libxslt-dev \
    openjdk-6-jdk \
    maven \
    emacs23
