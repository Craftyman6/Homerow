-- Set up fullscreen
--[[
local push = require "push"
local gameWidth, gameHeight = 1280, 720 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()
push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true, canvas = true})
]]
require"tesound"
require("saving")

version = "1.0"

function love.load()
    math.randomseed(os.time())
	keyboard = require 'keyboard'
	monitor = require 'monitor'
	cursor = require 'cursor'
	background = require 'background'
	monitor.init()
	keyboard.init()

	loadGame()
end

function love.update(dt)
	cursor.update(dt)
	keyboard.update(dt)
	monitor.update(dt)
	TEsound.cleanup()
end

function love.draw()

	monitor.draw()

	-- Entire keyboard and rows and keys
	keyboard.draw()
	-- TESTING
	--text(tostring(cursor.hoveredObj ~= nil), 0, 0, 20, {1, 1, 1})

	--[[
	love.graphics.setColor(1, 1, 1)
	cursorx, cursory = love.mouse.getPosition()
	love.graphics.circle("fill", cursorx, cursory, 2)
	]]
	--push:finish()
end
--[[
function love.keypressed(key)
	if key=="escape" then
		love.event.quit()
	elseif #key==1 then
		keyboard.placeLetterKeyTest(key)
	end
end
]]
