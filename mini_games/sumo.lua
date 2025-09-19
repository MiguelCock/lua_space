local Sumo = {}

function Sumo.load()
    
end

function Sumo.update(dt)
    
end

function Sumo.draw()
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Sumo", 700, 400)
    love.graphics.setColor(1,1,1)
end

return Sumo