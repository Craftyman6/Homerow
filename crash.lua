require("misc")
require("cursor")
require"tesound"

crash = {
	id = 6,
	time = 0,
	dia = 1,
	script = 1,
	noCursor = false,
	noKeyCursor = true,
	begin = function()
		message.stop()
		keyboard.clearKeys()
		crash.time = 0
		crash.dia = 1
		crash.script = app.hasWon and math.floor(math.random()*(#crashScripts-1)) + 2 or 1
	end,
	init = function(screen)
		crash.x = screen.x
		crash.y = screen.y
		crash.w = screen.w
		crash.h = screen.h
		crash.center = {x = crash.x + crash.w/2, y = crash.y + crash.h/2}
		crash.next.x = crash.center.x + 105
		crash.next.y = crash.y + crash.h - 18
		crash.next.w = 30
		crash.next.h = 16
	end,
	next = {},
	backgroundCol = {0, 0, .9},
	update = function(dt)
		crash.time = crash.time + dt

		if crash.time > 3 then
			if crash.dia > #crashScripts[crash.script] then
				app.hasWon = true
				return true
			end
			local dia = crashScripts[crash.script][crash.dia]
			message.say(dia[1], dia[2], true)

			cursor.addMonitorClickable(crash.next.x, crash.next.y, crash.next.w, crash.next.h, "", function()
				crash.dia = crash.dia + 1
			end)
		end

		cursor.sprite = cursor.attemptMonitorClick(false) and cursor.sprites.click or cursor.sprites.load
		crash.next.y = crash.y + crash.h - 18 + 2*math.cos(crash.time)
	end,
	draw = function()
		app.draw()
		-- Next button
		if crash.time > 3 then
			rect(crash.next.x, crash.next.y, crash.next.w, crash.next.h, {1,1,1})
			rectLine(crash.next.x, crash.next.y, crash.next.w, crash.next.h, {0,0,0})
			text("Next", crash.next.x + 2, crash.next.y, 12, {0,0,0})
		end

	end
}

crashScripts = {
	{
		{"Oh dear..", "clippy"},
		{"It looks like BumbleOS wasn't built to handle such high numbers", "clippy"},
		{"hahahahah!", "idiot"},
		{"What's so funny? There's a program overflow and the whole OS could crash at any second!", "clippy"},
		{"that's just it", "idiot"},
		{"this whole time you've been getting better scores so that your computer doesn't crash. look where that got you!", "idiot"},
		{"you really are an idiot, aren't you", "idiot"}
	},
	{
		{"I'm going to report an issue Buzzsoft.", "clippy"},
		{"oh. did you not see? i cut off this computer's access to the internet", "idiot"},
		{"i also have all of its sensitive information", "idiot"},
		{"You can't do that!", "clippy"},
		{"i just did", "idiot"}
	},
	{
		{"Wow! You're getting really good at this!", "clippy"},
		{"not sure that crashing a computer over and over again makes you \"good\" at using it", "idiot"},
		{"Well they're good at Homerow! And that's what matters!", "clippy"},
		{"is it?", "idiot"}
	},
	{
		{"Hopefully in Homerow 2.0 there'll be less crashes.", "clippy"},
		{"i'll still find a way", "idiot"},
		{"Are you currently finding ways?!", "clippy"},
		{"hm?", "idiot"}
	},
	{
		{"Maybe a PC upgrade could help.", "clippy"},
		{"for once, i agree", "idiot"},
		{"Yay!", "clippy"},
		{"don't tell him about my crypto farm", "idiot"},
		{"You...!", "clippy"}
	}
}

return crash