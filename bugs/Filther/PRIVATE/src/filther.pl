use Switch;
$_=<>;
chomp;
switch($_){
	case('twitter'){
		$/=undef;
		$_=<>;
		# bug: 140 strict. test1: un input de moins de 140 chars
		# m/.{140}/s;
		m/.{0,140}/s;
		print$&;
		print "\n";
	}
	# bug "revers" sans e. test2: n'importe lequel
	# case('revers'){
	case('reverse'){
		while(<>){
			chomp;
			print scalar reverse,"\n";
		}
	}
	case('hashtag'){
		while(<>){
			# bug A-za-z. test3: un mot frequent avec des caracteres suivants: [ ] ^ `
			# while(/([A-za-z0-9]{4,})/g){
			while(/([A-Za-z0-9]{4,})/g){
				$c{"#$1"}++;
			}
		}
		# bug cmp au lieu de <=>: test4 un mot frequent > 10
		# print(join"\x20",((sort{$c{$b}cmp$c{$a}}sort(keys%c))[0..9]),"\n");
		print(join"\x20",((sort{$c{$b}<=>$c{$a}}sort(keys%c))[0..9]),"\n");
	}
	case('kikoolol'){
		while(<>){
			# bug manque les parentheses. test5: n'importe lequel
			#s/(.)(.)/uc$1.lc$2/eg;print;
			s/(.)(.)/(uc$1).lc$2/eg;print;
		}
	}
	else{
		print"Cannot:$_";
	}
}
