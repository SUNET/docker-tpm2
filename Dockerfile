FROM debian:sid

MAINTAINER fredrik@thulin.net

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -q update
RUN apt-get -y upgrade

RUN apt -y install \
  autoconf-archive \
  libcmocka0 \
  libcmocka-dev \
  net-tools \
  build-essential \
  git \
  pkg-config \
  gcc \
  g++ \
  m4 \
  libtool \
  automake \
  libgcrypt20-dev \
  libssl-dev \
  uthash-dev \
  autoconf

RUN mkdir /src

WORKDIR /src
RUN git clone https://github.com/tpm2-software/tpm2-tss
WORKDIR /src/tpm2-tss
RUN ./bootstrap
RUN ./configure --prefix=/usr/local
RUN make all install

WORKDIR /src
RUN git clone https://github.com/tpm2-software/tpm2-tools
WORKDIR /src/tpm2-tools
RUN apt-get -y install libcurl4 libcurl4-openssl-dev pandoc man-db
RUN ./bootstrap
RUN ./configure --prefix=/usr/local
RUN make all install

# Install some handy tools
RUN apt-get -y install opensc p11-kit gnutls-bin

# Install abrmd since the headers are required to build the p11 module below
WORKDIR /src
RUN git clone https://github.com/tpm2-software/tpm2-abrmd.git
WORKDIR /src/tpm2-abrmd
RUN apt-get -y install libdbus-1-dev libglib2.0-dev
RUN ./bootstrap
RUN ./configure --prefix=/usr/local
RUN make all install

WORKDIR /src
RUN git clone https://github.com/irtimmer/tpm2-pk11
WORKDIR /src/tpm2-pk11
RUN apt-get -y install libp11-kit-dev libtasn1-6-dev cmake
RUN cmake .
RUN make all install

COPY tpm2-config /root/.tpm2/config

RUN apt-get -y install vim

VOLUME ["/root/certs"]
WORKDIR /root/certs

ENTRYPOINT ["/bin/bash"]
