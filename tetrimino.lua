local tetrimino = {}

function tetrimino.reset(shape, letter)
    tetrimino.y = -1
    tetrimino.x = 0
    tetrimino.img = {}
    tetrimino.rotation = 1
    tetrimino.letter = letter
    tetrimino.state = "falling"
    tetrimino.shape = shape
    tetrimino.rotations = table.getn(shape)
    tetrimino.offset = table.getn(shape[1][1])
    tetrimino.canvasSize = tetrimino.offset * game.cellSize
end

function tetrimino.spawn(shape, letter)
    tetrimino.reset(shape, letter)

    for rotation, shape in ipairs(shape) do
        table.insert(tetrimino.img, love.graphics.newCanvas(tetrimino.canvasSize, tetrimino.canvasSize))

        love.graphics.setCanvas(tetrimino.img[rotation])
        love.graphics.setColor(1, 0, 0)

        for i, row in ipairs(shape) do
            for j, col in ipairs(row) do
                if col == 1 then
                    game.drawCell(
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
    local x = tetrimino.x * game.cellSize + game.x + tetrimino.canvasSize
    local y = tetrimino.y * game.cellSize + game.y

    love.graphics.draw(tetrimino.img[tetrimino.rotation], x, y)
end

function tetrimino.update()
    tetrimino.down()
end

function tetrimino.rotate(dir)
    if dir == "ccw" then
        local next = tetrimino.rotation - 1

        if next < 1 then
            next = tetrimino.rotations
        end

        if not game.collides(tetrimino.x, tetrimino.y, tetrimino.shape[next]) then
            tetrimino.rotation = next
        end
    elseif dir == "cw" then
        local next = tetrimino.rotation + 1

        if next > tetrimino.rotations then
            next = 1
        end

        if not game.collides(tetrimino.x, tetrimino.y, tetrimino.shape[next]) then
            tetrimino.rotation = next
        end
    end
end

function tetrimino.down()
    local next = tetrimino.y + 1

    if not game.collides(tetrimino.x, next, tetrimino.shape[tetrimino.rotation]) then
        tetrimino.y = next
    else
        tetrimino.state = "stopped"
    end
end

function tetrimino.left()
    local next = tetrimino.x - 1

    if not game.collides(next, tetrimino.y, tetrimino.shape[tetrimino.rotation]) then
        tetrimino.x = next
    end
end

function tetrimino.right()
    local next = tetrimino.x + 1

    if not game.collides(next, tetrimino.y, tetrimino.shape[tetrimino.rotation]) then
        tetrimino.x = next
    end
end

return tetrimino
