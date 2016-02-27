// Copyright Dome Systems.
//
// Dome Private License (D-PL) [a369] PubPL 36 (22 Indium 971)
//
// * URL: http://csgames.org/2016/dome_license.md
// * Type: Software
// * Media: Software
// * Origin: Mines of Morriar
// * Author: PrivatJ

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
