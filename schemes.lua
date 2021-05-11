require("util")

local s = {}

s.sudoku = {
	back = color(1,1,1),
	fieldBack = color(.8,.8,.8),

	empty = color(1,1,1),
	emptySpecial = color(.9,.9,.9),
	hover = color(.7,.7,.7),
	full = color(.7,.3,1),
	stressed = color(.9,.5,1),
}

s.dark = {
	back = color(.2,.2,.2),
	fieldBack = color(.1,.1,.1),

	empty = color(.2,.2,.2),
	emptySpecial = color(.3,.3,.3),
	hover = color(.18,.18,.18),
	full = color(.8,.25,.25),
	stressed = color(.65,.2,.2),
}

s.pink = {
	back = color(1,.9,.9),
	fieldBack = color(.9,.8,.8),

	empty = color(1,.9,.9),
	emptySpecial = color(1,.8,.8),
	hover = color(.9,.7,.7),
	full = color(.8,.6,.6),
	stressed = color(.8,.5,.5),
}

s.crazy = {
	back = color(.2,.9,.9),
	fieldBack = color(.9,0,.3),

	empty = color(.3,.6,.4),
	emptySpecial = color(1,.4,.7),
	hover = color(1,1,1),
	full = color(.8,.9,.5),
	stressed = color(.8,.6,.6),
}

return s