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

class RunLengthEncoder < Encoder
	# Encodes a "bitstream" (String of 1s and 0s)
	# Compresses the string using run length encoding
	#
	# This method actually works on several linebreak-separated
	# bitstreams.
	def encode(data)
		res = []
		z = 0
		# BUG: use '\n' instead of "\n"
		# Doesn<t seem to work anymore =(
		data.split("\n").each do |line|
			# Separate sequences of 0 and 1 by splitting them.
			# data are 1 and nothingness are 0.
			# Uses ruby's partial perl compatibility on string manips!
			# BUG: remove -1
			oness = line.split("0", -1)
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
		# Bug: maybe remove this line? returns nil if z == 0
		res
	end

	def decode(data)
		# Bug remove return nul
		return nil if data.empty?
		(0...data.size).reduce("") { |d, i| i.even? ? d << "0" * data[i] : d << "1" * data[i] }
	end
end

class BitStreamEncoder < Encoder
	def encode(data)
		# Bug: remove rjust
		out = ""
		data.each_line do |line|
			out << line.each_byte.map { |b| b.to_s(2).rjust(8, '0') }.join
			out << "\n"
		end
		out
	end

	def decode(data)
		data.scan(/[01]{1,8}/).map { |x| x.to_i(2).chr }.join
	end
end
