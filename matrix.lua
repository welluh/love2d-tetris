local utils = require("utils")
local matrix = {
    board = {},
    canvas = love.graphics.newCanvas()
}

function matrix.spawn()
    matrix.prepareBoard()
    matrix.prepareDrawable()
end

function matrix.draw()
    love.graphics.draw(matrix.canvas)
    matrix.drawLandedBlocks()
end

function matrix.prepareBoard()
    -- if position is outside the actual playing field mark it as 1
    -- otherwise mark as 0. These are the outer bounds of the playing field,
    -- this means piece cannot go there because it's a wall O_O
    for i = 1, game.rows + 1 do
        matrix.board[i] = {}
        for j = 1, game.cols + 2 do
            matrix.board[i][j] = (i == game.rows + 1 or j == 1 or j == game.cols + 2) and 1 or 0
        end
    end
end

function matrix.prepareDrawable()
    local width = game.cols * game.cellSize
    local height = game.rows * game.cellSize

    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setCanvas(matrix.canvas)
    love.graphics.setColor(.2, .2, .2, .85)

    for row = 1, game.rows do
        for col = 1, game.cols do
            love.graphics.draw(
                graphics.BG,
                game.x + (col - 1) * game.cellSize,
                game.y + (row - 1) * game.cellSize
            )
        end
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setCanvas()
end

function matrix.drawLandedBlocks()
    for row, v in ipairs(matrix.board) do
        for col, letter in ipairs(v) do
            if letter ~= 0 and letter ~= 1 then
                -- offset by amount of wall tiles
                local currentCol = col - 2

                love.graphics.draw(
                    graphics.blocks[letter],
                    game.x + (currentCol) * game.cellSize,
                    game.y + (row - 1) * game.cellSize
                )
            end
        end
    end
end

function matrix.checkLandedBlocks(tetrimino)
    for i, v in ipairs(tetrimino.getCoordinates()) do
        for j, x in ipairs(v) do
            local currentRow = x.row
            local currentCol = x.col
            local occupied = x.occupied

            -- copy landed cells to game board table
            if occupied ~= 0 and
                matrix.board[currentRow] and
                matrix.board[currentRow][currentCol] then
                matrix.board[currentRow][currentCol] = tetrimino.letter
            end
        end
    end
end

function matrix.checkFilledRows(tetrimino)
    -- we only need to check the rows the last piece occupied
    local rows = {}

    for i, v in ipairs(tetrimino.getCoordinates()) do
        for j, x in ipairs(v) do
            local currentRow = x.row
            local currentCol = x.col
            local occupied = x.occupied

            if occupied ~= 0 and currentRow <= 1 then
                -- @TODO: better logic for finding out if game is over
                -- maybe check if the first row is filled / blocked
                -- after removing filled rows .. could attempt fitting
                -- next piece there??
                game.over()
            end

            if matrix.board[currentRow] then
                table.insert(rows, currentRow)
            end
        end
    end
    
    for _, row in ipairs(rows) do
        local filledRow = true

        if row < table.getn(matrix.board) then
            for _, col in ipairs(matrix.board[row]) do
                if col == 0 then
                    filledRow = false
                end
            end
            
            if filledRow then
                sfx.play("clear")
                table.remove(matrix.board, row)
                table.insert(matrix.board, 1, {1,0,0,0,0,0,0,0,0,0,0,1})
            end
        end
    end
end

return matrix
