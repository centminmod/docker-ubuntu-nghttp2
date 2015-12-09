#!/bin/bash

curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer > /tmp/gvm_install
chmod +x /tmp/gvm_install
/tmp/gvm_install
source /root/.gvm/scripts/gvm
/root/.gvm/bin/gvm version
/root/.gvm/bin/gvm listall

# echo "dash dash/sh boolean false" | debconf-set-selections && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
debconf-show dash

/root/.gvm/bin/gvm install go1.4.2
/root/.gvm/bin/gvm use go1.4.2
/root/.gvm/bin/gvm install go1.5.2
/root/.gvm/bin/gvm use go1.5.2
go version
echo "[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"" >> /root/.bashrc

cd ~
mkdir -p go/{bin,pkg,src}
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$PATH:$GOPATH/bin" >> ~/.bashrc
go env

mkdir -p $GOPATH/src/github.com/summerwind
mkdir -p $GOROOT/src/github.com/summerwind
#cd $GOROOT/src/github.com/summerwind
#git clone https://github.com/summerwind/h2spec.git
cd $GOPATH/src/github.com/summerwind
git clone https://github.com/summerwind/h2spec.git
cd h2spec
go get github.com/bradfitz/http2
go build cmd/h2spec.go
ln -s h2spec /usr/bin/h2spec
echo "./h2spec --help"
echo "./h2spec -h localhost -p 8081 -t"
