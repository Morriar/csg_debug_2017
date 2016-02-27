# Copyright Dome Systems.
#
# Dome Private License (D-PL) [a369] PubPL 36 (14 Indium 495)
#
# * URL: http://csgames.org/2016/dome_license.md
# * Type: Software
# * Media: Software
# * Origin: Mines of Morriar
# * Author: Calibri de la Morriar

# Cycle checking.
module z_cycle

import z_grid

redef class ZGrid

	# Does this grid contain a cycle?
	fun has_cycle: Bool do
		for id, node in nodes do
			if not node isa ZTransmitter then continue
			var v = new CycleVisitor(node)
			v.check
			if v.has_cycle then return true
		end
		return false
	end

end

private class CycleVisitor

	var check_node: ZTransmitter

	fun check do check_node.visit_inputs(self)

	var has_cycle = false

	var seen = new HashSet[ZNode]

	fun visit_inputs(node: ZNode) do
		if node == check_node then
			has_cycle = true
			return
		end
		if seen.has(node) then
			return
		end
		seen.add node
		if not node isa ZInputNode then return
		node.visit_inputs(self)
	end
end

redef class ZInputNode

	private fun visit_inputs(v: CycleVisitor) do
		for id, node in ins do v.visit_inputs(node)
	end
end
