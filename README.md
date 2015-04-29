Docker based image for [nghttp2 HTTP/2](https://nghttp2.org/) C library client, server, proxy and h2load testing tool for HTTP/2 on Ubuntu intended for use to test [h2o HTTP/2 server](https://github.com/h2o/h2o) integration on [CentminMod.com LEMP stack](http://centminmod.com). 

Used Ubuntu instead of CentOS as the nghttp2 build and compile software version requirements were too high a version for CentOS YUM packages and source compiling those higher software versions would take almost 2 hours to compile.

[Custom OpenSSL 1.0.2a version](https://github.com/PeterMosmans/openssl) with chacha20_poly1305 cipher patch etc is compiled for enabling ALPN TLS extension support. Default Ubuntu OpenSSL 1.0.1f only supports NPN TLS extension. The nghttp2 libraries support both ALPN & NPN extensions.

    /usr/local/http2-15/bin/openssl version
    OpenSSL 1.0.2-chacha (1.0.2b-dev)

Custom curl 7.42.1 version installed compiled against custom OpenSSL 1.0.2a

    /usr/local/http2-15/bin/curl --version
    curl 7.42.1 (x86_64-unknown-linux-gnu) libcurl/7.42.1 OpenSSL/1.0.2b zlib/1.2.8 nghttp2/0.7.13-DEV
    Protocols: dict file ftp ftps gopher http https imap imaps pop3 pop3s rtsp smb smbs smtp smtps telnet tftp 
    Features: IPv6 Largefile NTLM NTLM_WB SSL libz TLS-SRP HTTP2 UnixSockets

Also installed [Cipherscan SSL tool](https://github.com/jvehent/cipherscan), [testssl.sh tool](https://github.com/drwetter/testssl.sh), [h2spec](https://github.com/summerwind/h2spec) and [ssllabs-scan tool](https://github.com/ssllabs/ssllabs-scan/).

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

#### testssl tool usage

    testssl www.google.com:443

#### ssllabs-scan tool usage

    go run /opt/ssllabs-scan/ssllabs-scan.go https://www.google.com

or

    go run /opt/ssllabs-scan/ssllabs-scan.go -json-flat https://www.google.com

#### nghttp2 & Tools    

nghttp2 client, server, proxy and h2load paths and OpenSSL, curl custom compiled path, h2spec & testssl tool

    /usr/local/bin/nghttp --version
    /usr/local/bin/nghttpd --version
    /usr/local/bin/nghttpx --version
    /usr/local/bin/h2load --version
    /usr/local/http2-15/bin/openssl version
    /usr/local/http2-15/bin/curl --version
    /usr/bin/testssl --version
    /go/src/github.com/summerwind/h2spec/h2spec --help

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

OpenSSL 1.0.2a-chacha supported cipher list
===================================

    /usr/local/http2-15/bin/openssl ciphers -l -V "ALL:COMPLEMENTOFALL"
    
    0xCC,0x14 - ECDHE-ECDSA-CHACHA20-POLY1305 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=ChaCha20(256) Mac=AEAD
    0xCC,0x13 - ECDHE-RSA-CHACHA20-POLY1305 TLSv1.2 Kx=ECDH     Au=RSA  Enc=ChaCha20(256) Mac=AEAD
    0xCC,0x15 - DHE-RSA-CHACHA20-POLY1305 TLSv1.2 Kx=DH       Au=RSA  Enc=ChaCha20(256) Mac=AEAD
    0xC0,0x30 - ECDHE-RSA-AES256-GCM-SHA384 TLSv1.2 Kx=ECDH     Au=RSA  Enc=AESGCM(256) Mac=AEAD
    0xC0,0x2C - ECDHE-ECDSA-AES256-GCM-SHA384 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESGCM(256) Mac=AEAD
    0xC0,0x28 - ECDHE-RSA-AES256-SHA384 TLSv1.2 Kx=ECDH     Au=RSA  Enc=AES(256)  Mac=SHA384
    0xC0,0x24 - ECDHE-ECDSA-AES256-SHA384 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AES(256)  Mac=SHA384
    0xC0,0x14 - ECDHE-RSA-AES256-SHA    SSLv3 Kx=ECDH     Au=RSA  Enc=AES(256)  Mac=SHA1
    0xC0,0x0A - ECDHE-ECDSA-AES256-SHA  SSLv3 Kx=ECDH     Au=ECDSA Enc=AES(256)  Mac=SHA1
    0xC0,0x22 - SRP-DSS-AES-256-CBC-SHA SSLv3 Kx=SRP      Au=DSS  Enc=AES(256)  Mac=SHA1
    0xC0,0x21 - SRP-RSA-AES-256-CBC-SHA SSLv3 Kx=SRP      Au=RSA  Enc=AES(256)  Mac=SHA1
    0xC0,0x20 - SRP-AES-256-CBC-SHA     SSLv3 Kx=SRP      Au=SRP  Enc=AES(256)  Mac=SHA1
    0x00,0xA5 - DH-DSS-AES256-GCM-SHA384 TLSv1.2 Kx=DH/DSS   Au=DH   Enc=AESGCM(256) Mac=AEAD
    0x00,0xA3 - DHE-DSS-AES256-GCM-SHA384 TLSv1.2 Kx=DH       Au=DSS  Enc=AESGCM(256) Mac=AEAD
    0x00,0xA1 - DH-RSA-AES256-GCM-SHA384 TLSv1.2 Kx=DH/RSA   Au=DH   Enc=AESGCM(256) Mac=AEAD
    0x00,0x9F - DHE-RSA-AES256-GCM-SHA384 TLSv1.2 Kx=DH       Au=RSA  Enc=AESGCM(256) Mac=AEAD
    0x00,0x6B - DHE-RSA-AES256-SHA256   TLSv1.2 Kx=DH       Au=RSA  Enc=AES(256)  Mac=SHA256
    0x00,0x6A - DHE-DSS-AES256-SHA256   TLSv1.2 Kx=DH       Au=DSS  Enc=AES(256)  Mac=SHA256
    0x00,0x69 - DH-RSA-AES256-SHA256    TLSv1.2 Kx=DH/RSA   Au=DH   Enc=AES(256)  Mac=SHA256
    0x00,0x68 - DH-DSS-AES256-SHA256    TLSv1.2 Kx=DH/DSS   Au=DH   Enc=AES(256)  Mac=SHA256
    0x00,0x39 - DHE-RSA-AES256-SHA      SSLv3 Kx=DH       Au=RSA  Enc=AES(256)  Mac=SHA1
    0x00,0x38 - DHE-DSS-AES256-SHA      SSLv3 Kx=DH       Au=DSS  Enc=AES(256)  Mac=SHA1
    0x00,0x37 - DH-RSA-AES256-SHA       SSLv3 Kx=DH/RSA   Au=DH   Enc=AES(256)  Mac=SHA1
    0x00,0x36 - DH-DSS-AES256-SHA       SSLv3 Kx=DH/DSS   Au=DH   Enc=AES(256)  Mac=SHA1
    0xC0,0x77 - ECDHE-RSA-CAMELLIA256-SHA384 TLSv1.2 Kx=ECDH     Au=RSA  Enc=Camellia(256) Mac=SHA384
    0xC0,0x73 - ECDHE-ECDSA-CAMELLIA256-SHA384 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=Camellia(256) Mac=SHA384
    0x00,0xC4 - DHE-RSA-CAMELLIA256-SHA256 TLSv1.2 Kx=DH       Au=RSA  Enc=Camellia(256) Mac=SHA256
    0x00,0xC3 - DHE-DSS-CAMELLIA256-SHA256 TLSv1.2 Kx=DH       Au=DSS  Enc=Camellia(256) Mac=SHA256
    0x00,0xC2 - DH-RSA-CAMELLIA256-SHA256 TLSv1.2 Kx=DH/RSA   Au=DH   Enc=Camellia(256) Mac=SHA256
    0x00,0xC1 - DH-DSS-CAMELLIA256-SHA256 TLSv1.2 Kx=DH/DSS   Au=DH   Enc=Camellia(256) Mac=SHA256
    0x00,0x88 - DHE-RSA-CAMELLIA256-SHA SSLv3 Kx=DH       Au=RSA  Enc=Camellia(256) Mac=SHA1
    0x00,0x87 - DHE-DSS-CAMELLIA256-SHA SSLv3 Kx=DH       Au=DSS  Enc=Camellia(256) Mac=SHA1
    0x00,0x86 - DH-RSA-CAMELLIA256-SHA  SSLv3 Kx=DH/RSA   Au=DH   Enc=Camellia(256) Mac=SHA1
    0x00,0x85 - DH-DSS-CAMELLIA256-SHA  SSLv3 Kx=DH/DSS   Au=DH   Enc=Camellia(256) Mac=SHA1
    0xC0,0x19 - AECDH-AES256-SHA        SSLv3 Kx=ECDH     Au=None Enc=AES(256)  Mac=SHA1
    0x00,0xA7 - ADH-AES256-GCM-SHA384   TLSv1.2 Kx=DH       Au=None Enc=AESGCM(256) Mac=AEAD
    0x00,0x6D - ADH-AES256-SHA256       TLSv1.2 Kx=DH       Au=None Enc=AES(256)  Mac=SHA256
    0x00,0x3A - ADH-AES256-SHA          SSLv3 Kx=DH       Au=None Enc=AES(256)  Mac=SHA1
    0x00,0xC5 - ADH-CAMELLIA256-SHA256  TLSv1.2 Kx=DH       Au=None Enc=Camellia(256) Mac=SHA256
    0x00,0x89 - ADH-CAMELLIA256-SHA     SSLv3 Kx=DH       Au=None Enc=Camellia(256) Mac=SHA1
    0xC0,0x32 - ECDH-RSA-AES256-GCM-SHA384 TLSv1.2 Kx=ECDH/RSA Au=ECDH Enc=AESGCM(256) Mac=AEAD
    0xC0,0x2E - ECDH-ECDSA-AES256-GCM-SHA384 TLSv1.2 Kx=ECDH/ECDSA Au=ECDH Enc=AESGCM(256) Mac=AEAD
    0xC0,0x2A - ECDH-RSA-AES256-SHA384  TLSv1.2 Kx=ECDH/RSA Au=ECDH Enc=AES(256)  Mac=SHA384
    0xC0,0x26 - ECDH-ECDSA-AES256-SHA384 TLSv1.2 Kx=ECDH/ECDSA Au=ECDH Enc=AES(256)  Mac=SHA384
    0xC0,0x0F - ECDH-RSA-AES256-SHA     SSLv3 Kx=ECDH/RSA Au=ECDH Enc=AES(256)  Mac=SHA1
    0xC0,0x05 - ECDH-ECDSA-AES256-SHA   SSLv3 Kx=ECDH/ECDSA Au=ECDH Enc=AES(256)  Mac=SHA1
    0xC0,0x79 - ECDH-RSA-CAMELLIA256-SHA384 TLSv1.2 Kx=ECDH/RSA Au=ECDH Enc=Camellia(256) Mac=SHA384
    0xC0,0x75 - ECDH-ECDSA-CAMELLIA256-SHA384 TLSv1.2 Kx=ECDH/ECDSA Au=ECDH Enc=Camellia(256) Mac=SHA384
    0x00,0x9D - AES256-GCM-SHA384       TLSv1.2 Kx=RSA      Au=RSA  Enc=AESGCM(256) Mac=AEAD
    0x00,0x3D - AES256-SHA256           TLSv1.2 Kx=RSA      Au=RSA  Enc=AES(256)  Mac=SHA256
    0x00,0x35 - AES256-SHA              SSLv3 Kx=RSA      Au=RSA  Enc=AES(256)  Mac=SHA1
    0x00,0xC0 - CAMELLIA256-SHA256      TLSv1.2 Kx=RSA      Au=RSA  Enc=Camellia(256) Mac=SHA256
    0x00,0x84 - CAMELLIA256-SHA         SSLv3 Kx=RSA      Au=RSA  Enc=Camellia(256) Mac=SHA1
    0x00,0x95 - RSA-PSK-AES256-CBC-SHA  SSLv3 Kx=RSAPSK   Au=RSA  Enc=AES(256)  Mac=SHA1
    0x00,0x8D - PSK-AES256-CBC-SHA      SSLv3 Kx=PSK      Au=PSK  Enc=AES(256)  Mac=SHA1
    0xC0,0x2F - ECDHE-RSA-AES128-GCM-SHA256 TLSv1.2 Kx=ECDH     Au=RSA  Enc=AESGCM(128) Mac=AEAD
    0xC0,0x2B - ECDHE-ECDSA-AES128-GCM-SHA256 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESGCM(128) Mac=AEAD
    0xC0,0x27 - ECDHE-RSA-AES128-SHA256 TLSv1.2 Kx=ECDH     Au=RSA  Enc=AES(128)  Mac=SHA256
    0xC0,0x23 - ECDHE-ECDSA-AES128-SHA256 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AES(128)  Mac=SHA256
    0xC0,0x13 - ECDHE-RSA-AES128-SHA    SSLv3 Kx=ECDH     Au=RSA  Enc=AES(128)  Mac=SHA1
    0xC0,0x09 - ECDHE-ECDSA-AES128-SHA  SSLv3 Kx=ECDH     Au=ECDSA Enc=AES(128)  Mac=SHA1
    0xC0,0x1F - SRP-DSS-AES-128-CBC-SHA SSLv3 Kx=SRP      Au=DSS  Enc=AES(128)  Mac=SHA1
    0xC0,0x1E - SRP-RSA-AES-128-CBC-SHA SSLv3 Kx=SRP      Au=RSA  Enc=AES(128)  Mac=SHA1
    0xC0,0x1D - SRP-AES-128-CBC-SHA     SSLv3 Kx=SRP      Au=SRP  Enc=AES(128)  Mac=SHA1
    0x00,0xA4 - DH-DSS-AES128-GCM-SHA256 TLSv1.2 Kx=DH/DSS   Au=DH   Enc=AESGCM(128) Mac=AEAD
    0x00,0xA2 - DHE-DSS-AES128-GCM-SHA256 TLSv1.2 Kx=DH       Au=DSS  Enc=AESGCM(128) Mac=AEAD
    0x00,0xA0 - DH-RSA-AES128-GCM-SHA256 TLSv1.2 Kx=DH/RSA   Au=DH   Enc=AESGCM(128) Mac=AEAD
    0x00,0x9E - DHE-RSA-AES128-GCM-SHA256 TLSv1.2 Kx=DH       Au=RSA  Enc=AESGCM(128) Mac=AEAD
    0x00,0x67 - DHE-RSA-AES128-SHA256   TLSv1.2 Kx=DH       Au=RSA  Enc=AES(128)  Mac=SHA256
    0x00,0x40 - DHE-DSS-AES128-SHA256   TLSv1.2 Kx=DH       Au=DSS  Enc=AES(128)  Mac=SHA256
    0x00,0x3F - DH-RSA-AES128-SHA256    TLSv1.2 Kx=DH/RSA   Au=DH   Enc=AES(128)  Mac=SHA256
    0x00,0x3E - DH-DSS-AES128-SHA256    TLSv1.2 Kx=DH/DSS   Au=DH   Enc=AES(128)  Mac=SHA256
    0x00,0x33 - DHE-RSA-AES128-SHA      SSLv3 Kx=DH       Au=RSA  Enc=AES(128)  Mac=SHA1
    0x00,0x32 - DHE-DSS-AES128-SHA      SSLv3 Kx=DH       Au=DSS  Enc=AES(128)  Mac=SHA1
    0x00,0x31 - DH-RSA-AES128-SHA       SSLv3 Kx=DH/RSA   Au=DH   Enc=AES(128)  Mac=SHA1
    0x00,0x30 - DH-DSS-AES128-SHA       SSLv3 Kx=DH/DSS   Au=DH   Enc=AES(128)  Mac=SHA1
    0xC0,0x76 - ECDHE-RSA-CAMELLIA128-SHA256 TLSv1.2 Kx=ECDH     Au=RSA  Enc=Camellia(128) Mac=SHA256
    0xC0,0x72 - ECDHE-ECDSA-CAMELLIA128-SHA256 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=Camellia(128) Mac=SHA256
    0x00,0xBE - DHE-RSA-CAMELLIA128-SHA256 TLSv1.2 Kx=DH       Au=RSA  Enc=Camellia(128) Mac=SHA256
    0x00,0xBD - DHE-DSS-CAMELLIA128-SHA256 TLSv1.2 Kx=DH       Au=DSS  Enc=Camellia(128) Mac=SHA256
    0x00,0xBC - DH-RSA-CAMELLIA128-SHA256 TLSv1.2 Kx=DH/RSA   Au=DH   Enc=Camellia(128) Mac=SHA256
    0x00,0xBB - DH-DSS-CAMELLIA128-SHA256 TLSv1.2 Kx=DH/DSS   Au=DH   Enc=Camellia(128) Mac=SHA256
    0x00,0x9A - DHE-RSA-SEED-SHA        SSLv3 Kx=DH       Au=RSA  Enc=SEED(128) Mac=SHA1
    0x00,0x99 - DHE-DSS-SEED-SHA        SSLv3 Kx=DH       Au=DSS  Enc=SEED(128) Mac=SHA1
    0x00,0x98 - DH-RSA-SEED-SHA         SSLv3 Kx=DH/RSA   Au=DH   Enc=SEED(128) Mac=SHA1
    0x00,0x97 - DH-DSS-SEED-SHA         SSLv3 Kx=DH/DSS   Au=DH   Enc=SEED(128) Mac=SHA1
    0x00,0x45 - DHE-RSA-CAMELLIA128-SHA SSLv3 Kx=DH       Au=RSA  Enc=Camellia(128) Mac=SHA1
    0x00,0x44 - DHE-DSS-CAMELLIA128-SHA SSLv3 Kx=DH       Au=DSS  Enc=Camellia(128) Mac=SHA1
    0x00,0x43 - DH-RSA-CAMELLIA128-SHA  SSLv3 Kx=DH/RSA   Au=DH   Enc=Camellia(128) Mac=SHA1
    0x00,0x42 - DH-DSS-CAMELLIA128-SHA  SSLv3 Kx=DH/DSS   Au=DH   Enc=Camellia(128) Mac=SHA1
    0xC0,0x18 - AECDH-AES128-SHA        SSLv3 Kx=ECDH     Au=None Enc=AES(128)  Mac=SHA1
    0x00,0xA6 - ADH-AES128-GCM-SHA256   TLSv1.2 Kx=DH       Au=None Enc=AESGCM(128) Mac=AEAD
    0x00,0x6C - ADH-AES128-SHA256       TLSv1.2 Kx=DH       Au=None Enc=AES(128)  Mac=SHA256
    0x00,0x34 - ADH-AES128-SHA          SSLv3 Kx=DH       Au=None Enc=AES(128)  Mac=SHA1
    0x00,0xBF - ADH-CAMELLIA128-SHA256  TLSv1.2 Kx=DH       Au=None Enc=Camellia(128) Mac=SHA256
    0x00,0x9B - ADH-SEED-SHA            SSLv3 Kx=DH       Au=None Enc=SEED(128) Mac=SHA1
    0x00,0x46 - ADH-CAMELLIA128-SHA     SSLv3 Kx=DH       Au=None Enc=Camellia(128) Mac=SHA1
    0xC0,0x31 - ECDH-RSA-AES128-GCM-SHA256 TLSv1.2 Kx=ECDH/RSA Au=ECDH Enc=AESGCM(128) Mac=AEAD
    0xC0,0x2D - ECDH-ECDSA-AES128-GCM-SHA256 TLSv1.2 Kx=ECDH/ECDSA Au=ECDH Enc=AESGCM(128) Mac=AEAD
    0xC0,0x29 - ECDH-RSA-AES128-SHA256  TLSv1.2 Kx=ECDH/RSA Au=ECDH Enc=AES(128)  Mac=SHA256
    0xC0,0x25 - ECDH-ECDSA-AES128-SHA256 TLSv1.2 Kx=ECDH/ECDSA Au=ECDH Enc=AES(128)  Mac=SHA256
    0xC0,0x0E - ECDH-RSA-AES128-SHA     SSLv3 Kx=ECDH/RSA Au=ECDH Enc=AES(128)  Mac=SHA1
    0xC0,0x04 - ECDH-ECDSA-AES128-SHA   SSLv3 Kx=ECDH/ECDSA Au=ECDH Enc=AES(128)  Mac=SHA1
    0xC0,0x78 - ECDH-RSA-CAMELLIA128-SHA256 TLSv1.2 Kx=ECDH/RSA Au=ECDH Enc=Camellia(128) Mac=SHA256
    0xC0,0x74 - ECDH-ECDSA-CAMELLIA128-SHA256 TLSv1.2 Kx=ECDH/ECDSA Au=ECDH Enc=Camellia(128) Mac=SHA256
    0x00,0x9C - AES128-GCM-SHA256       TLSv1.2 Kx=RSA      Au=RSA  Enc=AESGCM(128) Mac=AEAD
    0x00,0x3C - AES128-SHA256           TLSv1.2 Kx=RSA      Au=RSA  Enc=AES(128)  Mac=SHA256
    0x00,0x2F - AES128-SHA              SSLv3 Kx=RSA      Au=RSA  Enc=AES(128)  Mac=SHA1
    0x00,0xBA - CAMELLIA128-SHA256      TLSv1.2 Kx=RSA      Au=RSA  Enc=Camellia(128) Mac=SHA256
    0x00,0x96 - SEED-SHA                SSLv3 Kx=RSA      Au=RSA  Enc=SEED(128) Mac=SHA1
    0x00,0x41 - CAMELLIA128-SHA         SSLv3 Kx=RSA      Au=RSA  Enc=Camellia(128) Mac=SHA1
    0x00,0x07 - IDEA-CBC-SHA            SSLv3 Kx=RSA      Au=RSA  Enc=IDEA(128) Mac=SHA1
    0x05,0x00,0x80 - IDEA-CBC-MD5            SSLv2 Kx=RSA      Au=RSA  Enc=IDEA(128) Mac=MD5 
    0x03,0x00,0x80 - RC2-CBC-MD5             SSLv2 Kx=RSA      Au=RSA  Enc=RC2(128)  Mac=MD5 
    0x00,0x94 - RSA-PSK-AES128-CBC-SHA  SSLv3 Kx=RSAPSK   Au=RSA  Enc=AES(128)  Mac=SHA1
    0x00,0x8C - PSK-AES128-CBC-SHA      SSLv3 Kx=PSK      Au=PSK  Enc=AES(128)  Mac=SHA1
    0xC0,0x11 - ECDHE-RSA-RC4-SHA       SSLv3 Kx=ECDH     Au=RSA  Enc=RC4(128)  Mac=SHA1
    0xC0,0x07 - ECDHE-ECDSA-RC4-SHA     SSLv3 Kx=ECDH     Au=ECDSA Enc=RC4(128)  Mac=SHA1
    0x00,0x66 - DHE-DSS-RC4-SHA         SSLv3 Kx=DH       Au=DSS  Enc=RC4(128)  Mac=SHA1
    0xC0,0x16 - AECDH-RC4-SHA           SSLv3 Kx=ECDH     Au=None Enc=RC4(128)  Mac=SHA1
    0x00,0x18 - ADH-RC4-MD5             SSLv3 Kx=DH       Au=None Enc=RC4(128)  Mac=MD5 
    0xC0,0x0C - ECDH-RSA-RC4-SHA        SSLv3 Kx=ECDH/RSA Au=ECDH Enc=RC4(128)  Mac=SHA1
    0xC0,0x02 - ECDH-ECDSA-RC4-SHA      SSLv3 Kx=ECDH/ECDSA Au=ECDH Enc=RC4(128)  Mac=SHA1
    0x00,0x05 - RC4-SHA                 SSLv3 Kx=RSA      Au=RSA  Enc=RC4(128)  Mac=SHA1
    0x00,0x04 - RC4-MD5                 SSLv3 Kx=RSA      Au=RSA  Enc=RC4(128)  Mac=MD5 
    0x01,0x00,0x80 - RC4-MD5                 SSLv2 Kx=RSA      Au=RSA  Enc=RC4(128)  Mac=MD5 
    0x00,0x92 - RSA-PSK-RC4-SHA         SSLv3 Kx=RSAPSK   Au=RSA  Enc=RC4(128)  Mac=SHA1
    0x00,0x8A - PSK-RC4-SHA             SSLv3 Kx=PSK      Au=PSK  Enc=RC4(128)  Mac=SHA1
    0xC0,0x12 - ECDHE-RSA-DES-CBC3-SHA  SSLv3 Kx=ECDH     Au=RSA  Enc=3DES(168) Mac=SHA1
    0xC0,0x08 - ECDHE-ECDSA-DES-CBC3-SHA SSLv3 Kx=ECDH     Au=ECDSA Enc=3DES(168) Mac=SHA1
    0xC0,0x1C - SRP-DSS-3DES-EDE-CBC-SHA SSLv3 Kx=SRP      Au=DSS  Enc=3DES(168) Mac=SHA1
    0xC0,0x1B - SRP-RSA-3DES-EDE-CBC-SHA SSLv3 Kx=SRP      Au=RSA  Enc=3DES(168) Mac=SHA1
    0xC0,0x1A - SRP-3DES-EDE-CBC-SHA    SSLv3 Kx=SRP      Au=SRP  Enc=3DES(168) Mac=SHA1
    0x00,0x16 - EDH-RSA-DES-CBC3-SHA    SSLv3 Kx=DH       Au=RSA  Enc=3DES(168) Mac=SHA1
    0x00,0x13 - EDH-DSS-DES-CBC3-SHA    SSLv3 Kx=DH       Au=DSS  Enc=3DES(168) Mac=SHA1
    0x00,0x10 - DH-RSA-DES-CBC3-SHA     SSLv3 Kx=DH/RSA   Au=DH   Enc=3DES(168) Mac=SHA1
    0x00,0x0D - DH-DSS-DES-CBC3-SHA     SSLv3 Kx=DH/DSS   Au=DH   Enc=3DES(168) Mac=SHA1
    0xC0,0x17 - AECDH-DES-CBC3-SHA      SSLv3 Kx=ECDH     Au=None Enc=3DES(168) Mac=SHA1
    0x00,0x1B - ADH-DES-CBC3-SHA        SSLv3 Kx=DH       Au=None Enc=3DES(168) Mac=SHA1
    0xC0,0x0D - ECDH-RSA-DES-CBC3-SHA   SSLv3 Kx=ECDH/RSA Au=ECDH Enc=3DES(168) Mac=SHA1
    0xC0,0x03 - ECDH-ECDSA-DES-CBC3-SHA SSLv3 Kx=ECDH/ECDSA Au=ECDH Enc=3DES(168) Mac=SHA1
    0x00,0x0A - DES-CBC3-SHA            SSLv3 Kx=RSA      Au=RSA  Enc=3DES(168) Mac=SHA1
    0x07,0x00,0xC0 - DES-CBC3-MD5            SSLv2 Kx=RSA      Au=RSA  Enc=3DES(168) Mac=MD5 
    0x00,0x93 - RSA-PSK-3DES-EDE-CBC-SHA SSLv3 Kx=RSAPSK   Au=RSA  Enc=3DES(168) Mac=SHA1
    0x00,0x8B - PSK-3DES-EDE-CBC-SHA    SSLv3 Kx=PSK      Au=PSK  Enc=3DES(168) Mac=SHA1
    0x08,0x00,0x80 - RC4-64-MD5              SSLv2 Kx=RSA      Au=RSA  Enc=RC4(64)   Mac=MD5 
    0x00,0x63 - EXP1024-DHE-DSS-DES-CBC-SHA SSLv3 Kx=DH(1024) Au=DSS  Enc=DES(56)   Mac=SHA1 export
    0x00,0x15 - EDH-RSA-DES-CBC-SHA     SSLv3 Kx=DH       Au=RSA  Enc=DES(56)   Mac=SHA1
    0x00,0x12 - EDH-DSS-DES-CBC-SHA     SSLv3 Kx=DH       Au=DSS  Enc=DES(56)   Mac=SHA1
    0x00,0x0F - DH-RSA-DES-CBC-SHA      SSLv3 Kx=DH/RSA   Au=DH   Enc=DES(56)   Mac=SHA1
    0x00,0x0C - DH-DSS-DES-CBC-SHA      SSLv3 Kx=DH/DSS   Au=DH   Enc=DES(56)   Mac=SHA1
    0x00,0x1A - ADH-DES-CBC-SHA         SSLv3 Kx=DH       Au=None Enc=DES(56)   Mac=SHA1
    0x00,0x62 - EXP1024-DES-CBC-SHA     SSLv3 Kx=RSA(1024) Au=RSA  Enc=DES(56)   Mac=SHA1 export
    0x00,0x09 - DES-CBC-SHA             SSLv3 Kx=RSA      Au=RSA  Enc=DES(56)   Mac=SHA1
    0x06,0x00,0x40 - DES-CBC-MD5             SSLv2 Kx=RSA      Au=RSA  Enc=DES(56)   Mac=MD5 
    0x00,0x65 - EXP1024-DHE-DSS-RC4-SHA SSLv3 Kx=DH(1024) Au=DSS  Enc=RC4(56)   Mac=SHA1 export
    0x00,0x64 - EXP1024-RC4-SHA         SSLv3 Kx=RSA(1024) Au=RSA  Enc=RC4(56)   Mac=SHA1 export
    0x00,0x14 - EXP-EDH-RSA-DES-CBC-SHA SSLv3 Kx=DH(512)  Au=RSA  Enc=DES(40)   Mac=SHA1 export
    0x00,0x11 - EXP-EDH-DSS-DES-CBC-SHA SSLv3 Kx=DH(512)  Au=DSS  Enc=DES(40)   Mac=SHA1 export
    0x00,0x0E - EXP-DH-RSA-DES-CBC-SHA  SSLv3 Kx=DH/RSA   Au=DH   Enc=DES(40)   Mac=SHA1 export
    0x00,0x0B - EXP-DH-DSS-DES-CBC-SHA  SSLv3 Kx=DH/DSS   Au=DH   Enc=DES(40)   Mac=SHA1 export
    0x00,0x19 - EXP-ADH-DES-CBC-SHA     SSLv3 Kx=DH(512)  Au=None Enc=DES(40)   Mac=SHA1 export
    0x00,0x08 - EXP-DES-CBC-SHA         SSLv3 Kx=RSA(512) Au=RSA  Enc=DES(40)   Mac=SHA1 export
    0x00,0x06 - EXP-RC2-CBC-MD5         SSLv3 Kx=RSA(512) Au=RSA  Enc=RC2(40)   Mac=MD5  export
    0x04,0x00,0x80 - EXP-RC2-CBC-MD5         SSLv2 Kx=RSA(512) Au=RSA  Enc=RC2(40)   Mac=MD5  export
    0x00,0x17 - EXP-ADH-RC4-MD5         SSLv3 Kx=DH(512)  Au=None Enc=RC4(40)   Mac=MD5  export
    0x00,0x03 - EXP-RC4-MD5             SSLv3 Kx=RSA(512) Au=RSA  Enc=RC4(40)   Mac=MD5  export
    0x02,0x00,0x80 - EXP-RC4-MD5             SSLv2 Kx=RSA(512) Au=RSA  Enc=RC4(40)   Mac=MD5  export
    0xC0,0x10 - ECDHE-RSA-NULL-SHA      SSLv3 Kx=ECDH     Au=RSA  Enc=None      Mac=SHA1
    0xC0,0x06 - ECDHE-ECDSA-NULL-SHA    SSLv3 Kx=ECDH     Au=ECDSA Enc=None      Mac=SHA1
    0xC0,0x15 - AECDH-NULL-SHA          SSLv3 Kx=ECDH     Au=None Enc=None      Mac=SHA1
    0xC0,0x0B - ECDH-RSA-NULL-SHA       SSLv3 Kx=ECDH/RSA Au=ECDH Enc=None      Mac=SHA1
    0xC0,0x01 - ECDH-ECDSA-NULL-SHA     SSLv3 Kx=ECDH/ECDSA Au=ECDH Enc=None      Mac=SHA1
    0x00,0x3B - NULL-SHA256             TLSv1.2 Kx=RSA      Au=RSA  Enc=None      Mac=SHA256
    0x00,0x02 - NULL-SHA                SSLv3 Kx=RSA      Au=RSA  Enc=None      Mac=SHA1
    0x00,0x01 - NULL-MD5                SSLv3 Kx=RSA      Au=RSA  Enc=None      Mac=MD5 
    0x00,0x00,0x00 - NULL-MD5                SSLv2 Kx=RSA(512) Au=RSA  Enc=None      Mac=MD5  export