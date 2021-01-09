#!/bin/bash

set -e

if [ -n "$1" ]; then
    cd /opt/wald
    exec "$@"
else
    apt-get update
    apt-get install -y \
        autoconf \
        build-essential \
        bc \
        git \
        jq \
        libssl-dev \
        libtool \
        net-tools \
        openssl \
        python-pip \
        pkg-config \
        sed \
        xxd \
        wget \
	    vim \
	    procps
    pip install base58
    # btcdeb setup
    if ! command -v btcdeb &> /dev/null
    then
	    cd /opt
	    wget https://github.com/bitcoin-core/btcdeb/archive/0.3.20.tar.gz
	    tar -xzf 0.3.20.tar.gz
	    cd btcdeb-0.3.20
	    chmod +x ./autogen.sh
	    ./autogen.sh
	    chmod +x  ./configure
	    ./configure
	    make
	    make install
    fi
    # bitcoin core setup
    chmod +x /usr/bin/bitcoin-cli
    chmod +x /usr/bin/bitcoind

    # bizantino utility
    if ! command -v hello.sh &> /dev/null
    then
	echo 'export PATH=$PATH:/opt/shared/utility' >> /root/.bashrc
    fi

    # foreground bitcoin daemon
    exec bitcoind
fi
