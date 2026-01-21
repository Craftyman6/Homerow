idiot = require 'idiot'
shop = require 'shop'
require("saving")
require("crumb")
require("Key.functionkey")

app = {
	id = 3,
	time = 0,
	noCursor = false,
	dead = false,
	won = false,
	crashed = false,
	hasWon = false,
	introDia = true,
	shopDia = true,
	infoFields = {
		-- Blew
		{
			name = "blew",
			value = 0,
			disValue = 0,
			col = {0,0,.9},
			desc = "That's your blew! Letter keys give blew for the score they'd have as a Scrabble tile. Hover over one to check!", 
			crumbs = {},
			timeSinceLastCrumb = 0
		},
		-- Read
		{
			name = "read",
			value = 0,
			disValue = 0,
			col = {.9,0,0},
			desc = "That's your read! Letter tiles each give one.", 
			crumbs = {},
			timeSinceLastCrumb = 0
		},
		-- Purp
		{
			name = "purp",
			value = 0,
			disValue = 0,
			col = {.9,0,.9},
			desc = "That's your purp! When you submit your word, the product of your blew and read get added to your purp.", 
			crumbs = {},
			timeSinceLastCrumb = 0
		},
		-- Teel
		{
			name = "teel",
			value = 50,
			disValue = 0,
			col = {.1,.5,.1},
			desc = "That's your teel! Get your purp greater than this before the round ends to stay in the game.", 
			crumbs = {},
			timeSinceLastCrumb = 0
		}
	},
	exchanges = {
		{
			used = false,
			available = false,
			label = "Top"
		},
		{
			used = false,
			available = false,
			label = "Middle"
		},
		{
			used = false,
			available = false,
			label = "Bottom"
		}
	},
	boss = 1,
	hornetted = false,
	bosses = {
		{
			name = "Hornet",
			desc = "Random letter\nkey pressed\nevery word",
			img = love.graphics.newImage("IMG/App/hornet.png")
		},
		{
			name = "Queen Bee",
			desc = "x2 teel",
			img = love.graphics.newImage("IMG/App/queen_bee.png")
		},
		{
			name = "Carpenter Bee",
			desc = "Can't move\nletter keys",
			img = love.graphics.newImage("IMG/App/carpenter_bee.png")
		},
		{
			name = "Wasp",
			desc = "Can't use\nmouse",
			img = love.graphics.newImage("IMG/App/wasp.png")
		}
	},
	round = 1,
	words = 4,
	maxWords = 4,
	highscore = {hasOne = false, word = "", score = 0},
	keysPressed = 0,
	teelValues = {40, 75, 150, 300, 600, 1000, 1500, 2000},
	init = function(screen)
		app.x = screen.x
		app.y = screen.y
		app.w = screen.w
		app.h = screen.h
		shop.init(app.x + app.w - app.shopTabW, app.y + app.infoTabH, app.shopTabW, app.h - app.infoTabH)
		app.center = {x = app.x + app.w/2, y = app.y + app.h/2}
		app.textbox.w = 200
		app.textbox.x = app.center.x - app.textbox.w/2
		app.textbox.y = app.y + 80
		app.textbox.h = 55
		app.textbox.text = ""
		app.textbox.textSize = 40
		app.textbox.textX = app.center.x
		app.textbox.hoverIndex = nil
		app.bag.x = app.x + 7
		app.bag.y = app.y + app.h - 47
		app.bag.w = 40
		app.bag.h = 40
		app.bag.col = {.7,.7,.9}
		app.bag.img = love.graphics.newImage("IMG/App/bag.png")
		app.used.x = app.x + 57
		app.used.y = app.y + app.h - 47
		app.used.w = 40
		app.used.h = 40
		app.used.col = {.65,.65,.85}
		app.used.img = love.graphics.newImage("IMG/App/used.png")
		app.reward.x = app.center.x - 112
		app.reward.y = app.y + 140
		app.reward.text = ""
		for i, field in ipairs(app.infoFields) do
			field.x = app.x + i*112 - 103
			field.y = app.y + 27
			field.w = 96
			field.h = 38
		end
		for i, exchange in ipairs(app.exchanges) do
			exchange.x = app.x + 9
			exchange.y = app.y + 120 + 40*i
			exchange.w = 85
			exchange.h = 30
		end
		for i = 1, 3 do
			local titleBarButton = app.titleBarButtons[i]
			titleBarButton.x = app.x + app.w - 20*i + 2
			titleBarButton.y = app.y + 2
			titleBarButton.w = 17
			titleBarButton.h = 17
			titleBarButton.col = i == 1 and app.titleBarXButtonCol or app.titleBarButtonCol
			titleBarButton.img = app.titleBarImgs[i+1]
			titleBarButton.onHover = ({
				"WARNING! Homerow saves after every round. Reopening will bring you to the start of your last completed round",
				"This changes the size of the game window. Cycle through the sizes to see which size suits your computer best!",
				"Click this to show the credits!"
			})[i]
			titleBarButton.onClick = ({
				function() if app.introDia then return end love.event.quit() end,
				function() if app.introDia then return end changeWindowS() end,
				function() monitor.screen.at = powershell powershell.begin() end
			})[i]
		end
	end,
	welcome = 1,
	textbox = {},
	bag = {},
	used = {},
	reward = {},
	titleBarButtons = {{},{},{}},
	infoTabH = 70,
	utilityTabW = 103,
	shopTabW = 103,
	bgCol = {1, .99, .98},
	infoTabFieldCol = {.893, .885, .819},
	infoTabBgCol = {.933, .925, .859},
	titleBarCol = {.3, .3, 1},
	titleBarButtonCol = {.45, .45, 1},
	titleBarXButtonCol = {.9, .4, .4},
	textboxBgCol = {.973, .965, .94},
	textboxBorderCol = {.6, .6, .7},
	wordCounterCol = {.5,.5,.9},
	roundCounterCol = {.3, .3, .8},
	exchangesTitleCol = {.3, .5, .7},
	exchangesBgCol = {.6, .8, 1},
	borderW = 2,
	-- Called when app is loaded
	begin = function()
		keyboard.clearLetterKeys()
		keyboard.returnToBag()
		keyboard.initializeBagPile()
		keyboard.fill()
		refreshRadio()
		shop.init(app.x + app.w - app.shopTabW, app.y + app.infoTabH, app.shopTabW, app.h - app.infoTabH)
		shop.clear()
		shop.money = 0
		shop.dispMoney = 0
		for i, field in ipairs(app.infoFields) do
			field.value = 0
		end
		for i, exchange in ipairs(app.exchanges) do
			exchange.used = false
		end
		app.welcome = math.floor(math.random()*#welcomeMessages+1)
		app.time = 0
		app.boss = math.floor(math.random()*4) + 1
		app.round = 1
		app.infoFields[4].disValue = 0
		app.infoFields[4].value = app.teelValues[app.round]
		app.maxWords = 4
		app.dead = false
		app.won = false
		app.crashed = false
		app.noCursor = false
		app.words = app.maxWords
		app.highscore = {hasOne = false, word = "", score = 0}
		app.keysPressed = 0
		if #keyboard.rows[5].keys <= 0 then keyboard.giveSpaceKey() end
		background.randomizeColor()
	end,
	titleBarImgs = {
		love.graphics.newImage("IMG/TitleBar/bee.png"),
		love.graphics.newImage("IMG/TitleBar/close.png"),
		love.graphics.newImage("IMG/TitleBar/maximize.png"),
		love.graphics.newImage("IMG/TitleBar/minimize.png")
	},
	submitWord = function()
		app.words = app.words - 1
		local purp = app.infoFields[1].value * app.infoFields[2].value
		app.addToInfoField(3, purp)
		if purp == math.max(purp, app.highscore.score) then
			app.highscore.hasOne = true
			app.highscore.word = keyboard.getTypedWord()
			app.highscore.score = purp
		end
		app.infoFields[1].value = 0 
		app.infoFields[2].value = 0
		app.infoFields[1].disValue = 0
		app.infoFields[2].disValue = 0
		app.hornetted = false
		app.introDia = false
	end,
	newRound = function()
		app.noCursor = false
		if app.infoFields[3].value < app.infoFields[4].value then app.die() return end
		for i, exchange in ipairs(app.exchanges) do exchange.used = false end
		refreshRadio()
		shop.stock()
		shop.giveMoney(app.getRoundReward())
		shop.restock.cost = 3
		app.round = app.round + 1
		app.words = app.maxWords
		app.infoFields[3].value = 0
		keyboard.returnToBag()
		if app.round > #app.teelValues then
			app.infoFields[4].value = app.infoFields[4].value*2
			app.won = true
			app.noCursor = true
		else
			app.infoFields[4].value = app.teelValues[app.round]
			if app.round == 8 and app.boss == 2 then
				app.infoFields[4].value = app.infoFields[4].value * 2
			end
			saveGame()
			keyboard.fill()
		end
		background.randomizeColor()
	end,
	die = function()
		app.dead = true
	end,
	getWordReward = function()
		local ret = 0
		for i, row in ipairs(keyboard.getLetterRows()) do
			if #row:getPressedKeys() > 0 then
				ret = ret + 1
			end
		end
		return ret
	end,
	getRoundReward = function()
		ret = 0
		for i = 1, 2, 0.5 do
			if app.infoFields[3].value >= i * app.infoFields[4].value then
				ret = ret + 3
			end
		end
		return ret
	end,
	onSpacePress = function()
		keyboard.unpressSpaceKey()
		if #keyboard.getTypedWord() <= 0 then if not app.introDia then message.say(get_random_value(noLettersMessagePool), "idiot", false) end return end
		if keyboard.typedWordIsValid() then
			shop.giveMoney(app.getWordReward())
		else	
			app.infoFields[1].value = 0
			app.infoFields[2].value = 0
			idiot.start(keyboard.getTypedWord().." isnt a word", false)
		end
		app.submitWord()
		if app.words <= 0 then
			app.noCursor = true
		end
		keyboard.usePressedLetterKeys()
		keyboard.fill()
		keyboard.unpressKeys()
	end,
	addToInfoField = function(i, value)
		if i > 4 or i < 1 or i % 1 ~= 0 or value <= 0 then return end
		app.infoFields[i].value = app.infoFields[i].value + value
		app.infoFields[i].disValue = app.infoFields[i].disValue + 1
	end,
	xToInfoField = function(i, value)
		if i > 4 or i < 1 or i % 1 ~= 0 or value <= 0 then return end
		app.infoFields[i].value = app.infoFields[i].value * value
		app.infoFields[i].disValue = app.infoFields[i].disValue
	end,
	exchange = function(exchangeID)
		if not app.exchanges[exchangeID].available then return end
		keyboard.exchangeRow(exchangeID + 1)
		app.exchanges[exchangeID].used = true
	end,
	update = function(dt)
		if idiot.active then return end

		-- Fill keyboard if empty
		-- Die if no key was added
		if #keyboard.getLetterKeys() == 0 then
			keyboard.fill()
			local queuedKeyExists = false
			for i, row in ipairs(keyboard.getLetterRows()) do
				if #row.queue > 0 then queuedKeyExists = true end
			end
			if #keyboard.getLetterKeys() == 0 and not queuedKeyExists then
				app.dead = true
			end
		end

		if app.dead then return true end
		app.time = app.time + dt

		if app.won then
			app.infoFields[4].value = app.infoFields[4].value*(1+dt)
			if app.infoFields[4].value > 1000000 then
				monitor.screen.at = crash
				crash.begin()
				app.crashed = true
				return
			end
		end


		-- TITLE BAR
		-- Button clickables
		for i, button in ipairs(app.titleBarButtons) do
			cursor.addMonitorClickable(button.x, button.y, button.w, button.h, button.onHover, button.onClick)
		end

		-- INFO TAB
		-- Info field clickables
		for i, field in ipairs(app.infoFields) do
			cursor.addMonitorClickable(field.x, field.y, field.w, field.h, field.desc, function() end)
		end
		-- Info field display values and crumbs
		local nextRoundReady = true
		for i, field in ipairs(app.infoFields) do
			-- Update crumbs
			field.timeSinceLastCrumb = field.timeSinceLastCrumb + dt
			for i = #field.crumbs, 1, -1 do
				if field.crumbs[i]:update(dt) then
					table.remove(field.crumbs, i)
				end
			end
			-- Update disValues
			field.disValue = math.min(field.disValue, field.value)
			local oldDisValue = field.disValue
			local dif = field.value - field.disValue
			field.disValue = easeTo(field.disValue, field.value, dt * (2*dif + 2))
			if field.disValue ~= field.value then nextRoundReady = false end
			-- Create crumbs
			if math.floor(oldDisValue) ~= math.floor(field.disValue) then
				table.insert(field.crumbs, Crumb:new(field.x + 10 + math.random()*#tostring(field.value)*12, field.y + 10 + math.random()*20, field.name, field.timeSinceLastCrumb))
				field.timeSinceLastCrumb = 0
			end
		end
		if nextRoundReady and app.noCursor and not app.won then app.newRound() end

		-- UTILITY TAB
		-- Round clickable
		cursor.addMonitorClickable(app.x + 10, app.y + 72, 80, 23, "It's round "..app.round.." out of 8! The round ends when you run out of words to play. You'll need to have more purp than teel (top right) to move onto the next one. When you do, all letter keys go back to the bag and the shop gets restocked", function() end)
		-- Words clickable
		cursor.addMonitorClickable(app.x + 10, app.y + 102, 80, 23, "You have "..app.words.." words to play before the round ends. This includes both correct and incorrect words. A word doesn't have to score for it to be used, so be careful!", function() end)
		-- Exchange clickables
		cursor.addMonitorClickable(app.x + 10, app.y + 132, 80, 20, "Below are your exchange buttons. Click them to discard the letter keys of their respective row, and replace them with unused keys from the bag", function() end)
		for i, exchange in ipairs(app.exchanges) do
			exchange.available = not exchange.used and #keyboard.rows[i+1]:getPressedKeys() <= 0
			local clickableMessage = exchange.available and ("Click this to exchange the "..string.lower(exchange.label).." letter key row with new keys from the bag.") or (exchange.used and "You've already used the "..string.lower(exchange.label).." exchange. You can use it again after this round." or "You can't use the "..string.lower(exchange.label).." exchange when there's a pressed key in the "..string.lower(exchange.label).." letter row")
			cursor.addMonitorClickable(exchange.x, exchange.y, exchange.w, exchange.h, clickableMessage, function() app.exchange(i) end)
		end
		-- Bag clickable
		local bagPileMessage = keyboard.bagPileString:match("%S") == nil and "Uh oh! You're out of keys!" or "The keys left in your bag are: "..keyboard.bagPileString
		cursor.addMonitorClickable(app.bag.x, app.bag.y, app.bag.w, app.bag.h, bagPileMessage, function() end)
		-- Used clickable
		local usedPileMessage = keyboard.usedPileString:match("%S") == nil and "Looks like you haven't used any keys yet." or "Your used keys are: "..keyboard.usedPileString
		cursor.addMonitorClickable(app.used.x, app.used.y, app.used.w, app.used.h, usedPileMessage, function() end)

		-- SHOP TAB
		shop.update(dt)

		-- Intro dialogue / Welcome messages
		if app.introDia then
			message.say("Great! You can type! Now, the rest is on you. Your goal in Homerow is to type words correctly. Only valid Scrabble words will do. Try typing one now! And after then, if you're confused on something, just hover over it and I'll be there!", "clippy", false)
		elseif app.shopDia and #shop.keys > 0 then
			if cursor.x > 400 and cursor.y > 100 and cursor.y < 360 then
				if not message.perishable then
					message.stop()
				end
			else
				message.say("Woah! The shop's been stocked! There, you can buy keys to help you in your run! There are two types, \"function\" keys, which are consumed when pressed, and \"special\" keys, that do special things if conditions are met as you press them! Try buying a key now!", "clippy", false)
			end
		elseif app.round == 1 and app.words == 4 and app.time > .5 and app.time < 4 then
			local speakerID = math.floor(app.time / 3) + 1
			message.say(welcomeMessages[app.welcome][speakerID], speakerID == 1 and "clippy" or "idiot", false)
		end

		-- TEXTBOX
		app.textbox.text, app.textbox.hoverIndex = keyboard.getTypedWord()
		app.textbox.textX = app.textbox.x + app.textbox.w/2 - #app.textbox.text*app.textbox.textSize/3.5

		-- REWARD
		cursor.addMonitorClickable(app.reward.x, app.reward.y, 220, 17, "When a word is submitted, gain $1 for each row with a pressed letter key. When the round ends, gain $3 for each increment of x1, x1.5, x2 that your purp gets over your teel.", function() end)
		app.reward.text = "After word: $"..app.getWordReward().." | After round: $"..app.getRoundReward()

		-- BOSS
		if app.round > 6 and app.round < 9 then
			cursor.addMonitorClickable(app.center.x - 112, app.y + 162, 220, 70, app.round == 7 and "Looks like you've got a boss bee coming up next round. Get ready!" or "There's a boss bee! You've got this!", function() end)
		end
	end,
	draw = function()
		-- Background
		rect(app.x, app.y, app.w, app.h, app.bgCol)

		-- Info Tab
		app.drawInfoTab()

		-- Utility Tab
		app.drawUtilityTab()

		-- Shop Tab
		shop.draw()

		-- Textbox
		rect(app.textbox.x, app.textbox.y, app.textbox.w, app.textbox.h, app.textboxBgCol)
		rectLine(app.textbox.x, app.textbox.y, app.textbox.w, app.textbox.h, app.textboxBorderCol)
		text(app.textbox.text, app.textbox.textX + 6, app.textbox.y, app.textbox.textSize, {.3,.3,.3})
		if app.textbox.hoverIndex ~= nil and app.time % .5 > .25 and #app.textbox.text < 7 then
			text("|", app.textbox.textX - 24 + app.textbox.hoverIndex*21, app.textbox.y + 2, app.textbox.textSize, {.3,.3,.3})
		end

		-- Reward
		text(app.reward.text, app.reward.x, app.reward.y, 13, {.9, .85, .25})

		-- Boss
		if app.round > 6 and app.round < 9 then
			text((app.round == 7 and "UPCOMING" or "CURRENT").."\nBOSS BEE", app.center.x - 100, app.y + 160, 15, {0,0,.2})
			local boss = app.bosses[app.boss]
			img(boss.img, app.center.x - 20 + (app.round == 8 and 3*math.sin(app.time) or 0), app.y + 160)
			textCenter(boss.name, app.center.x + 5, app.y + 200, 24, {0,0,.2})
			text(boss.desc, app.center.x + 25, app.y + 160 - (app.boss == 1 and 5 or 0), app.boss == 2 and 19 or 12, {0,0,.2})
		end

		-- Crash
		if app.crashed then
			rect(app.x, app.y, app.w, app.h, {1,1,1,math.min(.6,crash.time)})
		end

		app.drawTitleAndBorder(0)
	end,
	drawInfoTab = function()
		-- Background
		rect(app.x, app.y, app.w, app.infoTabH, app.infoTabBgCol)
		-- Fields
		for i, field in ipairs(app.infoFields) do
			rect(field.x, field.y, field.w, field.h, app.infoTabFieldCol)
			for i, crumb in ipairs(field.crumbs) do
				crumb:draw()
			end
			text(math.floor(field.disValue), field.x + 5, field.y + 2, 30, field.col)
		end
		-- Operators
		for i=1, 3 do
			text(({"x","=",">"})[i], app.x - 4 + i*112, app.y + 33, 22, app.infoTabFieldCol)
		end
	end,
	drawUtilityTab = function()
		-- Background
		rect(app.x, app.y + app.infoTabH, app.utilityTabW, app.h - app.infoTabH, {.9, .9, 1})
		-- Round
		textCenter("Round ".. app.round, app.x + 60, app.y + 72, 20, app.roundCounterCol)
		-- Words
		text("Words: "..app.words, app.x + 10, app.y + 102, 20, app.wordCounterCol)
		-- Exchanges
		text("Exchanges:", app.x + 9, app.y + 135, 16, app.exchangesTitleCol)
		for i, exchange in ipairs(app.exchanges) do
			rect(exchange.x, exchange.y, exchange.w, exchange.h, exchange.used and app.exchangesTitleCol or app.exchangesBgCol)
			textCenter(exchange.label, exchange.x + exchange.w/2 + 10, exchange.y + 3, 20, exchange.used and app.exchangesBgCol or app.exchangesTitleCol)
		end
		-- Bag
		rect(app.bag.x, app.bag.y, app.bag.w, app.bag.h, app.bag.col)
		img(app.bag.img, app.bag.x + 4, app.bag.y + 4)
		-- Used
		rect(app.used.x, app.used.y, app.used.w, app.used.h, app.used.col)
		img(app.used.img, app.used.x + 4, app.used.y + 4)
	end,
	-- Used in powershell as well just at the bottom
	drawTitleAndBorder = function(displacedY)
		-- Border
		for i = 0, app.borderW do
			rectLine(app.x + i, app.y + i + displacedY, app.w - 2*i, app.h - 2*i, app.titleBarCol)
		end
		-- Title bar
		rect(app.x, app.y + displacedY, app.w, 21, app.titleBarCol)
		for i, button in ipairs(app.titleBarButtons) do
			rect(button.x, button.y + displacedY, button.w, button.h, button.col)
			rectLine(button.x, button.y + displacedY, button.w, button.h, {1,1,1})
			img(button.img, button.x + 1, button.y + 1 + displacedY)
		end
		img(app.titleBarImgs[1], app.x + 2, app.y + 2 + displacedY)
		text("Homerow.exe"..(app.crashed and " (Not responding)" or ""), app.x + 20, app.y + 3 + displacedY, 15, {1,1,1})
	end
}

welcomeMessages = {
	{"Welcome back!", "can it, clip-wad!"},
	{"Make yourself at home...row!", "oh no. dad jokes. is he pregnant?"},
	{"Let's get back to typing!", "or spreading misinformation on the internet"},
	{"Stretch your knuckles!", "...what?"},
	{"The keys have been waiting for you!", "i haven't"},
	{"I've warmed up the keyboard for you!", "...why?"},
	{"It's number-go-up time!", "and tolerance-go-down time"},
	{"Clip-a-dip-dip!", "did he just say that?"},
	{"Get your fingers ready!", "please reword that clippy"}
}

noLettersMessagePool = {
	"looks like this guy's speechless",
	"no letters?",
	"there are no zero letter words idiot",
	"trying out \'minimalist typing\", are you?",
	"maybe press a letter first?",
	"at least spell a wrong word, not no word at all"
}

return app