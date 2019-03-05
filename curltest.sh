#!/bin/bash
#######################################
# curltest br url
# curltest gzip url
#######################################
set -e

bytesToHuman() {
    b=${1:-0}; d=''; s=0; S=(Bytes {K,M,G,T,E,P,Y,Z}iB)
    while ((b > 1024)); do
        d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
        b=$((b / 1024))
        let s++
    done
    echo "$b$d ${S[$s]}"
}

compare() {
  echo "URI: ${2} (${1})"

  SIZE=$(/usr/local/http2-15/bin/curl -kso /dev/null "${2}" -w '%{size_download}')
  SIZE_HUMAN=$(bytesToHuman "$SIZE")
  echo "Uncompressed size : $SIZE_HUMAN"

  SIZE=$(/usr/local/http2-15/bin/curl -H "Accept-Encoding: ${1}" -kso /dev/null "${2}" -w '%{size_download}')

  SIZE_HUMAN=$(bytesToHuman "$SIZE")
  echo "Compressed size   : $SIZE_HUMAN"
}

compare $1 $2