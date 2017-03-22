require 'socket'
require 'optparse'
require_relative 'utils'

# This challenge is ran with arguments (see tests/testX.args for argument lists)
options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: server.rb [OPTIONS]"

	opts.on("-b", "--binary", "Encode data stream to binary") do |v|
		options[:binary] = v
	end

	opts.on("-r", "--runlength", "Encode data stream to binary and run-length encode") do |v|
		options[:runlength] = v
	end
end.parse!

data = STDIN.read

if options[:binary] || options[:runlength]
	enc = BitStreamEncoder.new
	data = enc.encode data
end

if options[:runlength]
	enc = RunLengthEncoder.new
	data = enc.encode data
end

# Open a socket and wait for a friend.
server = UNIXServer.open('./solo.sock')

loop {
	client = server.accept
	client.puts data
	client.close
}
