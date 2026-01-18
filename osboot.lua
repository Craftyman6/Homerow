require("misc")
require("cursor")

osboot = {
	id = 1,
	noCursor = false,
	init = function(screen)
		osboot.x = screen.x
		osboot.y = screen.y
		osboot.w = screen.w
		osboot.h = screen.h
	end,
	timeLeft = 3,
	iconCol = {1, 1, 1},
	iconImg = love.graphics.newImage("IMG/OSBoot/bee2.png"),
	iconSize = 2.2,
	titleCol = {0.964, 1, 0.561},
	titleOSCol = {0.82, 0.643, 0.376},
	loadingBarCol = {0.219, 0.376, 1},
	loadingBarHighlightCol = {0.49, 0.592, 1},
	begin = function()
		osboot.timeLeft = 3
	end,
	update = function(dt)
		keyboard.clearKeys()
		cursor.sprite = cursor.sprites.load
		osboot.timeLeft = osboot.timeLeft - dt
		return osboot.timeLeft < 0
	end,
	draw = function()
		center = {x = osboot.x + osboot.w/2, y = osboot.y + osboot.h/2}
		-- Black bg
		rect(osboot.x, osboot.y, osboot.w, osboot.h, {0,0,0})
		-- Bee icon
		redColVal = (math.sin(2*love.timer.getTime())+1)/8+.5
		greenColVal = (math.cos(2*love.timer.getTime())+1)/10+.8
		osboot.iconCol = {redColVal, greenColVal, .5, 1}
		love.graphics.setColor(unpack(osboot.iconCol))
		love.graphics.draw(osboot.iconImg, center.x - 45, center.y - 105, 0, osboot.iconSize)
		-- Title
		text("Bumble", center.x - 75, center.y, 50, osboot.titleCol)
		text("OS", center.x + 80, center.y - 10, 30, osboot.titleOSCol)
		-- Slogan
		text("You spell. We bee.", center.x - 65, center.y + 50, 15, {1,1,1})
		-- Loading bar
		rectLine(center.x - 75, center.y + 88, 152, 14, {1,1,1})
		loadingInt = math.floor(-osboot.timeLeft*3 % 5 * 4) - 3
		for i = 0, 14 do
			if i >= loadingInt and i <= loadingInt + 2 then
				rect(center.x - 73 + 10*i, center.y + 90, 8, 10, osboot.loadingBarCol)
				rect(center.x - 73 + 10*i, center.y + 92, 8, 2, osboot.loadingBarHighlightCol)
			end
		end
	end
}

return osboot