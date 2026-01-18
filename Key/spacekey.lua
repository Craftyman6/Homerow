local class = require 'middleclass'
require("Key.key")

SpaceKey = class('SpaceKey', Key)

function SpaceKey:initialize(x, y, w, h)
	Key.initialize(self, x, y, w, h)
	self.name = "space"
	self.desc = "Space key | Unpresses all keys and submits typed word. If it's valid, your score is calculated. If not, well, that's not my department."
end

function SpaceKey:draw()
	Key.drawBasic(self, " ")
end

function SpaceKey:press()
	Key.press(self)
	monitor.screen.at.onSpacePress()
end