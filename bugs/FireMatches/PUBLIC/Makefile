#                 UQAM ON STRIKE PUBLIC LICENSE
#                   Version 2, December 2004
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
# 				  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
# 
#  0. You just do what the fuck you want to as long as you're on strike.
# 
# aHR0cDovL2NzZ2FtZXMub3JnLzIwMTYvCg==

compile:
	mkdir -p bin/
	javac -d bin/ src/firematches/Main.java \
		src/firematches/profiles/GPSLocation.java \
		src/firematches/profiles/ProfileBase.java \
		src/firematches/profiles/Profile.java \
		src/firematches/requests/CriteriaAge.java \
		src/firematches/requests/CriteriaBool.java \
		src/firematches/requests/CriteriaDist.java \
		src/firematches/requests/Criteria.java \
		src/firematches/requests/CriteriaMood.java \
		src/firematches/requests/CriteriaRadius.java \
		src/firematches/requests/CriteriaSex.java \
		src/firematches/requests/Match.java \
		src/firematches/requests/Request.java \
		src/firematches/profiles/exceptions/LocationFormatException.java \
		src/firematches/profiles/exceptions/ProfileFormatException.java \
		src/firematches/requests/exceptions/CriteriaFormatException.java \
		src/firematches/requests/exceptions/RequestFormatException.java

check:
	./tests.sh

clean:
	rm -rf bin/ out/
