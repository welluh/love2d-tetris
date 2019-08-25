local matrix = {
    canvas = love.graphics.newCanvas()
}

function matrix.spawn()
    local width = game.cols * game.cellSize
    local height = game.rows * game.cellSize

    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setCanvas(matrix.canvas)
    love.graphics.setColor(1, 1, 1, .75)

    for row = 1, game.rows do
        for col = 1, game.cols do
            game.drawCell(
                'line', 
                game.x + (col - 1) * game.cellSize,
                game.y + (row - 1) * game.cellSize
            )
        end
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setCanvas()
end

function matrix.draw()
    love.graphics.draw(matrix.canvas)
end

return matrix
