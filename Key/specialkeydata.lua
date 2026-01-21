commonWeight = 3
hiveKeyCost = 4
flowerCost = 6
commonCost = 8
uncommonWeight = 2
uncommonCost = 12
rareWeight = 1
rareCost = 20

specialKeyData = {
	-- 1: Hive key
	{
		name = "Hive key",
		desc = "+2 read when pressed",
		getDesc = function()
			return nil
		end,
		w = 50,
		h = 50,
		cost = hiveKeyCost,
		weight = 4,
		ability = function()
			app.addToInfoField(2, 2)
		end
	},
	-- 2: Mint hive key
	{
		name = "Mint hive key",
		desc = "+3 read if a 1 letter word is typed when pressed",
		getDesc = function()
			return nil
		end,
		w = 50,
		h = 50,
		cost = hiveKeyCost,
		weight = commonWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() ~= 1 then
				message.say("i see "..#keyboard.getPressedLetterKeys().." letters, not 1. dingus", "idiot", false)
			elseif not keyboard.typedWordIsValid() then
				message.say("there's only three 1 letter words and you've already forgotten them", "idiot", false)
			else
				app.addToInfoField(2, 3)
			end
		end
	},
	-- 3: Pink hive key
	{
		name = "Pink hive key",
		desc = "+3 read if a 2 letter word is typed when pressed",
		getDesc = function()
			return nil
		end,
		w = 50,
		h = 50,
		cost = hiveKeyCost,
		weight = commonWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() ~= 2 then
				message.say("i see "..#keyboard.getPressedLetterKeys().." letters, not 2. idiot", "idiot", false)
			elseif not keyboard.typedWordIsValid() then
				message.say(get_random_value(invalidWordMessages), "idiot", false)
			else
				app.addToInfoField(2, 3)
			end
		end
	},
	-- 4: Purple hive key
	{
		name = "Purple hive key",
		desc = "+4 read if a 3 letter word is typed when pressed",
		getDesc = function()
			return nil
		end,
		w = 50,
		h = 50,
		cost = hiveKeyCost,
		weight = commonWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() ~= 3 then
				message.say("i see "..#keyboard.getPressedLetterKeys().." letters, not 3. stupid", "idiot", "idiot", false)
			elseif not keyboard.typedWordIsValid() then
				message.say(get_random_value(invalidWordMessages), "idiot", false)
			else
				app.addToInfoField(2, 4)
			end
		end
	},
	-- 5: Brown hive key
	{
		name = "Brown hive key",
		desc = "+4 read if a 4 letter word is typed when pressed",
		getDesc = function()
			return nil
		end,
		w = 50,
		h = 50,
		cost = hiveKeyCost,
		weight = commonWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() ~= 4 then
				message.say("i see "..#keyboard.getPressedLetterKeys().." letters, not 4. wingnuts", "idiot", false)
			elseif not keyboard.typedWordIsValid() then
				message.say(get_random_value(invalidWordMessages), "idiot", false)
			else
				app.addToInfoField(2, 4)
			end
		end
	},
	-- 6: Grey hive key
	{
		name = "Grey hive key",
		desc = "x2 read if blew and read add up to less than 10 when pressed",
		getDesc = function()
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			if app.infoFields[1].value + app.infoFields[2].value < 10 then
				app.xToInfoField(2, 2)
			else
				message.say("i know "..app.infoFields[1].value.." + "..app.infoFields[2].value.." isn't less than 10, and i failed kindergarten!", "idiot", false)
			end
		end
	},
	-- 7: Red hive key
	{
		name = "Red hive key",
		desc = "+1 read for every 3 letter keys used this round when pressed",
		getDesc = function()
			return "Red hive key | +1 read for every 3 letter keys used this round  when pressed (Currently +"..math.floor(#keyboard.usedPile/3).." read)"
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			local toAdd = math.floor(#keyboard.usedPile/3)
			if toAdd <= 0 then
				message.say("not seeing many used keys, buckaroo", "idiot", false)
			else
				app.addToInfoField(2, toAdd)
			end
		end
	},
	-- 8: Blue hive key
	{
		name = "Blue hive key",
		desc = "+1 blew for every 4 unused letter keys in the bag when pressed",
		getDesc = function()
			return "Blue hive key | +1 read for every 4 letter keys used this round  when pressed (Currenty +"..math.floor(#keyboard.bagPile/4).." blew)"
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			local toAdd = math.floor(#keyboard.bagPile/4)
			if toAdd <= 0 then
				message.say("bag's emptier than my weekly block parties", idiot, false)
			else
				app.addToInfoField(1, toAdd)
			end
		end
	},
	-- 9: Gold hive key
	{
		name = "Gold hive key",
		desc = "+$1 when pressed",
		getDesc = function()
			return nil
		end,
		w = 50,
		h = 50,
		cost = 7,
		weight = commonWeight,
		ability = function()
			shop.giveMoney(1)
		end
	},
	-- 10: Green hive key
	{
		name = "Green hive key",
		desc = "+5 blew for each empty shop slot when pressed",
		getDesc = function()
			return "Green hive key | +5 blew for each empty shop slot when pressed (Currently +"..((4 - #shop.keys)*5).." blew)"
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			local toAdd = (4 - #shop.keys)*5
			if toAdd <= 0 then
				message.say("no pennypinchers allowed", "idiot", false)
			else
				app.addToInfoField(1, toAdd)
			end
		end
	},
	-- 11: Long hive key
	{
		name = "Long hive key",
		desc = "x2 read when pressed",
		getDesc = function()
			return nil
		end,
		w = 100,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			app.xToInfoField(2, 2)
		end
	},
	-- 12: Joker
	{
		name = "Joker",
		desc = "+4 read if there's a pressed A, K, Q or J letter key when pressed",
		getDesc = function()
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				local letter = string.lower(key.letter)
				if letter == "a" or letter == "k" or letter == "q" or letter == "j" then
					app.addToInfoField(2, 4)
					return
				end
			end
			message.say("what are you, a fool?", "idiot", false)
		end
	},
	-- 13: Yin and yang
	{
		name = "Yin and yang",
		desc = "Key gains +1 blew and +1 read if there are the same amount of vowels as consonants in letter keys pressed (>2 each) when pressed",
		getDesc = function(self, blew, read)
			return "Key gains +1 blew and +1 read if there are the same amount of vowels as consonants in letter keys pressed (>2 each) when pressed (Currently +"..blew.." blew +"..read.." read on press)"
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			local pressedLetterKeys = keyboard.getPressedLetterKeys()
			local letterCount = #pressedLetterKeys
			if letterCount > 3 and letterCount%2 == 0 then
				local vowelCount = 0
				local consonantCount = 0
				for i, key in ipairs(pressedLetterKeys) do
					if inList(vowels, key.letter) then vowelCount = vowelCount + 1 else consonantCount = consonantCount + 1 end
				end
				print(vowelCount.." vowels and "..consonantCount.." consonants")
				if vowelCount == consonantCount then print("shoulda returned") return 1, 1 end
			end
		end
	},
	-- 14: Eject button
	{
		name = "Eject button",
		desc = "Uses a random available exchange, then gives +20 blew when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			local useds = {}
			local availables = {}
			for i, exchange in ipairs(app.exchanges) do
				if exchange.used then table.insert(useds, i) end
				if exchange.available then table.insert(availables, i) end
			end
			if #useds >= 3 then
				message.say("what'd you do with your last exchanges?", "idiot", false)
			elseif #availables <= 0 then
				message.say("maybe press your letter keys AFTER trying to exchange?", "idiot", false)
			else
				app.exchange(get_random_value(availables))
				app.addToInfoField(1, 20)
			end
		end
	},
	-- 15: Volume up key
	{
		name = "Volume up key",
		desc = "+5 read if all exchanges are used when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			for i, exchange in ipairs(app.exchanges) do
				if not exchange.used then message.say("i don't think the computer heard you", "idiot", false) return end
			end
			app.addToInfoField(2, 5)
		end
	},
	-- 16: Mute key
	{
		name = "Mute key",
		desc = "+5 read if no exchanges are used when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			for i, exchange in ipairs(app.exchanges) do
				if exchange.used then message.say("that was botched. and no. you can't mute me", "idiot", false) return end
			end
			app.addToInfoField(2, 5)
		end
	},
	-- 17: Shuffle
	{
		name = "Shuffle",
		desc = "Randomly shuffles positions of letter keys in rows that don't contain pressed letter keys when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			local atLeastOneShuffled = false
			for i, row in ipairs(keyboard.getLetterRows()) do
				if #row:getPressedKeys() == 0 then
					row:shuffle()
					for i, key in ipairs(row.keys) do
						key:bounce()
					end
					atLeastOneShuffled = true
				end
			end
			if atLeastOneShuffled then return end
			message.say("you may wanna do the shuffle, but those keys don't")
		end
	},
	-- 18: TV Guide
	{
		name = "TV Guide",
		desc = "Key gains blew equivillant to the sum of the numbers on owned number keys when pressed",
		getDesc = function(self, blew, read)
			return "TV Guide | Key gains blew equivillant to the sum of the numbers on owned number keys when pressed (Currently +"..blew.." blew on press)"
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			local toAdd = 0
			for i, key in ipairs(keyboard.rows[1].keys) do
				if key.id < 8 then toAdd = toAdd + key.id end
			end
			return toAdd
		end
	},
	-- 19: Stanely Parable button
	{
		name = "Stanely Parable button",
		desc = "The end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end is never the end.",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			keyboard.rows[1]:unpressKeys()
			for i = 1, 10 do
				local toAddEndKey = FunctionKey:new(13)
				toAddEndKey.cost = 0
				if keyboard.addKey(toAddEndKey, 1) ~= 1 then return end
			end
		end
	},
	-- 20: Calculate button
	{
		name = "Calculate button",
		desc = "Gives number key of number equivilant to amount of function keys owned when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			local functionKeyCount = #keyboard.rows[1].keys
			if functionKeyCount == 0 then
				message.say("ah yes. the 0 key for your 0 letter words", "idiot", false)
			elseif functionKeyCount > 7 then
				message.say("what did you plan on doing with a "..functionKeyCount.." key anyways?", "idiot", false)
			else
				local error = keyboard.addKey(FunctionKey:new(functionKeyCount), 1)
				if error == -1 then
					message.say("not fittin, bud", "idiot", false)
				elseif error == -2 then
					message.say("you know the rules. no adding with pressed keys", "idiot", false)
				end
			end
		end
	},
	-- 21: Bookmark
	{
		name = "Bookmark",
		desc = "1/2 chance to give your last pressed function key when pressed",
		getDesc = function(self, blew, read)
			return "Bookmark | 1/2 chance to give your last pressed function key when pressed ("..functionKeyData[lastPressedFunctionKey].name..")"
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			if math.random() < .5 then
				message.say("nope!", "idiot", false)
				return
			end
			local error = keyboard.addKey(FunctionKey:new(lastPressedFunctionKey), 1)
			if error == -1 then
				message.say("i don't got no room for that!", "idiot", false)
			elseif error == -2 then
				message.say("you know the rules. no adding with pressed keys", "idiot", false)
			end
		end
	},
	-- 22: Cut
	{
		name = "Cut",
		desc = "x2 read if typed word is also a word without its last letter when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			typedWord = keyboard.getTypedWord()
			if #typedWord < 1 then
				message.say("where's the word?", "idiot", false) return
			elseif #typedWord < 2 then
				message.say("that word IS it's last letter", "idiot", false) return
			elseif not keyboard.typedWordIsValid() then
				message.say("that's not even a word to begin with", "idiot", false) return
			end
			local newWord = typedWord:sub(1, -2)
			if not dictionary.isWord(newWord) then
				message.say(newWord.." isn't a word i ever heard of", "idiot", false)
				return
			end
			app.xToInfoField(2, 2)
		end
	},
	-- 23: Seatbelt
	{
		name = "Seatbelt",
		desc = "Unpresses all vowel keys when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = rareCost,
		weight = rareWeight,
		ability = function()
			local pressedLetterKeys = keyboard.getPressedLetterKeys()
			for i, key in ipairs(pressedLetterKeys) do
				if inList(vowels, string.lower(key.letter)) then
					key.pressed = false
					key:bounce()
				end
			end
		end
	},
	-- 24: Elevator button
	{
		name = "Elevator button",
		desc = "Moves pressed letter keys up a row (if there's good room above them) when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			if #keyboard.rows[2]:getPressedKeys() > 0 then
				message.say("why would you want a key in the function key row?", "idiot", false)
				return
			end
			for row = 3, 4 do
				for i, key in ipairs(keyboard.rows[row]:getPressedKeys()) do
					-- Reuse attemptDrag function just to get if any key's hitbox touches a point
					if keyboard.attemptDrag(key.x, key.y - 25) ~= nil or keyboard.attemptDrag(key.x + key.w, key.y - 25) ~= nil then
						message.say("that "..key.letter.." key has a fella above him, methinks", "idiot", false)
						return
					end
				end
			end
			for row = 3, 4 do
				for i = #keyboard.rows[row].keys, 1, -1 do
					local key = keyboard.rows[row].keys[i]
					if key.pressed then
						table.insert(keyboard.rows[row - 1].keys, table.remove(keyboard.rows[row].keys, i))
						key:assignRow(keyboard.rows[row - 1])
					end
				end
			end
		end,
	},
	-- 25: Cash register button
	{
		name = "Cash register button",
		desc = "Gives $1 for every $10 you own when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			if shop.money < 10 then
				message.say("poor thing. literally", "idiot", false)
				return
			end
			shop.giveMoney(math.max(0, math.floor(shop.money/10)))
		end
	},
	-- 26: Uno reverse
	{
		name = "Uno reverse",
		desc = "Reverses positions of all keys when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			for i, row in ipairs(keyboard.rows) do
				row:reverse()
			end
		end
	},
	-- 27: Cart
	{
		name = "Cart",
		desc = "Restocks shop with function keys when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			local setBack = shop.specialChance
			shop.specialChance = 0
			shop.stock()
			shop.specialChance = setBack
		end
	},
	-- 28: Dice
	{
		name = "Dice",
		desc = "1/4 chance to capitalize all letter keys on the keyboard when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			if math.random() < .75 then
				message.say("nope!", "idiot", false)
				return
			end
			for i, key in ipairs(keyboard.getLetterKeys()) do
				key:capitalize()
			end
		end
	},
	-- 29: Rose
	{
		name = "Rose",
		desc = "+3 read for each pressed R, O, S or E key when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = flowerCost,
		weight = 4,
		ability = function()
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				local letter = string.lower(key.letter)
				if letter == "r" or letter == "o" or letter == "s" or letter == "e" then
					app.addToInfoField(2, 3)
				end
			end
			if string.lower(keyboard.getTypedWord()) == "rose" then
				message.say("Cash shower for your flower power!", "clippy", false)
				shop.giveMoney(10)
			end
		end
	},
	-- 30: Tulip
	{
		name = "Tulip",
		desc = "+3 read for each pressed T, U, L, I or P key when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = flowerCost,
		weight = 4,
		ability = function()
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				local letter = string.lower(key.letter)
				if letter == "t" or letter == "u" or letter == "l" or letter == "i" or letter == "p" then
					app.addToInfoField(2, 3)
				end
			end
			if string.lower(keyboard.getTypedWord()) == "tulip" then
				message.say("Cash shower for your flower power!", "clippy", false)
				shop.giveMoney(10)
			end
		end
	},
	-- 31: Lily
	{
		name = "Lily",
		desc = "+20 blew for each pressed L key. +10 blew for each pressed I or Y key when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = flowerCost,
		weight = 4,
		ability = function()
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				local letter = string.lower(key.letter)
				if letter == "l" then
					app.addToInfoField(1, 20)
				elseif letter == "i" or letter == "y" then
					app.addToInfoField(1, 10)
				end
			end
			if string.lower(keyboard.getTypedWord()) == "lily" then
				message.say("Cash shower for your flower power!", "clippy", false)
				shop.giveMoney(10)
			end
		end
	},
	-- 32: Mum
	{
		name = "Mum",
		desc = "+20 blew for each pressed M key. +10 blew for each pressed U key when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = flowerCost,
		weight = 4,
		ability = function()
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				local letter = string.lower(key.letter)
				if letter == "m" then
					app.addToInfoField(1, 20)
				elseif letter == "u" then
					app.addToInfoField(1, 10)
				end
			end
			if string.lower(keyboard.getTypedWord()) == "mum" then
				message.say("Cash shower for your flower power!", "clippy", false)
				shop.giveMoney(10)
			end
		end
	},
	-- 33: Thundercloud
	{
		name = "Thundercloud",
		desc = "Key gains +5 blew if typed word ends in \"er\" when pressed",
		getDesc = function(self, blew, read)
			return "Thundercloud | Key gains +5 blew if typed word ends in \"er\" when pressed (Currently +"..blew.." blew on press)"
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() == 0 then return end
			if not keyboard.typedWordIsValid() then
				message.say(get_random_value(invalidWordMessages), "idiot", false)
				return
			end
			if not keyboard.getTypedWord():sub(-2) == "er" then
				return
			end
			return 5
		end
	},
	-- 34: Detonate
	{
		name = "Detonate",
		desc = "Destroys all letter keys on keyboard when pressed. Self destructs",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 100,
		h = 50,
		cost = rareCost,
		weight = rareWeight,
		ability = function()
			for i, row in ipairs(keyboard.getLetterRows()) do
				row:clear()
			end
			TEsound.play("SFX/Key/detonate.mp3", "stream", {}, 2)
			return 0, 0, 0, true
		end
	},
	-- 35: Melded hive key
	{
		name = "Melded hive key",
		desc = "x3 read if there are two of the same letter keys pressed when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 100,
		h = 50,
		cost = rareCost,
		weight = rareWeight,
		ability = function()
			local index = {}
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				if index[key.letter] == nil then index[key.letter] = true
				else app.xToInfoField(2, 3) return end
			end
		end
	},
	-- 36: Kayak
	{
		name = "Kayak",
		desc = "x2 read if typed word is a palindrome (>2 letters) when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			if not keyboard.typedWordIsValid() then
				message.say(get_random_value(invalidWordMessages), "idiot", false)
				return 
			end
			local typedWord = keyboard.getTypedWord()
			if #typedWord == 0 then return end
			if typedWord ~= typedWord:reverse() then
				message.say("you're a little backwards, aren't you", "idiot", false)
			else
				app.xToInfoField(2, 2)
			end
		end
	},
	-- 37: Matador cape
	{
		name = "Matador cape",
		desc = "Key gains +1 read for each pressed function key when pressed",
		getDesc = function(self, blew, read)
			return "Key gains +1 read for each pressed function key when pressed (Currently +"..read.." read on press)"
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			ret = 0
			for i, key in ipairs(keyboard.rows[1]:getPressedKeys()) do
				ret = ret + 1
			end
			if ret == 0 then
				message.say("I don't see no pressed function keys", "idiot", false)
			end
			return 0, ret
		end
	},
	-- 38: Pride key
	{
		name = "Pride key",
		desc = "+2 blew, read, purp and teel for each pressed L, G, B, T or Q key when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			local count = 0
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				local letter = string.lower(key.letter)
				if letter == "l" or letter == "g" or letter == "b" or letter == "t" or letter == "q" then
					count = count + 1
				end
			end
			if count == 0 then
				message.say("what? still in the closet?", "idiot", false)
				return
			end
			for i = 1, 4 do
				app.addToInfoField(i, count*2)
			end
		end
	},
	-- 39: Stamp
	{
		name = "Stamp",
		desc = "Permanently increases pressed letter keys' base score by 2 when pressed",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				key.score = key.score + 2
				key.stamped = true
				key:bounce()
				TEsound.play("SFX/Key/stamp.mp3", "stream", {}, .5)
			end
		end
	},
	-- 40: Bullseye
	{
		name = "Bullseye",
		desc = "Permanently adds read to pressed letter keys based on how far their letters are from the end of typed word when pressed (e.x. \"kayak\" would give both a keys +1 read and the y key +2 read)",
		getDesc = function(self, blew, read)
			return nil
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			local pressedLetterKeys = keyboard.getPressedLetterKeys()
			table.sort(pressedLetterKeys)
			local size = #pressedLetterKeys
			if size < 3 then
				message.say("get better aim i guess", "idiot", false)
			end
			for i, key in ipairs(pressedLetterKeys) do
				local minDist = i - 1
				minDist = math.min(minDist, size - i)
				key.read = key.read + minDist
				if minDist > 0 then 
					key.bullseyed = true
					key:bounce()
					TEsound.play("SFX/Key/bullseye.mp3", "stream", {}, .3)
				end
			end
		end
	},
	-- 41: Ring
	{
		name = "Ring",
		desc = "Key gains x0.25 read if typed word ends in \"ng\" when pressed",
		getDesc = function(self, blew, read, xRead)
			return "Ring | Key gains x0.25 read if typed word ends in \"ng\" when pressed (Currently x"..xRead.." read on press)"
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			if #keyboard.getPressedLetterKeys() == 0 then return end
			if not keyboard.typedWordIsValid() then
				message.say(get_random_value(invalidWordMessages), "idiot", false)
				return
			end
			if keyboard.getTypedWord():sub(-2) ~= "ng" then
				return
			end
			TEsound.play("SFX/Key/ring.mp3", "stream", {}, .2)
			return 0, 0, .25
		end
	},
	-- 42: Microwave button
	{
		name = "Microwave button",
		desc = "Creates a random function key when pressed",
		getDesc = function(self, blew, read, xRead)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			local chance = shop.specialChance
			shop.specialChance = 0
			local _, keyID = shop.getRandomKey()
			shop.specialChance = chance
			local error = keyboard.addKey(FunctionKey:new(keyID), 1)
			if error == -1 then
				if keyboard.rows[1]:sizeLeft() > 0 then
					message.say("the key it chose was simply too wide. bummer", "idiot", false)
				else
					message.say("i don't got no room for that!", "idiot", false)
				end
			elseif error == -2 then
				message.say("you know the rules. no adding with pressed keys", "idiot", false)
			end
		end
	},
	-- 43: Capital
	{
		name = "Capital",
		desc = "Creates a SHIFT key when pressed if most keyboard keys are lowercase, or a CAPS key if most keyboard keys are uppercase",
		getDesc = function(self, blew, read, xRead)
			return nil
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function()
			local uppers = 0
			local lowers = 0
			for i, key in ipairs(keyboard.getLetterKeys()) do
				if key:isUpper() then uppers = uppers + 1 else lowers = lowers + 1 end
			end
			local keyToAdd = uppers < lowers and 8 or 9
			local error = keyboard.addKey(FunctionKey:new(keyToAdd), 1)
			if error == -1 then
				message.say("i don't got no room for that!", "idiot", false)
			elseif error == -2 then
				message.say("you know the rules. no adding with pressed keys", "idiot", false)
			end
		end
	},
	-- 44: Bubblewrap
	{
		name = "Bubblewrap",
		desc = "Key gains x0.01 read for each key pressed when pressed",
		getDesc = function(self, blew, read, xRead)
			return "Bubblewrap | Key gains x0.01 read for each key pressed when pressed (Currently x"..xRead.." read on press)"
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			local toAdd = 0
			for i, key in ipairs(keyboard.getPressedKeys()) do
				toAdd = toAdd + 0.01
			end
			return 0, 0, toAdd
		end
	},
	-- 45: Fish
	{
		name = "Fish",
		desc = "Says \"fish!\"",
		getDesc = function(self, blew, read, xRead)
			return nil
		end,
		w = 50,
		h = 50,
		cost = 1,
		weight = rareWeight,
		ability = function()
			if keyboard.getTypedWord() == "fish" then
				app.addToInfoField(1, 10000)
				app.addToInfoField(2, 10000)
				TEsound.play("SFX/Key/fish-hit.mp3", "stream", {}, .1)
			else
				TEsound.play("SFX/Key/fish.mp3", "stream", {}, .1)
			end
		end
	},
	-- 46: Squish button
	{
		name = "Squish button",
		desc = "Squishes as many letter keys as possible into rows (that don't have pressed keys) when pressed",
		getDesc = function(self, blew, read, xRead)
			return nil
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			keyboard.fillAllTheWay()
		end
	},
	-- 47: Honk
	{
		name = "Honk",
		desc = "Key gains x0.25 read when honked. Scares away random amount of function and letter keys",
		getDesc = function(self, blew, read, xRead)
			return "Honk | Key gains x0.25 read when honked. Scares away random amount of function and letter keys (Currently x"..xRead.." read on honk)"
		end,
		w = 50,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			for i = #keyboard.rows[1].keys, 1, -1 do
				if math.random() < .5 then
					table.remove(keyboard.rows[1].keys, i)
				end
			end
			for j, row in ipairs(keyboard.getLetterRows()) do
				for i = #row.keys, 1, -1 do
					if math.random() < .5 then
						table.insert(keyboard.usedPile, table.remove(row.keys, i))
					end
				end
			end
			TEsound.play("SFX/Key/honk.mp3", "stream", {}, .1)
			return 0, 0, 0.25
		end
	},
	-- 48: Bridge
	{
		name = "Bridge",
		desc = "Key gains +4 blew if a pressed key is touching the left edge. Gains +2 read if a pressed key is touching the right edge",
		getDesc = function(self, blew, read, xRead)
			return "Bridge | Key gains +4 blew if a pressed key is touching the left edge when pressed. Gains +2 read if a pressed key is touching the right edge when pressed (Currently +"..blew.." blew +"..read.." read on press)"
		end,
		w = 100,
		h = 50,
		cost = uncommonCost,
		weight = uncommonWeight,
		ability = function()
			local pressedLetterKeys = keyboard.getPressedLetterKeys()
			if #pressedLetterKeys == 0 then return end
			table.sort(pressedLetterKeys)
			local blewToAdd = 0
			local readToAdd = 0
			local leftmostKey = pressedLetterKeys[1]
			local rightmostKey = pressedLetterKeys[#pressedLetterKeys]
			if leftmostKey.x < leftmostKey.row.x + 1 then blewToAdd = 4 end
			if rightmostKey.x > rightmostKey.row.x + rightmostKey.row.w - rightmostKey.w - 1 then readToAdd = 2 end
			return blewToAdd, readToAdd
		end
	},
	-- 49: Crowbar
	{
		name = "Crowbar",
		desc = "Unpresses closest special key when pressed (left key if touching two). Swaps position of crowbar and space key if closest key is the space key",
		getDesc = function(self, blew, read, xRead)
			return nil
		end,
		w = 50,
		h = 50,
		cost = 25,
		weight = rareWeight,
		ability = function(self)
			local specialRow = keyboard.rows[5]
			local closestDist = specialRow.w
			local IDOfKeyToUnpress = 0
			for i, key in ipairs(specialRow.keys) do
				if key ~= self then
					if key.x < self.x and self.x - (key.x + key.w) < closestDist then
						closestDist = self.x - (key.x + key.w)
						IDOfKeyToUnpress = i
					elseif self.x < key.x and key.x - (self.x + self.w) < closestDist then
						closestDist = key.x - (self.x + self.w)
						IDOfKeyToUnpress = i
					end
				end
			end
			if IDOfKeyToUnpress == 0 then return end
			local keyToUnpress = specialRow.keys[IDOfKeyToUnpress]
			if tostring(keyToUnpress) == "instance of class SpaceKey" then
				local centerX = 0
				if self.x < keyToUnpress.x then
					centerX = (keyToUnpress.x + keyToUnpress.w - self.x)/2 + self.x
				else
					centerX = (self.x + self.w - keyToUnpress.x)/2 + keyToUnpress.x
				end

				local crowbarCenterX = self.x + self.w/2
				local newCrowbarCenterX = centerX + (centerX - crowbarCenterX)
				self.x = newCrowbarCenterX - self.w/2

				local spaceCenterX = keyToUnpress.x + keyToUnpress.w/2
				local newSpaceCenterX = centerX + (centerX - spaceCenterX)
				keyToUnpress.x = newSpaceCenterX - keyToUnpress.w/2

				return
			end
			keyToUnpress.pressed = false
		end
	},
	-- 50: Radio
	{
		name = "Radio",
		desc = "+5 read for each pressed letter key of a randomly given pool of letters when pressed (letters change every round)",
		getDesc = function(self, blew, read, xRead)
			local letterText = ""
			for i, letter in ipairs(radioLetters) do
				letterText = letterText.." "..radioLetters[i]
			end
			return "Radio |"..letterText.." | +5 read for each pressed letter key of a randomly given pool of letters (letters change every round)"
		end,
		w = 50,
		h = 50,
		cost = commonCost,
		weight = commonWeight,
		ability = function(self)
			for i, key in ipairs(keyboard.getPressedLetterKeys()) do
				for j, letter in ipairs(radioLetters) do
					if string.upper(key.letter) == letter then
						app.addToInfoField(2, 5)
					end
				end
			end
		end
	}
}

invalidWordMessages = {
	"bad news. that ain't valid",
	"how hard could spelling words be?",
	"haha! you thought that was a word. funny",
	"check a dictionary next time",
	"you know you can just google these things, right?",
	"you need a couple more vocab lessons"
}

return specialKeyData