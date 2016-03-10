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

import template

fun gen_file_content: Template do
	var tpl = new Template
	# gen lines
	for l in [1..50.rand + 1[ do
		tpl.addn gen_file_line
	end
	return tpl
end

fun gen_file_line: String do
	var arr = new Array[Int]
	for i in [0..9] do
		arr.add 9.rand
	end
	return arr.join("")
end

fun gen_files do
	# gen directories
	for i in [1..50] do
		system "mkdir -p tests/test_{i}.in"
		# gen files
		for j in [1..50.rand + 1] do
			var pfile = "test_{i}_{j}"
			var tpl = gen_file_content
			tpl.write_to_file "tests/test_{i}.in/{pfile}"
			system "bin/size tests/test_{i}.in > tests/test_{i}.res"
		end
	end
end

gen_files
