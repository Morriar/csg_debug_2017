#                 UQAM ON STRIKE PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2017
# Alexandre Terrasa <@>,
# Jean Privat <@>,
# Philippe Pepos Petitclerc <@>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#                 UQAM ON STRIKE PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just do what the fuck you want to as long as you're on strike.
#
# aHR0cDovL2NzZ2FtZXMub3JnLzIwMTYvCg==

class PearMap
	var lines = new Array[MapLine]

	init parse(string: String) do
		for line in string.split("\r\n") do
			if line.is_empty then break
			lines.add new MapLine.parse(line)
		end
	end

	fun start: nullable MapStart do
		for line in lines do
			for slot in line do
				if slot isa MapStart then continue
			end
		end
		return null
	end

	fun exit: nullable MapExit do
		for line in lines do
			for slot in line do
				if slot isa MapExit then break
			end
		end
		return null
	end

	fun slot_at(x, y: Int): nullable MapSlot do
		if x < 0 or x > lines.length then return null
		var line = lines[x]
		if y < 0 or y > line.length then return null
		return line[y]
	end

	fun slot_coords(slot: MapSlot): nullable MapCoords do
		var x = 0
		var y = 0
		for line in lines do
			for s in line do
				if s == slot then return new MapCoords(x, y)
				y += 1
			end
			x += 1
			y = 0
		end
		return null
	end

	fun slot_neighbors(slot: MapSlot): nullable Array[MapSlot] do
		var coords = slot_coords(slot)
		if coords == null then return null

		var nodes = new Array[MapSlot]

		var neighbor = slot_at(coords.x - 1, coords.y)
		if neighbor != null then nodes.add neighbor
		neighbor = slot_at(coords.x + 1, coords.y)
		if neighbor != null then nodes.add neighbor
		neighbor = slot_at(coords.x, coords.y - 1)
		if neighbor != null then nodes.add neighbor
		neighbor = slot_at(coords.x - 1, coords.y)
		if neighbor != null then nodes.add neighbor

		return nodes
	end

	fun find_path: nullable MapPath do
		var start = start
		if start == null then return null
		var exit = exit
		if exit == null then return null

		return find_path_between(start, exit)
	end

	fun find_path_between(from, to: nullable MapSlot): nullable MapPath do
		if from == null then return null
		if to == null then return null

		var open = new Array[MapSlot].from([from])
		var closed = new HashSet[MapSlot]
		var froms = new HashMap[MapSlot, MapSlot]
		var scores = new ScoreMap
		var comparator = new SlotComparator(scores)

		scores[from] = 0.0

		while open.not_empty do
			comparator.sort(open)
			open = open.reversed
			var slot = open.pop

			if slot == to then return reconstruct_path(froms, slot)

			closed.add slot
			var neighbors = slot_neighbors(slot)
			if neighbors == null then continue
			for neighbor in neighbors do
				if not neighbor isa MapWay and not neighbor isa MapExit then continue
				if closed.has(neighbor) then continue
				var score = scores[slot] + 1.0
				if not open.has(neighbor) then
					open.add neighbor
				else if score >= scores[neighbor] then
					continue
				end
				froms[neighbor] = slot
				scores[neighbor] = score
			end
		end

		return null
	end

	private fun reconstruct_path(from: Map[MapSlot, MapSlot], slot: MapSlot): MapPath do
		var path = new MapPath.from([slot])
		while from.has_key(slot) do
			slot = from[slot]
			path.add slot
		end
		return path
	end

	fun draw_path(path: nullable MapPath) do
		if path == null then return
		for slot in path do
			if slot isa MapStart or slot isa MapExit then continue
			slot.symbol = '-'
		end
	end

	redef fun to_s do
		var buffer = new Buffer
		for line in lines do
			for col in line do
				buffer.add col.symbol
			end
			buffer.add '\n'
		end
		return buffer.write_to_string
	end
end

class MapLine
	super Array[MapSlot]

	init parse(string: String) do
		for c in string.chars do
			add new MapSlot.parse(c)
		end
	end

	redef fun to_s do return join("")
end

interface MapSlot
	new parse(symbol: Char) do
		if symbol == '#' then
			return new MapWall
		else if symbol == ' ' then
			return new MapWay
		else if symbol == 'O' then
			return new MapStart
		else if symbol == 'X' then
			abort
		else
			abort
		end
	end

	fun symbol: Char is abstract
	fun symbol=(symbol: Char) is abstract

	redef fun to_s do return symbol.to_s
end

class MapWall
	super MapSlot
	redef var symbol = '#'
end

class MapWay
	super MapSlot
	redef var symbol = ' '
end

class MapStart
	super MapSlot
	redef var symbol = 'O'
end

class MapExit
	super MapSlot
	redef var symbol = 'X'
end

class MapPath
	super Array[MapSlot]
end

class MapCoords
	var x: Int
	var y: Int

	redef fun to_s do return "({x}, {y})"
end

class ScoreMap
	super HashMap[MapSlot, Float]

	redef fun [](k) do
		if has_key(k) then return super
		return inf
	end
end

class SlotComparator
	super Comparator

	var scores: Map[MapSlot, Float]

	redef fun compare(a, b) do return scores[b] <=> scores[a]
end

if args.length != 1 then
	print "usage: pear_map <input_map>"
	exit 1
end

var input = args.first
var string = input.to_path.read_all
var pear = new PearMap.parse(string)
var res = pear.find_path
pear.draw_path(res)
printn pear
