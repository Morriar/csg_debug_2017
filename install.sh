#!/bin/bash

bfore= pwd

apt-get install build-essential ccache libgc-dev graphviz libunwind-dev pkg-config

apt-get install -y mongodb
apt-get install -y nodejs
apt-get install -y npm
apt-get install -y openjdk-7-jdk
apt-get install -y lua5.2
apt-get install -y gcc
apt-get install -y golang
apt-get install -y mono-runtime
apt-get install -y mono-dmcs
apt-get install -y ghc

# update node js
cp /usr/bin/nodejs /user/bin/node
npm cache clean -f
npm install -g n
n stable

# install nit
bfore= pwd
cd ~/
git clone http://nitlanguage.org/nit.git
cd nit
make
source misc/nit_env.sh
cd $bfore

# install node deps
cd src
npm install
cd ..
