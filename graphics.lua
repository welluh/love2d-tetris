graphics = {}

function graphics.load()
    graphics.BG = love.graphics.newImage("assets/img/platform_block.png")
    graphics.blocks = {
        O = love.graphics.newImage("assets/img/o.png"),
        I = love.graphics.newImage("assets/img/i.png"),
        T = love.graphics.newImage("assets/img/t.png"),
        J = love.graphics.newImage("assets/img/j.png"),
        L = love.graphics.newImage("assets/img/l.png"),
        S = love.graphics.newImage("assets/img/s.png"),
        Z = love.graphics.newImage("assets/img/z.png")
    }
end
