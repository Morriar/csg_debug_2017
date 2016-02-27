# Copyright Dome Systems.
#
# Dome Private License (D-PL) [a369] PubPL 36 (14 Indium 495)
#
# * URL: http://csgames.org/2016/dome_license.md
# * Type: Software
# * Media: Software
# * Origin: Mines of Morriar
# * Author: Calibri de la Morriar

# Defines the grid logic.
module z_logic

import z_grid

redef class ZGrid
	# List all output nodes in the grid.
	fun output_nodes: Set[ZOutputNode] do
		var res = new HashSet[ZOutputNode]
		for id, node in nodes do
			if node isa ZOutputNode and not node isa ZTransmitter then res.add node
		end
		return res
	end

	# List all input nodes in the grid.
	fun input_nodes: Set[ZInputNode] do
		var res = new HashSet[ZInputNode]
		for id, node in nodes do
			if node isa ZInputNode and not node isa ZTransmitter then res.add node
		end
		return res
	end

	# List all transmitters in the grid.
	fun transmitters: Set[ZTransmitter] do
		var res = new HashSet[ZTransmitter]
		for id, node in nodes do
			if node isa ZTransmitter then res.add node
		end
		return res
	end
end

redef class ZNode
	# Check z input/output for node.
	fun check: Bool is abstract
end

redef class ZOutputNode
	# Compute the z output for `self`.
	fun compute_output: Int do return z_output

	redef fun check do return compute_output > 0
end

redef class ZInputNode
	# Compute power input for `self`.
	fun compute_input: Int do
		var z_in = 0
		for id, node in ins do
			z_in += node.compute_output
		end
		return z_in
	end

	redef fun check do return compute_input == z_input
end

redef class ZTransmitter
	redef fun compute_output do
		var z_in = compute_input
		if z_in > z_input then
			return 0
		end
		if z_in > z_output then
			return z_output
		end
		return z_in
	end

	redef fun check do return compute_input <= z_input
end
