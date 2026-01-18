require("misc")

shop = {
	money = 0,
	dispMoney = 0,
	keys = {},
	specialAvailable = true,
	functionAvailable = true,

	specialWeights = {},
	specialWeightsTotal = 0,
	functionWeights = {},
	functionWeightsTotal = 0,
	specialChance = .5,

	loadWeights = function()
		shop.specialWeights = {}
		shop.specialWeightsTotal = 0
		shop.functionWeights = {}
		shop.functionWeightsTotal = 0
		for i, key in ipairs(functionKeyData) do
			shop.functionWeightsTotal = shop.functionWeightsTotal + key.weight
			table.insert(shop.functionWeights, shop.functionWeightsTotal)
		end
		for i, key in ipairs(specialKeyData) do
			shop.specialWeightsTotal = shop.specialWeightsTotal + key.weight
			table.insert(shop.specialWeights, shop.specialWeightsTotal)
		end
	end,

	getRandomKey = function()
		if math.random() < shop.specialChance then
			local rand = math.random()*shop.specialWeightsTotal
			for i, keyCount in ipairs(shop.specialWeights) do
				if rand < keyCount then return "special", i end
			end
		else
			local rand = math.random()*shop.functionWeightsTotal
			for i, keyCount in ipairs(shop.functionWeights) do
				if rand < keyCount then return "function", i end
			end
		end
	end,

	clear = function()
		shop.keys = {}
	end,

	stock = function()
		shop.keys = {}
		for i = 1, 4 do
			local type, id = shop.getRandomKey()
			if type == "special" then
				table.insert(shop.keys, SpecialKey:new(id, shop.x + shop.w, shop.center.y))
			elseif type == "function" then
				table.insert(shop.keys, FunctionKey:new(id, shop.x + shop.w, shop.center.y))
			end
		end
	end,

	init = function(x, y, w, h)
		shop.x = x
		shop.y = y
		shop.w = w
		shop.h = h
		shop.center = {x = shop.x + shop.w/2, y = shop.y + shop.h/2}
		shop.restock.x = shop.x + shop.w - 51
		shop.restock.y = shop.y + shop.h - 41
		shop.restock.w = 33
		shop.restock.h = 31
		shop.restock.col = {.6, .9, .6}
		shop.restock.img = love.graphics.newImage("IMG/App/restock.png")
		shop.loadWeights()
	end,
	restock = {
		buy = function()
			-- Return if there's not enough money
			if shop.money < shop.restock.cost then
				if app.introDia then return end
				message.say(get_random_value(poorMessages), "idiot", false) return
			end
			-- Subtract money
			shop.money = shop.money - shop.restock.cost
			-- Restock
			shop.stock()
			-- Increase cost
			shop.restock.cost = shop.restock.cost + 1
		end,
		cost = 3
	},

	bgCol = {.9, 1, .9},
	titleCol = {.4, .8, .4},
	moneyCol = {.2, .8, .6},

	giveMoney = function(money)
		shop.money = shop.money + money
	end,

	buy = function(keyID)
		local key = shop.keys[keyID]
		-- Return if there's not enough money
		if shop.money < key.cost then
			message.say(get_random_value(poorMessages), "idiot", false) return
		end
		local typeChecker = tostring(key)
		local type = typeChecker == "instance of class FunctionKey" and "function" or "special"
		local row = type == "function" and 1 or 5
		-- Return if there's no room
		if keyboard.rows[row]:sizeLeft() < key:size() then
			message.say("Looks like your full on "..type.." keys. You can sell one by holding it in place for 4 seconds.", "clippy", false) return
		end
		-- Return if there's a pressed key
		if #keyboard.rows[row]:getPressedKeys() > 0 then
			message.say("We're not allowed to sell you a "..type.." key if you've got a pressed one on your keyboard. Sorry.", "clippy", false) return
		end
		-- Subtract money
		shop.money = shop.money - key.cost
		-- Add key
		key.x = 0
		key:bounce()
		keyboard.rows[row]:addKey(table.remove(shop.keys, keyID))
		-- Remove shop intro dia
		app.shopDia = false
	end,

	update = function(dt)
		local easeSpd = 200*dt
		-- Title clickable
		cursor.addMonitorClickable(shop.x + 10, shop.y + 1, 80, 20, "Welcome to the shop! Every round, the shop gets stocked with function keys and special keys to add to your keyboard. Hover over a key to check its price, and hover over your money to find out how to make some!", function() end)
		-- Keys
		for i, key in ipairs(shop.keys) do
			key.dispZ = key.z
			key.x = easeTo(key.x, shop.center.x - key.w/2, easeSpd)
			key.y = shop.y + 46*i - 20
			if shop.functionAvailable then
				cursor.addMonitorClickable(key.x, key.y, key.w, key.h, "$"..key.cost.." | "..key.desc, function() shop.buy(i) end)
			end
		end
		-- Money clickable
		cursor.addMonitorClickable(shop.x + 5, shop.y + shop.h - 45, 35, 35, "You've got $"..shop.money.." to spend. You get $1 for each row that gets used in a word, and $3 at the end of the round for getting your purp over x1, x1.5, and x2 your teel (up to $9!).", function() end)
		-- Money display easing
		shop.dispMoney = easeTo(shop.dispMoney, shop.money, dt*3*(shop.money - shop.dispMoney) + .2)
		-- Restock
		cursor.addMonitorClickable(shop.restock.x, shop.restock.y, shop.restock.w, shop.restock.h, "$"..shop.restock.cost.." | Stocks the shop with new keys. Cost goes up after use but resets after round.", function() shop.restock.buy() end)
	end,

	draw = function()
		-- Background
		rect(shop.x, shop.y, shop.w, shop.h, shop.bgCol)
		-- Title
		text("S H O P", shop.x + 10, shop.y + 1, 22, shop.titleCol)
		-- Keys
		for i, key in ipairs(shop.keys) do
			key:draw()
		end
		-- Money
		text("$"..math.floor(shop.dispMoney), shop.x + 10, shop.y + shop.h - 40, 22, shop.moneyCol)
		-- Restock
		rect(shop.restock.x, shop.restock.y, shop.restock.w, shop.restock.h, shop.restock.col)
		img(shop.restock.img, shop.restock.x, shop.restock.y)
	end

}

fullMessages = {
	"way too many keys there pal",
	"you got room for that?",
	"did you miss the \"put the square in the square hole\" lecture in kindergarten?",
	"your greed will consume you",
	"you already have so much! i don't even have arms!",
	"i want you to imagine a scenario where this key sqeezes in there",
	"where would you put it?"
}


poorMessages = {
	"get a job, bum!",
	"we only accept royalty here",
	"mighty thin wallet you got there",
	"come back when you're a little... hmmmm... richer!",
	"and how do you expect to pay for this?",
	"try your local grocery store for a cheaper alternative",
	"not in this economy",
	"where's MY cut of the check?",
	"one number here's smaller than the other, bud"
}

return shop