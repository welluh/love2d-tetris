local matrix = require("matrix")

local tetrimino = {
    y = 0,
    x = 0,
    img = {},
    rotation = 1
}

function tetrimino.spawn(shape)
    tetrimino.rotations = #shape
    local offset = table.getn(shape[1][1]) * matrix.cellSize
    tetrimino.x = matrix.coords.x + offset
    tetrimino.y = matrix.coords.y

    for rotation, shape in ipairs(shape) do
        table.insert(tetrimino.img, love.graphics.newCanvas(offset, offset))

        love.graphics.setCanvas(tetrimino.img[rotation])
        love.graphics.setColor(1, 0, 0)

        for i, row in ipairs(shape) do
            for j, col in ipairs(row) do
                if col == 1 then
                    matrix.drawCell(
                        'fill',
                        (j - 1) * matrix.cellSize,
                        (i - 1) * matrix.cellSize
                    )
                end
            end
        end

        love.graphics.setColor(1, 1, 1)
        love.graphics.setCanvas()
    end
end

function tetrimino.draw()
    love.graphics.draw(
        tetrimino.img[tetrimino.rotation], 
        tetrimino.x, 
        tetrimino.y
    )
end

function tetrimino.update()
    tetrimino.down()
end

function tetrimino.rotate()
    tetrimino.rotation = tetrimino.rotation + 1

    if tetrimino.rotation > tetrimino.rotations then
        tetrimino.rotation = 1
    end
end

function tetrimino.down(v)
    tetrimino.y = tetrimino.y + matrix.cellSize
end

function tetrimino.left()
    tetrimino.x = tetrimino.x - matrix.cellSize
end

function tetrimino.right()
    tetrimino.x = tetrimino.x + matrix.cellSize
end

return tetrimino
