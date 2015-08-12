FROM ubuntu:vivid
MAINTAINER George Liu <https://github.com/centminmod/docker-ubuntu-nghttp2>
# Setup HTTP/2 nghttp2 on Ubuntu 15.x
RUN ulimit -c -m -s -t unlimited && apt-get update && apt-get install -y dnsutils libssh2-1 libssh2-1-dev iputils-ping jq libc6-dev bison mercurial libboost-dev libboost-thread-dev nano tar bsdmainutils apt-file wget mlocate make binutils autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev libjemalloc-dev cython python3.4-dev openssl git gcc g++ libpcre3-dev libcap-dev libncurses5-dev curl && apt-get clean && apt-get autoclean && apt-get remove  

# RUN echo "dash dash/sh boolean false" | debconf-set-selections && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash;  debconf-show dash   

RUN cd /usr/local/src; git clone https://github.com/PeterMosmans/openssl.git --depth 1 -b 1.0.2-chacha
RUN cd /usr/local/src/openssl; ./config shared enable-threads zlib experimental-jpake enable-md2 enable-rc5 enable-rfc3779 enable-gost enable-static-engine enable-ec_nistp_64_gcc_128 --prefix=/usr/local/http2-15 && make && make install && echo "/usr/local/http2-15/lib" > /etc/ld.so.conf.d/openssl.conf && ldconfig && make clean && echo "alias openssl='/usr/local/http2-15/bin/openssl'" >> /root/.bashrc && . /root/.bashrc ; alias openssl='/usr/local/http2-15/bin/openssl'

RUN mkdir /usr/local/src/nghttp2_libevent21 && cd /usr/local/src/nghttp2_libevent21 && wget -cnv --no-check-certificate https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz && tar xzf libevent-2.0.21-stable.tar.gz && cd libevent-2.0.21-stable && CFLAGS=-I/usr/local/http2-15/include CXXFLAGS=-I/usr/local/http2-15/include LDFLAGS=-L/usr/local/http2-15/lib ./configure --prefix=/usr/local/http2-15 && make -j2 && make install && make clean && echo "/usr/local/http2-15/lib" > /etc/ld.so.conf.d/libevent-i386.conf && ldconfig

RUN cd /usr/local/src; git clone --depth 1 https://github.com/tatsuhiro-t/spdylay.git
RUN cd /usr/local/src/spdylay && autoreconf -i && automake && autoconf && ./configure OPENSSL_LIBS='-L/usr/local/http2-15/lib -lssl -lcrypto -levent -levent_openssl' && make -j2 && make install && make clean

RUN cd /usr/local/src; git clone --depth 1 https://github.com/tatsuhiro-t/nghttp2.git
RUN cd /usr/local/src/nghttp2 && autoreconf -i && automake && autoconf && ./configure --enable-app --enable-asio-lib OPENSSL_LIBS='-L/usr/local/http2-15/lib -lssl -lcrypto' && make -j2 && make install && ldconfig && make clean

# RUN cd /usr/local/src; mkdir -p /usr/local/src/libcurl_static; cd /usr/local/src/libcurl_static && wget -cnv http://curl.haxx.se/download/curl-7.44.0.tar.gz && tar xzf curl-7.44.0.tar.gz && cd /usr/local/src/libcurl_static/curl-7.44.0 && ./configure --prefix=/usr/local/http2-15 --with-ssl=/usr/local/http2-15 --with-libssh2 --disable-static --enable-threaded-resolver && make -j2 && make install && echo "/usr/local/http2-15/lib" > /etc/ld.so.conf.d/curl.conf && ldconfig && echo "alias curl='/usr/local/http2-15/bin/curl'" >> /root/.bashrc && . /root/.bashrc ; alias curl='/usr/local/http2-15/bin/curl'; /usr/local/http2-15/bin/curl --version;

RUN cd /usr/local/src; git clone --depth 1 https://github.com/bagder/curl.git libcurl_static && cd /usr/local/src/libcurl_static && autoreconf -i && automake && autoconf && ./configure --prefix=/usr/local/http2-15 --with-ssl=/usr/local/http2-15 --with-libssh2 --disable-static --enable-threaded-resolver && make -j2 && make install && echo "/usr/local/http2-15/lib" > /etc/ld.so.conf.d/curl.conf && ldconfig && echo "alias curl='/usr/local/http2-15/bin/curl'" >> /root/.bashrc && . /root/.bashrc ; alias curl='/usr/local/http2-15/bin/curl'; /usr/local/http2-15/bin/curl --version;

RUN INSTALL_DIR=/opt; cd $INSTALL_DIR && git clone https://github.com/jvehent/cipherscan && cd cipherscan && chmod 0700 cipherscan && ln -s ${INSTALL_DIR}/cipherscan/cipherscan /usr/bin/cipherscan

RUN wget -cnv --no-check-certificate -O /usr/bin/testssl https://raw.githubusercontent.com/drwetter/testssl.sh/master/testssl.sh; chmod 0700 /usr/bin/testssl; export OPENSSL=/usr/local/http2-15/bin/openssl; echo "export OPENSSL=/usr/local/http2-15/bin/openssl" >> /root/.bashrc

RUN cd /opt; git clone https://github.com/ssllabs/ssllabs-scan.git

# ADD goinstall.sh /tmp/goinstall.sh
# RUN chmod 0700 /tmp/goinstall.sh; /tmp/goinstall.sh

ENV GOLANG_VERSION 1.4.2
RUN curl -sSL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz | tar -v -C /usr/src -xz
RUN cd /usr/src/go/src && ./make.bash --no-clean 2>&1
ENV PATH /usr/src/go/bin:$PATH
RUN mkdir -p /go/{bin,pkg,src} && chmod -R 777 /go
ENV GOPATH /go
ENV PATH /go/bin:$PATH
RUN echo "export GOPATH=/go" >> /root/.bashrc; echo "export PATH=$PATH:$GOPATH/bin" >> /root/.bashrc; go env

RUN export GOPATH=/go; export PATH=$PATH:$GOPATH/bin; mkdir -p $GOPATH/src/github.com/summerwind; mkdir -p $GOROOT/src/github.com/summerwind; 
RUN cd $GOPATH/src/github.com/summerwind; pwd; git clone https://github.com/summerwind/h2spec.git; cd h2spec; /usr/src/go/bin/go get github.com/bradfitz/http2; /usr/src/go/bin/go build cmd/h2spec.go; echo "$GOPATH/src/github.com/summerwind/h2spec/h2spec --help"; echo "$GOPATH/src/github.com/summerwind/h2spec/h2spec -h localhost -p 8081 -t"

RUN ls -lah /usr/local/bin/ | egrep 'nghttp|h2load' && echo "/usr/local/http2-15/bin/openssl version"

RUN echo && echo "check if your HTTP/2 enabled web host supports ALPN & NPN TLS extensions" && echo "if testing a HTTP/2 server on non-standard port other than 443, ensure" && echo "target HTTP/2 server's firewall has allowed your docker image's host system" && echo "ip address to connect to that non-standard port e.g. 8081 for h2o server" && echo && echo "/usr/local/http2-15/bin/openssl s_client -alpn h2-14 -host yourhttp2_enabledhostname -port 8081" && echo "/usr/local/http2-15/bin/openssl s_client -nextprotoneg h2-14 -host yourhttp2_enabledhostname -port 8081"

# /usr/bin/cipherscan
# /usr/local/bin/nghttp --version
# /usr/local/bin/nghttpd --version
# /usr/local/bin/nghttpx --version
# /usr/local/bin/h2load --version
# /usr/local/http2-15/bin/openssl version
# /usr/local/http2-15/bin/curl --version
# /go/src/github.com/summerwind/h2spec/h2spec -h