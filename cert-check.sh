#!/bin/bash
export LD_LIBRARY_PATH='/usr/lib/x86_64-linux-gnu'

certcheck() {
  domain=$1
  TLSPROTOCOL_H3=$(/usr/local/src/curl/src/curl --http3 -4Iv https://$domain 2>&1 | awk '/^HTTP/ {print $1}')
  TLSPROTOCOL_H2=$(/usr/local/src/curl/src/curl --http2 -4Iv https://$domain 2>&1 | awk '/^HTTP/ {print $1}')
  TLSPROTOCOL_H1=$(/usr/local/src/curl/src/curl --http1.1 -4Iv https://$domain 2>&1 | awk '/^HTTP/ {print $1}')

  certinfo -domain $domain | jq -r '"\(.subject.common_name)|\(.serial_number)|\(.issuer.organization)|\(.not_after)|\(.sans)"' | awk -v v3=$TLSPROTOCOL_H3 -v v2=$TLSPROTOCOL_H2 -v v1=$TLSPROTOCOL_H1 '{print $0"|"v3"|"v2"|"v1}'
}

case "$1" in
  check )
    certcheck $2
    ;;
  * )
    echo "$0 domain.com"
    ;;
esac