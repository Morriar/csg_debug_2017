# Copyright Dome Systems.
#
# Dome Private License (D-PL) [a369] PubPL 36 (14 Indium 495)
#
# * URL: http://csgames.org/2016/dome_license.md
# * Type: Software
# * Media: Software
# * Origin: Mines of Morriar
# * Author: Calibri de la Morriar

# Define the main power grid elements.
#
#
# The grid is represented as a graph.
module z_grid

# A Grid contains power nodes.
class ZGrid

	# Nodes contained in the grid.
	var nodes = new HashMap[String, ZNode]

	# Add a node to the grid.
	fun add_node(node: ZNode) do nodes[node.id] = node
end

# An power node that goes in a ZGRid.
abstract class ZNode

	# Node uniq id.
	var id: String

	redef fun to_s do return "\{{id}\}"
end

# Node that produces power.
class ZOutputNode
	super ZNode

	# Power output (in `z` units).
	var z_output: Int

	# Out links (to input nodes).
	var outs = new HashMap[String, ZInputNode]

	# Create a link from self to an input node.
	fun add_output(to: ZInputNode) do outs[to.id] = to

	redef fun to_s do return "\{{id} O: {z_output}\}"
end

# Node that consumes power.
class ZInputNode
	super ZNode

	# Power input needed (in `z` units).
	var z_input: Int

	# Incomming links from output nodes.
	var ins = new HashMap[String, ZOutputNode]

	# Create a link to self from an output node.
	fun add_input(to: ZOutputNode) do ins[to.id] = to

	redef fun to_s do return "\{{id} I: {z_input}\}"
end

# Node that conducts power.
#
# ZTransmitter act as both input and output nodes.
class ZTransmitter
	super ZOutputNode
	super ZInputNode
	autoinit id=, z_input=, z_output=

	redef fun to_s do return "\{{id} I: {z_input}, O: {z_output}\}"
end
