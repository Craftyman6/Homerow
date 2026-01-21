require("misc")
require("cursor")
require"tesound"

powershell = {
	id = 5,
	noCursor = false,
	noKeyCursor = true,
	begin = function()
		message.stop()
		background.color = 5
	end,
	init = function(screen)
		powershell.x = screen.x
		powershell.y = screen.y
		powershell.w = screen.w
		powershell.h = screen.h
	end,
	borderW = 2,
	titleBarCol = {.3, .3, 1},
	borderCol = {1, 1, 1},
	backgroundCol = {0, 0, .9},
	update = function(dt)
		message.stop()

		local maximize = app.titleBarButtons[2]
		cursor.addMonitorClickable(maximize.x, maximize.y + (powershell.h - 20), maximize.w, maximize.h, "", function() monitor.screen.at = app background.randomizeColor() end)
	end,
	draw = function()
		-- Background
		rect(powershell.x, powershell.y, powershell.w, powershell.h, {0.004, 0.141, 0.337})

		-- Border
		for i = 0, app.borderW do
			rectLine(powershell.x + i, powershell.y + i, powershell.w - 2*i, powershell.h - 2*i - 21, powershell.borderCol)
		end

		-- Credits
		text(credits, powershell.x + 5, powershell.y + 24, 12, {1,1,1})

		-- Title bar
		rect(powershell.x - 2, powershell.y - 2, powershell.w + 4, 25, powershell.titleBarCol)
		text("Bumble Powershell", powershell.x + 5, powershell.y + 3, 15, {1,1,1})

		app.drawTitleAndBorder(powershell.h - 20)
	end
}

function creditsCenter(text, padding)
	local ret = " "..text.." "
	for i = 1, 70 - #text, 2 do
		ret = padding..ret..padding
	end
	if #ret % 2 == 0 then ret = ret..padding end
	ret = ret.."\n"
	return ret
end

creditsTitleSpacing = "                   "
credits = "PS C:\\Users\\Daisy1109> homerow --version\n"..
creditsTitleSpacing.." _  _                              \n"..
creditsTitleSpacing.."| || |___ _ __  ___ _ _ _____ __ __\n"..
creditsTitleSpacing.."| __ / _ \\ '  \\/ -_) '_/ _ \\ V  V /\n"..
creditsTitleSpacing.."|_||_\\___/_|_|_\\___|_| \\___/\\_/\\_/     v"..version.."\n\n"..
creditsCenter("Development","-")..
creditsCenter("Colin Schaffner"," ")..
creditsCenter("Tools",".")..
creditsCenter("LÖVE | Pixelorama | asciiart.eu"," ")..
creditsCenter("Libraries/Resources",".")..
creditsCenter("middleclass | moonshine | TESound | deostroll's dictionary.txt | pprint"," ")..
creditsCenter("Inspirations",".")..
creditsCenter("Balatro | OMG Words | Microsoft Windows XP"," ")..
creditsCenter("Playtesting",".")..
creditsCenter("RaidenPAX | Cheerbs | AubreyBrace"," ")

return powershell