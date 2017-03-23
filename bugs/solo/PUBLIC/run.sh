#!/bin/bash

#                 UQAM ON STRIKE PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2017
# Alexandre Terrasa <@>,
# Jean Privat <@>,
# Philippe Pepos Petitclerc <@>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#                 UQAM ON STRIKE PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just do what the fuck you want to as long as you're on strike.
#
# aHR0cDovL2NzZ2FtZXMub3JnLzIwMTYvCg==

while [[ $# -gt 1 ]]
do
	key="$1"

	case $key in
		-p|--plain)
		options=""
		shift
		;;
		-b|--binary)
		options="-b"
		shift
		;;
		-r|--runlength)
		options="-r"
		shift
		;;
		*)
		options=""
		shift
		;;
	esac
done

in_file=$1

if [ -e solo.sock ]
then
	rm solo.sock
fi

ruby src/server.rb $options < "$in_file" &
server_pid=$!

while [ ! -e solo.sock ]
do
	sleep 1
done

ruby src/client.rb $options

kill $server_pid > /dev/null 2>&1
if [ -e solo.sock ]
then
	rm solo.sock
fi

