local class = require 'middleclass'
require("Key.key")

BluescreenKey = class('BluescreenKey', Key)

function BluescreenKey:initialize(x, y, w, h, label)
	Key.initialize(self, x, y, w, h)
	self.pressed = false
	self.label = label
end

function BluescreenKey:draw()
	Key.drawBasic(self, self.label)
end