require("misc")
require("Key.key")
require("row")
require("Key.letterkey")
require("Key.spacekey")
require("Key.bluescreenkey")
require("Key.functionkey")
require("Key.specialkey")
local dictionary = require 'Dict.dictionary'

keyboard = {
	x = 13,
	y = 450,
	w = 500,
	h = 250,
	rows = {
		Row:new(13, 450, 500),
		Row:new(13, 500, 500),
		Row:new(13, 550, 500),
		Row:new(13, 600, 500),
		Row:new(13, 650, 500)
	},
	bagPile = {},
	bagPileString = "",
	usedPile = {},
	usedPileString = "",
	queue = {},
	borderCol = {0.8, 0.792, 0.686},
	baseCol = {0.949, 0.941, 0.8274},

	-- INIT
	init = function()
		dictionary.init()
	end,

	-- UPDATE
	update = function(dt)
		-- Add queued key
		if #keyboard.queue > 0 then
			local queuedKey = shallow_copy(keyboard.queue[1])
			keyboard.rows[queuedKey.row]:addKey(queuedKey.key)
			table.remove(keyboard.queue, 1)
		end
		-- Hornet
		if app.round == 8 and app.boss == 1 and not app.hornetted
		and #keyboard.getLetterKeys() ~= 0
		and #keyboard.getQueuedLetterKeys() == 0 then
			get_random_value(keyboard.getLetterKeys()):press()
			app.hornetted = #keyboard.getPressedLetterKeys() ~= 0
		end
		for i, row in ipairs(keyboard.rows) do
			row:update(dt)
		end
	end,

	-- DRAW
	draw = function()
		-- Border
		rect(keyboard.x - 4, keyboard.y - 2, keyboard.w + 8, keyboard.h + 14, keyboard.borderCol)
		-- Base
		rect(keyboard.x, keyboard.y, keyboard.w, keyboard.h, keyboard.baseCol)
		-- All rows and keys
		for i, row in ipairs(keyboard.rows) do
			row:draw()
		end
	end,

	-- ADD KEY
	addKey = function(key, row) 
		return keyboard.rows[row]:addKey(key)
	end,

	-- PILE FUNCTIONS
	-- Sets bag pile to initial state
	initializeBagPile = function()
		keyboard.bagPile = {}
		for i, key in ipairs(beginningKeysData) do
			table.insert(keyboard.bagPile, LetterKey:new(0, 0, 50, 50, key.letter, key.score))
		end
		keyboard.updatePileStrings()
	end,
	-- Fills keyboard with as many bag pile keys as allowed
	fill = function()
		for i, row in ipairs(keyboard.getLetterRows()) do
			row:fill(keyboard.bagPile)
		end
		keyboard.updatePileStrings()
	end,
	-- Fills keyboard with as many bag pile keys as possible (Squish button)
	fillAllTheWay = function()
		for i, row in ipairs(keyboard.getLetterRows()) do
			if #row:getPressedKeys() == 0 then
				row:fillAllTheWay(keyboard.bagPile)
			end
		end
		keyboard.updatePileStrings()
	end,
	-- Returns keys from keyboard and used pile to bag pile
	returnToBag = function()
		-- Return keyboard keys
		for i, row in ipairs(keyboard.getLetterRows()) do
			for i, key in ipairs(row:clear()) do
				table.insert(keyboard.bagPile, key)
			end
		end
		-- Return used keys
		for i = #keyboard.usedPile, 1, -1 do
			table.insert(keyboard.bagPile, table.remove(keyboard.usedPile, i))
		end
		-- Reset all keys' times and pressed
		for i, key in ipairs(keyboard.bagPile) do
			key.time = 0
			key.x = 0
			key.pressed = false
		end
		keyboard.updatePileStrings()
	end,
	-- Moves pressed letter keys to used pile
	usePressedLetterKeys = function()
		for i = 2, 4 do
			keyboard.rows[i]:useKeys()
		end
		keyboard.updatePileStrings()
	end,
	exchangeRow = function(rowID)
		local row = keyboard.rows[rowID]
		for i, key in ipairs(row:clear()) do
			table.insert(keyboard.usedPile, key)
		end
		keyboard.fill()
		keyboard.updatePileStrings()
	end,
	-- Updates the display string for piles
	updatePileStrings = function()
		keyboard.bagPileString = keyboard.letterKeyListToString(keyboard.bagPile)
		keyboard.usedPileString = keyboard.letterKeyListToString(keyboard.usedPile)
	end,

	-- SPACE KEY
	giveSpaceKey = function()
		keyboard.spacekey = SpaceKey:new(keyboard.rows[5].x + 100,
			keyboard.rows[5].y,
			250, 50)
		keyboard.addKey(keyboard.spacekey, 5)
	end,
	unpressSpaceKey = function()
		keyboard.spacekey.pressed = false
	end,

	-- LETTER KEY MANIP
	-- Removes all letter keys. Returns what was removed
	clearLetterKeys = function()
		retList = {}
		for i=2, 4 do
			for i, key in ipairs(keyboard.rows[i]:clear()) do
				table.insert(retList, key)
			end
		end
	end,
	unpressLetterKeys = function()
		for i=2, 4 do
			keyboard.rows[i]:unpressKeys()
		end
	end,
	placeLetterKeyTest = function(letter)
		row = get_random_value(keyboard.rows)
		if row:full() then return end
		letterkey = LetterKey:new(row.x + math.random()*(row.w - 50), row.y, 50, 50, letter)
		--row:addKey(letterkey)
		keyboard.addKey(letterkey, get_random_value({2,3,4}))
	end,

	-- INFORMATION GETTERS
	getKeys = function()
		keys = {}
		for i, row in ipairs(keyboard.rows) do
			for j, key in ipairs(row:getKeys()) do
				table.insert(keys, key)
			end
		end
		return keys
	end,
	getLetterRows = function()
		letterRows = {}
		for i = 2, 4 do
			table.insert(letterRows, keyboard.rows[i])
		end
		return letterRows
	end,
	getLetterKeys = function()
		letterKeys = {}
		for i, row in ipairs(keyboard.getLetterRows()) do
			for j, key in ipairs(row:getKeys()) do
				table.insert(letterKeys, key)
			end
		end
		return letterKeys
	end,
	getQueuedLetterKeys = function()
		queuedLetterKeys = {}
		for i, row in ipairs(keyboard.getLetterRows()) do
			for i, key in ipairs(row.queue) do
				table.insert(queuedLetterKeys, key)
			end
		end
		return queuedLetterKeys
	end,
	getPressedLetterKeys = function()
		pressedLetterKeys = {}
		for i, row in ipairs(keyboard.getLetterRows()) do
			for i, key in ipairs(row:getPressedKeys()) do
				table.insert(pressedLetterKeys, key)
			end
		end
		return pressedLetterKeys
	end,
	getPressedKeys = function()
		pressedKeys = {}
		for i, row in ipairs(keyboard.rows) do
			for i, key in ipairs(row:getPressedKeys()) do
				table.insert(pressedKeys, key)
			end
		end
		return pressedKeys
	end,
	giveTutorialKeys = function()
		keyboard.clearLetterKeys()
		for i, row in ipairs(tutorialKeys) do
			for j, key in ipairs(row) do
				letterkey = LetterKey:new(
					keyboard.rows[i].x + j*75 - 75 + math.random()*50,
					keyboard.rows[i].y,
					50, 50, key, 1
				)
				keyboard.addKey(letterkey, i)
			end
		end
	end,
	letterKeyListToString = function(keyList)
		local retString = ""
		local letterList = {}
		for i, key in ipairs(keyList) do
			local letter = key.letter
			local lowLetter = string.lower(letter)
			if letterList[lowLetter] == nil then letterList[lowLetter] = {} end
			table.insert(letterList[lowLetter], letter)
		end
		for i, letter in ipairs(alphabet) do
			if letterList[letter] ~= nil then
				for i, letterOfKey in ipairs(letterList[letter]) do
					retString = retString..letterOfKey
				end
			end
			retString = retString.." "
		end
		return retString
	end,

	-- KEY MANIP
	-- Deletes every key on the keyboard
	clearKeys = function()
		for i, row in ipairs(keyboard.rows) do
			row:clear()
		end
	end,
	giveBluescreenKeys = function()
		local labels = {"CTRL", "ALT", "DEL"}
		for i, label in ipairs(labels) do
			get_random_value(keyboard.rows):addKey(BluescreenKey:new(0, 0, 50, 50, label))
		end
	end,
	pressRandomLetterKeyFromQueue = function()
		allQueuedKeys = {}
		for i, row in ipairs(keyboard.getLetterRows()) do
			for i, key in ipairs(row.queue) do
				table.insert(allQueuedKeys, key)
			end
		end
		get_random_value(allQueuedKeys):press()
	end,
	pressRandomLetterKey = function()
		get_random_value(keyboard.getLetterKeys()):press()
	end,

	-- Returns self if given coord is in hitbox. Returns nil if not
	attemptDrag = function(x, y)
		for i, key in ipairs(keyboard.getKeys()) do
			if key:inHitbox(x, y) then return key end
		end
		return nil
	end,
	unpressKeys = function()
		for i, row in ipairs(keyboard.rows) do
			row:unpressKeys()
		end
	end,

	-- Returns word made by pressed keys, and also position that hovered key would type into (nil if there's no hovered key)
	getTypedWord = function()
		pressedLetterKeys = keyboard.getPressedLetterKeys()
		table.sort(pressedLetterKeys)
		word = ""
		for i, key in ipairs(pressedLetterKeys) do
			word = word..key.letter
		end
		hoveredKey = cursor.hoveredObj
		if hoveredKey == nil or hoveredKey.pressed or hoveredKey.letter == nil then return word, nil end
		table.insert(pressedLetterKeys, hoveredKey)
		table.sort(pressedLetterKeys)
		for i, key in ipairs(pressedLetterKeys) do
			if hoveredKey == key then
				return word, i
			end
		end
		return word, nil
	end,
	-- Returns if the current typed word is valid
	typedWordIsValid = function()
		return dictionary.isWord(keyboard.getTypedWord())
	end,
}

alphabet = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}

vowels = {"a","e","i","o","u"}

tutorialKeys = {
	{},
	{"d","e","y","s","u","t"},
	{"w","i","o","l","r","p"},
	{"s","f","i","a","b","n"}
}

beginningKeysData = {
    {letter = "a", score = 1}, {letter = "a", score = 1}, {letter = "a", score = 1}, {letter = "a", score = 1},
    {letter = "a", score = 1}, {letter = "a", score = 1}, {letter = "a", score = 1}, {letter = "a", score = 1},
    {letter = "a", score = 1},  -- 9 a

    {letter = "b", score = 3}, {letter = "b", score = 3}, -- 2 b

    {letter = "c", score = 3}, {letter = "c", score = 3}, -- 2 c

    {letter = "d", score = 2}, {letter = "d", score = 2}, {letter = "d", score = 2}, {letter = "d", score = 2}, -- 4 d

    {letter = "e", score = 1}, {letter = "e", score = 1}, {letter = "e", score = 1}, {letter = "e", score = 1},
    {letter = "e", score = 1}, {letter = "e", score = 1}, {letter = "e", score = 1}, {letter = "e", score = 1},
    {letter = "e", score = 1}, {letter = "e", score = 1}, {letter = "e", score = 1}, {letter = "e", score = 1}, -- 12 e

    {letter = "f", score = 4}, {letter = "f", score = 4}, -- 2 f

    {letter = "g", score = 2}, {letter = "g", score = 2}, {letter = "g", score = 2}, -- 3 g

    {letter = "h", score = 4}, {letter = "h", score = 4}, -- 2 h

    {letter = "i", score = 1}, {letter = "i", score = 1}, {letter = "i", score = 1}, {letter = "i", score = 1},
    {letter = "i", score = 1}, {letter = "i", score = 1}, {letter = "i", score = 1}, {letter = "i", score = 1},
    {letter = "i", score = 1}, -- 9 i

    {letter = "j", score = 8}, -- 1 j

    {letter = "k", score = 5}, -- 1 k

    {letter = "l", score = 1}, {letter = "l", score = 1}, {letter = "l", score = 1}, {letter = "l", score = 1}, -- 4 l

    {letter = "m", score = 3}, {letter = "m", score = 3}, -- 2 m

    {letter = "n", score = 1}, {letter = "n", score = 1}, {letter = "n", score = 1}, {letter = "n", score = 1},
    {letter = "n", score = 1}, {letter = "n", score = 1}, -- 6 n

    {letter = "o", score = 1}, {letter = "o", score = 1}, {letter = "o", score = 1}, {letter = "o", score = 1},
    {letter = "o", score = 1}, {letter = "o", score = 1}, {letter = "o", score = 1}, {letter = "o", score = 1}, -- 8 o

    {letter = "p", score = 3}, {letter = "p", score = 3}, -- 2 p

    {letter = "q", score = 10}, -- 1 q

    {letter = "r", score = 1}, {letter = "r", score = 1}, {letter = "r", score = 1}, {letter = "r", score = 1},
    {letter = "r", score = 1}, {letter = "r", score = 1}, -- 6 r

    {letter = "s", score = 1}, {letter = "s", score = 1}, {letter = "s", score = 1}, {letter = "s", score = 1}, -- 4 s

    {letter = "t", score = 1}, {letter = "t", score = 1}, {letter = "t", score = 1}, {letter = "t", score = 1},
    {letter = "t", score = 1}, {letter = "t", score = 1}, -- 6 t

    {letter = "u", score = 1}, {letter = "u", score = 1}, {letter = "u", score = 1}, {letter = "u", score = 1}, -- 4 u

    {letter = "v", score = 4}, {letter = "v", score = 4}, -- 2 v

    {letter = "w", score = 4}, {letter = "w", score = 4}, -- 2 w

    {letter = "x", score = 8}, -- 1 x

    {letter = "y", score = 4}, {letter = "y", score = 4}, -- 2 y

    {letter = "z", score = 10} -- 1 z
}

return keyboard