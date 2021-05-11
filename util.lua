EMPTY_CELL = 0

function copy(t)
	if type(t)~="table" then
		return t
	else
		local ret = {}
		for k,v in pairs(t) do
			ret[k]=copy(v)
		end
		return ret
	end
end

function cell(x, y)
	return {x = x, y = y, value = 1}
end

local function _rotate(fig, w, h)
	local wrongX, wrongY = false, false
	for _,v in ipairs(fig) do
		v.x, v.y = w-v.y+1, v.x
		if v.x<1 or v.x>h then
			wrongX = true
		end
		if v.y<1 or v.y>w then
			wrongY = true
		end
	end
	if wrongX or wrongY then
		for _,v in ipairs(fig) do
			if wrongX then
				v.x = (v.x + h-1)%h+1
			end
			if wrongY then
				v.y = (v.y + w-1)%w+1
			end
		end
	end
	return fig
end

function getWH(fig)
	assert(fig, "figure must be given!")
	local w = 1
	local h = 1
	for _,v in ipairs(fig) do
		if v.x>w then 
			w = v.x
		end
		if v.y>h then 
			h = v.y
		end
	end
	return w,h
end

function rotate(fig)
	local w,h = getWH(fig)
	if w==1 and h==1 then 
		return fig
	elseif w==1 or h==1 then
		return math.random(1,2)==2 and fig or _rotate(fig, w, h)
	else
		local count = math.random(1,4)
		if count==4 then 
			return fig
		else
			for i=1,count do
				w,h = h,w
				_rotate(fig, w, h)
			end
			return fig
		end
	end
end

local colorsMeta = {
	get=function(self)
        return self.red, self.green, self.blue, self.alpha
    end, 
    set=function(self,r,g,b,a)
        self.red=r or 1;self.green=g or 1; self.blue=b or 1; self.alpha=a or 1
    end
}

function color(r,g,b,a)
    return setmetatable({red=r or 1,green=g or 1,blue=b or 1, alpha=a or 1}, {__index = colorsMeta})
end

function onArea(pos_x, pos_y, x,y,w,h)
    return pos_x>=x and pos_x<=(x+w) and pos_y<=(y+h) and pos_y>=y
end
