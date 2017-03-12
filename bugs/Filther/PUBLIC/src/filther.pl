use Switch;
$_=<>;chomp;switch($_){case('twitter'){$/=undef;$_=<>;m/.{140}/s;print$&;}case('revers'){while(<>){print scalar reverse;}}case('#hashtag'){while(<>){while(/([A-za-z0-9]{4,})/g){$c{"#$1"}++;}}print(join"\x20",((sort{$c{$b}cmp$c{$a}}sort(keys%c))[0..9]),"\n");}case('kikoolol'){while(<>){s/(.)(.)/uc$1.lc$2/eg;print;}}else{print"Cannot:$_";}}
