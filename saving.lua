local pprint = require('pprint.pprint')

saveGame = function(blank)
	-- Initialize save file
	local f, errorstr = love.filesystem.newFile("savestate.lua")
	print("Save state status: "..(errorstr or "Working"))
	local ok, err = f:open("w")
	if not ok then print(err) end

	-- Initialize save object
	local save = {}
	save.hasWon = app.hasWon
	save.shopDia = app.shopDia
	save.blank = blank

	-- If blank, skip saving other data
	if not save.blank then
		-- Initialize variables
		save.round = app.round
		save.boss = app.boss
		save.money = shop.money
		save.shopKeys = {}
		save.bagKeys = {}
		save.functionKeys = {}
		save.specialKeys = {}
		save.spacekeyX = 0
		save.highscore = app.highscore
		save.keysPressed = app.keysPressed

		-- Save shop keys
		for i, key in ipairs(shop.keys) do
			local typeChecker = tostring(key)
			local type = typeChecker == "instance of class FunctionKey" and "function" or "special"
			save.shopKeys[i] = {id = key.id, type = type}
		end

		-- Save letter keys
		for i, key in ipairs(keyboard.bagPile) do
			table.insert(save.bagKeys, letterKeyToSaveKey(key))
		end

		-- Save function keys
		for i, key in ipairs(keyboard.rows[1].keys) do
			table.insert(save.functionKeys, functionKeyToSaveKey(key))
		end

		-- Save special keys
		for i, key in ipairs(keyboard.rows[5].keys) do
			local typeChecker = tostring(key)
			local type = typeChecker == "instance of class SpecialKey" and "special" or "space"
			if type == "special" then table.insert(save.specialKeys, specialKeyToSaveKey(key))
			else save.spacekeyX = key.x end
		end
	end

	-- Write to save file
	saveTable = pprint.pformat(save)
	local success = f:write("return "..saveTable)
	if not success then print("Error occured in saving game!") end
	f:close()
end

loadGame = function()
	-- Load save file
	local ok, save = pcall(require, "savestate")
	if ok == false then return end
	if not save then return end

	-- Load vars
	monitor.screen.at = app
	app.introDia = false
	app.shopDia = save.shopDia
	app.hasWon = save.hasWon
	if save.blank then
		app.begin()
		return
	end
	app.round = save.round
	background.randomizeColor()
	app.boss = save.boss
	shop.money = save.money
	shop.keys = {}

	-- Load shop keys
	for i, key in ipairs(save.shopKeys) do
		if key.type == "special" then
			table.insert(shop.keys, SpecialKey:new(key.id, shop.x + shop.w, shop.center.y))
		elseif key.type == "function" then
			table.insert(shop.keys, FunctionKey:new(key.id, shop.x + shop.w, shop.center.y))
		end
	end

	-- Clear keyboard
	for i, row in ipairs(keyboard.rows) do
		row:clear()
		row.queue = {}
	end
	-- Empty bag
	keyboard.bagPile = {}

	-- Load bag with letter keys
	for i, key in ipairs(save.bagKeys) do
		table.insert(keyboard.bagPile, saveKeyToLetterKey(key))
	end

	-- Load function keys
	for i, key in ipairs(save.functionKeys) do
		keyboard.addKey(saveKeyToFunctionKey(key), 1)
	end

	-- Load special keys
	for i, key in ipairs(save.specialKeys) do
		keyboard.addKey(saveKeyToSpecialKey(key), 5)
	end

	-- Give space key
	keyboard.spacekey = SpaceKey:new(save.spacekeyX, 0, 250, 50)
	keyboard.addKey(keyboard.spacekey, 5)

	app.infoFields[4].value = app.teelValues[app.round]
	if app.round == 8 and app.boss == 2 then
		app.infoFields[4].value = app.infoFields[4].value * 2
	end
end

letterKeyToSaveKey = function(key)
	return {
		x = key.x,
		y = key.y,
		w = key.w,
		h = key.h,
		letter = key.letter,
		score = key.score,
		read = key.read,
		stamped = key.stamped,
		bullseyed = key.bullseyed,
	}
end

saveKeyToLetterKey = function(key)
	local retKey = LetterKey:new(key.x, key.y, key.w, key.h, key.letter, key.score)
	retKey.read = key.read
	retKey.stamped = key.stamped
	retKey.bullseyed = key.bullseyed
	return retKey
end

functionKeyToSaveKey = function(key)
	return {
		x = key.x,
		y = key.y,
		id = key.id
	}
end

saveKeyToFunctionKey = function(key)
	return FunctionKey:new(key.id, key.x, key.y)
end

specialKeyToSaveKey = function(key)
	return {
		x = key.x,
		id = key.id,
		blew = key.blew,
		read = key.read,
		xRead = key.xRead
	}
end

saveKeyToSpecialKey = function(key)
	local retKey = SpecialKey:new(key.id, key.x)
	retKey.blew = key.blew
	retKey.read = key.read
	retKey.xRead = key.xRead
	return retKey
end