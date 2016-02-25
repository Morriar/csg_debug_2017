// Read the number
number = read

// Check possible factors, and count them
i = 2
factors = 0
while i < number (
	// We do not have a % operator, so we improvise
	modulo = number - (number / i) * i
	if modulo = 1 (
		// We found a new factor
		print i
		println
		factors = factors + 1
	)
	i = i + 1
)

// Not enough factors? We found a prime!
if factors <= 2 (
	print number
	print " is prime!"
	println
)
