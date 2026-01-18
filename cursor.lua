require("keyboard")
idiot = require 'idiot'
message = require 'message'

cursor = {
	x = 0,
	y = 0,
	held = false,
	heldObj = nil,
	hoveredObj = nil,
	holdDis = {x = 0, y = 0},
	clikedLastFrame = false,
	monitorClickables = {},
	buttonTime = 0,
	buttonPressTime = .15,
	sprites = {
		point = love.graphics.newImage("IMG/Cursor/point.png"),
		click = love.graphics.newImage("IMG/Cursor/click.png"),
		load = love.graphics.newImage("IMG/Cursor/load.png"),
	},
	sprite = love.graphics.newImage("IMG/Cursor/point.png"),
	--[[
	example clickable:
	{x = 100, y = 100, w = 100, h = 100,
	onClick = function() print("bruh") end}
	]]
	update = function(dt)
		-- Don't even run if idiot is active or final word is scoring
		if idiot.active or monitor.screen.at.noCursor then cursor.buttonTime = 0 return end

		-- Update sprite
		cursor.sprite = cursor.attemptMonitorClick(false) and cursor.sprites.click or cursor.sprites.point
		if app.round == 8 and app.boss == 4 then cursor.sprite = cursor.sprites.load end

		-- Update cursor coordinates
		cursor.x, cursor.y = love.mouse.getPosition()

		-- Hold key if holding click and cursor escaped hovered key's hitbox
		if cursor.hoveredObj ~= nil and keyboard.attemptDrag(cursor.x, cursor.y) ~= cursor.hoveredObj and love.mouse.isDown(1) and cursor.buttonTime < cursor.buttonPressTime then
			cursor.held = true
			cursor.heldObj = cursor.hoveredObj
			cursor.holdDis = {x = cursor.heldObj:getCenterX() - cursor.heldObj.x, y = cursor.y - cursor.heldObj.y}
			cursor.buttonTime = cursor.buttonPressTime
		end

		-- Get hovered object
		if cursor.heldObj == nil then
			cursor.hoveredObj = keyboard.attemptDrag(cursor.x, cursor.y)
		end

		-- Click
		if not love.mouse.isDown(1) and cursor.buttonTime > 0 and cursor.buttonTime < cursor.buttonPressTime then
			if cursor.hoveredObj ~= nil and not monitor.screen.at.noKeyCursor then
				cursor.hoveredObj:press()
			else
				cursor.attemptMonitorClick(true)
			end
		end

		-- Update button time
		cursor.buttonTime = love.mouse.isDown(1) and cursor.buttonTime + dt or 0

		-- Reset clickables at end of cursor update call
		-- Monitor update call happens after and fills it for next frame
		cursor.monitorClickables = {}
		cursor.clickedLastFrame = love.mouse.isDown(1)

		-- Update held object
		if cursor.held then
			-- Release if button is released
			if not love.mouse.isDown(1) then cursor.held = false cursor.heldObj = nil return end
			-- Drag held object
			if cursor.heldObj == nil then return end
			cursor.heldObj:drag(dt, cursor.x - cursor.holdDis.x, cursor.y - cursor.holdDis.y)
		-- Hover object and attempt to hold it
		else
			-- Return if nothing's hovered or hovering over a pressed key
			if cursor.hoveredObj == nil then return end
			if cursor.hoveredObj.pressed then return end
			-- Set object as hovered on their end
			cursor.hoveredObj:setHovered()

			-- Attempt to hold a key
			if not love.mouse.isDown(1) or cursor.buttonTime < cursor.buttonPressTime then return end
			cursor.held = true
			cursor.heldObj = cursor.hoveredObj
			cursor.holdDis = {x = cursor.x - cursor.heldObj.x, y = cursor.y - cursor.heldObj.y}
		end
	end,
	addMonitorClickable = function(x, y, w, h, tip, func)
		table.insert(cursor.monitorClickables, {x = x, y = y, w = w, h = h, tip = tip, onClick = func})
	end,
	-- Returns whether cursor is over a clickable
	-- Given boolean determines if clickable's onClick function is actually run
	attemptMonitorClick = function(runOnClick)
		if app.round == 8 and app.boss == 4 then return end
		for i, clickable in ipairs(cursor.monitorClickables) do

			if cursor.x >= clickable.x and
			cursor.y >= clickable.y and
			cursor.x <= clickable.x + clickable.w and
			cursor.y <= clickable.y + clickable.h then
				message.say(clickable.tip, "clippy", true)
				if runOnClick then clickable.onClick() end
				return true
			end
		end
		return false
	end,
	draw = function()
		love.graphics.setColor(1,1,1)
		love.graphics.draw(cursor.sprite, cursor.x + 2*math.cos(3*love.timer.getTime()), cursor.y + 2*math.sin(3*love.timer.getTime()))
	end
}

return cursor