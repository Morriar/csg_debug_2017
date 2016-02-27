# Copyright Dome Systems.
#
# Dome Private License (D-PL) [a369] PubPL 36 (14 Indium 495)
#
# * URL: http://csgames.org/2016/dome_license.md
# * Type: Software
# * Media: Software
# * Origin: Mines of Morriar
# * Author: Calibri de la Morriar

# Parsing services.
#
# Build a grid from a bucnh of strings.
module z_parse

import z_grid

redef class ZGrid
	# Read file content as a string.
	init from_file(file: String) do
		if not file.file_exists then
			print "Error: file `{file}` not found."
			exit 1
		end
		with fr = new FileReader.open(file) do
			var in_nodes = false
			var in_links = false
			for line in fr.read_lines do
				if line.is_empty then continue
				if line == "nodes" then
					in_nodes = true
					in_links = false
					continue
				end
				if line == "links" then
					in_nodes = true
					in_links = false
					continue
				end
				if in_nodes then
					add_node new ZNode.from_string(line.trim)
				else if in_links then
					parse_link(line.trim)
				end
			end
		end
	end

	# Parse a link line.
	#
	# Expected something like:
	#	T1 --> T2
	private fun parse_link(str: String) do
		link_from_parts(str.split_with(" "))
	end

	# Init a link from a pre-split string.
	private fun link_from_parts(parts: Array[String]) do
		if parts.length != 3 or parts[1] != "-->" then
			print "Error: bad format for link `{parts.join(" ")}`."
		end
		var from = nodes.get_or_null(parts[0])
		var to = nodes.get_or_null(parts[2])
		if not from isa ZOutputNode or not to isa ZInputNode then
			print "Error: can't create link for nodes `{parts[0]}` and `{parts[2]}`."
			exit 1
			abort
		end
		from.add_output(to)
		to.add_input(from)
	end
end

redef class ZNode
	# ZNode factory from a node string representation.
	#
	# Expected something like:
	#	O O1 AtomicEngine 50
	private new from_string(str: String) do
		var parts = str.split_with(" ")
		if parts.is_empty then
			print "Error: cannot parse empty node line."
			exit 1
		end
		var kind = parts.first
		if kind == "O" then
			return new ZOutputNode.from_parts(parts)
		else if kind == "I" then
			return new ZInputNode.from_parts(parts)
		else if kind == "T" then
			return new ZTransmitter.from_parts(parts)
		else
			print "Error: unkown node kind `{kind}`."
			exit 1
		end
		abort
	end
end

redef class ZInputNode
	# Init `self` from a pre-split string.
	private init from_parts(parts: Array[String]) do
		if parts.length != 4 then
			print "Error: bad format for node `{parts.join(" ")}`."
		end
		init(parts[1], parts[3].to_i)
	end
end

redef class ZOutputNode
	# Init `self` from a pre-split string.
	private init from_parts(parts: Array[String]) do
		if parts.length != 4 then
			print "Error: bad format for node `{parts.join(" ")}`."
		end
		init(parts[1], parts[3].to_i)
	end
end

redef class ZTransmitter
	# Init `self` from a pre-split string.
	private init from_parts(parts: Array[String]) do
		if parts.length != 5 then
			print "Error: bad format for node `{parts.join(" ")}`."
		end
		init(parts[1], parts[3].to_i, parts[4].to_i)
	end
end
