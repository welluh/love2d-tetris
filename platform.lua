local platform = {
    cellSize = 28,
    rows = 22,
    cols = 12,
    matrix = love.graphics.newCanvas()
}

function platform.spawn()
    local width = platform.cols * platform.cellSize
    local height = platform.rows * platform.cellSize

    love.graphics.setCanvas(platform.matrix)
    love.graphics.setColor(1, 1, 1, .75)

    for row = 0, platform.rows do
        for col = 0, platform.cols do
            love.graphics.rectangle(
                'line', 
                (love.graphics.getWidth() - width) / 2 + col * platform.cellSize,
                (love.graphics.getHeight() - height) / 2 + row * platform.cellSize,
                platform.cellSize,
                platform.cellSize
            )
        end
    end

    love.graphics.setCanvas()
end

function platform.draw()
    love.graphics.draw(platform.matrix)
end

return platform
