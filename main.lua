local field = require("field")
local drawer = require("drawer")

local figures
local dragging = false
local currentFigureDrag = 1
local dragData = {x=1, y=1, data = {}}

math.randomseed(os.time())

local function genFigures(force)
	if not figures then
		figures = field.getNextFigures(3)
		return
	end
	local c = #figures
	for _,v in ipairs(figures) do
		if not v.cells then
			c = c - 1
		end
	end
	if c==0 or force then
		figures = field.getNextFigures(3)
	end
end

local schemes
local currentScheme

function love.load()
	love.window.setTitle("Blocku Doku copy prototype")
	love.window.setMode(440, 550)
	field.init("sudoku")
	genFigures()
	drawer.init()
	local s = drawer.getSchemes()
	schemes = {}
	for i,v in ipairs(s) do
		local csi = {name = v, next = s[i+1] or s[1], prev = s[i-1] or s[#s]}
		schemes[v] = csi
	end
	currentScheme = drawer.getCurrentScheme()
end

-- function love.update(dt)

-- end

local function getSmallFigXY(fig, i)
	local w,h = drawer.getSmallSize(fig)
	return 40+55+125*(i-1)-w/2, 420+55-h/2
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(40, 40)
	if not dragging then
		drawer.drawPlainField(field.getField(), field.getSpecialCellsSet())
	else
		local w,h = drawer.getNormalSize(figures[currentFigureDrag])
		if onArea(love.mouse.getX()-w/2, love.mouse.getY()-h/2, 40, 40, 360, 360) and dragData.canDrop then
			local dx, dy = math.floor((love.mouse.getX()-w/2-40)/40), math.floor((love.mouse.getY()-h/2-40)/40)
			drawer.drawStressedField(field.getField(), {dx=dx, dy=dy, cells = figures[currentFigureDrag].cells}, dragData.data and dragData.data or {}, field.getSpecialCellsSet())
		else
			drawer.drawPlainField(field.getField(), field.getSpecialCellsSet())
		end
	end
	love.graphics.pop()

	if dragging then
		love.graphics.push()
		love.graphics.translate(love.mouse.getX(), love.mouse.getY())
		drawer.drawDragFigure(figures[currentFigureDrag])
		love.graphics.pop()
	end
	
	for i,v in ipairs(figures) do
		if v.cells and (dragging and i~=currentFigureDrag or not dragging) then
			love.graphics.push()
			local w,h = drawer.getSmallSize(v)
			love.graphics.translate(getSmallFigXY(v, i))
			drawer.drawSmallFigure(v)
			love.graphics.pop()
		end
	end
end

function love.mousepressed(x, y, button)
	if button==1 then
		for i,v in ipairs(figures) do
			local x1, y1 = getSmallFigXY(v, i)
			local w,h = drawer.getSmallSize(v)
			if onArea(x, y, x1-40, y1-40, w+80, h+80) and v.cells then
				dragging = true
				currentFigureDrag = i
				break
			end
		end
	end
end

function love.mousereleased(x, y, button)
	if button==1 and dragging then
		if dragData.canDrop then
			local w,h = drawer.getNormalSize(figures[currentFigureDrag])
			local dx, dy = math.ceil((love.mouse.getX()-w/2-40)/40), math.ceil((love.mouse.getY()-h/2-40)/40)
			local f = field.getField()
			if dx>0 and dy>0 and dx<=f.w and dy<=f.h then
				field.drop(dx, dy, figures[currentFigureDrag])
				figures[currentFigureDrag].cells = nil
				genFigures()
			end
		end
		dragging = false
		dragData.x = nil
		dragData.y = nil
	end
end

function love.mousemoved(x, y, dx, dy)
	if dragging then
		local fig = figures[currentFigureDrag]
		local w,h = drawer.getNormalSize(fig)
		if onArea(x-w/2, y-h/2, 40, 40, 360, 360) then
			local x1, y1 = math.ceil((x-w/2-40)/40), math.ceil((y-h/2-40)/40)
			local f = field.getField()
			if x1<=0 or y1<=0 or (x1+fig.w-1)>f.w or (y1+fig.h-1)>f.h then
				dragData.canDrop = false
				dragData.data = {}
				return
			end
			local s = drawer.getSettings()
			if x1~=dragData.x or y1~=dragData.y then
				dragData.data = field.getDropData(x1, y1, fig)
				dragData.canDrop = field.canDrop(x1, y1, fig)
			end
		else
			dragData.canDrop = false
		end
	end
end

function love.keypressed(key, code)
	if love.keyboard.isDown("lctrl") and key=='q' then
		love.event.quit()
	end
	if love.keyboard.isDown("lctrl") and key=='r' then
		field.init("sudoku")
		genFigures(true)
	end
	if key=="space" then
		if love.keyboard.isDown("lctrl") then
			currentScheme = schemes[currentScheme].prev
		else
			currentScheme = schemes[currentScheme].next
		end
		drawer.init(currentScheme)
	end
end
