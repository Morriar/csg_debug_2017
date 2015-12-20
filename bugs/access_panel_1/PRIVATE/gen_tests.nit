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

class IDGenerator

	# Gen `count` ids (valid of invalid).
	fun gen_ids(count: Int): Array[String] do
		var list = new Array[String]
		for i in [0..count[ do
			if 100.rand > 15 then
				list.add gen_id
			else
				list.add gen_bad_id
			end
		end
		return list
	end

	private fun gen_id: String do
		var id = new Buffer
		for j in [1..4] do
			if j > 1 then id.append "-"
			for k in [1..4] do
				id.append allowed.rand.to_s
			end
		end
		return id.write_to_string
	end

	var allowed: Range[Int] = [0..9]

	private fun gen_bad_id: String do
		var allowed = bad_pattern
		var id = new Buffer
		for j in [1..4] do
			if j > 1 then id.append "-"
			for k in [1..4] do
				id.append allowed.rand
			end
		end
		return id.write_to_string
	end

	var bad_pattern: Array[String] is lazy do
		var p = new Array[String]
		for i in [0..9] do p.add i.to_s
		for c in ['a'..'z'] do p.add c.to_s
		for c in ['A'..'Z'] do p.add c.to_s
		for i in [0..1000] do p.add(([0..9].rand).to_s)
		p.add "FLAG_9879856456431231"
		return p
	end
end

class IDChecker

	fun is_well_formed(id: String): Bool do
		return id.has("[0-9]\{4\}-[0-9]\{4\}-[0-9]\{4\}-[0-9]\{4\}".to_re)
	end

	fun is_valid(id: String): Bool do
		var numbers = extract_numbers(id)
		var sum = 0
		var i = numbers.length
		var parity = i % 2
		while i > 0 do
			i -= 1
			var digit = numbers[i]
			# printn "{digit} "
			if i % 2 == parity then
				digit *= 2
				# printn "(x2) {digit}"
			end
			if digit > 9 then
				digit -= 9
				# printn "(-9) {digit}"
			end
			sum += digit
			# print ""
		end
		# print sum
		return sum % 10 == 0
	end

	private fun extract_numbers(id: String): Array[Int] do
		var numbers = new Array[Int]
		for c in id.chars do
			if c.is_digit then numbers.add c.to_i
		end
		return numbers
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

var gen = new IDGenerator
var check = new IDChecker
for i in [from .. to] do
	var n = 10.rand
	var ids = gen.gen_ids(n)
	ids.join("\n").write_to_file(dir / "{prefix}{i}.in")

	var lines = new Array[String]
	if n == 0 then
		lines.add "Error: empty list"
	end
	for id in ids do
		if check.is_well_formed(id) then
			if check.is_valid(id) then
				lines.add "{id}: valid"
			else
				lines.add "{id}: invalid"
			end
		else
			lines.add "{id}: malformed"
		end
	end
	(lines.join("\n") + "\n").write_to_file(dir / "{prefix}{i}.res")
end
