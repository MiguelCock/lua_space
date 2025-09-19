local Planets = {}

-- Create and save a planet
function Planets.create(x, y, scale, img, miniGameIndex)
    local planet = {
        x = x,
        y = y,
        img = img,
        scale = scale,
        radius = img:getWidth() * scale,
        miniGameIndex = miniGameIndex
    }
    table.insert(Planets, planet)
end

-- Return the miniGameIndex of the planet being collided with
-- Returns nil if no collision
function Planets.checkCollision(player)
    for _, planet in ipairs(Planets) do
        local dx = player.x - planet.x
        local dy = player.y - planet.y
        local distance = math.sqrt(dx * dx + dy * dy)
        if distance < (player.radius + planet.radius) then
            return planet.miniGameIndex
        end
    end
    return 1
end

-- Draw all Planets
function Planets.draw()
    for _, planet in ipairs(Planets) do
        love.graphics.draw(planet.img, planet.x, planet.y, 0, planet.scale * 2, planet.scale * 2, planet.img:getWidth()/2, planet.img:getHeight()/2)
    end
end

return Planets
