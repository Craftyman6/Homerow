require"tesound"

idiot = {
	init = function(screen)
		idiot.x = screen.x
		idiot.y = screen.y
		idiot.w = screen.w
		idiot.h = screen.h
	end,
	active = false,
	shortTtl = 2,
	longTtl = 3.5,
	ttl = 0,
	message = "",
	sprites = {
		white = love.graphics.newImage("IMG/Idiot/white.png"),
		black = love.graphics.newImage("IMG/Idiot/black.png")
	},
	white = true,
	sprite = love.graphics.newImage("IMG/Idiot/white.png"),
	spriteSize = .4,
	start = function(message, long)
		if idiot.active then return end
		idiot.active = true
		idiot.ttl = long and idiot.longTtl or idiot.shortTtl
		idiot.message = message
		TEsound.play("SFX/Idiot/"..(long and "long" or "short")..".mp3", "static", {}, .3)
	end,
	update = function(dt)
		idiot.ttl = idiot.ttl - dt
		idiot.white = math.floor(idiot.ttl*2 % 2) == 0
		idiot.sprite = idiot.white and idiot.sprites.white or idiot.sprites.black
		idiot.active = idiot.ttl > 0
	end,
	drawBg = function()
		if not idiot.active then return end
		color = idiot.white and 0 or 1
		rect(idiot.x, idiot.y, idiot.w, idiot.h, {color, color, color, .8})
	end,
	draw = function()
		if not idiot.active then return end
		center = {x = idiot.x + idiot.w/2, y = idiot.y + idiot.h/2}
		-- Faces
		love.graphics.setColor(1,1,1)
		for dx = -80, 170, 120 do
			love.graphics.draw(idiot.sprite, center.x - dx, center.y - 40, 0, idiot.spriteSize)
		end
		-- Text
		colorId = idiot.white and 1 or 0
		color = {colorId, colorId, colorId}
		text("you are an idiot", center.x - 131, center.y - 100, 30, color)
		textCenter(idiot.message, center.x, center.y + 59, 30, color)
	end,
}

return idiot