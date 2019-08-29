local utils = require("utils")

local tetrimino = {
    t = 0,
    dropMode = nil,
    HARD_DROP = "hardDrop",
    SOFT_DROP = "softDrop",
    FALLING = "falling",
    STOPPED = "stopped",
    movementDelay = 0.07,
    inputDelay = 0.075 -- wait 75ms before allowing to move by holding down any key
}

function tetrimino.spawn(shape, letter)
    tetrimino.y = 0
    tetrimino.x = 4
    tetrimino.dropMode = tetrimino.SOFT_DROP
    tetrimino.rotation = 1
    tetrimino.letter = letter
    tetrimino.state = tetrimino.FALLING
    tetrimino.img = {}
    tetrimino.shape = shape
    tetrimino.rotations = table.getn(shape)
    tetrimino.canvasSize = table.getn(shape[1][1]) * game.cellSize
    tetrimino.prepareDrawables()
end

function tetrimino.prepareDrawables()
    for rotation, shape in ipairs(tetrimino.shape) do
        table.insert(tetrimino.img, love.graphics.newCanvas(tetrimino.canvasSize, tetrimino.canvasSize))

        love.graphics.setCanvas(tetrimino.img[rotation])

        for i, row in ipairs(shape) do
            for j, col in ipairs(row) do
                if col == 1 then
                    love.graphics.draw(
                        graphics.blocks[tetrimino.letter],
                        (j - 1) * game.cellSize,
                        (i - 1) * game.cellSize
                    )
                end
            end
        end

        love.graphics.setColor(1, 1, 1)
        love.graphics.setCanvas()
    end
end

function tetrimino.draw()
    local x = tetrimino.x * game.cellSize + game.x - game.cellSize
    local y = tetrimino.y * game.cellSize + game.y - game.cellSize

    love.graphics.draw(tetrimino.img[tetrimino.rotation], x, y)
end

function tetrimino.update(dt)
    local key = love.keyboard.isDown
    tetrimino.t = tetrimino.t + dt

    if tetrimino.t > tetrimino.inputDelay then
        if tetrimino.t > tetrimino.movementDelay then
            if key("left") then
                tetrimino.left()
            elseif key("right") then
                tetrimino.right()
            elseif key("down") then
                tetrimino.down()
            end
            tetrimino.t = 0
        end
    end
end

function tetrimino.rotate(dir)
    local next

    if dir == "ccw" then
        next = tetrimino.rotation - 1

        if next < 1 then
            next = tetrimino.rotations
        end
    elseif dir == "cw" then
        next = tetrimino.rotation + 1

        if next > tetrimino.rotations then
            next = 1
        end
    end

    local coords = tetrimino.getCoordinates(tetrimino.y, tetrimino.x, tetrimino.shape[next])

    if not game.collides(coords) then
        if tetrimino.letter ~= 'o' then
            sfx.play("rotate")
        end
        
        tetrimino.rotation = next
    end
end

function tetrimino.hardDrop()
    tetrimino.dropMode = tetrimino.HARD_DROP
    repeat
        tetrimino.down()
    until(tetrimino.state == tetrimino.STOPPED)
    sfx.play(tetrimino.HARD_DROP)
    tetrimino.dropMode = tetrimino.SOFT_DROP
end

function tetrimino.down()
    local next = tetrimino.y + 1
    local coords = tetrimino.getCoordinates(next, tetrimino.x, tetrimino.shape[tetrimino.rotation])

    if not game.collides(coords) then
        tetrimino.y = next
    else
        sfx.play(tetrimino.SOFT_DROP)
        tetrimino.state = tetrimino.STOPPED
    end
end

function tetrimino.left()
    local next = tetrimino.x - 1
    local coords = tetrimino.getCoordinates(tetrimino.y, next, tetrimino.shape[tetrimino.rotation])

    if not game.collides(coords) then
        tetrimino.x = next
    end

    tetrimino.t = 0
end

function tetrimino.right()
    local next = tetrimino.x + 1
    local coords = tetrimino.getCoordinates(tetrimino.y, next, tetrimino.shape[tetrimino.rotation])

    if not game.collides(coords) then
        tetrimino.x = next
    end

    tetrimino.t = 0
end

function tetrimino.getCoordinates(y, x, shape)
    y = y or tetrimino.y
    x = x or tetrimino.x
    shape = shape or tetrimino.shape[tetrimino.rotation]

    local coords = {}
    for i, row in ipairs(shape) do
        coords[i] = {}
        for j, occupied in ipairs(row) do
            table.insert(coords[i], {
                row = y + i - 1,
                col = x + j,
                occupied = occupied
            })
        end
    end

    return coords
end

return tetrimino
