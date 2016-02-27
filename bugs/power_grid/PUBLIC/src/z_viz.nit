# Copyright Dome Systems.
#
# Dome Private License (D-PL) [a369] PubPL 36 (14 Indium 495)
#
# * URL: http://csgames.org/2016/dome_license.md
# * Type: Software
# * Media: Software
# * Origin: Mines of Morriar
# * Author: Calibri de la Morriar

# Display grids in a dot format.
module z_viz

import z_logic

redef class ZGrid
	# Return `self` in a dot format.
	fun to_dot: String do
		var b = new Buffer
		b.append("digraph \"z_grid\" \{\n")
		b.append("rankdir=LR;")
		for id, node in nodes do
			b.append("{node.to_dot};\n")
		end
		for id, node in nodes do
			if node isa ZOutputNode then
				for oid, onode in node.outs do
					b.append("\"{id}\"->\"{oid}\";\n")
				end
			end
		end
		b.append("\}\n")
		return b.write_to_string
	end

	# Open Graphviz with `self.to_dot`.
	#
	# Mainly used for debugging.
	fun show_dot do
		var f = new ProcessWriter("dot", "-Txlib")
		f.write to_dot
		f.close
	end
end

redef class ZNode
	private fun to_dot: String do
		return "\"{id}\" [label=\"{dot_label}\", style=\"filled\", fillcolor=\"{dot_color}\"]"
	end

	private fun dot_label: String do return id

	private fun dot_color: String do if check then return "green" else return "red"
end

redef class ZOutputNode
	redef fun dot_label do return "{id}\no: {compute_output}"
end

redef class ZInputNode
	redef fun dot_label do return "{id}\ni: {compute_input}/{z_input}"
end

redef class ZTransmitter
	redef fun dot_label do return "{id}\ni: {compute_input}/{z_input}\no: {compute_output}/{z_output}"
end
