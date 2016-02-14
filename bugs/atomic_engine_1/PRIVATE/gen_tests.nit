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
	var cols = 7.rand
	var rows = 7.rand
	s.add("R {1000.rand} {cols} {rows}")
	for i in [0..cols[ do
		for j in [0..rows[ do
			var r = 100.rand
			if r < 40 then
				s.add("U {20.rand} {i} {j}")
			else if r < 60 then
				s.add("C {10.rand} {i} {j}")
			else if r < 70 then
				s.add("O {20.rand} {i} {j}")
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
	sys.system("java -cp bin/ sim.Simulator < {dir}/{prefix}{i}.in > {dir}/{prefix}{i}.res")
end
