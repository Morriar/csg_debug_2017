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

import profiles

class RequestGenerator

	var moods_file: String
	var out_dir: String

	var mood_names = new Array[String]

	init do
		mood_names.add_all load_names(moods_file, false)
	end

	fun load_names(path: String, capitalize: Bool): Array[String] do
		var fr = new FileReader.open(path)
		var res = new Array[String]
		for line in fr.read_lines do
			res.add if capitalize then line.capitalized else line
		end
		return res
	end

	fun gen_requests(count: Int) do
		var i = 1
		while i <= count do
			gen_request(i)
			i += 1
		end
	end

	fun gen_request(i: Int) do
		var age = [18..55].rand
		var req = new Buffer
		req.append "{new Id([1..100].rand)} "
		req.append "sex="
		req.append (["true", "false", "*"].rand)
		req.append "\;"
		req.append "mood={mood_names.rand}\;"
		req.append "age={age - 5}..{age + 5}\;"
		req.append "radius={new GPS}:{1000000}"
		req.write_to_file "{out_dir}/test{i}.in"
	end
end

if args.length != 2 then
	print "usage: requests <mood_names> <out_dir>"
	exit 1
end

var gen = new RequestGenerator(args[0], args[1])
gen.gen_requests(100)
