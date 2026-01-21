local class = require 'middleclass'
require"tesound"
require("misc")
message = require 'message'

Key = class('Key')

-- Initialize and assign variables (also just a nice list of them)
function Key:initialize(x, y, w, h)
	self.x = x
	self.y = y
	self.z = 5
	self.dispZ = 20
	self.w = w
	self.h = h
	self.left = {wallBlocked = false, dragBlocked = false, touchedKey = false, touchedKeyLastFrame = false}
	self.right = {wallBlocked = false, dragBlocked = false, touchedKey = false, touchedKeyLastFrame = false}
	self.time = 0
	self.pressed = false
	self.dragged = false
	self.draggedLastFrame = false
	self.hovered = false
	self.hoveredLastFrame = false
	self.collisioned = false
	self.baseCol = {1, 0.997, 0.922}
	self.labelCol = {.4, .4, .4}
	self.shadowCol = {0.8, 0.792, 0.686}
	self.name = "key"
	self.desc = ""
end

-- Assigns key to a row. Must be done before an update function is called on it
function Key:assignRow(row)
	self.row = row
end

-- Once a frame
function Key:update(dt)
	-- Update time
	if self.time == 0 then positionRatio = (self.x - self.row.x) / (self.row.w) TEsound.play("SFX/Key/bump.mp3", "static", {}, .2, math.random()/2 + positionRatio/4 + .7) end
	self.time = self.time + dt
	-- Ensure in bounds
	self:keepInBounds()
	-- Reset whether touching keys
	self.left.touchedKey = false; self.right.touchedKey = false
	-- Collide with other keys
	self:collideAll()
	self.row:resetCollision()
	-- Reset flag if didn't touch a key
	if not self.left.touchedKey then self.left.wallBlocked = self.pressed self.left.dragBlocked = false end
	if not self.right.touchedKey then self.right.wallBlocked = self.pressed self.right.dragBlocked = false end
	-- Bump SFX
	if not self.row:full() and ((not self.left.touchedKeyLastFrame and self.left.touchedKey) or (not self.right.touchedKeyLastFrame and self.right.touchedKey)) then
		positionRatio = (self.x - self.row.x) / (self.row.w)
		TEsound.play("SFX/Key/bump.mp3", "static", {}, .2, math.random()/2 + positionRatio/4 + .7)
	end
	self.left.touchedKeyLastFrame = self.left.touchedKey
	self.right.touchedKeyLastFrame = self.right.touchedKey
	self:keepInBounds()
	-- Set z
	if self.pressed then self.z = 0 elseif self.dragged then self.z = 10 elseif self.hovered then self.z = 3 else self.z = 5 end
	self.dispZ = easeTo(self.dispZ, self.z, dt*75)
	-- Reset dragged and hovered flags
	self.draggedLastFrame = self.dragged
	self.dragged = false
	self.hoveredLastFrame = self.hovered
	self.hovered = false
end


-- Checks key's collision with every key in row
function Key:collideAll()
	for i, key in ipairs(self.row.keys) do
		self:collide(key)
	end
end

-- Checks key's collision with a specific given key
function Key:collide(key)
	-- Ensure not collisioned again this cycle
	self.collisioned = true
	-- Returns
	if self == key then return end
	if not self:inHitbox(key.x, key:getCenterY()) and not self:inHitbox(key.x + key.w, key:getCenterY()) then return end
	-- Calc difference in x position
	xDif = self:getCenterX() - key:getCenterX()
	-- If colliding with a pressed key
	if key.pressed then 
		if xDif > 0 then self.left.wallBlocked = true self.left.touchedKey = true
		else self.right.wallBlocked = true self.right.touchedKey = true end
		if not key.collisioned then key:collideAll() end return 
	end
	-- Seperate if on top of eachother
	if math.abs(xDif) < 2 then
		self.x = self.x - 2
		key.x = key.x + 2
		xDif = self:getCenterX() - key:getCenterX()
	end


	-- If to the right of the key
	if (xDif > 0) then
		self.left.wallBlocked = key.left.wallBlocked or self.pressed
		self.left.dragBlocked = key.left.dragBlocked or key.dragged
		self.left.touchedKey = true
		if key.left.wallBlocked then return end
		if self.left.dragBlocked and not self.right.wallBlocked then return end
		key.x = self.x - key.w
	-- If to the left of the key
	else
		self.right.wallBlocked = key.right.wallBlocked or self.pressed
		self.right.dragBlocked = key.right.dragBlocked or key.dragged
		self.right.touchedKey = true
		if key.right.wallBlocked then return end
		if self.right.dragBlocked and not self.left.wallBlocked then return end
		key.x = self.x + self.w
	end
	key:keepInBounds()
	-- Recurse into collided key if haven't done so
	if not key.collisioned then key:collideAll() end
end

-- Attempt to drag key into given position. Returns whether it failed from standstill (for selling function and special keys)
function Key:drag(dt, x, y)
	-- SFX
	if not self.draggedLastFrame then 
		positionRatio = (self.x - self.row.x) / (self.row.w)
		TEsound.play("SFX/Key/drag.mp3", "static", {}, .3, math.random()/2 + positionRatio/4 + .6)
	end
	self.dragged = true
	dragSpd = 20
	-- Calc x dif
	xDif = self.x - x
	absXDif = math.abs(xDif)
	-- Returns
	if absXDif < 5 then return true end
	if xDif > 0 and self.left.wallBlocked then return
	elseif xDif < 0 and self.right.wallBlocked then return end
	-- Displace
	xMove = mid(-dragSpd, dt * absXDif * 10 * (xDif < 0 and 1 or -1), dragSpd)
	self.x = self.x + xMove
	--self:update()
	--self:keepInBounds()
end

-- Corrects key position if out of row's bounds
function Key:keepInBounds()
	self.x = mid(self.row.x, self.x, self.row.x + self.row.w - self.w)
	self.y = self.row.y
	if self.x == self.row.x then self.left.wallBlocked = true end
	if self.x == self.row.x + self.row.w - self.w then self.right.wallBlocked = true end
end

-- Returns whether given position is in key's hitbox
function Key:inHitbox(x, y)
	return x >= self.x and
		y >= self.y and
		x <= self.x + self.w and
		y <= self.y + self.h
end

-- Returns center positions of key
function Key:getCenterX()
	return (self.x + self.x + self.w) / 2
end
function Key:getCenterY()
	return (self.y + self.y + self.h) / 2
end

-- Less than overload for sorting
function Key:__lt(key)
	return self.x < key.x
end

-- More than overload for sorting
function Key:__gt(key)
	return self.x > key.x
end

-- Returns unit size of key (50px = 1)
function Key:size()
	return math.floor(self.w / 50)
end

-- Set hovered flag and play sfx if wasn't hovered before
-- Takes a sell cost
function Key:setHovered(sellCost)
	message.say(self.desc..((sellCost and keyboard.rows[5]:full()) and " | Hold in place to sell for $"..sellCost or ""), "clippy", true)
	if not self.hoveredLastFrame and not self.pressed then 
		positionRatio = (self.x - self.row.x) / (self.row.w)
		TEsound.play("SFX/Key/hover.mp3", "static", {}, .1, math.random()/2 + positionRatio/2 + .4)
	end
	self.hovered = true
end

-- Presses the key. Overwrite this method in subclasses
function Key:press()
	if self.pressed or self.dragged or self.draggedLastFrame or self.time < .5 then return true end
	self.pressed = true
	positionRatio = (self.x - self.row.x) / (self.row.w)
	TEsound.play("SFX/Key/press.mp3", "static", {}, .15, math.random()/2 + positionRatio/4 + .6)
	app.keysPressed = app.keysPressed + 1
	return false
end

-- Sets x position to random spot in row
function Key:randomizePosition()
	self.x = math.random()*(self.row.w - self.w) + self.row.x
end

-- Adds to the dsipZ
function Key:bounce()
	self.dispZ = self.dispZ + 10
end

function Key:drawBasic(label)
	-- Base
	if not self.pressed then
		rect(self.x + 5, self.y + 11 - self.dispZ, self.w - 10, self.dispZ + self.h - 15, self.shadowCol)
	end
	-- Top
	rect(self.x + 7, self.y + 8 - self.dispZ, self.w - 14, self.h - 16, self.baseCol)
	-- Text
	text(label, self.x + 12 - (#label < 4 and 0 or 3), self.y + 7 - self.dispZ + (#label < 3 and 0 or 8), #label < 3 and 20 or 16, self.labelCol)
end

function Key:drawImg(label)
	-- Base
	if not self.pressed then
		for i = 0, self.dispZ - 1 do
			img(self.img, self.x + 4, self.y  + 8 - i)
		end
	end
	-- Top
	img(self.img, self.x + 4, self.y + 8 - self.dispZ)
end