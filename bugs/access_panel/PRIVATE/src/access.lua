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
		lines[#lines + 1] = l
	end
	return lines
end

function check_lines(lines)
	if #lines == 0 then
		print "Error: empty list"
		return
	end
	for i, id in ipairs(lines) do
		if is_well_formed(id) then
			if is_valid(id) then
				print(id .. ": valid")
			else
				print(id .. ": invalid")
			end
		else
			print(id .. ": malformed")
		end
	end
end

function is_well_formed(id)
	if #id ~= 19 then return false end
	for i = 1, #id do
		local c = id:sub(i,i)
		if i == 5 or i == 10 or i == 15 then
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
	--sum odd digits
	for i=1,nums:len(),2 do
		s1=s1+nums:sub(i,i)
	end
	--evens
	local s2=0
	for i=2,nums:len(),2 do
		local doubled=nums:sub(i,i)*2
		doubled=string.gsub(doubled,'(%d)(%d)',function(a,b)return a+b end)
		s2=s2+doubled
	end
	local total=s1+s2
	if total%10==0 then
		return true
	end
	return false
end

lines=read_input()
check_lines(lines)
