local utils = require("utils")

local tetrimino = {}

function tetrimino.spawn(shape, letter)
    tetrimino.y = -1
    tetrimino.x = 4
    tetrimino.img = {}
    tetrimino.rotation = 1
    tetrimino.letter = letter
    tetrimino.state = "falling"
    tetrimino.shape = shape
    tetrimino.rotations = table.getn(shape)
    tetrimino.canvasSize = table.getn(shape[1][1]) * game.cellSize
    tetrimino.prepareDrawables()
end

function tetrimino.prepareDrawables()
    for rotation, shape in ipairs(tetrimino.shape) do
        table.insert(tetrimino.img, love.graphics.newCanvas(tetrimino.canvasSize, tetrimino.canvasSize))

        love.graphics.setCanvas(tetrimino.img[rotation])
        love.graphics.setColor(1, 0, 0)

        for i, row in ipairs(shape) do
            for j, col in ipairs(row) do
                if col == 1 then
                    utils.drawCell(
                        'fill',
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

function tetrimino.update()
    tetrimino.down()
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
        tetrimino.rotation = next
    end
end

function tetrimino.hardDrop()
    game.speed = 0.001
end

function tetrimino.down()
    local next = tetrimino.y + 1
    local coords = tetrimino.getCoordinates(next, tetrimino.x, tetrimino.shape[tetrimino.rotation])

    if not game.collides(coords) then
        tetrimino.y = next
    else
        tetrimino.state = "stopped"
    end
end

function tetrimino.left()
    local next = tetrimino.x - 1
    local coords = tetrimino.getCoordinates(tetrimino.y, next, tetrimino.shape[tetrimino.rotation])

    if not game.collides(coords) then
        tetrimino.x = next
    end
end

function tetrimino.right()
    local next = tetrimino.x + 1
    local coords = tetrimino.getCoordinates(tetrimino.y, next, tetrimino.shape[tetrimino.rotation])

    if not game.collides(coords) then
        tetrimino.x = next
    end
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
