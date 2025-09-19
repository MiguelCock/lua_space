local Candy = {}

function Candy.load()
    
end

function Candy.update(dt)
    
end

function Candy.draw()
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Candy", 700, 400)
    love.graphics.setColor(1,1,1)
end

return Candy