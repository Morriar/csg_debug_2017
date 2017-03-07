intrude import pear_map

redef class PearMap
	init from(other: PearMap) do
		for line in other.lines do
			self.lines.add new MapLine.from(line)
		end
	end
end

redef class MapLine
	init from(other: MapLine) do
		for c in other do
			self.add new MapSlot.parse(c.symbol)
		end
	end
end

class GenMap
	super PearMap

	init random(x, y: Int) do
		for i in [1..y] do
			lines.add new MapLine
			for j in [1..x] do
				lines.last.add new MapWall
			end
		end
		random_start
		random_exit
		random_paths(2 * x / y)
	end

	fun random_start do
		var slot = random_slot
		if slot == null then return
		replace_slot(slot, new MapStart)
	end

	fun random_exit do
		var slot = random_slot
		while slot == start do slot = random_slot
		if slot == null then return
		replace_slot(slot, new MapExit)
	end

	fun random_paths(i: Int) do
		while i >= 0 do
			draw_path(find_path_between(random_slot, random_slot))
			i -= 1
		end
	end

	fun replace_slot(slot, new_slot: MapSlot) do
		var coords = slot_coords(slot)
		if coords == null then return
		lines[coords.x][coords.y] = new_slot
	end

	redef fun find_path_between(start, exit) do
		if start == null then return null
		if exit == null then return null

		var open = new Array[MapSlot].from([start])
		var closed = new HashSet[MapSlot]
		var from = new HashMap[MapSlot, MapSlot]
		var scores = new ScoreMap
		var comparator = new SlotComparator(scores)

		scores[start] = 0.0

		while open.not_empty do
			comparator.sort(open)
			var slot = open.pop

			if slot == exit then return reconstruct_path(from, slot)

			closed.add slot
			var neighbors = slot_neighbors(slot)
			if neighbors == null then continue
			for neighbor in neighbors do
				if closed.has(neighbor) then continue
				var score = scores[slot] + 1.0
				if not open.has(neighbor) then
					open.add neighbor
				else if score >= scores[neighbor] then
					continue
				end
				from[neighbor] = slot
				scores[neighbor] = score
			end
		end

		return null
	end

	redef fun draw_path(path) do
		if path == null then return
		for slot in path do
			if slot isa MapStart or slot isa MapExit then continue
			slot.symbol = ' '
		end
	end

	fun random_slot: nullable MapSlot do
		return slot_at([0..lines.length - 1].rand, [0..lines.first.length - 1].rand)
	end
end


for i in [2..50] do

	var x = [40, 45, 50, 55, 60, 65, 70, 75, 80].rand
	var y = [10, 15, 20, 25, 30, 35, 40, 45, 50].rand

	var pear = new GenMap.random(x, y)
	var path = pear.find_path
	pear.draw_path(path)
	print pear
	pear.to_s.write_to_file("tests/test{i}.in")

	var res = new PearMap.from(pear)
	path = res.find_path
	res.draw_path(path)
	print res
	res.to_s.write_to_file("tests/test{i}.res")

end
