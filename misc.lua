function mid(a,b,c)
	return math.max(math.min(a,b), math.min(math.max(a,b),c));
end

function angle_move(x,y, targetx, targety, speed)
	local a=math.atan2(x-targetx,y-targety)
	return {x=-speed*math.sin(a), y=-speed*math.cos(a)}
end

function distanceToObjs(obj1, obj2)
	x = obj2.x - obj1.x
	y = obj2.y - obj1.y
	return math.sqrt(x^2 + y^2)
end

function distanceToPnts(x1, y1, x2, y2)
	x = x2 - x1
	y = y2 - y1
	return math.sqrt(x^2 + y^2)
end

function shallow_copy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        copy[k] = v
    end
    return copy
end

function randomize_array(arr)
	ret = {}
	while (#arr > 0) do
		table.insert(ret, table.remove(arr, 1 + math.floor(math.random()*#arr)))
	end
	for i, value in ipairs(ret) do
		table.insert(arr, value)
	end
	return ret
end

function get_random_value(arr)
	return arr[math.floor(math.random()*#arr) + 1]
end

function get_text_x_by_center(center, length, size)
	return center - length * size / 3 
end

function wrap_text(str, limit)
    local result = ""
    local count = 0

    for word in str:gmatch("%S+") do
        if count + #word + 1 > limit then
            result = result .. "\n" .. word
            count = #word
        else
            if result ~= "" then
                result = result .. " " .. word
                count = count + #word + 1
            else
                result = word
                count = #word
            end
        end
    end

    return result
end

function num_to_place(num)
	local comp_num = num % 10
	if comp_num == 1 then return "st"
	elseif comp_num == 2 then return "nd"
	elseif comp_num == 3 then return "rd"
	else return "th" end
end

function mid(a, b, c)
	return math.max(math.min(a,b), math.min(math.max(a,b),c))
end

-- Shortened Love/drawing functions
indexed_fonts = {}
function set_font_size(size)
	if indexed_fonts[size] == nil then
		indexed_fonts[size] = love.graphics.newFont("EnvyCodeRBold.ttf", size)
	end
	love.graphics.setFont(indexed_fonts[size])
end

function rect(x, y, w, h, c)
	love.graphics.setColor(unpack(c))
	love.graphics.rectangle("fill", x, y, w, h)
end

function rectLine(x, y, w, h, c, r)
	love.graphics.setColor(unpack(c))
	love.graphics.setLineStyle("rough")
	love.graphics.rectangle("line", x, y, w, h, r)
end

function circ(x, y, r, c)
	love.graphics.setColor(unpack(c))
	love.graphics.circle("fill", x, y, r)
end

function circLine(x, y, r, c)
	love.graphics.setColor(unpack(c))
	love.graphics.setLineStyle("rough")
	love.graphics.circle("line", x, y, r)
end

function img(img, x, y, r, s)
	love.graphics.setColor({1,1,1})
	love.graphics.draw(img, x, y, r, s)
end

function color(c1, c2, c3)
	love.graphics.setColor(c1, c2, c3)
end

function line(x1, y1, x2, y2, w, c)
	if x1 == x2 then
		rect(x1 - w, y1, w*2, y2 - y1, c)
	elseif y1 == y2 then
		rect(x1, y1 - w, x2 - x1, w*2, c)
	end
end

function text(string, x, y, size, color)
	love.graphics.setColor(unpack(color))
	set_font_size(size)
	love.graphics.print(string, x, y)
end

function textCenter(string, x, y, size, color)
	newX = x - size/2*(#string/2) - 10
	text(string, newX, y, size, color)
end

function easeTo(from, to, dt)
	return mid(from - dt, to, from + dt)
end

function inList(list, key)
	for i, item in ipairs(list) do
		if key == item then return true end
	end
	return false
end