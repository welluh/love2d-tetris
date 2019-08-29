function love.load()
    require "game"
    require "sfx"
    -- require "graphics"
    
    -- seed the rng, calling math.random() a couple of times
    -- seems to give reasonably random pieces each time
    math.randomseed(os.time()) math.random() math.random() math.random()

    -- game timer
    t = 0

    sfx.load()
    -- graphics.load()
    game.run()
end

function love.draw()
    game.draw()
end

function love.update(dt)
    game.update(dt)
end
