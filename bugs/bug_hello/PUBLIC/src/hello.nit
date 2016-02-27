# Copyright Dome Systems.
#
# Dome Private License (D-PL) [a369] PubPL 36 (7 Gallium 369)
#
# * URL: http://csgames.org/2016/dome_license.md
# * Type: Software
# * Media: Software
# * Origin: Mines of Morriar
# * Author: Morriar

if args.is_empty do
	print "Error: expected one argument <name>!"
	exit 1
end
print "Hello {args[1]}!"
