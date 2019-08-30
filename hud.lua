local hud = {
    next = nil,
}

function hud.spawn(next)
    hud.next = {}
    for rotation, shape in ipairs(next.rotations) do
        table.insert(hud.next, love.graphics.newCanvas(next.canvasSize, next.canvasSize))
        love.graphics.setCanvas(hud.next[rotation])

        for i, row in ipairs(shape) do
            for j, col in ipairs(row) do
                if col == 1 then
                    love.graphics.draw(
                        graphics.blocks[next.letter],
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

function hud.draw()
    local x = love.graphics.getWidth() / 2 + game.cols * game.cellSize / 2 + game.cellSize * 2
    love.graphics.draw(hud.next[1], x, game.y)
end

return hud
