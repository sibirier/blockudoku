require("util")

local sudoku = {
	x = 9, y = 9,
}

sudoku.getNextFigures = function(count)
	local figures = {
		{cell(1,1),}, -- line 1
		{cell(1,1), cell(1,2),}, -- line 2
		{cell(1,1), cell(1,2), cell(1,3),}, -- line 3
		{cell(1,1), cell(1,2), cell(1,3), cell(1,4),}, -- line 5
		{cell(1,1), cell(1,2), cell(1,3), cell(1,4), cell(1,5),}, -- line 5
		{cell(1,1), cell(1,2), cell(2,1), cell(2,2),}, -- square
		{cell(1,1), cell(1,2), cell(2,1), }, -- angle 2l
		{cell(1,1), cell(1,2), cell(2,2), }, -- angle 2r
		{cell(1,1), cell(2,2), }, -- diag 2
		{cell(1,1), cell(2,2), cell(3,3),}, -- giag 3
		{cell(1,1), cell(1,2), cell(1,3), cell(2,1),}, -- angle 3-1 l
		{cell(1,1), cell(1,2), cell(1,3), cell(2,3),}, -- angke 3-1 r
		{cell(1,1), cell(1,2), cell(2,2), cell(2,3),}, -- z
		{cell(1,3), cell(1,2), cell(2,2), cell(2,1),}, -- s
		{cell(1,1), cell(1,3), cell(2,2),}, -- hollow tank
		{cell(1,1), cell(1,2), cell(1,3), cell(2,2),}, -- tank
		{cell(1,1), cell(1,2), cell(1,3), cell(2,2), cell(3,2),}, -- long tank
		{cell(1,1), cell(2,1), cell(2,2), cell(2,3), cell(3,2),}, -- Y l
		{cell(1,3), cell(2,1), cell(2,2), cell(2,3), cell(3,2),}, -- Y r
		{cell(1,1), cell(1,2), cell(1,3), cell(2,1), cell(3,1),}, -- long angle 2l
		{cell(1,1), cell(1,2), cell(1,3), cell(2,3), cell(3,3),}, -- long angle 2r
		{cell(1,1), cell(1,2), cell(1,3), cell(2,1), cell(2,3),}, -- п
		{cell(1,1), cell(1,2), cell(1,3), cell(2,1), cell(2,3), cell(3,1), cell(3,3),}, -- П
	}
	local ret = {}
	for i=1,count do
		local data = {cells = rotate( copy(figures[math.random(1, #figures)]) )}
		data.w, data.h = getWH(data.cells)
		table.insert(ret, data)
	end
	return ret
end

local function checkCol(field, x, set)
	local full = true
	for i=1,9 do
		if field[x][i]==EMPTY_CELL then
			full = false
			break
		end
	end
	if full then
		for i=1,9 do
			set[x + (i-1)*9] = true
		end
	end
	return full
end

local function checkRow(field, y, set)
	local full = true
	for x=1,9 do
		if field[x][y]==EMPTY_CELL then
			full = false
			break
		end
	end
	if full then
		for x=1,9 do
			set[x + (y-1)*9] = true
		end
	end
	return full
end

local function checkBlock(field, block, set)
	local full = true
	local dx = 3*((block-1)%3)
	local dy = 3*math.floor((block-1)/3)
	for x=1,3 do
		for y=1,3 do
			if field[dx+x][dy+y]==EMPTY_CELL then
				full = false
				break
			end
		end
	end
	if full then
		for x=1,3 do
			for y=1,3 do
				set[dx+x+(dy+y-1)*9] = true
			end
		end
	end
	return full
end

sudoku.getDropData = function(data, x, y, figureData)
	local fieldWithFigure = copy(data)
	for _,v in ipairs(figureData.cells) do
		fieldWithFigure[x+v.x-1][y+v.y-1] = v.value
	end

	local set = {}
	local totalChecked = 0
	for i=1, sudoku.x do
		if checkRow(fieldWithFigure, i, set) then
			totalChecked = totalChecked + 1
		end
	end
	for i=1, sudoku.y do
		if checkCol(fieldWithFigure, i, set) then
			totalChecked = totalChecked + 1
		end
	end
	for i=1, 9 do
		if checkBlock(fieldWithFigure, i, set) then
			totalChecked = totalChecked + 1
		end
	end
	local cells = {}
	for k in pairs(set) do
		table.insert( cells, {y = math.ceil(k/9), x = (k-1)%9 + 1} )
	end
	return {cells = cells, combos = totalChecked}
end

sudoku.getSpecialCellsSet = function()
	local set = {}
	for i=1,9,2 do
		local dx = ((i-1)%3)*3
		local dy = (math.ceil(i/3)-1)*3
		for j=1,9 do
			local x, y = (j-1)%3+1, math.ceil(j/3)
			set[dx+x+(dy+y-1)*9] = true
		end
	end
	return set
end

return sudoku