local platform = require("platform")

function love.load()
    platform:spawn()
end

function love.draw()
    platform:draw()
end

function love.update(dt)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
