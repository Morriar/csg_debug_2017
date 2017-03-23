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

class RunLengthEncoder < Encoder
	# Encodes a "bitstream" (String of 1s and 0s)
	# Compresses the string using run length encoding
	#
	# This method actually works on several linebreak-separated
	# bitstreams.
	def encode(data)
		res = []
		z = 0
		data.split('\n').each do |line|
			# Separate sequences of 0 and 1 by splitting them.
			# data are 1 and nothingness are 0.
			# Uses ruby's partial perl compatibility on string manips!
			oness = line.split("0")
			oness.each do |ones|
				# two cases:
				# * there is something, it's a sequence of 1
				# * there is nothing, it's the continuation of a sequence of 0
				o = ones.length
				if o == 0
					z += 1
				elsif z == 0 && !res.empty?
					res[-1] += o
					z = 1
				else
					res << z << o
					z = 1
				end
			end
			z -= 1
		end
		res << z if z != 0
	end

	def decode(data)
		(0...data.size).reduce("") { |d, i| i.even? ? d << "0" * data[i] : d << "1" * data[i] }
	end
end

class BitStreamEncoder < Encoder
	def encode(data)
		out = ""
		first = true
		data.each_line do |line|
			out << "\n" if not first
			out << line.each_byte.map { |b| b.to_s(2) }.join
			first = false
		end
	end

	def decode(data)
		data.scan(/[01]{1,8}/).map { |x| x.to_i(2).chr }.join
	end
end

class Encoder

	@abstract
	def encode
		# Do implement this
	end

	@abstract
	def decode
		# Do implement this
	end
end
