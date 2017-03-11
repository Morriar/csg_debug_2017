require 'socket'
require_relative 'utils'

hostname = 'localhost'
port = 2000

s = TCPSocket.open(hostname, port)

data = ''
while line = s.gets
	data << line
end
s.close

data = data.split.map{ |x| x.to_i }

enc = RunLengthEncoder.new
data = enc.decode data
enc = BitStreamEncoder.new
data = enc.decode data

print data

