#!/bin/bash
# install lsquic library https://github.com/litespeedtech/lsquic

install() {
  export CFLAGS=' -Wimplicit-fallthrough=0 -Wno-implicit-function-declaration -Wno-pedantic -Wno-unused-result -Wno-unused-value -Wno-error=unused-result'
  export LD_LIBRARY_PATH='/usr/lib/x86_64-linux-gnu'
  export GOROOT=/usr/local/go
  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/usr/local/go/bin:/usr/local/go/bin
  apt-get update && apt-get install -y build-essential git cmake software-properties-common zlib1g-dev libevent-dev && apt-get clean && apt-get autoclean && apt-get remove
  mkdir -p /src

  cd /src
  rm -rf boringssl
  git clone https://boringssl.googlesource.com/boringssl
  cd boringssl
  git checkout 32e59d2d3264e4e104b355ef73663b8b79ac4093
  wget -4 -O boringssl-meds.patch https://github.com/litespeedtech/lsquic/raw/master/patches/boringssl-meds.patch
  patch -p1 -i boringssl-meds.patch
  rm CMakeCache.txt
  make clean
  cmake .
  time make
  BORINGSSL_SOURCE=$PWD
  echo $BORINGSSL_SOURCE
  #cd /usr/local/lib
  #cp $BORINGSSL_SOURCE/ssl/libssl.a .
  #cp $BORINGSSL_SOURCE/crypto/libcrypto.a .
  mkdir -p $BORINGSSL_SOURCE/lib
  cp $BORINGSSL_SOURCE/ssl/libssl.a $BORINGSSL_SOURCE/lib
  cp $BORINGSSL_SOURCE/crypto/libcrypto.a $BORINGSSL_SOURCE/lib
  ls -lah $BORINGSSL_SOURCE/lib

  cd /src
  rm -rf lsquic
  git clone https://github.com/litespeedtech/lsquic
  cd lsquic
  git submodule init
  git submodule update
  #cmake -DBORINGSSL_DIR=$BORINGSSL_SOURCE .
  rm CMakeCache.txt
  make clean
  cmake -DBORINGSSL_INCLUDE=$BORINGSSL_SOURCE/include -DBORINGSSL_LIB=$BORINGSSL_SOURCE/lib .
  time make
  time make test
  \cp -f http_client /usr/bin
  \cp -f http_server /usr/bin
  ls -lah /usr/bin/http_client /usr/bin/http_server
  echo
  echo "http_client -s www.google.com -M HEAD -p / -o version=Q046"
  # http_client -s www.google.com -M HEAD -p / -o version=Q046
}

install