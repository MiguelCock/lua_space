local Shooting = {}

function Shooting.load()
    
end

function Shooting.update(dt)
    
end

function Shooting.draw()
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Racing", 700, 400)
    love.graphics.setColor(1,1,1)
end

return Shooting