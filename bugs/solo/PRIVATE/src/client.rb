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

s = UNIXSocket.open('./solo.sock')

data = ''
while line = s.gets
	data << line
end
s.close

if options[:runlength]
	data = data.split().map { |x| x.to_i }
	enc = RunLengthEncoder.new
	data = enc.decode data
	# p data
end

if options[:binary] || options[:runlength]
	enc = BitStreamEncoder.new
	data = enc.decode data
	# p data
end

if not data.nil?
	print data
end
