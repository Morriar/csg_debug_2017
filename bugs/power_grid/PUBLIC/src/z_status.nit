# Copyright Dome Systems.
#
# Dome Private License (D-PL) [a369] PubPL 36 (14 Indium 495)
#
# * URL: http://csgames.org/2016/dome_license.md
# * Type: Software
# * Media: Software
# * Origin: Mines of Morriar
# * Author: Calibri de la Morriar

# Check and display grid status.
module z_status

import opts

import z_logic
import z_parse
import z_cycle
import z_viz

private class ZNodeComparator
	super Comparator

	redef type COMPARED: ZNode
	redef fun compare(n1, n2) do return n1.id <=> n2.id
end

redef class ZNode
	private fun console_status: String is abstract
end

redef class ZOutputNode
	redef fun console_status do
		if check then
			return "{self}: [OK]"
		else
			return "{self}: [KO] no input"
		end
	end
end

redef class ZInputNode
	redef fun console_status do
		if check then
			return "{self}: [OK]"
		else
			return "{self}: [KO] wrong input ({self.compute_input}/{self.z_input})"
		end
	end
end

redef class ZTransmitter
	redef fun console_status do
		if check then
			return "{self}: [OK]"
		else
			return "{self}: [KO] wrong input ({self.compute_input}{self.z_input})"
		end
	end
end

var opt_show = new OptionBool("Show grid with graphviz", "--show-grid")
var ctx = new OptionContext
ctx.add_option opt_show
ctx.parse(sys.args)
var args = ctx.rest

if args.is_empty then
	print "usage:"
	print "\tz_status grid.in"
	exit 1
end

var grid = new ZGrid.from_file(sys.args.first)
var comparator = new ZNodeComparator

print "Loaded {grid.nodes.length} nodes!!!"

print "\nCheck cycles..."
if grid.has_cycle then
	print "DANGER: This grid contains cycles!"
	return
end

print "\nCheck outputs..."
var nodes: Array[ZNode] = grid.output_nodes.to_a
comparator.sort(nodes)
for node in nodes do
	print " * {node.console_status}"
end

print "\nCheck transmitters..."
nodes = grid.transmitters.to_a
comparator.sort(nodes)
for node in nodes do
	print " * {node.console_status}"
end

print "\nCheck inputs..."
nodes = grid.input_nodes.to_a
comparator.sort(nodes)
for node in nodes do
	print " * {node.console_status}"
end

if opt_show.value then
	grid.show_dot
end
