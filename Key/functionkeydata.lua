numberCost = 1
numberWeight = 1
functionCost = 2
functionWeight = 2
fnEscCost = 3
fnEscWeight = 1

functionKeyData = {
	-- 1: 1
	{
		name = "1",
		desc = "x1.5 read if a valid 1 letter word is typed",
		w = 50,
		h = 50,
		cost = numberCost,
		weight = numberWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() == 1 and keyboard.typedWordIsValid() then
			app.xToInfoField(2, 1.5) return true else return false end
		end
	},
	-- 2: 2
	{
		name = "2",
		desc = "x1.5 read if a valid 2 letter word is typed",
		w = 50,
		h = 50,
		cost = numberCost,
		weight = numberWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() == 2 and keyboard.typedWordIsValid() then
			app.xToInfoField(2, 1.5) return true else return false end
		end
	},
	-- 3: 3
	{
		name = "3",
		desc = "x1.5 read if a valid 3 letter word is typed",
		w = 50,
		h = 50,
		cost = numberCost,
		weight = numberWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() == 3 and keyboard.typedWordIsValid() then
			app.xToInfoField(2, 1.5) return true else return false end
		end
	},
	-- 4: 4
	{
		name = "4",
		desc = "x1.5 read if a valid 4 letter word is typed",
		w = 50,
		h = 50,
		cost = numberCost,
		weight = numberWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() == 4 and keyboard.typedWordIsValid() then
			app.xToInfoField(2, 1.5) return true else return false end
		end
	},
	-- 5: 5
	{
		name = "5",
		desc = "x1.5 read if a valid 5 letter word is typed",
		w = 50,
		h = 50,
		cost = numberCost,
		weight = numberWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() == 5 and keyboard.typedWordIsValid() then
			app.xToInfoField(2, 1.5) return true else return false end
		end
	},
	-- 6: 6
	{
		name = "6",
		desc = "x1.5 read if a valid 6 letter word is typed",
		w = 50,
		h = 50,
		cost = numberCost,
		weight = numberWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() == 6 and keyboard.typedWordIsValid() then
			app.xToInfoField(2, 1.5) return true else return false end
		end
	},
	-- 7: 7
	{
		name = "7",
		desc = "x1.5 read if a valid 7 letter word is typed",
		w = 50,
		h = 50,
		cost = numberCost,
		weight = numberWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() == 7 and keyboard.typedWordIsValid() then
			app.xToInfoField(2, 1.5) return true else return false end
		end
	},
	-- 8: SHIFT
	{
		name = "SHIFT",
		desc = "Capitalizes pressed letter keys",
		w = 100,
		h = 50,
		cost = 1,
		weight = functionWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() > 0 then
				for i, key in ipairs(keyboard.getPressedLetterKeys()) do
					key:capitalize()
				end
				return true
			end
			return false
		end
	},
	-- 9: CAPS
	{
		name = "CAPS",
		desc = "Capitalizes and uncapitalizes letter keys of a random row",
		w = 100,
		h = 50,
		cost = functionCost,
		weight = functionWeight,
		ability = function()
			for i, key in ipairs(get_random_value(keyboard.getLetterRows()).keys) do
				key:toggleCase()
			end
			return true
		end
	},
	-- 10: BACKSPACE
	{
		name = "BACKSPACE",
		desc = "Removes up to three pressed letter keys",
		w = 100,
		h = 50,
		cost = functionCost,
		weight = functionWeight,
		ability = function()
			local pressedLetterKeys = #keyboard.getPressedLetterKeys()
			if pressedLetterKeys < 1 or pressedLetterKeys > 3 then return false end
			for i, row in ipairs(keyboard.getLetterRows()) do
				row:clearPressedKeys()
			end
			return true
		end
	},
	-- 11: ALT
	{
		name = "ALT",
		desc = "Progresses pressed letter keys along the alphabet (A -> B)",
		w = 50,
		h = 50,
		cost = functionCost,
		weight = functionWeight,
		ability = function()
			local pressedLetterKeys = #keyboard.getPressedLetterKeys()
			if pressedLetterKeys < 1 then return false end
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				key:progress()
			end
			return true
		end
	},
	-- 12: HOME
	{
		name = "HOME",
		desc = "Moves up to one pressed letter key per row to the left edge",
		w = 50,
		h = 50,
		cost = functionCost,
		weight = functionWeight,
		ability = function()
			local tooMuch = false
			local notEnough = true
			for i, row in ipairs(keyboard.getLetterRows()) do
				local pressedKeys = #row:getPressedKeys()
				if pressedKeys > 0 then notEnough = false end
				if pressedKeys > 1 then tooMuch = true end
			end
			if tooMuch or notEnough then return false end
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				for i, otherKey in ipairs(key.row.keys) do
					if otherKey < key then
						otherKey.x = otherKey.x + key.w
					end
				end
				key.x = key.row.x
			end
			return true
		end
	},
	-- 13: END
	{
		name = "END",
		desc = "Moves up to one pressed letter key per row to the right edge",
		w = 50,
		h = 50,
		cost = functionCost,
		weight = functionWeight,
		ability = function()
			local tooMuch = false
			local notEnough = true
			for i, row in ipairs(keyboard.getLetterRows()) do
				local pressedKeys = #row:getPressedKeys()
				if pressedKeys > 0 then notEnough = false end
				if pressedKeys > 1 then tooMuch = true end
			end
			if tooMuch or notEnough then return false end
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				for i, otherKey in ipairs(key.row.keys) do
					if otherKey > key then
						otherKey.x = otherKey.x - key.w
					end
				end
				key.x = key.row.x + key.row.w - key.w
			end
			return true
		end
	},
	-- 14: TAB
	{
		name = "TAB",
		desc = "Gives $1 for each pressed key",
		w = 100,
		h = 50,
		cost = 3,
		weight = functionWeight,
		ability = function()
			shop.giveMoney(#keyboard.getPressedKeys())
			return true
		end
	},
	-- 15: DEL
	{
		name = "DEL",
		desc = "Removes all letter keys of a random row",
		w = 50,
		h = 50,
		cost = functionCost,
		weight = functionWeight,
		ability = function()
			get_random_value(keyboard.getLetterRows()):clear()
			return true
		end
	},
	-- 16: NUM LOCK
	{
		name = "NUM LOCK",
		desc = "Creates 2 random number keys",
		w = 100,
		h = 50,
		cost = functionCost,
		weight = functionWeight,
		ability = function(self)
			local numPool = {1,2,3,4,5,6,7}
			local toAdd = {}
			local alreadyOwned = {false, false, false, false, false, false, false}
			-- Check the num keys already owned
			for i, key in ipairs(keyboard.rows[1].keys) do
				if key.id < 8 then alreadyOwned[key.id] = true end
			end
			-- Remove already owned keys from the pool
			for i = #alreadyOwned, 1, -1 do
				if alreadyOwned[i] then table.remove(numPool, i) end
			end
			-- Prepare two num keys to add
			for i = 1, 2 do
				if #numPool > 0 then
					table.insert(toAdd, table.remove(numPool, math.floor(math.random()*#numPool+1)))
				else
					table.insert(toAdd, i)
				end
			end
			-- Add them
			for i, add in ipairs(toAdd) do
				table.insert(keyboard.rows[1].queue, FunctionKey:new(add, self.x - 50 + 50*i))
			end
			-- Throw the key at the right so that it gets updated first and thus deleted first so it doesn't collide with new keys
			self.x = self.row.x + self.row.w
			return true
		end
	},
	-- 17: CTRL
	{
		name = "CTRL",
		desc = "Turns pressed letter keys into rightmost pressed letter key. Unpresses rightmost pressed letter key.",
		w = 50,
		h = 50,
		cost = functionCost,
		weight = functionWeight,
		ability = function(self)
			local pressedLetterKeys = keyboard.getPressedLetterKeys()
			if #pressedLetterKeys < 2 then return false end
			table.sort(pressedLetterKeys)
			local rightmostPressed = pressedLetterKeys[#pressedLetterKeys]
			for i, key in ipairs(pressedLetterKeys) do
				key.letter = rightmostPressed.letter
				key.score = rightmostPressed.score
			end
			pressedLetterKeys[#pressedLetterKeys].pressed = false
			return true
		end
	},
	-- 18: FN
	{
		name = "FN ",
		desc = "Creates a copy of its closest function key (copies right key if touching two)",
		w = 50,
		h = 50,
		cost = fnEscCost,
		weight = fnEscWeight,
		ability = function(self)
			local closestDist = self.row.w
			local keyToCopy = 0
			for i, key in ipairs(keyboard.rows[1].keys) do
				if key ~= self then
					if key.x < self.x and self.x - (key.x + key.w) < closestDist then
						closestDist = self.x - (key.x + key.w)
						keyToCopy = key.id
					elseif self.x < key.x and key.x - (self.x + self.w) < closestDist then
						closestDist = key.x - (self.x + self.w)
						keyToCopy = key.id
					end
				end
			end
			if keyToCopy == 0 then return false end
			if self.row:sizeLeft() + 1 < functionKeyData[keyToCopy].w/50 then return false end
			table.insert(keyboard.rows[1].queue, FunctionKey:new(keyToCopy, self.x - (1/self:size())*50 + 50))
			-- Throw the key at the right so that it gets updated first and thus deleted first so it doesn't collide with new key
			self.x = self.row.x + self.row.w - self.w
			return true
		end
	},
	-- 19: ESC
	{
		name = "ESC",
		desc = "Unpresses up to two letter keys",
		w = 50,
		h = 50,
		cost = fnEscCost,
		weight = fnEscWeight,
		ability = function(self)
			pressedLetterKeys = keyboard.getPressedLetterKeys()
			if #pressedLetterKeys == 0 or #pressedLetterKeys > 2 then return false end
			for i, key in ipairs(pressedLetterKeys) do
				key.pressed = false
			end
			return true
		end
	}
}

return functionKeyData