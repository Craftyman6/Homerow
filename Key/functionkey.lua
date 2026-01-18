local class = require 'middleclass'
require"tesound"
message = require 'message'
functionKeyData = require 'Key.functionkeydata'
require("Key.key")
require("misc")

FunctionKey = class('FunctionKey', Key)

lastPressedFunctionKey = 1

function FunctionKey:initialize(id, x, y)
	local data = {}
	if id == nil then
		data = get_random_value(functionKeyData)
	else
		data = functionKeyData[id]
	end


	Key.initialize(self, x or 0, y or 0, data.w, data.h)
	self.id = id
	self.cost = data.cost
	self.name = data.name
	self.desc = self.name.." | "..data.desc
	self.ability = data.ability
	self.toLeave = false
	self.sellTime = 0
	self.sold = false
end

function FunctionKey:update(dt)
	if self.sold then shop.giveMoney(math.max(0, math.floor(self.cost/2))) return true end
	self.sellTime = self.dragged and self.sellTime or 0
	Key.update(self, dt)
	return self.toLeave
end

function FunctionKey:draw()
	Key.drawBasic(self, self.name)
end

function FunctionKey:drag(dt, x, y)
	if Key.drag(self, dt, x, y) then
		self.sellTime = self.sellTime + dt
		if self.sellTime >= 4 then self.sold = true return end
		message.say(sellMessages[1 + math.floor(self.sellTime)], "clippy", true)
	else
		self.sellTime = 0
	end
end

function FunctionKey:press()
	if Key.press(self) then return end
	lastPressedFunctionKey = self.id
	self.toLeave = self.ability(self)
	if not self.toLeave then
		message.say(get_random_value(failMessages), "idiot", false)
	else
		TEsound.play("SFX/Key/function"..mid(1, #keyboard.getPressedLetterKeys(), 3)..".mp3", "static", {}, .3)
	end
end

failMessages = {
	"looks like that didn't work",
	"what'd you think would happen?",
	"hate to say it but you should listen to clippy",
	"welp. there went that",
	"read the instructions next time",
	"womp womp",
	"failed!"
}

sellMessages = {
	"",
	"Selling key in 3...",
	"2...",
	"1...",
}