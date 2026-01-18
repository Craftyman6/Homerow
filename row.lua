local class = require 'middleclass'
require("misc")
require("Key.key")

Row = class('Row')

-- Initialize vars
function Row:initialize(x, y, w)
	self.x = x
	self.y = y
	self.w = w
	self.keys = {}
	self.queue = {}
	self.borderCol = {0.8, 0.792, 0.686}
end

-- Fills row to allowed cap with random keys of given bag pile
function Row:fill(bagPile)
	for i = 0, 5 - (#self.keys + #self.queue) do
		if #bagPile <= 0 then return end
		randID = math.floor(math.random()*#bagPile + 1)
		self:addKey(table.remove(bagPile, randID))
	end
end

-- Fills row with keys until its entirely full (Squish button)
function Row:fillAllTheWay(bagPile)
	for i = 0, 9 - (#self.keys + #self.queue) do
		if #bagPile <= 0 then return end
		randID = math.floor(math.random()*#bagPile + 1)
		self:addKey(table.remove(bagPile, randID))
	end
end

-- Once per frame
function Row:update(dt)
	-- Add queued key
	if #self.queue > 0 then
		key = table.remove(self.queue, 1)
		key:assignRow(self)
		if key.x == 0 then key:randomizePosition() end
		table.insert(self.keys, key)
	end
	-- Update keys
	table.sort(self.keys)
	for i = #self.keys, 1, -1 do
		if self.keys[i]:update(dt) then
			table.remove(self.keys, i)
		end
	end
end

-- Attempt to add key to row. Returns 1 if successful
-- Returns -1 if row too full, or -2 if there's a pressed key
function Row:addKey(key)
	if self:sizeLeft() < key:size() then return -1
	elseif #self:getPressedKeys() > 0 then return -2 end
	table.insert(self.queue, key)
	return 1
end

function Row:draw()
	-- Division line
	line(self.x,
		self.y+50,
		self.x+keyboard.w,
		self.y+50,
		1, self.borderCol
	)
	for i, key in ipairs(self.keys) do
		key:draw()
	end
end

-- Returns list of all keys
function Row:getKeys()
	return self.keys
end

-- Returns list of all pressed keys
function Row:getPressedKeys()
	local retList = {}
	for i, key in ipairs(self.keys) do
		if key.pressed then
			table.insert(retList, key)
		end
	end
	return retList
end

-- SIZE GETTERS
-- Returns the size, i.e. how many keys are in the row (wide keys count as two)
function Row:size()
	total = 0
	for i, key in ipairs(self.keys) do
		total = total + key:size()
	end
	for i, key in ipairs(self.queue) do
		total = total + key:size()
	end
	return total
end
-- Returns the size limit of the row (will most likely always be 10)
function Row:maxSize()
	return math.floor(self.w / 50)
end
-- Return how much size is left i.e. the largest key/amount of keys that can fit
function Row:sizeLeft()
	return self:maxSize() - self:size()
end
-- Returns whether the row is currently completely full
function Row:full()
	return self:size() >= self:maxSize()
end

-- Reset collisioned flag of all of row's keys
function Row:resetCollision()
	for i, key in ipairs(self.keys) do
		key.collisioned = false
	end
end

-- Deletes all keys (returns list of the deleted ones)
function Row:clear()
	local retList = {}
	for i = 1, #self.keys do
		retList[i] = self.keys[i]
		self.keys[i] = nil
	end
	return retList
end

-- Unpresses all keys
function Row:unpressKeys()
	for i, key in ipairs(self.keys) do
		key.pressed = false
	end
end

-- Moves pressed keys to used pile
function Row:useKeys()
	for i = #self.keys, 1, -1 do
		if self.keys[i].pressed then
			table.insert(keyboard.usedPile, table.remove(self.keys, i))
		end
	end
end

-- Removes pressed keys
function Row:clearPressedKeys()
	for i = #self.keys, 1, -1 do
		if self.keys[i].pressed then
			table.remove(self.keys, i)
		end
	end
end

-- Randomizes positiions of keys
function Row:shuffle()
	for i, key in ipairs(self.keys) do
		key:randomizePosition()
	end
end

-- Reverse positions of key
function Row:reverse()
	for i, key in ipairs(self.keys) do
		local rowCenterX = self.x + self.w/2
		local keyCenterX = key.x + key.w/2
		local newKeyCenterX = rowCenterX + (rowCenterX - keyCenterX)
		key.x = newKeyCenterX - key.w/2
		key:bounce()
	end
end