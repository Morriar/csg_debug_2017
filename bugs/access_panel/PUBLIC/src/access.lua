-- Copyright Dome Systems.
--
-- Dome Private License (D-PL) [a369] PubPL 36 (7 Gallium 369)
--
-- * URL: http://csgames.org/2016/dome_license.md
-- * Type: Software
-- * Media: Software
-- * Origin: Mines of Morriar
-- * Author: Morriar

function read_input()
	lines = {}
	while true do
		local l = io.read("*l")
		if l == nil then break end
		lines[#lines] = l
	end
	return lines
end

function check_lines(lines)
	for i, id in ipairs(lines) do
		if not is_well_formed(id) then
			print(id .. ": malformed")
		end
		if is_valid(id) then
			print(id .. ": valid")
		else
			print(id .. ": invalid")
		end
	end
end

function is_well_formed(id)
	if #id ~= 20 then return false end
	for i = 1, #id, 2 do
		local c = id:sub(i,i)
		if i == 4 or i == 9 or i == 14 then
			if c ~= '-' then return false end
		else
			if tonumber(c) == nil then return false end
		end
	end
	return true
end

function is_valid(id)
	di=string.reverse(id)
	local s1=0
	local nums = ""
	for i=1,di:len() do
		c = di:sub(i,i)
		if c ~= '-' then nums = nums .. c end
	end
	for i=1,di:len(),2 do
		s1=s1+di:sub(i,i)
	end
	local s2=0
	for i=2,di:len(),2 do
		local doubled=di:sub(i,i)*2
		doubled=string.gsub(doubled,'(%d)(%d)',function(a,b)return a+b end)
		s2=s2+doubled
	end
	local total=s1+s2
	if total%10==1 then
		return true
	end
	return false
end

lines=read_input()
-- TODO this should not be commented check_lines(lines)
