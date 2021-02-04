#!/bin/bash
# install custom curl-http3 binary to support HTTP/3 via Cloudflare Quiche
ZSTD_VER=1.4.8

zstd_install() {
  echo
  echo "zstd install"
  echo
  pushd /usr/local/src
  rm -f zstd-${ZSTD_VER}.tar.gz
  rm -rf /usr/local/src/zstd-${ZSTD_VER}
  wget -4 -c https://github.com/facebook/zstd/archive/v${ZSTD_VER}.tar.gz -O zstd-${ZSTD_VER}.tar.gz --tries=3
  tar xvzf zstd-${ZSTD_VER}.tar.gz
  cd zstd-${ZSTD_VER}
  make clean
  make -j$(nproc)
  make install
  popd
}

install() {
  export CFLAGS=' -Wimplicit-fallthrough=0 -Wno-implicit-function-declaration'
  export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig;/usr/lib/x86_64-linux-gnu/pkgconfig"
  export LD_LIBRARY_PATH='/usr/local/lib;/usr/lib/x86_64-linux-gnu'
  export GOROOT=/usr/local/go
  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/usr/local/go/bin:/usr/local/go/bin
  apt-get -y install build-essential autoconf libtool pkg-config libev-dev cmake libunwind-dev brotli libbrotli-dev libzstd-dev zstd tar lz4 liblz4-dev && apt-get -y remove rustc && apt-get clean && apt-get autoclean && apt-get remove
  zstd_install
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  if [ -f /root/.cargo/bin/rustc ]; then
    /root/.cargo/bin/rustup update
  fi
  source $HOME/.cargo/env
  # apt-get -y install build-essential autoconf libtool pkg-config libev-dev cmake libunwind-dev golang cargo && apt-get clean && apt-get autoclean && apt-get remove
  cd /usr/local/src
  rm -rf quiche
  git clone --recursive https://github.com/cloudflare/quiche
  cd /usr/local/src/quiche
  mkdir -p deps/boringssl/src/lib
  # h3-27 hang rollback
  # quiche 0.7.0
  # git checkout 5092e4d
  # quiche 0.6.0
  # git checkout fd5e028
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
  echo "\$PWD"
  echo $PWD
  ln -s $PWD/include .openssl
  # Build quiche:
  cd ../..
  echo "cargo build --release --examples --features ffi,pkg-config-meta,qlog"
  cargo build --release --examples --features ffi,pkg-config-meta,qlog
  ln -vnf $(find target/release -name libcrypto.a -o -name libssl.a) deps/boringssl/src/lib/
  mkdir -p /usr/local/quiche/bin/
  \cp -af /usr/local/src/quiche/target/release/examples/http3-client /usr/local/quiche/bin/
  \cp -af /usr/local/src/quiche/target/release/examples/http3-server /usr/local/quiche/bin/
  \cp -af /usr/local/src/quiche/target/release/examples/client /usr/local/quiche/bin/
  \cp -af /usr/local/src/quiche/target/release/examples/server /usr/local/quiche/bin/
  \cp -af /usr/local/src/quiche/target/release/quiche.pc /usr/lib/x86_64-linux-gnu/pkgconfig/quiche.pc
  \cp -af /usr/local/src/quiche/include/*.h /usr/include/x86_64-linux-gnu
  \cp -af /usr/local/src/quiche/target/release/deps/libquiche.so /usr/lib/x86_64-linux-gnu
  \cp -af /usr/local/src/quiche/target/release/deps/libquiche.a /usr/lib/x86_64-linux-gnu
  export PATH="$HOME/.cargo/bin:/usr/local/quiche/bin/:${PATH}"
  if [ ! "$(grep "\$HOME/.cargo/bin:/usr/local/quiche/bin" /root/.bashrc)" ]; then
    echo 'export PATH="$HOME/.cargo/bin:/usr/local/quiche/bin/:${PATH}"' >> /root/.bashrc;
  fi
  echo
  echo "/usr/local/quiche/bin/http3-server -h"
  /usr/local/quiche/bin/http3-server -h
  echo
  echo "/usr/local/quiche/bin/http3-client -h"
  /usr/local/quiche/bin/http3-client -h
  echo
  # echo "/usr/local/quiche/bin/http-server -h"
  # /usr/local/quiche/bin/http-server -h
  # echo
  # echo "/usr/local/quiche/bin/http-client -h"
  # /usr/local/quiche/bin/http-client -h

  echo
  cd /usr/local/src
  rm -rf curl
  git clone https://github.com/curl/curl
  cd curl
  # git checkout 00da8341
  # git checkout 1c134e9
  # 7.74
  # git checkout e052859
  make clean
  ./buildconf
  echo
  echo "\$PWD"
  echo $PWD
  echo
  echo "ls -lah /quiche/target/release/deps"
  ls -lah /quiche/target/release/deps
  echo
  echo "ls -lah /quiche/target/release"
  ls -lah /quiche/target/release
  echo
  # export LD_LIBRARY_PATH='/usr/lib/x86_64-linux-gnu:/usr/local/src/quiche/target/release'
  echo "./configure LDFLAGS=\"-Wl,-rpath,$PWD/../quiche/target/release\" --with-ssl=$PWD/../quiche/deps/boringssl/src --with-quiche=$PWD/../quiche/target/release --with-brotli --with-zstd --with-libssh2 --enable-alt-svc"
  ./configure LDFLAGS="-Wl,-rpath,$PWD/../quiche/target/release" --with-quiche=$PWD/../quiche/target/release --with-ssl=$PWD/../quiche/deps/boringssl/src --with-brotli --with-zstd --with-libssh2 --enable-alt-svc
  make -j$(nproc)
  echo
  lib/mk-ca-bundle.pl -f
  # export CURL_CA_BUNDLE=/usr/local/src/curl/ca-bundle.crt
  update-ca-certificates
  ls -lah /etc/ssl/certs/ca-certificates.crt
  echo
  /usr/local/src/curl/src/curl -V
  alias curl-http3="export LD_LIBRARY_PATH='/usr/lib/x86_64-linux-gnu';/usr/local/src/curl/src/curl"
  if [ ! "$(grep 'alias curl-http3' /root/.bashrc)" ]; then
    echo "alias curl-http3=\"export LD_LIBRARY_PATH='/usr/lib/x86_64-linux-gnu';/usr/local/src/curl/src/curl\"" >> /root/.bashrc;
  fi
  echo
  # curl-http3 -V
  # echo
  echo "tests"
  echo
  echo "curl-http3 --http3 -4Iv https://www.litespeedtech.com"
  # /usr/local/src/curl/src/curl --http3 -4Iv https://www.litespeedtech.com
  echo
  echo "curl-http3 --http3 -4Iv https://www.facebook.com"
  # /usr/local/src/curl/src/curl --http3 -4Iv https://www.facebook.com
  echo
  echo "curl-http3 --http3 -4Iv https://geekflare.com"
  # /usr/local/src/curl/src/curl --http3 -4Iv https://geekflare.com
  # echo
  # echo "curl-http3 --http3 -4Iv https://quic.tech:4433/"
  # /usr/local/src/curl/src/curl --http3 -4Iv https://quic.tech:4433/
  echo
  echo "curl-http3 --http3 -4Iv https://cloudflare-quic.com:443"
  # /usr/local/src/curl/src/curl --http3 -4Iv https://cloudflare-quic.com:443
}

install