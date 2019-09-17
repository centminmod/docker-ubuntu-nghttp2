#!/bin/bash
# install custom curl-http3 binary to support HTTP/3 via Cloudflare Quiche

install() {
  export CFLAGS=' -Wimplicit-fallthrough=0 -Wno-implicit-function-declaration'
  export LD_LIBRARY_PATH='/usr/lib/x86_64-linux-gnu'
  export GOROOT=/usr/local/go
  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/usr/local/go/bin:/usr/local/go/bin
  apt-get -y install build-essential autoconf libtool pkg-config libev-dev cmake libunwind-dev cargo && apt-get clean && apt-get autoclean && apt-get remove
  # apt-get -y install build-essential autoconf libtool pkg-config libev-dev cmake libunwind-dev golang cargo && apt-get clean && apt-get autoclean && apt-get remove
  cd /usr/local/src
  rm -rf quiche
  git clone --recursive https://github.com/cloudflare/quiche
  cd /usr/local/src/quiche
  git checkout 89d0317
  cd /usr/local/src/quiche/deps/boringssl
  rm -rf build
  mkdir -p build
  cd build
  cmake -DCMAKE_POSITION_INDEPENDENT_CODE=on ..
  make -j$(nproc)
  cd ..
  rm -rf .openssl/lib
  mkdir .openssl/lib -p
  \cp -f build/crypto/libcrypto.a build/ssl/libssl.a .openssl/lib
  ln -s $PWD/include .openssl
  # Build quiche:
  cd ../..
  QUICHE_BSSL_PATH=$PWD/deps/boringssl cargo build --release --examples --features pkg-config-meta
  mkdir -p /usr/local/quiche/bin/
  \cp -af /usr/local/src/quiche/target/release/examples/http3-client /usr/local/quiche/bin/
  \cp -af /usr/local/src/quiche/target/release/examples/http3-server /usr/local/quiche/bin/
  \cp -af /usr/local/src/quiche/target/release/examples/client /usr/local/quiche/bin/
  \cp -af /usr/local/src/quiche/target/release/examples/server /usr/local/quiche/bin/
  export PATH="/usr/local/quiche/bin/:${PATH}"
  if [ ! "$(grep '/usr/local/quiche/bin' /root/.bashrc)" ]; then
    echo 'export PATH="/usr/local/quiche/bin/:${PATH}"' >> /root/.bashrc;
  fi
  echo
  echo "/usr/local/quiche/bin/http3-server -h"
  /usr/local/quiche/bin/http3-server -h
  echo
  echo "/usr/local/quiche/bin/http3-client -h"
  /usr/local/quiche/bin/http3-client -h
  echo
  echo "/usr/local/quiche/bin/http-server -h"
  /usr/local/quiche/bin/http-server -h
  echo
  echo "/usr/local/quiche/bin/http-client -h"
  /usr/local/quiche/bin/http-client -h

  echo
  cd /usr/local/src
  rm -rf curl
  git clone https://github.com/curl/curl
  cd curl
  make clean
  ./buildconf
  ./configure LDFLAGS="-Wl,-rpath,$PWD/../quiche/target/release" --with-ssl=$PWD/../quiche/deps/boringssl/.openssl --with-quiche=$PWD/../quiche/target/release
  make -j$(nproc)
  /usr/local/src/curl/src/curl -V
  alias curl-http3="export LD_LIBRARY_PATH='/usr/lib/x86_64-linux-gnu';/usr/local/src/curl/src/curl"
  if [ ! "$(grep 'alias curl-http3' /root/.bashrc)" ]; then
    echo "alias curl-http3=\"export LD_LIBRARY_PATH='/usr/lib/x86_64-linux-gnu';/usr/local/src/curl/src/curl\"" >> /root/.bashrc;
  fi
  echo
  curl-http3 -V
  echo
}

install