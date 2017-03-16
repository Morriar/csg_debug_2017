#!/bin/bash

ruby server.rb < in.txt &
sleep 1
ruby client.rb
kill $!
