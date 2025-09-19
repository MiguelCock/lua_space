local Racing = {}

function Racing.load()
    
end

function Racing.update(dt)
    
end

function Racing.draw()
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Racing", 700, 400)
    love.graphics.setColor(1,1,1)
end

return Racing