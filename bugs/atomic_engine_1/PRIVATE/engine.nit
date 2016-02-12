# Give as input the layout of a reactor
# Compute coloring for this layout.

# Input Layout
#
#	################
#   #o-o------o#####
#   ######o#########
#   #o-o--+---o#####
#   ######o#########
#   ################
#
#

# A Reactor contains slots that can be filled up with reactor items.
class Reactor
	var slots: Array[ReactorSlot]

	# Compute the energy output for one round.
	# TODO
	fun z_output: Int do return 0

	fun produced_heat: Int do return 0
end

# A Reactor slot can contain any kind of `ReactorItem`.
#
# Each slot can produce energy and heat depending on what item is placed in it.
class ReactorSlot

	# Slots touching `self`.
	var neightboors: Array[ReactorSlot]

	# Item contained in this reactor slot.
	var item: nullable ReactorItem

	# Energy output for this slot for one turn.
	var z_output: Int do
		if not item isa UraniumBar then return 0
		var output = 1
		for neightboor in neightboors do
			if neightboor.item isa UraniumBar then output *= 10
		end
		return output
	end

	# Heat output for this slot for one turn.
	var heat_output: Int do
		if item isa UraniumBar then
			# TODO heat produced according to neightboors
		end
		return 0
	end
end

# Something that can go in a `ReactorSlot`.

interface ReactorItem
	fun apply_round is abstract
end

# A UraniumBar generates energy and heat.
# TODO Add complex rules about proximity.
class UraniumBar
	super ReactorItem
end

# Cooling plates are used to absorb heat so the reactor does not explode.
class CoolingPlate
	super ReactorItem
end

# Cooling pipes are used to conduct the heat from a ReactorSlot to a cooling plate.
class CoolingPipe
	super ReactorItem
end
