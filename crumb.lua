local class = require 'middleclass'
require("misc")
require"tesound"

Crumb = class('Crumb')

function Crumb:initialize(x, y, fieldName, timeSinceLastCrumb)
	self.x = x
	self.y = y
	self.img = love.graphics.newImage("IMG/Crumb/"..fieldName..".png")
	local a = math.random()*math.pi*2
	self.dx = math.cos(a) * math.random()
	self.dy = math.sin(a) * math.random()
	self.ttl = 1
	self.time = 0
	local intensity = mid(0, .03 / timeSinceLastCrumb, 1)
	TEsound.play("SFX/Crumb/"..fieldName..".mp3", "static", {}, intensity/6 + .2, 1 - intensity/9)
end

function Crumb:update(dt)
	self.time = self.time + dt
	if self.time >= self.ttl then return true end
	self.x = self.x + self.dx
	self.y = self.y + self.dy
end

function Crumb:draw()
	local dir = self.dx > 0 and 1 or -1
	love.graphics.setColor(1,1,1, 1 - self.time)
	love.graphics.draw(self.img, self.x - 2.5, self.y - 2.5, self.time*dir, 1, 1, 2.5, 2.5)
end