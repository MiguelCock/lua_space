-- planets.lua
local planets = {}

-- Create and save a planet
function planets.create(x, y, img, miniGameIndex)
    local planet = {
        x = x,
        y = y,
        img = img,
        radius = img:getWidth() * 8,
        miniGameIndex = miniGameIndex
    }
    table.insert(planets, planet)
end

-- Return the miniGameIndex of the planet being collided with
-- Returns nil if no collision
function planets.checkCollision(player)
    for _, planet in ipairs(planets) do
        local dx = player.x - planet.x
        local dy = player.y - planet.y
        local distance = math.sqrt(dx * dx + dy * dy)
        if distance < (player.radius + planet.radius) then
            return planet.miniGameIndex
        end
    end
    return 1
end

-- Draw all planets (optional helper)
function planets.draw()
    for _, planet in ipairs(planets) do
        love.graphics.draw(planet.img, planet.x, planet.y, 0, 8, 8)
    end
end

return planets
