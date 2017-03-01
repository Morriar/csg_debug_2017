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

import ini

class ProfileGenerator

	var females_file: String
	var males_file: String
	var moods_file: String
	var out_dir: String

	var female_names = new Array[String]
	var male_names = new Array[String]
	var mood_names = new Array[String]

	init do
		female_names.add_all load_names(females_file, true)
		male_names.add_all load_names(males_file, true)
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

	fun gen_profiles(count: Int) do
		var i = 1
		while i <= count do
			gen_profile(i)
			i += 1
		end
	end

	fun gen_profile(i: Int) do
		var id = new Id(i)
		var sex = [true, false].rand
		var profile = new ConfigTree("{out_dir}/{id}.profile")
		profile["mood"] = "I feel {mood_names.rand}..."
		profile["location"] = (new GPS).to_s
		profile["age"] = [18..55].rand.to_s
		profile["sex"] = sex.to_s
		profile["name"] = if sex then male_names.rand else female_names.rand
		profile.save
	end
end

class GPS

	var precision = 5
	var lat: String is noinit
	var lon: String is noinit

	init do
		lat = gen_between([0..90])
		lon = gen_between([0..180])
	end

	fun gen_between(range: Range[Int]): String do
		var float = ""
		while float.length <= precision do
			float = "{float}{[0..9].rand}"
		end
		return "{range.rand}.{float}"
	end

	redef fun to_s do return "{lat},{lon}"
end

class Id
	var id: Int

	redef fun to_s do
		var s = id.to_s
		while s.length < 5 do
			s = "0{s}"
		end
		return s
	end
end

if args.length != 4 then
	print "usage: profiles <female_names> <male_names> <mood_names> <out_dir>"
	exit 1
end

var gen = new ProfileGenerator(args[0], args[1], args[2], args[3])
gen.gen_profiles(100)
