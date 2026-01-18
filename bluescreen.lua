require("misc")
require("cursor")
require"tesound"

bluescreen = {
	id = 4,
	noCursor = false,
	begin = function()
		keyboard.clearKeys()
		keyboard.giveBluescreenKeys()
		message.stop()
		TEsound.play("SFX/Bluescreen/error.mp3", "static", {}, .3)
		saveGame(true)
		background.color = 3
	end,
	init = function(screen)
		bluescreen.x = screen.x
		bluescreen.y = screen.y
		bluescreen.w = screen.w
		bluescreen.h = screen.h
	end,
	backgroundCol = {0, 0, .9},
	update = function(dt)
		message.stop()
		return #keyboard.getPressedKeys() > 2
	end,
	draw = function()
		center = {x = bluescreen.x + bluescreen.w/2, y = bluescreen.y + bluescreen.h/2}
		-- Background
		rect(bluescreen.x, bluescreen.y, bluescreen.w, bluescreen.h, bluescreen.backgroundCol)
		-- OS
		rect(center.x - 48, bluescreen.y + 40, 93, 26, {1,1,1})
		text("BumbleOS", center.x - 46, bluescreen.y + 41, 20, bluescreen.backgroundCol)
		-- Desc
		text((app.won and "A critical" or "An").." error has occured. To continue:\n\nPress CTRL + ALT + DEL to restart your computer.\nIf you do this, data in any open applications may\nbe lost.\n\n"..
			"Error information:\n"..
			"Round reached: "..(app.round == 9 and "You won!" or app.round).."\n"..
			"Keys pressed: "..app.keysPressed.."\n"..
			"Highed scoring word: "..(app.highscore.hasOne and ("\""..app.highscore.word.."\" with "..math.floor(app.highscore.score).." points") or "No score"), bluescreen.x + 8, bluescreen.y + 90, 15, {1,1,1})
	end
}

return bluescreen