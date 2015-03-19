Docker based image for [nghttp2 HTTP/2](https://nghttp2.org/) C library client, server, proxy and h2load testing tool for HTTP/2 on Ubuntu intended for use to test [h2o HTTP/2 server](https://github.com/h2o/h2o) integration on [CentminMod.com LEMP stack](http://centminmod.com). 

Used Ubuntu instead of CentOS as the nghttp2 build and compile software version requirements were too high a version for CentOS YUM packages and source compiling those higher software versions would take almost 2 hours to compile.

Custom OpenSSL 1.0.2 version is compiled (reports as OpenSSL 1.1.0-dev) for enabling ALPN TLS extension support. Default Ubuntu OpenSSL 1.0.1f only supports NPN TLS extension. The nghttp2 libraries support both ALPN & NPN extensions.

Also installed is [Cipherscan SSL tool](https://github.com/jvehent/cipherscan).

### My Docker Hub repo

* [https://registry.hub.docker.com/u/centminmod/docker-ubuntu-nghttp2/](https://registry.hub.docker.com/u/centminmod/docker-ubuntu-nghttp2/)

### My Quay.io repo

* [https://quay.io/repository/centminmod/docker-ubuntu-nghttp2/](https://quay.io/repository/centminmod/docker-ubuntu-nghttp2/)

### Centmin Mod Docker Development forums

* [https://community.centminmod.com/forums/centmin-mod-docker-development.52/](https://community.centminmod.com/forums/centmin-mod-docker-development.52/)

---

#### Grab from Docker Hub

    docker pull centminmod/docker-ubuntu-nghttp2

#### Or grab from Quay.io Repo

    docker pull quay.io/centminmod/docker-ubuntu-nghttp2:latest

Run docker container and from there you can launch [nghttp2 HTTP/2](https://nghttp2.org/). Documentation at [https://nghttp2.org/documentation/](https://nghttp2.org/documentation/).

    docker run -ti --name nghttp centminmod/docker-ubuntu-nghttp2 /bin/bash

or if connecting to an already running docker image named `nghttp`

    docker exec -ti nghttp /bin/bash

#### Cipherscan tool usage

    cipherscan www.google.com:443

#### nghttp2 Tools    

nghttp2 client, server, proxy and h2load paths and OpenSSL custom compiled path

    /usr/local/bin/nghttp --version
    /usr/local/bin/nghttpd --version
    /usr/local/bin/nghttpx --version
    /usr/local/bin/h2load --version
    /usr/local/http2-15/bin/openssl version    

check for ALPN extension support in h2o server - look for ALPN protocol: h2-14
===================================

    /usr/local/http2-15/bin/openssl s_client -alpn h2-14 -host http2basedhost.com -port 8081
    CONNECTED(00000003)
    
    ---
    New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES256-GCM-SHA384
    Server public key is 2048 bit
    Secure Renegotiation IS supported
    Compression: NONE
    Expansion: NONE
    ALPN protocol: h2-14
    SSL-Session:
        Protocol  : TLSv1.2
        Cipher    : ECDHE-RSA-AES256-GCM-SHA384

check for NPN extension support in h2o server - look for Next protocol: (1) h2-14
===================================

    /usr/local/http2-15/bin/openssl s_client -nextprotoneg h2-14 -host http2basedhost.com -port 8081
    
    ---
    New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES256-GCM-SHA384
    Server public key is 2048 bit
    Secure Renegotiation IS supported
    Compression: NONE
    Expansion: NONE
    Next protocol: (1) h2-14
    No ALPN negotiated    

Example using nghttp2 client against h2o HTTP/2 server on port 8081
===================================

    nghttp -nv https://http2basedhost.com:8081

    [  0.203] Connected
    [  0.285][NPN] server offers:
              * h2
              * h2-16
              * h2-14
    The negotiated protocol: h2
    [  0.367] send SETTINGS frame <length=12, flags=0x00, stream_id=0>
              (niv=2)
              [SETTINGS_MAX_CONCURRENT_STREAMS(0x03):100]
              [SETTINGS_INITIAL_WINDOW_SIZE(0x04):65535]
    [  0.367] send HEADERS frame <length=45, flags=0x05, stream_id=1>
              ; END_STREAM | END_HEADERS
              (padlen=0)
              ; Open new stream
              :method: GET
              :path: /
              :scheme: https
              :authority: http2basedhost.com:8081
              accept: */*
              accept-encoding: gzip, deflate
              user-agent: nghttp2/0.7.8-DEV
    [  0.449] recv SETTINGS frame <length=18, flags=0x00, stream_id=0>
              (niv=3)
              [SETTINGS_ENABLE_PUSH(0x02):0]
              [SETTINGS_MAX_CONCURRENT_STREAMS(0x03):100]
              [SETTINGS_INITIAL_WINDOW_SIZE(0x04):262144]
    [  0.449] send SETTINGS frame <length=0, flags=0x01, stream_id=0>
              ; ACK
              (niv=0)
    [  0.449] recv SETTINGS frame <length=0, flags=0x01, stream_id=0>
              ; ACK
              (niv=0)
    [  0.449] recv (stream_id=1) :status: 200
    [  0.449] recv (stream_id=1) server: h2o/1.1.2-alpha1
    [  0.449] recv (stream_id=1) date: Thu, 19 Mar 2015 01:36:11 GMT
    [  0.449] recv (stream_id=1) content-type: text/html
    [  0.449] recv (stream_id=1) last-modified: Sat, 14 Mar 2015 19:15:28 GMT
    [  0.449] recv (stream_id=1) etag: "550488d0-612"
    [  0.449] recv (stream_id=1) vary: accept-encoding
    [  0.449] recv (stream_id=1) content-encoding: gzip
    [  0.449] recv (stream_id=1) cache-control: max-age=172800
    [  0.449] recv (stream_id=1) strict-transport-security: max-age=31536000; includeSubDomains; preload
    [  0.449] recv (stream_id=1) x-frame-options: deny
    [  0.449] recv HEADERS frame <length=209, flags=0x04, stream_id=1>
              ; END_HEADERS
              (padlen=0)
              ; First response header
    [  0.449] recv DATA frame <length=1554, flags=0x01, stream_id=1>
              ; END_STREAM
    [  0.449] send GOAWAY frame <length=8, flags=0x00, stream_id=0>
              (last_stream_id=0, error_code=NO_ERROR(0x00), opaque_data(0)=[])

Example against OpenLiteSpeed 1.3.8 server with HTTP/2 web site on port 8082
===================================

    nghttp -nv https://http2basedhost.com:8082

    [  0.148] Connected
    [  0.228][NPN] server offers:
              * h2-14
              * spdy/3.1
              * spdy/3
              * spdy/2
              * http/1.1
    The negotiated protocol: h2-14
    [  0.390] send SETTINGS frame <length=12, flags=0x00, stream_id=0>
              (niv=2)
              [SETTINGS_MAX_CONCURRENT_STREAMS(0x03):100]
              [SETTINGS_INITIAL_WINDOW_SIZE(0x04):65535]
    [  0.390] send HEADERS frame <length=45, flags=0x05, stream_id=1>
              ; END_STREAM | END_HEADERS
              (padlen=0)
              ; Open new stream
              :method: GET
              :path: /
              :scheme: https
              :authority: http2basedhost.com:8082
              accept: */*
              accept-encoding: gzip, deflate
              user-agent: nghttp2/0.7.8-DEV
    [  0.471] recv SETTINGS frame <length=12, flags=0x00, stream_id=0>
              (niv=2)
              [SETTINGS_MAX_CONCURRENT_STREAMS(0x03):100]
              [SETTINGS_INITIAL_WINDOW_SIZE(0x04):65536]
    [  0.471] recv WINDOW_UPDATE frame <length=4, flags=0x00, stream_id=0>
              (window_size_increment=65535)
    [  0.471] send SETTINGS frame <length=0, flags=0x01, stream_id=0>
              ; ACK
              (niv=0)
    [  0.471] recv SETTINGS frame <length=0, flags=0x01, stream_id=0>
              ; ACK
              (niv=0)
    [  0.471] recv (stream_id=1) :status: 200
    [  0.471] recv (stream_id=1) etag: "ed9-5508fbfa-6633c"
    [  0.471] recv (stream_id=1) last-modified: Wed, 18 Mar 2015 04:15:54 GMT
    [  0.471] recv (stream_id=1) content-type: text/html
    [  0.471] recv (stream_id=1) accept-ranges: bytes
    [  0.471] recv (stream_id=1) date: Thu, 19 Mar 2015 01:38:18 GMT
    [  0.471] recv (stream_id=1) server: LiteSpeed
    [  0.471] recv (stream_id=1) content-encoding: gzip
    [  0.471] recv (stream_id=1) vary: accept-encoding
    [  0.471] recv HEADERS frame <length=109, flags=0x04, stream_id=1>
              ; END_HEADERS
              (padlen=0)
              ; First response header
    [  0.471] recv DATA frame <length=10, flags=0x00, stream_id=1>
    [  0.551] recv DATA frame <length=1568, flags=0x00, stream_id=1>
    [  0.551] recv DATA frame <length=0, flags=0x01, stream_id=1>
              ; END_STREAM
    [  0.551] send GOAWAY frame <length=8, flags=0x00, stream_id=0>
              (last_stream_id=0, error_code=NO_ERROR(0x00), opaque_data(0)=[])
