
# RLE on STDIN. Alternate 0 and 1, first slot is 0. All non-first elements are > 0
res = []
z = 0
# BUG: use '\n' instead of "\n"
STDIN.read.split("\n").each do |line|
	# Separate sequences of 0 and 1 by splitting them. data are 1 and nothingness are 0.
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

print res
print "\n"
