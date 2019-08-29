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
    speed = .5,
    queue = nil,
    currentPiece = 0
}

function game.run()
    game.x = (love.graphics.getWidth() - game.cols * game.cellSize) / 2
    game.y = (love.graphics.getHeight() - game.rows * game.cellSize) / 2
    game.queue = game.getBag(shapes)

    matrix.spawn()
    game.next()
end

function game.next()
    game.currentPiece = game.currentPiece + 1

    local shape = shapes[game.queue[game.currentPiece]]

    -- draw new bag of tetriminos
    if nil == shape then
        game.queue = game.getBag(shapes)
        game.currentPiece = 1
        shape = shapes[game.queue[game.currentPiece]]
    end

    tetrimino.spawn(shape.rotations, shape.letter)
end

function game.draw()
    matrix.draw()
    tetrimino.draw()
    game.drawBoard()

    if tetrimino.state == "stopped" then
        matrix.checkLandedBlocks(tetrimino)
        matrix.checkFilledRows(tetrimino)
        game.next()
    end
end

function game.drawBoard()
    for row, v in ipairs(matrix.board) do
        for col, x in ipairs(v) do
            love.graphics.print(x, col * 20, row * 20 + 96)
        end
    end
end

function game.update(dt)
    t = t + dt
    tetrimino.update(dt)

    -- auto drop on each step
    if t > game.speed then
        t = 0
        tetrimino.down()
    end
end

function game.collides(coords)
    for i, v in ipairs(coords) do
        for j, x in ipairs(v) do
            local currentRow = x.row
            local currentCol = x.col
            local occupied = x.occupied

            if matrix.board[currentRow]
                and matrix.board[currentRow][currentCol] 
                and matrix.board[currentRow][currentCol] ~= 0
                and occupied == 1 then
                return true
            end
        end
    end

    return false
end

function game.getBag(shapes)
    return utils.shuffleTable({"I","J","L","O","S","T","Z"})
end

function love.keypressed(key)
    if key == "escape" then
		love.event.quit()
    end

    if key == "up" or key == "a" then 
        tetrimino.rotate("ccw")
    elseif key == "left" then 
        tetrimino.left()
    elseif key == "right" then
        tetrimino.right()
    elseif key == "s" then 
        tetrimino.rotate("cw")
    elseif key == "down" then
        tetrimino.down()
    elseif key == "space" then
        tetrimino.hardDrop()
    end
end

function game.over()
    print("Game Over!")
    love.event.quit()
end
