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

help:
	@echo "usage:"
	@echo " * install		install all required dependencies (need sudo)"
	@echo " * check		check all bugs"
	@echo " * load-teams		load & deploy teams from teams.json and bugs.json"
	@echo " * start-scoreboard	start the scoreboard web server"
	@echo " * start-cron		start the cron & the competition"

install: install-mongodb install-nodejs install-java install-lua install-gcc install-go install-mono install-haskell install-python install-nit install-pep8term install-perl install-bash install-ruby install-firejail
	cd src && npm install

install-mongodb:
	apt-get install -y mongodb

install-nodejs:
	apt-get install -y npm
	apt-get install -y nodejs
	# update node js
	# ln -sf /usr/bin/node /usr/bin/nodejs && 
	npm cache clean -f && npm install -g n && n stable

install-java:
	apt-get install -y openjdk-8-jdk

install-lua:
	apt-get install -y lua5.2

install-gcc:
	apt-get install -y gcc

install-go:
	apt-get install -y golang

install-mono:
	apt-get install -y mono-runtime
	apt-get install -y mono-dmcs

install-haskell:
	apt-get install -y ghc

install-python:
	# apt-get install -y python2.7

install-nit:
	apt-get install -y build-essential ccache libgc-dev graphviz libunwind-dev pkg-config
	# git clone http://nitlanguage.org/nit.git && cd nit && make && source misc/nit_env.sh

install-pep8term:
	test -d pep8term || git clone https://github.com/privat/pep8term.git
	cd pep8term && git pull
	${MAKE} -C pep8term
	ln -s pep8term/pep8 /usr/bin/pep8 || echo "Already Done"
	ln -s pep8term/asem8 /usr/bin/asem8 || echo "Already Done"

install-perl:
	apt-get install -y perl libswitch-perl

install-bash:
	apt-get install -y sharutils ncompress exiftools pngcheck

install-ruby:
	apt-get install -y ruby

install-firejail:
	git clone https://github.com/netblue30/firejail.git && cd firejail && ./configure && make && make install-strip

check:
	make --no-print-directory -C bugs/ check
	make --no-print-directory -C tests/ check

init-compe:
	rm -rf DEPLOY
	./srv/delete_teams.sh teams.lst
	./srv/create_teams.sh teams.lst teams_keys
	node src/loadRounds.js
	node src/loadStatus.js
	node src/loadTeams.js teams.json
	node src/loadBugs.js bugs/
	node src/deployTeams.js bugs/ DEPLOY/ PUBLIC
	./srv/init_teams.sh teams.lst /home/debug/csg_debug/DEPLOY/

start-scoreboard:
	node src/bin/www

start-cron:
	node src/cron.js DEPLOY 35 300
