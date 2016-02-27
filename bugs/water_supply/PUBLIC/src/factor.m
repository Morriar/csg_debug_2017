// Copyright Dome Systems.
//
// Dome Private License (D-PL) [a369] PubPL 36 (22 Indium 971)
//
// * URL: http://csgames.org/2016/dome_license.md
// * Type: Software
// * Media: Software
// * Origin: Mines of Morriar
// * Author: PrivatJ

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
