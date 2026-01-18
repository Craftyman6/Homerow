local class = require 'middleclass'
message = require 'message'
require("Key.key")

LetterKey = class('LetterKey', Key)

function LetterKey:initialize(x, y, w, h, letter, score)
	Key.initialize(self, x, y, w, h)
	self.letter = letter
	self.score = score
	self.blew = self.score
	self.read = 1
	self.name = self.letter
	self.desc = self.letter.." key"
	self.stamped = false
	self.bullseyed = false
end

function LetterKey:update(dt)
	self.blew = self.score + (self:isUpper() ~= nil and self.score or 0)
	self.desc = self.letter.." key | +"..self.blew.." blew | +"..self.read.." read"..
		(self:isUpper() and " | Uppercase (blew given is double its score)" or "")
	Key.update(self, dt)
end

function LetterKey:draw()
	Key.drawBasic(self, self.letter)
	if self.stamped then
		circ(self.x + 33, self.y + 18 - self.dispZ, 5, {0,0,1})
	end
	if self.bullseyed then
		for i = 0, 2 do
			local white = i==1 and 1 or 0
			circ(self.x + 33, self.y + 33 - self.dispZ, 6 - 2*i, {1,white,white})
		end
	end

	-- Test flags
	--[[
	local testFlagSize = 2
	if self.left.wallBlocked then
		rect(self.x + 5, self.y + 4, testFlagSize, testFlagSize, {0, 0, 0})
	end
	if self.right.wallBlocked then
		rect(self.x + self.w - 5, self.y + 4, testFlagSize, testFlagSize, {0, 0, 0})
	end
	if self.left.dragBlocked then
		rect(self.x + 5, self.y + self.h - 4, testFlagSize, testFlagSize, {0, 0, 0})
	end
	if self.right.dragBlocked then
		rect(self.x + self.w - 5, self.y + self.h - 4, testFlagSize, testFlagSize, {0, 0, 0})
	end
	if self.left.touchedKey then
		rect(self.x + 5, self:getCenterY(), testFlagSize, testFlagSize, {0, 0, 0})
	end
	if self.right.touchedKey then
		rect(self.x + self:getCenterY(), self.y + self.h - 4, testFlagSize, testFlagSize, {0, 0, 0})
	end
	]]
end

function LetterKey:drag(dt, x, y)
	if app.round == 8 and app.boss == 3 then return end
	Key.drag(self, dt, x, y)
end

function LetterKey:press()
	if #keyboard.getPressedLetterKeys() >= 7 then 
		if monitor.screen.at == app then message.say(get_random_value(cantPressMessagePool), "idiot", false) end
		return
	end
	if Key.press(self) then return end
	app.addToInfoField(1, self.blew)
	app.addToInfoField(2, self.read)
end

function LetterKey:toggleCase()
	if self.letter:match("%l") then self.letter = self.letter:upper() else self.letter = self.letter:lower() end
	Key.bounce(self)
end

function LetterKey:isUpper()
	return self.letter:match("%u")
end

function LetterKey:capitalize()
	self.letter = self.letter:upper()
	Key.bounce(self)
end

function LetterKey:progress()
	local letterAsByte = self.letter:byte()
	-- Uppercase
	if letterAsByte >= 65 and letterAsByte <= 90 then
		self.letter = string.char(letterAsByte == 90 and 65 or (letterAsByte+1))
	-- Lowercase
	elseif letterAsByte >= 97 and letterAsByte <= 122 then
		self.letter = string.char(letterAsByte == 122 and 97 or (letterAsByte+1))
	end
	Key.bounce(self)
end

cantPressMessagePool = {
	"okay mr \"i know eight letter words\"",
	"is seven keys not enough?",
	"even i can't count to eight",
	"everyone knows there are no eight letter words",
	"but seven keys is so... prime",
	"no more than seven, idiot",
	"you just want to press them all, don't you"
}