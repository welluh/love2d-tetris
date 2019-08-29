function love.load()
    require "game"
    
    -- seed the rnd generator, calling math.random() a couple of times
    -- seems to give reasonably random pieces each time
    math.randomseed(os.time()) math.random() math.random() math.random()

    -- game timer
    t = 0

    game.run()
end

function love.draw()
    game.draw()
end

function love.update(dt)
    game.update(dt)
end
