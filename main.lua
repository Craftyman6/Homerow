-- Set up fullscreen
--[[
local push = require "push"
local gameWidth, gameHeight = 1280, 720 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()
push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true, canvas = true})
]]
require"tesound"
require("saving")

version = "1.1"

windowW = 525
windowH = 720
windowS = 1

function love.load()
    math.randomseed(os.time())
    love.window.setMode(windowW*windowS, windowH*windowS)
	keyboard = require 'keyboard'
	monitor = require 'monitor'
	cursor = require 'cursor'
	background = require 'background'
	monitor.init()
	keyboard.init()

	loadGame()

	--love.window.setFullscreen(true, "desktop")

	stencilCanvas = love.graphics.newCanvas(windowW, windowH, {format = "stencil8"})	
	colorCanvas = love.graphics.newCanvas(windowW, windowH)
end

function changeWindowS()
	windowS = ({1.25, 1.5, 1})[windowS*4-3]
    love.window.setMode(windowW*windowS, windowH*windowS)
end

function love.update(dt)
	cursor.update(dt)
	keyboard.update(dt)
	monitor.update(dt)
	TEsound.cleanup()
end

function love.draw()
	love.graphics.setCanvas({colorCanvas, depthstencil=stencilCanvas})

	monitor.draw()

	-- Entire keyboard and rows and keys
	keyboard.draw()

	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(colorCanvas, 0, 0, 0, windowS)
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
