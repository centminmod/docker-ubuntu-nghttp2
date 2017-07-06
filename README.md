# docker-ubuntu-nghttp2

[![](https://images.microbadger.com/badges/version/centminmod/docker-ubuntu-nghttp2.svg)](https://microbadger.com/images/centminmod/docker-ubuntu-nghttp2 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/centminmod/docker-ubuntu-nghttp2.svg)](https://microbadger.com/images/centminmod/docker-ubuntu-nghttp2 "Get your own image badge on microbadger.com")  [![](https://images.microbadger.com/badges/commit/centminmod/docker-ubuntu-nghttp2.svg)](https://microbadger.com/images/centminmod/docker-ubuntu-nghttp2 "Get your own commit badge on microbadger.com")

Docker based image for [nghttp2 HTTP/2](https://nghttp2.org/) C library client, server, proxy and h2load testing tool for HTTP/2 on Ubuntu intended for use to test [h2o HTTP/2 server](https://github.com/h2o/h2o) and [Nginx HTTP/2](http://centminmod.com/http2-nginx.html) integration & [Letsencrypt client](http://centminmod.com/letsencrypt-freessl.html) integration in [CentminMod.com LEMP stack](http://centminmod.com). 

Used Ubuntu instead of CentOS as the nghttp2 build and compile software version requirements were too high a version for CentOS YUM packages and source compiling those higher software versions would take almost 2 hours to compile.

[Custom OpenSSL 1.0.2k version](https://github.com/PeterMosmans/openssl) with chacha20_poly1305 cipher patch etc is compiled for enabling ALPN TLS extension support. Default Ubuntu OpenSSL 1.0.1g only supports NPN TLS extension. The nghttp2 libraries support both ALPN & NPN extensions.

    /usr/local/http2-15/bin/openssl version
    OpenSSL 1.0.2-chacha (1.0.2k-dev)

Custom curl 7.54.1 DEV version installed compiled against custom OpenSSL 1.1.1 dev build with TLS v1.3 draft-18 branch support

    curl -V
    curl 7.54.1-DEV (x86_64-pc-linux-gnu) libcurl/7.54.1-DEV OpenSSL/1.1.1 zlib/1.2.11 libpsl/0.17.0 (+libidn2/0.16) libssh2/1.7.0
    Release-Date: [unreleased]
    Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp 
    Features: AsynchDNS IPv6 Largefile NTLM NTLM_WB SSL libz TLS-SRP UnixSockets HTTPS-proxy PSL

Also installed [Cipherscan SSL tool](https://github.com/jvehent/cipherscan), [testssl.sh tool](https://github.com/drwetter/testssl.sh), [h2spec](https://github.com/summerwind/h2spec) and [ssllabs-scan tool](https://github.com/ssllabs/ssllabs-scan/), [is-http2-cli](https://github.com/stefanjudis/is-http2-cli), [h2i](https://github.com/bradfitz/http2/tree/master/h2i) and [Mozilla TLS Observatory](https://github.com/mozilla/tls-observatory).

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

also I setup an alias shortcut which makes it easy to remove the current image and redownload a fresh one

    alias rmnghttp='docker stop nghttp; docker rm nghttp; docker rmi centminmod/docker-ubuntu-nghttp2; docker run -ti --name nghttp centminmod/docker-ubuntu-nghttp2 /bin/bash'

#### is-http2-cli tool usage

    /usr/local/bin/is-http2 https://centminmod.com
    ✓ HTTP/2 supported by https://centminmod.com
    Supported protocols: h2 http/1.1

#### Cipherscan tool usage

    cipherscan www.google.com:443

#### testssl tool usage

    testssl www.google.com:443

#### ssllabs-scan tool usage

    go run /opt/ssllabs-scan/ssllabs-scan.go https://www.google.com

or

    go run /opt/ssllabs-scan/ssllabs-scan.go -json-flat https://www.google.com

#### h2i usage

    /usr/bin/h2i google.com

#### nghttp2 & Tools    

nghttp2 client, server, proxy and h2load paths and OpenSSL, curl custom compiled path, h2spec & testssl tool

    /usr/local/bin/nghttp --version
    /usr/local/bin/nghttpd --version
    /usr/local/bin/nghttpx --version
    /usr/local/bin/h2load --version
    /usr/local/http2-15/bin/openssl version
    /usr/local/http2-15/bin/curl --version
    /usr/bin/testssl --version
    /usr/bin/h2spec --help
    /usr/bin/h2i --help

check for ALPN extension support in Nginx HTTP/2 patched Centmin Mod Nginx LEMP stack server - look for ALPN protocol: h2
===================================

    /usr/local/http2-15/bin/openssl s_client -alpn h2 -host centminmod.com -port 443

    ---
    New, TLSv1/SSLv3, Cipher is ECDHE-RSA-CHACHA20-POLY1305
    Server public key is 2048 bit
    Secure Renegotiation IS supported
    Compression: NONE
    Expansion: NONE
    ALPN protocol: h2
    SSL-Session:
        Protocol  : TLSv1.2
        Cipher    : ECDHE-RSA-CHACHA20-POLY1305    

check for ALPN extension support in h2o server - look for ALPN protocol: h2-14
===================================

    /usr/local/http2-15/bin/openssl s_client -alpn h2-14 -host h2ohttp2.centminmod.com -port 8081
        
    ---
    New, TLSv1/SSLv3, Cipher is ECDHE-RSA-CHACHA20-POLY1305
    Server public key is 2048 bit
    Secure Renegotiation IS supported
    Compression: NONE
    Expansion: NONE
    ALPN protocol: h2-14
    SSL-Session:
        Protocol  : TLSv1.2
        Cipher    : ECDHE-RSA-CHACHA20-POLY1305

check for NPN extension support in h2o server - look for Next protocol: (1) h2-14
===================================

    /usr/local/http2-15/bin/openssl s_client -nextprotoneg h2-14 -host h2ohttp2.centminmod.com -port 8081
    
    ---
    New, TLSv1/SSLv3, Cipher is ECDHE-RSA-CHACHA20-POLY1305
    Server public key is 2048 bit
    Secure Renegotiation IS supported
    Compression: NONE
    Expansion: NONE
    Next protocol: (1) h2-14
    No ALPN negotiated

Example using nghttp2 client against Nginx 1.9.15 HTTP/2 server on port 443
===================================

    nghttp -nv https://centminmod.com:443
    [  0.082] Connected
    The negotiated protocol: h2
    [  0.104] recv SETTINGS frame <length=18, flags=0x00, stream_id=0>
              (niv=3)
              [SETTINGS_MAX_CONCURRENT_STREAMS(0x03):128]
              [SETTINGS_INITIAL_WINDOW_SIZE(0x04):0]
              [SETTINGS_MAX_FRAME_SIZE(0x05):16777215]
    [  0.104] recv WINDOW_UPDATE frame <length=4, flags=0x00, stream_id=0>
              (window_size_increment=2147418112)
    [  0.104] send SETTINGS frame <length=12, flags=0x00, stream_id=0>
              (niv=2)
              [SETTINGS_MAX_CONCURRENT_STREAMS(0x03):100]
              [SETTINGS_INITIAL_WINDOW_SIZE(0x04):65535]
    [  0.104] send SETTINGS frame <length=0, flags=0x01, stream_id=0>
              ; ACK
              (niv=0)
    [  0.104] send PRIORITY frame <length=5, flags=0x00, stream_id=3>
              (dep_stream_id=0, weight=201, exclusive=0)
    [  0.104] send PRIORITY frame <length=5, flags=0x00, stream_id=5>
              (dep_stream_id=0, weight=101, exclusive=0)
    [  0.104] send PRIORITY frame <length=5, flags=0x00, stream_id=7>
              (dep_stream_id=0, weight=1, exclusive=0)
    [  0.104] send PRIORITY frame <length=5, flags=0x00, stream_id=9>
              (dep_stream_id=7, weight=1, exclusive=0)
    [  0.104] send PRIORITY frame <length=5, flags=0x00, stream_id=11>
              (dep_stream_id=3, weight=1, exclusive=0)
    [  0.104] send HEADERS frame <length=41, flags=0x25, stream_id=13>
              ; END_STREAM | END_HEADERS | PRIORITY
              (padlen=0, dep_stream_id=11, weight=16, exclusive=0)
              ; Open new stream
              :method: GET
              :path: /
              :scheme: https
              :authority: centminmod.com
              accept: */*
              accept-encoding: gzip, deflate
              user-agent: nghttp2/1.11.0-DEV

Example against OpenLiteSpeed 1.4.8 server with HTTP/2 web site on port 8099
===================================

    nghttp -nv h2ohttp2.centminmod.com:8099

    [  0.143] Connected
    [  0.220][NPN] server offers:
              * h2-14
              * spdy/3.1
              * spdy/3
              * spdy/2
              * http/1.1
    The negotiated protocol: h2-14
    [  0.313] send SETTINGS frame <length=12, flags=0x00, stream_id=0>
              (niv=2)
              [SETTINGS_MAX_CONCURRENT_STREAMS(0x03):100]
              [SETTINGS_INITIAL_WINDOW_SIZE(0x04):65535]
    [  0.313] send PRIORITY frame <length=5, flags=0x00, stream_id=3>
              (dep_stream_id=0, weight=201, exclusive=0)
    [  0.313] send PRIORITY frame <length=5, flags=0x00, stream_id=5>
              (dep_stream_id=0, weight=101, exclusive=0)
    [  0.313] send PRIORITY frame <length=5, flags=0x00, stream_id=7>
              (dep_stream_id=0, weight=1, exclusive=0)
    [  0.313] send PRIORITY frame <length=5, flags=0x00, stream_id=9>
              (dep_stream_id=7, weight=1, exclusive=0)
    [  0.313] send PRIORITY frame <length=5, flags=0x00, stream_id=11>
              (dep_stream_id=3, weight=1, exclusive=0)
    [  0.313] send HEADERS frame <length=51, flags=0x25, stream_id=13>
              ; END_STREAM | END_HEADERS | PRIORITY
              (padlen=0, dep_stream_id=11, weight=16, exclusive=0)
              ; Open new stream
              :method: GET
              :path: /
              :scheme: https
              :authority: h2ohttp2.centminmod.com:8099
              accept: */*
              accept-encoding: gzip, deflate
              user-agent: nghttp2/1.0.1-DEV
    [  0.392] recv SETTINGS frame <length=12, flags=0x00, stream_id=0>
              (niv=2)
              [SETTINGS_MAX_CONCURRENT_STREAMS(0x03):100]
              [SETTINGS_INITIAL_WINDOW_SIZE(0x04):65536]
    [  0.392] recv WINDOW_UPDATE frame <length=4, flags=0x00, stream_id=0>
              (window_size_increment=65535)
    [  0.392] recv SETTINGS frame <length=0, flags=0x01, stream_id=0>
              ; ACK
              (niv=0)
    [  0.392] recv (stream_id=13) :status: 200
    [  0.392] recv (stream_id=13) cache-control: public, max-age=900
    [  0.392] recv (stream_id=13) cache-control: public, must-revalidate, proxy-revalidate
    [  0.392] recv (stream_id=13) expires: Tue, 19 May 2015 15:06:49 GMT
    [  0.392] recv (stream_id=13) etag: "59a-550c18e6-c0c59"
    [  0.392] recv (stream_id=13) last-modified: Fri, 20 Mar 2015 12:56:06 GMT
    [  0.392] recv (stream_id=13) content-type: text/html; charset=utf-8
    [  0.392] recv (stream_id=13) content-length: 480
    [  0.392] recv (stream_id=13) accept-ranges: bytes
    [  0.392] recv (stream_id=13) content-encoding: gzip
    [  0.392] recv (stream_id=13) vary: Accept-Encoding
    [  0.392] recv (stream_id=13) date: Tue, 19 May 2015 14:51:49 GMT
    [  0.392] recv (stream_id=13) server: LiteSpeed
    [  0.392] recv HEADERS frame <length=196, flags=0x04, stream_id=13>
              ; END_HEADERS
              (padlen=0)
              ; First response header
    [  0.392] recv DATA frame <length=480, flags=0x00, stream_id=13>
    [  0.392] recv DATA frame <length=0, flags=0x01, stream_id=13>
              ; END_STREAM
    [  0.392] send SETTINGS frame <length=0, flags=0x01, stream_id=0>
              ; ACK
              (niv=0)
    [  0.392] send GOAWAY frame <length=8, flags=0x00, stream_id=0>
              (last_stream_id=0, error_code=NO_ERROR(0x00), opaque_data(0)=[])

OpenSSL 1.1.1 dev build with TLS v1.3 draft-18 supported cipher list
===================================

    /usr/local/http2-15/bin/openssl ciphers -V "ALL:COMPLEMENTOFALL"
              0xC0,0x2C - ECDHE-ECDSA-AES256-GCM-SHA384 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESGCM(256) Mac=AEAD
              0xC0,0x30 - ECDHE-RSA-AES256-GCM-SHA384 TLSv1.2 Kx=ECDH     Au=RSA  Enc=AESGCM(256) Mac=AEAD
              0x00,0xA3 - DHE-DSS-AES256-GCM-SHA384 TLSv1.2 Kx=DH       Au=DSS  Enc=AESGCM(256) Mac=AEAD
              0x00,0x9F - DHE-RSA-AES256-GCM-SHA384 TLSv1.2 Kx=DH       Au=RSA  Enc=AESGCM(256) Mac=AEAD
              0xCC,0xA9 - ECDHE-ECDSA-CHACHA20-POLY1305 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=CHACHA20/POLY1305(256) Mac=AEAD
              0xCC,0xA8 - ECDHE-RSA-CHACHA20-POLY1305 TLSv1.2 Kx=ECDH     Au=RSA  Enc=CHACHA20/POLY1305(256) Mac=AEAD
              0xCC,0xAA - DHE-RSA-CHACHA20-POLY1305 TLSv1.2 Kx=DH       Au=RSA  Enc=CHACHA20/POLY1305(256) Mac=AEAD
              0xC0,0xAF - ECDHE-ECDSA-AES256-CCM8 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESCCM8(256) Mac=AEAD
              0xC0,0xAD - ECDHE-ECDSA-AES256-CCM  TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESCCM(256) Mac=AEAD
              0xC0,0xA3 - DHE-RSA-AES256-CCM8     TLSv1.2 Kx=DH       Au=RSA  Enc=AESCCM8(256) Mac=AEAD
              0xC0,0x9F - DHE-RSA-AES256-CCM      TLSv1.2 Kx=DH       Au=RSA  Enc=AESCCM(256) Mac=AEAD
              0x00,0xA7 - ADH-AES256-GCM-SHA384   TLSv1.2 Kx=DH       Au=None Enc=AESGCM(256) Mac=AEAD
              0xC0,0x2B - ECDHE-ECDSA-AES128-GCM-SHA256 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESGCM(128) Mac=AEAD
              0xC0,0x2F - ECDHE-RSA-AES128-GCM-SHA256 TLSv1.2 Kx=ECDH     Au=RSA  Enc=AESGCM(128) Mac=AEAD
              0x00,0xA2 - DHE-DSS-AES128-GCM-SHA256 TLSv1.2 Kx=DH       Au=DSS  Enc=AESGCM(128) Mac=AEAD
              0x00,0x9E - DHE-RSA-AES128-GCM-SHA256 TLSv1.2 Kx=DH       Au=RSA  Enc=AESGCM(128) Mac=AEAD
              0xC0,0xAE - ECDHE-ECDSA-AES128-CCM8 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESCCM8(128) Mac=AEAD
              0xC0,0xAC - ECDHE-ECDSA-AES128-CCM  TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESCCM(128) Mac=AEAD
              0xC0,0xA2 - DHE-RSA-AES128-CCM8     TLSv1.2 Kx=DH       Au=RSA  Enc=AESCCM8(128) Mac=AEAD
              0xC0,0x9E - DHE-RSA-AES128-CCM      TLSv1.2 Kx=DH       Au=RSA  Enc=AESCCM(128) Mac=AEAD
              0x00,0xA6 - ADH-AES128-GCM-SHA256   TLSv1.2 Kx=DH       Au=None Enc=AESGCM(128) Mac=AEAD
              0xC0,0x24 - ECDHE-ECDSA-AES256-SHA384 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AES(256)  Mac=SHA384
              0xC0,0x28 - ECDHE-RSA-AES256-SHA384 TLSv1.2 Kx=ECDH     Au=RSA  Enc=AES(256)  Mac=SHA384
              0x00,0x6B - DHE-RSA-AES256-SHA256   TLSv1.2 Kx=DH       Au=RSA  Enc=AES(256)  Mac=SHA256
              0x00,0x6A - DHE-DSS-AES256-SHA256   TLSv1.2 Kx=DH       Au=DSS  Enc=AES(256)  Mac=SHA256
              0xC0,0x73 - ECDHE-ECDSA-CAMELLIA256-SHA384 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=Camellia(256) Mac=SHA384
              0xC0,0x77 - ECDHE-RSA-CAMELLIA256-SHA384 TLSv1.2 Kx=ECDH     Au=RSA  Enc=Camellia(256) Mac=SHA384
              0x00,0xC4 - DHE-RSA-CAMELLIA256-SHA256 TLSv1.2 Kx=DH       Au=RSA  Enc=Camellia(256) Mac=SHA256
              0x00,0xC3 - DHE-DSS-CAMELLIA256-SHA256 TLSv1.2 Kx=DH       Au=DSS  Enc=Camellia(256) Mac=SHA256
              0x00,0x6D - ADH-AES256-SHA256       TLSv1.2 Kx=DH       Au=None Enc=AES(256)  Mac=SHA256
              0x00,0xC5 - ADH-CAMELLIA256-SHA256  TLSv1.2 Kx=DH       Au=None Enc=Camellia(256) Mac=SHA256
              0xC0,0x23 - ECDHE-ECDSA-AES128-SHA256 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AES(128)  Mac=SHA256
              0xC0,0x27 - ECDHE-RSA-AES128-SHA256 TLSv1.2 Kx=ECDH     Au=RSA  Enc=AES(128)  Mac=SHA256
              0x00,0x67 - DHE-RSA-AES128-SHA256   TLSv1.2 Kx=DH       Au=RSA  Enc=AES(128)  Mac=SHA256
              0x00,0x40 - DHE-DSS-AES128-SHA256   TLSv1.2 Kx=DH       Au=DSS  Enc=AES(128)  Mac=SHA256
              0xC0,0x72 - ECDHE-ECDSA-CAMELLIA128-SHA256 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=Camellia(128) Mac=SHA256
              0xC0,0x76 - ECDHE-RSA-CAMELLIA128-SHA256 TLSv1.2 Kx=ECDH     Au=RSA  Enc=Camellia(128) Mac=SHA256
              0x00,0xBE - DHE-RSA-CAMELLIA128-SHA256 TLSv1.2 Kx=DH       Au=RSA  Enc=Camellia(128) Mac=SHA256
              0x00,0xBD - DHE-DSS-CAMELLIA128-SHA256 TLSv1.2 Kx=DH       Au=DSS  Enc=Camellia(128) Mac=SHA256
              0x00,0x6C - ADH-AES128-SHA256       TLSv1.2 Kx=DH       Au=None Enc=AES(128)  Mac=SHA256
              0x00,0xBF - ADH-CAMELLIA128-SHA256  TLSv1.2 Kx=DH       Au=None Enc=Camellia(128) Mac=SHA256
              0xC0,0x0A - ECDHE-ECDSA-AES256-SHA  SSLv3 Kx=ECDH     Au=ECDSA Enc=AES(256)  Mac=SHA1
              0xC0,0x14 - ECDHE-RSA-AES256-SHA    SSLv3 Kx=ECDH     Au=RSA  Enc=AES(256)  Mac=SHA1
              0x00,0x39 - DHE-RSA-AES256-SHA      SSLv3 Kx=DH       Au=RSA  Enc=AES(256)  Mac=SHA1
              0x00,0x38 - DHE-DSS-AES256-SHA      SSLv3 Kx=DH       Au=DSS  Enc=AES(256)  Mac=SHA1
              0x00,0x88 - DHE-RSA-CAMELLIA256-SHA SSLv3 Kx=DH       Au=RSA  Enc=Camellia(256) Mac=SHA1
              0x00,0x87 - DHE-DSS-CAMELLIA256-SHA SSLv3 Kx=DH       Au=DSS  Enc=Camellia(256) Mac=SHA1
              0xC0,0x19 - AECDH-AES256-SHA        SSLv3 Kx=ECDH     Au=None Enc=AES(256)  Mac=SHA1
              0x00,0x3A - ADH-AES256-SHA          SSLv3 Kx=DH       Au=None Enc=AES(256)  Mac=SHA1
              0x00,0x89 - ADH-CAMELLIA256-SHA     SSLv3 Kx=DH       Au=None Enc=Camellia(256) Mac=SHA1
              0xC0,0x09 - ECDHE-ECDSA-AES128-SHA  SSLv3 Kx=ECDH     Au=ECDSA Enc=AES(128)  Mac=SHA1
              0xC0,0x13 - ECDHE-RSA-AES128-SHA    SSLv3 Kx=ECDH     Au=RSA  Enc=AES(128)  Mac=SHA1
              0x00,0x33 - DHE-RSA-AES128-SHA      SSLv3 Kx=DH       Au=RSA  Enc=AES(128)  Mac=SHA1
              0x00,0x32 - DHE-DSS-AES128-SHA      SSLv3 Kx=DH       Au=DSS  Enc=AES(128)  Mac=SHA1
              0x00,0x9A - DHE-RSA-SEED-SHA        SSLv3 Kx=DH       Au=RSA  Enc=SEED(128) Mac=SHA1
              0x00,0x99 - DHE-DSS-SEED-SHA        SSLv3 Kx=DH       Au=DSS  Enc=SEED(128) Mac=SHA1
              0x00,0x45 - DHE-RSA-CAMELLIA128-SHA SSLv3 Kx=DH       Au=RSA  Enc=Camellia(128) Mac=SHA1
              0x00,0x44 - DHE-DSS-CAMELLIA128-SHA SSLv3 Kx=DH       Au=DSS  Enc=Camellia(128) Mac=SHA1
              0xC0,0x18 - AECDH-AES128-SHA        SSLv3 Kx=ECDH     Au=None Enc=AES(128)  Mac=SHA1
              0x00,0x34 - ADH-AES128-SHA          SSLv3 Kx=DH       Au=None Enc=AES(128)  Mac=SHA1
              0x00,0x9B - ADH-SEED-SHA            SSLv3 Kx=DH       Au=None Enc=SEED(128) Mac=SHA1
              0x00,0x46 - ADH-CAMELLIA128-SHA     SSLv3 Kx=DH       Au=None Enc=Camellia(128) Mac=SHA1
              0x00,0xAD - RSA-PSK-AES256-GCM-SHA384 TLSv1.2 Kx=RSAPSK   Au=RSA  Enc=AESGCM(256) Mac=AEAD
              0x00,0xAB - DHE-PSK-AES256-GCM-SHA384 TLSv1.2 Kx=DHEPSK   Au=PSK  Enc=AESGCM(256) Mac=AEAD
              0xCC,0xAE - RSA-PSK-CHACHA20-POLY1305 TLSv1.2 Kx=RSAPSK   Au=RSA  Enc=CHACHA20/POLY1305(256) Mac=AEAD
              0xCC,0xAD - DHE-PSK-CHACHA20-POLY1305 TLSv1.2 Kx=DHEPSK   Au=PSK  Enc=CHACHA20/POLY1305(256) Mac=AEAD
              0xCC,0xAC - ECDHE-PSK-CHACHA20-POLY1305 TLSv1.2 Kx=ECDHEPSK Au=PSK  Enc=CHACHA20/POLY1305(256) Mac=AEAD
              0xC0,0xAB - DHE-PSK-AES256-CCM8     TLSv1.2 Kx=DHEPSK   Au=PSK  Enc=AESCCM8(256) Mac=AEAD
              0xC0,0xA7 - DHE-PSK-AES256-CCM      TLSv1.2 Kx=DHEPSK   Au=PSK  Enc=AESCCM(256) Mac=AEAD
              0x00,0x9D - AES256-GCM-SHA384       TLSv1.2 Kx=RSA      Au=RSA  Enc=AESGCM(256) Mac=AEAD
              0xC0,0xA1 - AES256-CCM8             TLSv1.2 Kx=RSA      Au=RSA  Enc=AESCCM8(256) Mac=AEAD
              0xC0,0x9D - AES256-CCM              TLSv1.2 Kx=RSA      Au=RSA  Enc=AESCCM(256) Mac=AEAD
              0x00,0xA9 - PSK-AES256-GCM-SHA384   TLSv1.2 Kx=PSK      Au=PSK  Enc=AESGCM(256) Mac=AEAD
              0xCC,0xAB - PSK-CHACHA20-POLY1305   TLSv1.2 Kx=PSK      Au=PSK  Enc=CHACHA20/POLY1305(256) Mac=AEAD
              0xC0,0xA9 - PSK-AES256-CCM8         TLSv1.2 Kx=PSK      Au=PSK  Enc=AESCCM8(256) Mac=AEAD
              0xC0,0xA5 - PSK-AES256-CCM          TLSv1.2 Kx=PSK      Au=PSK  Enc=AESCCM(256) Mac=AEAD
              0x00,0xAC - RSA-PSK-AES128-GCM-SHA256 TLSv1.2 Kx=RSAPSK   Au=RSA  Enc=AESGCM(128) Mac=AEAD
              0x00,0xAA - DHE-PSK-AES128-GCM-SHA256 TLSv1.2 Kx=DHEPSK   Au=PSK  Enc=AESGCM(128) Mac=AEAD
              0xC0,0xAA - DHE-PSK-AES128-CCM8     TLSv1.2 Kx=DHEPSK   Au=PSK  Enc=AESCCM8(128) Mac=AEAD
              0xC0,0xA6 - DHE-PSK-AES128-CCM      TLSv1.2 Kx=DHEPSK   Au=PSK  Enc=AESCCM(128) Mac=AEAD
              0x00,0x9C - AES128-GCM-SHA256       TLSv1.2 Kx=RSA      Au=RSA  Enc=AESGCM(128) Mac=AEAD
              0xC0,0xA0 - AES128-CCM8             TLSv1.2 Kx=RSA      Au=RSA  Enc=AESCCM8(128) Mac=AEAD
              0xC0,0x9C - AES128-CCM              TLSv1.2 Kx=RSA      Au=RSA  Enc=AESCCM(128) Mac=AEAD
              0x00,0xA8 - PSK-AES128-GCM-SHA256   TLSv1.2 Kx=PSK      Au=PSK  Enc=AESGCM(128) Mac=AEAD
              0xC0,0xA8 - PSK-AES128-CCM8         TLSv1.2 Kx=PSK      Au=PSK  Enc=AESCCM8(128) Mac=AEAD
              0xC0,0xA4 - PSK-AES128-CCM          TLSv1.2 Kx=PSK      Au=PSK  Enc=AESCCM(128) Mac=AEAD
              0x13,0x02 - TLS13-AES-256-GCM-SHA384 TLSv1.3 Kx=any      Au=any  Enc=AESGCM(256) Mac=AEAD
              0x13,0x03 - TLS13-CHACHA20-POLY1305-SHA256 TLSv1.3 Kx=any      Au=any  Enc=CHACHA20/POLY1305(256) Mac=AEAD
              0x13,0x01 - TLS13-AES-128-GCM-SHA256 TLSv1.3 Kx=any      Au=any  Enc=AESGCM(128) Mac=AEAD
              0x13,0x05 - TLS13-AES-128-CCM-8-SHA256 TLSv1.3 Kx=any      Au=any  Enc=AESCCM8(128) Mac=AEAD
              0x13,0x04 - TLS13-AES-128-CCM-SHA256 TLSv1.3 Kx=any      Au=any  Enc=AESCCM(128) Mac=AEAD
              0x00,0x3D - AES256-SHA256           TLSv1.2 Kx=RSA      Au=RSA  Enc=AES(256)  Mac=SHA256
              0x00,0xC0 - CAMELLIA256-SHA256      TLSv1.2 Kx=RSA      Au=RSA  Enc=Camellia(256) Mac=SHA256
              0x00,0x3C - AES128-SHA256           TLSv1.2 Kx=RSA      Au=RSA  Enc=AES(128)  Mac=SHA256
              0x00,0xBA - CAMELLIA128-SHA256      TLSv1.2 Kx=RSA      Au=RSA  Enc=Camellia(128) Mac=SHA256
              0xC0,0x38 - ECDHE-PSK-AES256-CBC-SHA384 TLSv1 Kx=ECDHEPSK Au=PSK  Enc=AES(256)  Mac=SHA384
              0xC0,0x36 - ECDHE-PSK-AES256-CBC-SHA SSLv3 Kx=ECDHEPSK Au=PSK  Enc=AES(256)  Mac=SHA1
              0xC0,0x22 - SRP-DSS-AES-256-CBC-SHA SSLv3 Kx=SRP      Au=DSS  Enc=AES(256)  Mac=SHA1
              0xC0,0x21 - SRP-RSA-AES-256-CBC-SHA SSLv3 Kx=SRP      Au=RSA  Enc=AES(256)  Mac=SHA1
              0xC0,0x20 - SRP-AES-256-CBC-SHA     SSLv3 Kx=SRP      Au=SRP  Enc=AES(256)  Mac=SHA1
              0x00,0xB7 - RSA-PSK-AES256-CBC-SHA384 TLSv1 Kx=RSAPSK   Au=RSA  Enc=AES(256)  Mac=SHA384
              0x00,0xB3 - DHE-PSK-AES256-CBC-SHA384 TLSv1 Kx=DHEPSK   Au=PSK  Enc=AES(256)  Mac=SHA384
              0x00,0x95 - RSA-PSK-AES256-CBC-SHA  SSLv3 Kx=RSAPSK   Au=RSA  Enc=AES(256)  Mac=SHA1
              0x00,0x91 - DHE-PSK-AES256-CBC-SHA  SSLv3 Kx=DHEPSK   Au=PSK  Enc=AES(256)  Mac=SHA1
              0xC0,0x9B - ECDHE-PSK-CAMELLIA256-SHA384 TLSv1 Kx=ECDHEPSK Au=PSK  Enc=Camellia(256) Mac=SHA384
              0xC0,0x99 - RSA-PSK-CAMELLIA256-SHA384 TLSv1 Kx=RSAPSK   Au=RSA  Enc=Camellia(256) Mac=SHA384
              0xC0,0x97 - DHE-PSK-CAMELLIA256-SHA384 TLSv1 Kx=DHEPSK   Au=PSK  Enc=Camellia(256) Mac=SHA384
              0x00,0x35 - AES256-SHA              SSLv3 Kx=RSA      Au=RSA  Enc=AES(256)  Mac=SHA1
              0x00,0x84 - CAMELLIA256-SHA         SSLv3 Kx=RSA      Au=RSA  Enc=Camellia(256) Mac=SHA1
              0x00,0xAF - PSK-AES256-CBC-SHA384   TLSv1 Kx=PSK      Au=PSK  Enc=AES(256)  Mac=SHA384
              0x00,0x8D - PSK-AES256-CBC-SHA      SSLv3 Kx=PSK      Au=PSK  Enc=AES(256)  Mac=SHA1
              0xC0,0x95 - PSK-CAMELLIA256-SHA384  TLSv1 Kx=PSK      Au=PSK  Enc=Camellia(256) Mac=SHA384
              0xC0,0x37 - ECDHE-PSK-AES128-CBC-SHA256 TLSv1 Kx=ECDHEPSK Au=PSK  Enc=AES(128)  Mac=SHA256
              0xC0,0x35 - ECDHE-PSK-AES128-CBC-SHA SSLv3 Kx=ECDHEPSK Au=PSK  Enc=AES(128)  Mac=SHA1
              0xC0,0x1F - SRP-DSS-AES-128-CBC-SHA SSLv3 Kx=SRP      Au=DSS  Enc=AES(128)  Mac=SHA1
              0xC0,0x1E - SRP-RSA-AES-128-CBC-SHA SSLv3 Kx=SRP      Au=RSA  Enc=AES(128)  Mac=SHA1
              0xC0,0x1D - SRP-AES-128-CBC-SHA     SSLv3 Kx=SRP      Au=SRP  Enc=AES(128)  Mac=SHA1
              0x00,0xB6 - RSA-PSK-AES128-CBC-SHA256 TLSv1 Kx=RSAPSK   Au=RSA  Enc=AES(128)  Mac=SHA256
              0x00,0xB2 - DHE-PSK-AES128-CBC-SHA256 TLSv1 Kx=DHEPSK   Au=PSK  Enc=AES(128)  Mac=SHA256
              0x00,0x94 - RSA-PSK-AES128-CBC-SHA  SSLv3 Kx=RSAPSK   Au=RSA  Enc=AES(128)  Mac=SHA1
              0x00,0x90 - DHE-PSK-AES128-CBC-SHA  SSLv3 Kx=DHEPSK   Au=PSK  Enc=AES(128)  Mac=SHA1
              0xC0,0x9A - ECDHE-PSK-CAMELLIA128-SHA256 TLSv1 Kx=ECDHEPSK Au=PSK  Enc=Camellia(128) Mac=SHA256
              0xC0,0x98 - RSA-PSK-CAMELLIA128-SHA256 TLSv1 Kx=RSAPSK   Au=RSA  Enc=Camellia(128) Mac=SHA256
              0xC0,0x96 - DHE-PSK-CAMELLIA128-SHA256 TLSv1 Kx=DHEPSK   Au=PSK  Enc=Camellia(128) Mac=SHA256
              0x00,0x2F - AES128-SHA              SSLv3 Kx=RSA      Au=RSA  Enc=AES(128)  Mac=SHA1
              0x00,0x96 - SEED-SHA                SSLv3 Kx=RSA      Au=RSA  Enc=SEED(128) Mac=SHA1
              0x00,0x41 - CAMELLIA128-SHA         SSLv3 Kx=RSA      Au=RSA  Enc=Camellia(128) Mac=SHA1
              0x00,0x07 - IDEA-CBC-SHA            SSLv3 Kx=RSA      Au=RSA  Enc=IDEA(128) Mac=SHA1
              0x00,0xAE - PSK-AES128-CBC-SHA256   TLSv1 Kx=PSK      Au=PSK  Enc=AES(128)  Mac=SHA256
              0x00,0x8C - PSK-AES128-CBC-SHA      SSLv3 Kx=PSK      Au=PSK  Enc=AES(128)  Mac=SHA1
              0xC0,0x94 - PSK-CAMELLIA128-SHA256  TLSv1 Kx=PSK      Au=PSK  Enc=Camellia(128) Mac=SHA256
              0xC0,0x06 - ECDHE-ECDSA-NULL-SHA    SSLv3 Kx=ECDH     Au=ECDSA Enc=None      Mac=SHA1
              0xC0,0x10 - ECDHE-RSA-NULL-SHA      SSLv3 Kx=ECDH     Au=RSA  Enc=None      Mac=SHA1
              0xC0,0x15 - AECDH-NULL-SHA          SSLv3 Kx=ECDH     Au=None Enc=None      Mac=SHA1
              0x00,0x3B - NULL-SHA256             TLSv1.2 Kx=RSA      Au=RSA  Enc=None      Mac=SHA256
              0xC0,0x3B - ECDHE-PSK-NULL-SHA384   TLSv1 Kx=ECDHEPSK Au=PSK  Enc=None      Mac=SHA384
              0xC0,0x3A - ECDHE-PSK-NULL-SHA256   TLSv1 Kx=ECDHEPSK Au=PSK  Enc=None      Mac=SHA256
              0xC0,0x39 - ECDHE-PSK-NULL-SHA      SSLv3 Kx=ECDHEPSK Au=PSK  Enc=None      Mac=SHA1
              0x00,0xB9 - RSA-PSK-NULL-SHA384     TLSv1 Kx=RSAPSK   Au=RSA  Enc=None      Mac=SHA384
              0x00,0xB8 - RSA-PSK-NULL-SHA256     TLSv1 Kx=RSAPSK   Au=RSA  Enc=None      Mac=SHA256
              0x00,0xB5 - DHE-PSK-NULL-SHA384     TLSv1 Kx=DHEPSK   Au=PSK  Enc=None      Mac=SHA384
              0x00,0xB4 - DHE-PSK-NULL-SHA256     TLSv1 Kx=DHEPSK   Au=PSK  Enc=None      Mac=SHA256
              0x00,0x2E - RSA-PSK-NULL-SHA        SSLv3 Kx=RSAPSK   Au=RSA  Enc=None      Mac=SHA1
              0x00,0x2D - DHE-PSK-NULL-SHA        SSLv3 Kx=DHEPSK   Au=PSK  Enc=None      Mac=SHA1
              0x00,0x02 - NULL-SHA                SSLv3 Kx=RSA      Au=RSA  Enc=None      Mac=SHA1
              0x00,0x01 - NULL-MD5                SSLv3 Kx=RSA      Au=RSA  Enc=None      Mac=MD5 
              0x00,0xB1 - PSK-NULL-SHA384         TLSv1 Kx=PSK      Au=PSK  Enc=None      Mac=SHA384
              0x00,0xB0 - PSK-NULL-SHA256         TLSv1 Kx=PSK      Au=PSK  Enc=None      Mac=SHA256
              0x00,0x2C - PSK-NULL-SHA            SSLv3 Kx=PSK      Au=PSK  Enc=None      Mac=SHA1

OpenSSL 1.1.1 dev TLS v1.3 draft-18 specific

    /usr/local/http2-15/bin/openssl ciphers -V "ALL:COMPLEMENTOFALL" | grep TLS13
              0x13,0x02 - TLS13-AES-256-GCM-SHA384 TLSv1.3 Kx=any      Au=any  Enc=AESGCM(256) Mac=AEAD
              0x13,0x03 - TLS13-CHACHA20-POLY1305-SHA256 TLSv1.3 Kx=any      Au=any  Enc=CHACHA20/POLY1305(256) Mac=AEAD
              0x13,0x01 - TLS13-AES-128-GCM-SHA256 TLSv1.3 Kx=any      Au=any  Enc=AESGCM(128) Mac=AEAD
              0x13,0x05 - TLS13-AES-128-CCM-8-SHA256 TLSv1.3 Kx=any      Au=any  Enc=AESCCM8(128) Mac=AEAD
              0x13,0x04 - TLS13-AES-128-CCM-SHA256 TLSv1.3 Kx=any      Au=any  Enc=AESCCM(128) Mac=AEAD