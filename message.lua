require("misc")
idiot = require 'idiot'

message = {
	init = function(screen)
		message.x = screen.x + screen.w/2 - 100
		message.y = screen.y + screen.h
		message.bottomY = screen.y + screen.h
	end,
	active = false,
	w = 200,
	h = 40,
	text = "",
	cutoffText = "",
	perishable = false,
	keptAlive = false,
	time = 0,
	ttl = 120,
	lines = 1,
	lineH = 14,
	img = love.graphics.newImage("IMG/Message/idiot.png"),
	imgSize = .2,
	say = function(text, image, perishable)
		if message.text == text then 
			if perishable then
				message.keptAlive = true return
			else
				message.time = math.min(message.time, #text/70) return
			end
		end
		-- If regular text is happening, don't let perishables start
		if message.active and perishable then return end
		message.active = true
		message.text = text
		message.img = love.graphics.newImage("IMG/Message/"..image..".png")
		message.perishable = perishable
		message.keptAlive = perishable
		message.time = 0
	end,
	stop = function()
		message.active = false
	end,
	over = function()
		return 70*message.time > message.ttl + #message.text
	end,
	talking = function()
		return 70*message.time < 0 + #message.text
	end,
	stop = function()
		message.text = ""
		message.cutoffText = ""
		message.time = 0
		message.active = false
	end,
	update = function(dt)
		if not message.active then return end
		if idiot.active then return end
		if message.perishable and not message.keptAlive then message.stop() return end
		message.time = message.time + dt
		if not message.perishable and message.over() then message.stop() return end
		message.cutoffText = message.text:sub(1, math.min(math.floor(70*message.time), #message.text))
		message.cutoffText = wrap_text(message.cutoffText, 32)
		local _, newlines = message.cutoffText:gsub("\n", "")
		message.lines = 1 + newlines
		message.y = message.bottomY - message.lines * message.lineH - 5
		message.h = message.lines * message.lineH + 4
		message.keptAlive = false
	end,
	draw = function()
		if idiot.active then return end
		-- Textbox
		if not message.active then return end
		rect(message.x, message.y, message.w, message.h, {1,1,1})
		rectLine(message.x, message.y, message.w, message.h, {0,0,0})
		-- Text
		text(message.cutoffText, message.x + 4, message.y, 12.5, {0,0,0})
		-- Image
		bounce = message.talking() and 5*math.max(math.sin(message.time*20), math.cos(message.time*20 + math.pi/2)) or 0
		turn = message.talking() and math.sin(message.time*20)/10 or 0
		love.graphics.setColor(1,1,1)
		love.graphics.draw(message.img, message.x - 45, message.bottomY - 40 - bounce, turn, message.imgSize)
	end
}

return message