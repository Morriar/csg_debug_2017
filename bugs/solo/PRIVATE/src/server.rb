require 'socket'
require_relative 'utils'

data = STDIN.read
enc = BitStreamEncoder.new
data = enc.encode data
enc = RunLengthEncoder.new
data = enc.encode data

# Open a socket and wait for a friend.
server = TCPServer.open(2000)

loop {
	client = server.accept
	client.puts data
	client.close
}
