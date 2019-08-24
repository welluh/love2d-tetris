local matrix = require("matrix")
local tetrimino = require("tetrimino")
local shapes = require("tetriminos/all")

function love.load()
    -- seed the rnd generator, calling math.random() a couple of times
    -- seems to give reasonably random pieces each time
    math.randomseed(os.time()) math.random() math.random() math.random()

    -- game timer
    t = 0

	-- temporary table to hold all shapes for shuffling
    local temp = {
        shapes["O"],
        shapes["I"],
        shapes["S"],
        shapes["Z"],
        shapes["L"],
        shapes["J"],
        shapes["T"],
    }
    local queue = shuffle(temp)
    matrix.spawn()
    tetrimino.spawn(queue[1])
end

function love.draw()
    matrix.draw()
    tetrimino.draw()
end

function love.update(dt)
    t = t + dt
    
    if t > 1 then
        t = 0
        tetrimino.update()
    end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
    end
    
    if key == "up" then
        tetrimino.rotate()
    elseif key == "down" then
        tetrimino.down()
    elseif key == "left" then
        tetrimino.left()
    elseif key == "right" then
        tetrimino.right()
    end
end

function shuffle(temp)
	local n = #temp
		
	for i = 1, n do
		local k = math.random(n)
		temp[n], temp[k] = temp[k], temp[n]
		n = n - 1
	end
		
	return temp
end
