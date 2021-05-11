local field = {}
local data = {}

local schemes = {
	sudoku = require("sudoku")
}

local currentScheme

function field.init(scheme)
	currentScheme = schemes[scheme or 'sudoku'] or schemes.sudoku
	data = {}
	for i=1,currentScheme.x do
		data[i] = {}
		for j=1,currentScheme.y do
			data[i][j] = EMPTY_CELL
		end
	end
end

function field.canDrop(x, y, figureData)
	local canDrop = true
	for _,v in ipairs(figureData.cells) do
		if not data[x+v.x-1] or not data[x+v.x-1][y+v.y-1] or data[x+v.x-1][y+v.y-1]~=EMPTY_CELL then
			canDrop = false
			break
		end
	end
	return canDrop
end

function field.drop(x, y, figureData, dropData)
	for _,v in ipairs(figureData.cells) do
		data[x+v.x-1][y+v.y-1] = v.value
	end
	dropData = dropData or currentScheme.getDropData(data, x, y, figureData)
	for _,v in ipairs(dropData.cells) do
		data[v.x][v.y] = EMPTY_CELL
	end
	return dropData
end

function field.getField()
	return {data = data, w = currentScheme.x, h = currentScheme.y}
end

function field.getNextFigures(count)
	return currentScheme.getNextFigures(count)
end

function field.getDropData(x, y, figureData)
	return currentScheme.getDropData(data, x, y, figureData)
end

function field.getSpecialCellsSet()
	return currentScheme.getSpecialCellsSet()
end

return field