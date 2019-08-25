local utils = require("utils")
local matrix = require("matrix")
local tetrimino = require("tetrimino")
local shapes = require("tetriminos/all")

game = {
    x = nil,
    y = nil,
    cellSize = 28,
    rows = 20,
    cols = 10,
    occupiedCells = {},
    queue = nil,
}

function game.init()
    game.x = (love.graphics.getWidth() - (game.cols * game.cellSize)) / 2
    game.y = (love.graphics.getHeight() - (game.rows * game.cellSize)) / 2
    game.queue = game.getBag(shapes)
    game.currentPiece = 0
end

function game.run()
    for i = 1, game.rows + 1 do
        game.occupiedCells[i] = {}
        for j = 1, game.cols + 2 do
            -- if position is outside the actual playing field mark it as 1
            -- otherwise mark as 0. These are the outer bounds of the playing field
            -- aka piece cannot go there because it's a wall O_O
            game.occupiedCells[i][j] = (i == game.rows + 1 or j == 1 or j == game.cols + 2) and 1 or 0
        end
    end

    matrix.spawn()
    game.next()
end

function game.next()
    game.currentPiece = game.currentPiece + 1
    local c = shapes[game.queue[game.currentPiece]]

    if nil == c then
        game.queue = game.getBag(shapes)
        game.currentPiece = 1
        c = shapes[game.queue[game.currentPiece]]
    end

    tetrimino.spawn(c.rotations, c.letter)
end

function game.draw()
    -- draw occupied cells
    for row, v in ipairs(game.occupiedCells) do
        for col, x in ipairs(v) do
            love.graphics.print(x, 5 + col * 15, 76 + row * 15)

            if x ~= 0 and x ~= 1 then
                love.graphics.rectangle(
                    'fill',
                    game.x + (col - 2) * game.cellSize,
                    game.y + (row - 1) * game.cellSize,
                    game.cellSize - 1,
                    game.cellSize - 1
                )
            end
        end
    end

    matrix.draw()
    tetrimino.draw()

    -- if tetrimino is stopped copy landed cells to occupiedCells table
    if tetrimino.state == "stopped" then
        local shape = tetrimino.shape[tetrimino.rotation]
        local rows = {}

        for i, row in ipairs(shape) do
            local currentRow = tetrimino.y + i
            table.insert(rows, currentRow)
            
            for j, col in ipairs(row) do
                -- @TODO: get rid of the whole offset position juggling!
                local currentCol = tetrimino.x + tetrimino.offset + j + 1
    
                if game.occupiedCells[currentRow] 
                    and game.occupiedCells[currentRow][currentCol] 
                    and col == 1 then
                        game.occupiedCells[currentRow][currentCol] = tetrimino.letter
                end
            end
        end

        -- check filled rows
        local n = 0
        for _, row in ipairs(rows) do
            -- @TODO: better logic for finding out if game is over
            if row == 0 then
                print("Game Over!")
                love.event.quit()
            end

            if game.occupiedCells[row] then
                local blocks = 0

                for _, col in ipairs(game.occupiedCells[row]) do
                    if col ~= 0 and col ~= 1 then
                        blocks = blocks + 1
                    end
                end

                if blocks == 10 then
                    n = n + 1
                    table.remove(game.occupiedCells, row)
                    table.insert(game.occupiedCells, 1, {1,0,0,0,0,0,0,0,0,0,0,1})
                end
            end
        end

        -- next piece
        game.next()
    end
end

function game.update(dt)
    t = t + dt
    
    if t > .5 then
        t = 0
        tetrimino.update()
    end
end

function game.collides(x, y, shape)
    for i, row in ipairs(shape) do
        local currentRow = y + i

        for j, col in ipairs(row) do
            -- @TODO: get rid of the whole offset position juggling!
            local currentCol = x + tetrimino.offset + j + 1

            if game.occupiedCells[currentRow] 
                and game.occupiedCells[currentRow][currentCol] 
                and game.occupiedCells[currentRow][currentCol] ~= 0
                and col == 1 then
                return true
            end
        end
    end

    return false
end

function game.getBag(shapes)
    return utils.shuffleTable({"I","J","L","O","S","T","Z"})
end

function game.drawCell(mode, x, y)
    love.graphics.rectangle(
        mode,
        x,
        y,
        game.cellSize - 1,
        game.cellSize - 1
    )
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
    end
    
    if key == "up" or key == "a" then 
        tetrimino.rotate("ccw")
    elseif key == "s" then 
        tetrimino.rotate("cw")
    elseif key == "down" then
        tetrimino.down()
    elseif key == "left" then
        tetrimino.left()
    elseif key == "right" then
        tetrimino.right()
    end
end
