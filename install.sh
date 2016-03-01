#!/bin/bash

# Copyright 2016 Alexandre Terrasa <alexandre@moz-code.org>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
apt-get install -y python2.7

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

# install firejail
git clone https://github.com/netblue30/firejail.git
cd firejail
./configure && make && sudo make install-strip
cd ..

# chmod -R 771 ~/
