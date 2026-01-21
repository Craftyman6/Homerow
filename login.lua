require("misc")
require("cursor")
keyboard = require 'keyboard'
message = require 'message'

stageMessages = {
	{
		message = "Welcome to BumbleOS. I'm Clippy!",
		from = "clippy"
	},
	{
		message = "As you can probably tell, Bumble keyboards don't work the same way that regular keyboards do.",
		from = "clippy"
	},
	{
		message = "no duh.",
		from = "idiot"
	},
	{
		message = "Oh dear.. it seems my antivirus isn't as good as I thought. Pay him no mind. ",
		from = "clippy"
	},
	{
		message = "We've given you an account with a password of \"default\", and I'm here to teach you how to spell it with your new, special keyboard!",
		from = "clippy"
	},
}

tryMessages = {
	{
		message = "Letters are typed by their left-to-right order on the keyboard, and NOT by the order you press them in. Hold left click on a key to drag it and click it to press. Keys can't be unpressed until you press space to submit your word. Try your password, \"default\"!",
		from = "clippy"
	},
	{
		message = "Stop poking fun! They're still learning! Since the keys are read left-to-right, you'll need to move your keys before you press them. For example, make sure \"e\" is to the right of \"d\" and to the left of \"f\" on the keyboard itself to spell \"default\".",
		from = "clippy"
	},
	{
		message = "When in doubt, hover over a key and look at the cursor in the text box. Hold left click to move your keys before you press them. For example, make sure \"e\" is to the right of \"d\" and to the left of \"f\" on the keyboard itself to spell \"default\".",
		from = "clippy"
	}
}

login = {
	id = 2,
	noCursor = false,
	begin = function() 
	end,
	init = function(screen)
		login.x = screen.x
		login.y = screen.y
		login.w = screen.w
		login.h = screen.h
		login.center = {x = login.x + login.w/2, y = login.y + login.h/2}
		login.user.x = login.center.x + 20
		login.user.y = login.center.y - 30
		login.user.w = (login.x + login.w) - login.user.x
		login.user.h = 49
		login.pass.x = login.x + login.w + 10
		login.pass.y = login.center.y
		login.pass.w = 180
		login.pass.h = 30
		login.pass.word = ""
		login.pass.answer = "default"
		login.next.x = login.center.x + 105
		login.next.y = login.y + login.h - 18
		login.next.w = 30
		login.next.h = 16
		login.maximize.x = login.x + login.w - 40
		login.maximize.y = login.y + 50
		login.maximize.w = 32
		login.maximize.h = 32
		login.next.active = false
		--keyboard.giveTutorialKeys()
	end,
	chosen = false,
	bgCol = {0.314, 0.447, 0.843},
	divLineCol = {0.404, 0.537, 0.918},
	divLineLength = 60,
	borderStripCol = {0, 0.169, 0.573},
	borderLineCols = {{0.6, 0.729, 0.984}, {1, 0.686, 0.349}},
	maximizeImgs = {love.graphics.newImage("IMG/Login/large.png"), love.graphics.newImage("IMG/Login/small.png")},
	borderH = 40,
	flowerImg = love.graphics.newImage("IMG/Login/flower.png"),
	flowerSize = .7,
	time = 0,
	lastTimeIncrement = 0,
	user = {},
	pass = {},
	next = {},
	maximize = {},
	stage = 1,
	tries = 1,
	done = false,
	spaceKeyGiven = false,
	-- When the next button is pressed, go to the next stage in the dialogue
	nextDia = function()
		login.stage = login.stage + 1
		if login.stage > #stageMessages then
			login.giveSpaceKey()
		end
	end,
	-- When the proceedural dialogue is done, give the spacebar and switch to try dialogue
	giveSpaceKey = function()
		keyboard.giveSpaceKey()
		login.next.active = false
		login.spaceKeyGiven = true
	end,
	-- Gets called by SpaceKey. Checks if password is correct
	onSpacePress = function()
		keyboard.unpressSpaceKey()
		keyboard.unpressLetterKeys()
		if login.pass.word == "" then return end
		if login.pass.word == login.pass.answer then
			login.done = true
		else
			idiot.start("wrong password", true)
			login.tries = login.tries + 1
		end
	end,
	-- Called once per frame
	update = function(dt)
		-- Don't update and return true back to monitor if login set as done
		if login.done then return true end
		-- Decide if next button should be shown
		login.next.active = login.chosen and not login.spaceKeyGiven
		-- Maximize clickable
		cursor.addMonitorClickable(login.maximize.x, login.maximize.y, login.maximize.w, login.maximize.h, "", function() changeWindowS() end)
		-- Add user clickable if not clicked yet (return if so)
		if not login.chosen then
			cursor.addMonitorClickable(login.user.x, login.user.y, login.user.w, login.user.h, "", function()
				login.chosen = true
				login.next.active = true
				keyboard.giveTutorialKeys()
				TEsound.play("SFX/Login/user.mp3", "static", {}, .4)
			end)
			return
		end
		-- Progress timer (used for drawing animations)
		login.time = login.time + dt
		-- Say dialogue based off stage of login
		if login.spaceKeyGiven then
			tryMessage = tryMessages[math.min(login.tries, #tryMessages)]
			message.say(tryMessage.message, tryMessage.from, false)
		else
			cursor.addMonitorClickable(login.next.x, login.next.y, login.next.w, login.next.h, "", function()
				login.nextDia()
			end)
			stageMessage = stageMessages[login.stage]
			message.say(stageMessage.message, stageMessage.from, false)
		end
		-- Get typed word variables
		login.pass.word, login.hoverIndex = keyboard.getTypedWord()
		-- Update animations variables
		login.user.y = login.center.y - 30 - math.min(login.time * 100, 30)
		login.pass.x = login.x + login.w + 10 - math.min(login.time * 400, 210)
		login.next.y = login.y + login.h - 18 + 2*math.cos(login.time)
	end,
	draw = function()
		-- Background
		rect(login.x, login.y, login.w, login.h, login.bgCol)
		-- Division line
		line(login.center.x, login.y + login.divLineLength, login.center.x, login.y + login.h - login.divLineLength, 1, login.divLineCol)
		-- Top and bottom borders
		for i = 0, 1 do
			pos = {x = login.x, y = login.y + i*login.h - i*login.borderH}
			rect(pos.x, pos.y, login.w, login.borderH, login.borderStripCol)
			line(pos.x, pos.y + (1+-i)*login.borderH, pos.x + login.w, pos.y + (1+-i)*login.borderH, 2, login.borderLineCols[i+1])
		end
		-- OS title
		text("Bumble", login.center.x - 205, login.center.y - 50, 50, {1,1,1})
		text("OS", login.center.x - 50, login.center.y - 60, 30, {1,1,1})
		-- Instruction
		instruction = login.chosen and "  Enter your password" or "To begin, click a user name"
		text(instruction, login.center.x - 205, login.center.y + 10, 13, {1,1,1})
		-- User
		if login.chosen then rect(login.user.x - 2, login.user.y - 2, login.user.w, login.user.h, login.borderStripCol) end
		love.graphics.setColor(1,1,1)
		love.graphics.draw(login.flowerImg, login.user.x, login.user.y, 0, login.flowerSize)
		text("Daisy1109", login.user.x + 55, login.user.y, 17, {1,1,1})
		-- Password
		rect(login.pass.x, login.pass.y, login.pass.w, login.pass.h, {1,1,1})
		if login.hoverIndex ~= nil and login.time % .5 > .25 then
			text("|", login.pass.x - 11 + login.hoverIndex*11, login.pass.y + 2, 20, {0,0,0})
		end
		text(login.pass.word, login.pass.x + 6, login.pass.y + 2, 20, {.3,.3,.3})
		-- Next button
		if login.next.active then
			rect(login.next.x, login.next.y, login.next.w, login.next.h, {1,1,1})
			rectLine(login.next.x, login.next.y, login.next.w, login.next.h, {0,0,0})
			text("Next", login.next.x + 2, login.next.y, 12, {0,0,0})
		end
		-- Maximize
		img(login.maximizeImgs[math.floor(windowS*1.5)], login.maximize.x, login.maximize.y, 0, .5)
	end
}

return login