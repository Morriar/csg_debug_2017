# Copyright 2017 Alexandre Terrasa <alexandre@moz-code.org>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
