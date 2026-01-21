require("misc")

background = {
	time = 0,
	dist = 20,
	h = 100,
	rightH = 170,
	color = 5,
	colors = {{0,0,0}, {0,0,0}, {0,0,0}},
	colorsToChoose = {
		-- Red
		{{.4,.2,.2}, {.5,.2,.2}, {.6,.2,.2}},
		-- Green
		{{.2,.3,.2}, {.2,.4,.2}, {.2,.5,.2}},
		-- Blue
		{{.2,.2,.4}, {.2,.2,.5}, {.2,.2,.6}},
		-- Purple
		{{.2,.1,.3}, {.3,.1,.4}, {.4,.1,.5}},
		-- Black
		{{0,0,0},{0,0,0},{0,0,0}},
		-- Mix
		{{.6,0,0}, {0,.5,0}, {0,0,.6}}
	},
	randomizeColor = function()
		if app.round == 8 then background.color = 6 return 
		elseif app.round == 9 then background.color = 5 return end
		options = {1,2,3,4}
		table.remove(options, background.color)
		background.color = get_random_value(options)
	end,
	screenStencil = function()
		love.graphics.rectangle("fill", 0, 0, 525, 720)
	end,
	monitorStencil = function()
		love.graphics.rectangle("fill", monitor.x, monitor.y, monitor.w, monitor.h)
	end,
	update = function(dt)
		background.time = background.time + dt*10
		for i, whichOfSet in ipairs(background.colors) do
			for j, hex in ipairs(whichOfSet) do
				local targetSet = background.colorsToChoose[background.color]
				local targetColor = targetSet[i]
				local targetHex = targetColor[j]
				background.colors[i][j] = easeTo(hex, background.colorsToChoose[background.color][i][j], dt/10)
			end
		end
	end,
	draw = function()
		love.graphics.stencil(background.screenStencil, "replace", 1)
		love.graphics.stencil(background.monitorStencil, "replace", 2, true)
		love.graphics.setStencilTest("equal", 1)
		local dispY = -background.time % background.h * 3
		for i = 1, 12 do
			local y = i*background.h + dispY - 570
			love.graphics.setColor(unpack(background.colors[i%3+1]))
			love.graphics.polygon("fill", 
				0, y,
				0, y + background.h,
				526, y + background.h + background.rightH,
				526, y + background.rightH
			)
		end

		love.graphics.setStencilTest()
	end
}

return background