FROM ubuntu:eoan
MAINTAINER George Liu <https://github.com/centminmod/docker-ubuntu-nghttp2>
# Setup HTTP/2 nghttp2 on Ubuntu 19.x
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/centminmod/docker-ubuntu-nghttp2.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="0.0.1"
RUN ulimit -c -m -s -t unlimited ; echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections; apt-get update && apt-get install -y bc python-six libc-ares-dev libspdylay-dev nodejs npm libldb-dev libldap2-dev libpsl-dev libidn11 libidn11-dev libidn2-0 libidn2-0-dev perl python-setuptools dnsutils libssh2-1 libssh2-1-dev iputils-ping jq libc6-dev bison ruby ruby-dev mercurial libboost-dev libboost-thread-dev nano tar bsdmainutils apt-file wget mlocate make binutils autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev libjemalloc-dev cython python3 openssl git-all gcc g++ libpcre3-dev libcap-dev libncurses5-dev curl && apt-get clean && apt-get autoclean && apt-get remove; cd /usr/local/src; git clone -b OpenSSL_1_1_1-stable --depth 1 https://github.com/openssl/openssl && cd /usr/local/src/openssl; ./config -Wl,--enable-new-dtags,-rpath=/usr/local/http2-15/lib enable-ec_nistp_64_gcc_128 enable-tls1_3 --prefix=/usr/local/http2-15 && make -j$(nproc) && make install && echo "/usr/local/http2-15/lib" > /etc/ld.so.conf.d/openssl.conf && ldconfig && make clean && echo "alias openssl=\"export LD_LIBRARY_PATH='/usr/local/http2-15/lib';/usr/local/http2-15/bin/openssl\"" >> /root/.bashrc && . /root/.bashrc ; alias openssl='/usr/local/http2-15/bin/openssl'; mkdir -p /usr/local/http2-15/certs/; \cp -Rpf /etc/ssl/certs/* /usr/local/http2-15/certs/; echo 'ca_directory=/etc/ssl/certs/' >> /etc/wgetrc ; mkdir /usr/local/src/nghttp2_libevent21 && cd /usr/local/src/nghttp2_libevent21 && wget -cnv --no-check-certificate https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz && tar xzf libevent-2.1.8-stable.tar.gz && cd libevent-2.1.8-stable && CFLAGS=-I/usr/local/http2-15/include CXXFLAGS=-I/usr/local/http2-15/include LDFLAGS=-L/usr/local/http2-15/lib ./configure --prefix=/usr/local/http2-15 && make -j$(nproc) && make install && make clean && echo "/usr/local/http2-15/lib" > /etc/ld.so.conf.d/libevent-i386.conf && ldconfig; cd /usr/local/src; git clone --depth 1 https://github.com/tatsuhiro-t/nghttp2.git && cd /usr/local/src/nghttp2; git submodule update --init && autoreconf -i && automake && autoconf && PKG_CONFIG_PATH=/usr/local/http2-15/lib/pkgconfig ./configure --enable-app --enable-asio-lib && make -j$(nproc) && make install && ldconfig && make clean; cd /usr/local/src; git clone --depth 1 https://github.com/bagder/curl.git libcurl_static && cd /usr/local/src/libcurl_static && autoreconf -i && automake && autoconf && ./configure --prefix=/usr/local/http2-15 --with-ssl=/usr/local/http2-15 --with-libssh2 --disable-static --enable-threaded-resolver && make && make install && echo "/usr/local/http2-15/lib" > /etc/ld.so.conf.d/curl.conf && ldconfig && echo "alias curl=\"export LD_LIBRARY_PATH='/usr/local/http2-15/lib';/usr/local/http2-15/bin/curl\"" >> /root/.bashrc && . /root/.bashrc ; alias curl='/usr/local/http2-15/bin/curl'; /usr/local/http2-15/bin/curl --version; INSTALL_DIR=/opt; cd $INSTALL_DIR && git clone https://github.com/mozilla/cipherscan && cd cipherscan && chmod 0700 cipherscan && ln -s ${INSTALL_DIR}/cipherscan/cipherscan /usr/bin/cipherscan; ln -s ${INSTALL_DIR}/cipherscan/cscan.sh /usr/bin/cscan.sh; ln -s ${INSTALL_DIR}/cipherscan/cscan.py /usr/bin/cscan.py; ln -s ${INSTALL_DIR}/cipherscan/analyze.py /usr/bin/analyze.py; cd $INSTALL_DIR; git clone https://github.com/drwetter/testssl.sh;  ln -s $INSTALL_DIR/testssl.sh/testssl.sh /usr/bin/testssl; popd; export OPENSSL=/usr/local/http2-15/bin/openssl; echo "export OPENSSL=/usr/local/http2-15/bin/openssl" >> /root/.bashrc && cd /opt; git clone https://github.com/ssllabs/ssllabs-scan.git; wget --no-check-certificate -c https://dl.google.com/go/go1.12.1.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.12.1.linux-amd64.tar.gz; echo "alias cipherscan='cipherscan -o /usr/local/http2-15/bin/openssl'" >> /root/.bashrc; echo "alias testssl='testssl --openssl=/usr//bin/openssl'" >> /root/.bashrc; echo "alias h2load-cf='h2load --ciphers=ECDHE-ECDSA-AES128-GCM-SHA256'" >> /root/.bashrc; wget  --no-check-certificate -O /usr/local/bin/curltest https://github.com/centminmod/docker-ubuntu-nghttp2/raw/master/curltest.sh; chmod +x /usr/local/bin/curltest;

ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $PATH:$GOROOT/bin
RUN export GOROOT=/usr/local/go; export PATH=$PATH:$GOROOT/bin; echo "export GOROOT=/usr/local/go" >> /root/.bashrc; echo "export PATH=$PATH:$GOROOT/bin" >> /root/.bashrc; go env; export GOPATH=/go; export PATH=$PATH:$GOPATH/bin; mkdir -p $GOPATH/src/github.com/summerwind; mkdir -p $GOROOT/src/github.com/summerwind; echo "/go/bin/h2spec --help"; echo "/go/bin/h2spec -h localhost -p 8081 -t"
RUN cd ~; wget --no-check-certificate https://github.com/summerwind/h2spec/releases/download/v2.2.1/h2spec_linux_amd64.tar.gz; tar xvzf h2spec_linux_amd64.tar.gz; rm -rf h2spec_linux_amd64.tar.gz; cp -a h2spec /usr/bin/h2spec; cd ~; go get github.com/bradfitz/http2/h2i; ln -s /go/bin/h2i /usr/bin/h2i; cd ~; go get github.com/mozilla/tls-observatory/tlsobs; ln -s /go/bin/tlsobs /usr/bin/tlsobs; cd ~; #npm install -g is-http2-cli; ln -s /usr/bin/nodejs /usr/bin/node; ls -lah /usr/local/bin/ | egrep 'nghttp|h2load' && echo "/usr/local/http2-15/bin/openssl version"; echo && echo "check if your HTTP/2 enabled web host supports ALPN & NPN TLS extensions" && echo "if testing a HTTP/2 server on non-standard port other than 443, ensure" && echo "target HTTP/2 server's firewall has allowed your docker image's host system" && echo "ip address to connect to that non-standard port e.g. 8081 for h2o server" && echo && echo "/usr/local/http2-15/bin/openssl s_client -alpn h2-14 -host yourhttp2_enabledhostname -port 8081" && echo "/usr/local/http2-15/bin/openssl s_client -nextprotoneg h2-14 -host yourhttp2_enabledhostname -port 8081"

COPY curl-http3.sh /tmp/curl-http3.sh
COPY cert-check.sh /usr/local/bin/cert-check
COPY lsquic.sh /tmp/lsquic.sh
RUN chmod +x /usr/local/bin/cert-check; chmod +x /tmp/curl-http3.sh; /tmp/curl-http3.sh; chmod +x /tmp/lsquic.sh; /tmp/lsquic.sh; go get -u github.com/cloudflare/cfssl/cmd/cfssl-certinfo; ln -s /go/bin/cfssl-certinfo /usr/local/bin/certinfo; go get -u github.com/cloudflare/cfssl/cmd/cfssl-scan; ln -s /go/bin/cfssl-scan /usr/local/bin/certscan

# /usr/bin/cipherscan
# /usr/local/bin/nghttp --version
# /usr/local/bin/nghttpd --version
# /usr/local/bin/nghttpx --version
# /usr/local/bin/h2load --version
# /usr/local/bin/is-http2
# /usr/local/http2-15/bin/openssl version
# /usr/local/http2-15/bin/curl --version
# /go/bin/h2spec --help or /usr/bin/h2spec --help
# /go/bin/h2i or /usr/bin/h2i --help
# /go/bin/tlsobs or /usr/bin/tlsobs --help
# /go/bin/cfssl-certinfo