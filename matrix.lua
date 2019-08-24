local matrix = {
    coords = {
        x = nil,
        y = nil
    },
    cellSize = 28,
    rows = 22,
    cols = 12,
    canvas = love.graphics.newCanvas()
}

function matrix.spawn()
    matrix.coords.x = (love.graphics.getWidth() - (matrix.cols * matrix.cellSize)) / 2
    matrix.coords.y = (love.graphics.getHeight() - (matrix.rows * matrix.cellSize)) / 2
    local width = matrix.cols * matrix.cellSize
    local height = matrix.rows * matrix.cellSize

    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setCanvas(matrix.canvas)
    love.graphics.setColor(1, 1, 1, .75)

    for row = 1, matrix.rows do
        for col = 1, matrix.cols do
            matrix.drawCell(
                'line', 
                matrix.coords.x + (col - 1) * matrix.cellSize,
                matrix.coords.y + (row - 1) * matrix.cellSize
            )
        end
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setCanvas()
end

function matrix.draw()
    love.graphics.draw(matrix.canvas)
end

function matrix.drawCell(mode, x, y)
    love.graphics.rectangle(
        mode,
        x,
        y,
        matrix.cellSize - 1,
        matrix.cellSize - 1
    )
end

return matrix
