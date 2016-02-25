number = read
i = 1
factors = 0
while i <= number (
	// we do not have a % operator, so we improvise
	modulo = number - (number / i) * i
	if modulo = 0 (
		print i
		println
		factors = factors + 1
	)
	i = i + 1
)
if factors = 2 (
	print number
	print " is prime!"
	println
)
