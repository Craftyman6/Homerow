local class = require 'middleclass'
require"tesound"
message = require 'message'
specialKeyData = require 'Key.specialkeydata'
require("Key.key")
require("misc")

SpecialKey = class('SpecialKey', Key)

function SpecialKey:initialize(id, x, y)
	local data = {}
	if id == nil then
		data = get_random_value(specialKeyData)
	else
		data = specialKeyData[id]
	end

	Key.initialize(self, x or 0, y or 0, data.w, data.h)
	self.id = id
	self.cost = data.cost
	self.name = data.name
	self.desc = self.name.." | "..data.desc
	self.ability = data.ability
	self.sellTime = 0
	self.sold = false
	self.img = love.graphics.newImage("IMG/SpecialKey/"..self.name..".png")
	self.blew = 0
	self.read = 0
	self.xRead = 1
	self.toLeave = false
	self.getDesc = data.getDesc
end

function SpecialKey:update(dt)
	if self.sold then shop.giveMoney(math.max(0, math.floor(self.cost/2))) return true end
	self.desc = self:getDesc(self.blew, self.read, self.xRead) or self.desc
	self.sellTime = self.dragged and self.sellTime or 0
	Key.update(self, dt)
	return self.toLeave
end

function SpecialKey:draw()
	Key.drawImg(self, self.name)
end

function SpecialKey:drag(dt, x, y)
	if Key.drag(self, dt, x, y) then
		self.sellTime = self.sellTime + dt
		if self.sellTime >= 4 then self.sold = true return end
		message.say(sellMessages[1 + math.floor(self.sellTime)], "clippy", true)
	else
		self.sellTime = 0
	end
end

function SpecialKey:press()
	if Key.press(self) then return end
	local blew, read, xRead, leave = self.ability(self)
	self.toLeave = leave
	self.blew = self.blew + (blew or 0)
	self.read = self.read + (read or 0)
	self.xRead = self.xRead + (xRead or 0)
	app.addToInfoField(1, self.blew)
	app.addToInfoField(2, self.read)
	app.xToInfoField(2, self.xRead)
end

sellMessages = {
	"",
	"Selling key in 3...",
	"2...",
	"1...",
}

radioLetters = {"a", "b", "c", "d"}

function refreshRadio()
	local options = shallow_copy(alphabet)
	radioLetters = {}
	for i = 1, 4 do
		table.insert(radioLetters, table.remove(options, math.floor(math.random()*#options)+1))
		radioLetters[i] = string.upper(radioLetters[i])
	end
end