# Copyright 2015 Alexandre Terrasa <alexandre@moz-code.org>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import json

fun gen: JsonObject do
	var json = new JsonObject
	json["max_z"] = 20.rand
	var vents = new JsonArray
	for i in [0..20.rand[ do
		var v = new JsonObject
		v["name"] = "airvent_{i}"
		v["z"] = 5.rand + 1
		v["o2"] = 10.rand + 1
		vents.add v
	end
	json["airvents"] = vents
	return json
end

if args.length != 4 then
	print "usage:\n"
	print "gen_tests dir prefix from to"
	exit 1
end

var dir = args[0]
var prefix = args[1]
var from = args[2].to_i
var to = args[3].to_i

dir.mkdir

for i in [from .. to] do
	gen.to_pretty_json.write_to_file(dir / "{prefix}{i}.in")
	sys.system("node src/airvents.js {dir}/{prefix}{i}.in > {dir}/{prefix}{i}.res")
end
