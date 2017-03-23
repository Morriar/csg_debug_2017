#!/bin/bash

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

