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

# Found a nice tutorial about control flow in Nit on the official website.
# It was hidden in the Language Reference section.
#
# I also found lots of examples on the github repo! Such Helpful! Much Nit!
if args.is_empty do
	print "Error: expected one argument <name>!"
	exit 1
end
print "Hello {args[1]}!"
