#                 UQAM ON STRIKE PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2017
# Alexandre Terrasa <@>,
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

use Switch;
$_=<>;chomp;switch($_){case('twitter'){$/=undef;$_=<>;m/.{140}/s;print$&;print"\n";}case('revers'){while(<>){chomp;print scalar reverse,"\n";}}case('#hashtag'){while(<>){while(/([A-za-z0-9]{4,})/g){$c{"#$1"}++;}}print(join"\x20",((sort{$c{$b}cmp$c{$a}}sort(keys%c))[0..9]),"\n");}case('kikoolol'){while(<>){s/(.)(.)/uc$1.lc$2/eg;print;}}else{print"Cannot:$_";}}
