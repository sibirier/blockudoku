local drawer = {}
local settings = {cell_w = 40, cell_h = 40, gap = 2, s_cell_w = 21, s_cell_h = 21}
local colorSchemes = require("schemes")

local colorScheme = "sudoku"
local function cs()
	return colorSchemes[colorScheme]
end

function drawer.getSchemes()
	local ret = {}
	for k in pairs(colorSchemes) do
		table.insert(ret, k)
	end
	return ret
end

function drawer.getCurrentScheme()
	return colorScheme
end

function drawer.init(scheme)
	colorScheme = colorSchemes[scheme] and scheme or "sudoku"
	love.graphics.setBackgroundColor(cs().back:get())
end

function drawer.getSettings()
	return {w = settings.cell_w, h = settings.cell_h}
end

function drawer.getSmallSize(f)
	return f.w*settings.s_cell_w, f.h*settings.s_cell_h
end

function drawer.getNormalSize(f)
	return f.w*settings.cell_w, f.h*settings.cell_h
end

function drawer.drawPlainField(field, specialCells)
	love.graphics.setColor(cs().fieldBack:get())
	love.graphics.rectangle("fill", -settings.gap/2, -settings.gap/2, field.w*settings.cell_w + settings.gap, field.h*settings.cell_h + settings.gap)
	specialCells = specialCells or {}
	for x=1,field.w do
		for y=1,field.h do
			local c 
			if field.data[x][y]==0 then
				if specialCells[x+(y-1)*field.w] then
					c = cs().emptySpecial
				else
					c = cs().empty
				end
			else
				c = cs().full
			end
			love.graphics.setColor(c:get())
			love.graphics.rectangle("fill", (x-1)*settings.cell_w + settings.gap/2, (y-1)*settings.cell_h + settings.gap/2, settings.cell_w-settings.gap, settings.cell_h-settings.gap)			
		end
	end
end

local cache = {
	fig = {link = nil, data = nil},
	drop = {link = nil, data = nil},
}

function drawer.drawStressedField(field, figureData, dropData, specialCells)
	local figureSet 
	if figureData == cache.fig.link then
		figureSet = cache.fig.data
	else
		figureSet = {}
		for _,v in ipairs(figureData.cells) do
			figureSet[(v.y+figureData.dy-1)*field.w+figureData.dx+v.x] = true
		end
		cache.fig.data = figureSet
	end
	local set
	if dropData == cache.fig.link then
		set = cache.fig.data
	else
		set = {}
		for _,v in ipairs((dropData or {}).cells or {}) do
			set[(v.y-1)*field.w + v.x] = true
		end
		cache.drop.data = set
	end
	love.graphics.setColor(cs().fieldBack:get())
	love.graphics.rectangle("fill", -settings.gap/2, -settings.gap/2, field.w*settings.cell_w + settings.gap, field.h*settings.cell_h + settings.gap)
	specialCells = specialCells or {}
	for x=1,field.w do
		for y=1,field.h do
			local c 
			if field.data[x][y]==0 then
				if figureSet[x+(y-1)*field.w] then
					c = cs().hover
				else
					if specialCells[x+(y-1)*field.w] then
						c = cs().emptySpecial
					else
						c = cs().empty
					end
				end
			else
				if set[x+(y-1)*field.w] then
					c = cs().stressed
				else
					c = cs().full
				end
			end
			love.graphics.setColor(c:get())
			love.graphics.rectangle("fill", (x-1)*settings.cell_w + settings.gap/2, (y-1)*settings.cell_h + settings.gap/2, settings.cell_w-settings.gap, settings.cell_h-settings.gap)			
		end
	end
end

function drawer.drawSmallFigure(f)
	love.graphics.setColor(cs().full:get())
	for _,v in ipairs(f.cells) do
		love.graphics.rectangle("fill", (v.x-1)*settings.s_cell_w+settings.gap/2, (v.y-1)*settings.s_cell_h+settings.gap/2, settings.s_cell_w-settings.gap, settings.s_cell_h-settings.gap)
	end
end

function drawer.drawDragFigure(f) -- centered
	local w,h = f.w/2*settings.cell_w, f.h/2*settings.cell_h
	love.graphics.setColor(cs().full:get())
	for _,v in ipairs(f.cells) do
		love.graphics.rectangle("fill", -w+(v.x-1)*settings.cell_w+settings.gap/2, -h+(v.y-1)*settings.cell_h+settings.gap/2, settings.cell_w-settings.gap, settings.cell_h-settings.gap)
	end
end

return drawer