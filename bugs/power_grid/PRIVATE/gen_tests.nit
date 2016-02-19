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

# Use this tool to deploy teams infrastructures from a json list.
#
# usage:
#	gen_test dir test_prefix from_count to_count

fun gen: Array[String] do
	var s = new Array[String]
	s.add "nodes"

	# Gen output sources
	var outs = new Array[Int]
	var max = 5.rand + 1
	for i in [1..max] do
		outs.add i
		s.add("\tO o{i} AtomicEngine {200.rand}")
	end

	# Gen transmitters
	var ts = new Array[Int]
	max = 5.rand + 1
	for i in [1..max] do
		ts.add i
		s.add("\tT t{i} Trasnmitter {200.rand} {100.rand}")
	end

	# Gen input sources
	var ins = new Array[Int]
	max = 5.rand + 1
	for i in [1..max] do
		ins.add i
		s.add("\tI i{i} Airvents {100.rand}")
	end

	s.add "links"
	for i in outs do
		if 100.rand > 70 then
			s.add "\to{i} --> i{ins.length.rand + 1}"
		else
			s.add "\to{i} --> t{ts.length.rand + 1}"
		end
	end
	for i in ts do
		max = 5.rand + 1
		for j in [1..max] do
			if 100.rand > 70 then
				s.add "\tt{i} --> i{ins.length.rand + 1}"
			else
				var o = ts.length.rand + 1
				if o != i then s.add "\tt{i} --> t{o}"
			end
		end
	end
	return s
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
	gen.join("\n").write_to_file(dir / "{prefix}{i}.in")
	sys.system("bin/z_status {dir}/{prefix}{i}.in > {dir}/{prefix}{i}.res")
end
