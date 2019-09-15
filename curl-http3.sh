#!/bin/bash
# install custom curl-http3 binary to support HTTP/3 via Cloudflare Quiche

install() {
  apt-get -y install build-essential autoconf libtool pkg-config libev-dev cmake libunwind-dev golang cargo && apt-get clean && apt-get autoclean && apt-get remove
  cd /usr/local/src
  git clone --recursive https://github.com/cloudflare/quiche
  cd /usr/local/src/quiche/deps/boringssl
  rm -rf build
  mkdir -p build
  cd build
  cmake -DCMAKE_POSITION_INDEPENDENT_CODE=on ..
  make -j$(nproc)
  cd ..
  rm -rf .openssl/lib
  mkdir .openssl/lib -p
  cp build/crypto/libcrypto.a build/ssl/libssl.a .openssl/lib
  ln -s $PWD/include .openssl
  # Build quiche:
  cd ../..
  QUICHE_BSSL_PATH=$PWD/deps/boringssl cargo build --release --features pkg-config-meta
  cd /usr/local/src
  git clone https://github.com/curl/curl
  cd curl
  make clean
  ./buildconf
  ./configure LDFLAGS="-Wl,-rpath,$PWD/../quiche/target/release" --with-ssl=$PWD/../quiche/deps/boringssl/.openssl --with-quiche=$PWD/../quiche/target/release
  make -j$(nproc)
  /usr/local/src/curl/src/curl -V
  alias curl-http3='/usr/local/src/curl/src/curl'
  echo "alias curl-http3='/usr/local/src/curl/src/curl'" >> /root/.bashrc;
  echo
  curl-http3 -V
  echo
}

install