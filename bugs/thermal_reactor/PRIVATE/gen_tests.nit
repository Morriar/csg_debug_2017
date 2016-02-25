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

# Use this tool to generate tests for the Thermal Generator 1 challenge.
#
# Usage:
#	gen_tests dir/ prefix from to
#
# Example:
#	gen_tests tests/ test 11 50

import template

class ThermalProbe
	var name: String
	var level: Int

	fun is_deployed: Bool do return level >= 0
	redef fun to_s do return name
end

class ThermalConfiguration
	var probes = new Array[ThermalProbe]

	fun render_input: Template do
		var res = new Template

		var max_level = 0

		res.add " "
		for i in [0 .. probes.length[ do
			var probe = probes[i]
			res.add " "
			res.add probe.to_s
			if probe.level > max_level then
				max_level = probe.level
			end
		end
		res.add "\n"
		for i in [0 .. max_level] do
			res.add i.to_s
			for j in [0 .. probes.length[ do
				var probe = probes[j]
				if probe.level == i then
					res.add " x"
				else
					res.add "  "
				end
			end
			res.add "\n"
		end
		return res
	end

	fun render_output: Template do
		var res = new Template

		var max_level = 0
		res.add "Probes configuration after request:\n"
		res.add " "
		for i in [0 .. probes.length[ do
			var probe = probes[i]
			res.add " "
			res.add probe.to_s
			if probe.level > max_level then
				max_level = probe.level
			end
		end
		res.add "\n"
		for i in [0 .. max_level] do
			res.add i.to_s
			for j in [0 .. probes.length[ do
				var probe = probes[j]
				if probe.level == i then
					res.add " *"
				else if probe.level > i then
					res.add " |"
				else
					res.add "  "
				end
			end
			res.add "\n"
		end
		return res
	end
end

if args.length != 4 then
	print "usage:\n"
	print "gen_test dir prefix from to"
	exit 1
end

var dir = args[0]
var prefix = args[1]
var from = args[2].to_i
var to = args[3].to_i

dir.mkdir
for i in [from .. to] do
	var config = new ThermalConfiguration
	for c in ['A'..'Z'] do
		if [0..100].rand > 50 then continue
		config.probes.add new ThermalProbe(c.to_s, [0..9].rand)
	end
	config.render_input.write_to_file(dir / "{prefix}{i}.in")
	config.render_output.write_to_file(dir / "{prefix}{i}.res")
end
