require("misc")
require("cursor")
idiot = require 'idiot'
osboot = require 'osboot'
login = require 'login'
app = require 'app'
bluescreen = require 'bluescreen'
powershell = require 'powershell'
crash = require 'crash'
background = require 'background'
message = require 'message'
local moonshine = require 'moonshine'

backgroundCol = {0,0,0}

monitor = {
	x = 29,
	y = 30,
	w = 467,
	h = 345,
	blackBorderW = 5,
	hasSwapped = false,
	borderW = 10,
	borderCol = {0.949, 0.941, 0.8274},
	baseCol = {0.8, 0.792, 0.686},
	stickynoteImg = love.graphics.newImage("IMG/Monitor/stickynote.png"),
	init = function()
		monitor.screen = {x = monitor.x + monitor.blackBorderW + 3, 
			y = monitor.y + monitor.blackBorderW + 3,
			w = monitor.w - 2*monitor.blackBorderW - 6,
			h = monitor.h - 2*monitor.blackBorderW - 6,
			at = osboot}
		idiot.init(monitor.screen)
		osboot.init(monitor.screen)
		login.init(monitor.screen)
		app.init(monitor.screen)
		bluescreen.init(monitor.screen)
		powershell.init(monitor.screen)
		crash.init(monitor.screen)
		message.init(monitor.screen)
		monitor.screen.at.begin()
		effect = moonshine(moonshine.effects.scanlines).chain(moonshine.effects.crt).chain(moonshine.effects.pixelate)
		effect.resize(monitor.screen.x + monitor.screen.w, monitor.screen.y + monitor.screen.h)
		effect.scanlines.opacity = .05
		effect.crt.distortionFactor = {1.02, 1.02}
		effect.crt.feather = 0
		effect.pixelate.size = {.5,.5}
	end,
	update = function(dt)
		-- Change screen if page says to
		if monitor.screen.at.update(dt) then
			if monitor.screen.at.id == 1 then
				monitor.screen.at = monitor.hasSwapped and app or login 
			elseif monitor.screen.at.id == 2 then
				monitor.screen.at = app
			elseif monitor.screen.at.id == 3 then
				monitor.screen.at = bluescreen
			elseif monitor.screen.at.id == 4 then
				monitor.screen.at = osboot
			elseif monitor.screen.at.id == 6 then
				monitor.screen.at = bluescreen
			end
			monitor.hasSwapped = true
			monitor.screen.at.begin()
		end
		idiot.update(dt)
		message.update(dt)
		if idiot.active then 
			effect.pixelate.size = {math.random()*10, math.random()*10}
		else effect.pixelate.size = {.5,.5} end
		background.update(dt)
	end,
	draw = function()
		-- Draw screen with effect
		love.graphics.setColor(1,1,1)
		--love.graphics.translate(monitor.screen.x, monitor.screen.y)
		effect(function() 
			monitor.screen.at.draw()
			message.draw()
			cursor.draw()
			idiot.drawBg()
		end)
		--love.graphics.translate(-monitor.screen.x, -monitor.screen.y)
		idiot.draw()

		background.draw()
		-- Monitor border
		monitor.drawBorder()
	end,
	drawBackground = function()
		blackBorderW = 8
		-- left
		rect(0, 0, monitor.x + blackBorderW, 720, backgroundCol)
		-- top
		rect(0, 0, 1280, monitor.y + blackBorderW, backgroundCol)
		-- right
		rect(monitor.x + monitor.w - blackBorderW, 0, 1280 - monitor.x - monitor.w + blackBorderW, 720, backgroundCol)
		-- bottom
		rect(0, monitor.y + monitor.h - blackBorderW, 1280, 720 - monitor.y - monitor.h + blackBorderW, backgroundCol)
	end,
	drawBorder = function()
		-- left
		line(monitor.x - monitor.borderW,
			monitor.y - 2*monitor.borderW,
			monitor.x - monitor.borderW,
			monitor.y + monitor.h + 2*monitor.borderW,
			monitor.borderW,
			monitor.borderCol)
		-- right
		line(monitor.x + monitor.w + monitor.borderW,
			monitor.y - 2*monitor.borderW,
			monitor.x + monitor.w + monitor.borderW,
			monitor.y + monitor.h + 2*monitor.borderW,
			monitor.borderW,
			monitor.borderCol)
		-- top
		line(monitor.x - 2*monitor.borderW,
			monitor.y - monitor.borderW,
			monitor.x + monitor.w + 2*monitor.borderW,
			monitor.y - monitor.borderW,
			monitor.borderW,
			monitor.borderCol)
		-- bottom (double width)
		line(monitor.x - 2*monitor.borderW,
			monitor.y + monitor.h + 2*monitor.borderW,
			monitor.x + monitor.w + 2*monitor.borderW,
			monitor.y + monitor.h + 2*monitor.borderW,
			2*monitor.borderW,
			monitor.borderCol)
		-- round corners
		roundness = 3
		for x = 0, 1 do
			for y = 0, 1 do
				rect(monitor.x + x*monitor.w - x*roundness,
					monitor.y + y*monitor.h - y*roundness,
					roundness, roundness, monitor.borderCol)
			end
		end
		-- Buttons
		for i = 1, 4 do
			rectLine(monitor.x + monitor.w - 170 + 30 * i, monitor.y + monitor.h + 12, 20, 15, monitor.baseCol, 20)
		end
		rect(monitor.x + monitor.w - 15, monitor.y + monitor.h + 15, 7, 7, {1,0,0})
		-- Monitor base
		rect(monitor.x, monitor.y + monitor.h + 4*monitor.borderW, monitor.w, 20, monitor.baseCol)
		-- sticky note
		if app.hasWon then
			rect(monitor.x + 20, monitor.y + monitor.h + 10, 60, 60, {.9, 1, 0})
			img(monitor.stickynoteImg, monitor.x + 20, monitor.y + monitor.h + 10)
		end
	end
}

return monitor