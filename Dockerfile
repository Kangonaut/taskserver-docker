FROM ubuntu:22.04

WORKDIR /root

ARG TASKD_VERSION="1.1.0"
ENV TASKD_VERSION=${TASKD_VERSION}

# update APT repo cache
RUN apt update

# set timezone
RUN apt install -y tzdata
ENV TZ="Europe/Vienna"

# install tools
RUN apt install -y vim curl

# install build dependencies
RUN apt install -y g++ libgnutls28-dev uuid-dev cmake gnutls-bin

# download tarball
RUN curl -LO "https://github.com/GothenburgBitFactory/taskserver/releases/download/v${TASKD_VERSION}/taskd-${TASKD_VERSION}.tar.gz"

# expand tarball
RUN tar xzf "taskd-${TASKD_VERSION}.tar.gz"
WORKDIR taskd-${TASKD_VERSION}

# build
RUN cmake -DCMAKE_BUILD_TYPE=release .
RUN make

# install
RUN make install

# re-set working directory
WORKDIR /root

# set and create torage location
ENV TASKDDATA=/var/taskd
RUN mkdir -p $TASKDDATA

# copy init script
COPY init.sh /root/

# remove entrypoint
ENTRYPOINT []
