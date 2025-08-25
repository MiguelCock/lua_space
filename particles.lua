-- particle.lua
local Particle = {}
Particle.__index = Particle

function Particle.new(x, y)
    local self = setmetatable({}, Particle)

    -- Tiny round particle image
    local size = 16
    local data = love.image.newImageData(size, size)
    data:mapPixel(function(px, py)
        local cx, cy    = px - size/2 + 0.5, py - size/2 + 0.5
        local dist = math.sqrt(cx*cx + cy*cy)
        local alpha = dist <= (size * 0.45) and 1 or 0
        return 1, 1, 1, alpha
    end)
    local img = love.graphics.newImage(data)
    img:setFilter("linear", "linear")

    -- Particle system setup
    self.ps = love.graphics.newParticleSystem(img, 512)
    self.ps:setParticleLifetime(0.4, 1.2)
    self.ps:setSizes(0.6, 0.2)
    self.ps:setSizeVariation(1)
    self.ps:setSpeed(120, 260)
    self.ps:setLinearDamping(1.5, 2.2)
    self.ps:setSpread(math.rad(70))
    self.ps:setDirection(-math.pi / 2)
    self.ps:setEmissionArea("ellipse", 12, 6, 0, true)
    self.ps:setRotation(0, math.pi * 2)
    self.ps:setSpin(-2, 2)
    self.ps:setRadialAcceleration(-40, -10)
    self.ps:setTangentialAcceleration(-20, 20)
    self.ps:setColors(
        1, 0.9, 0.6, 1,
        1, 0.4, 0.2, 0.6,
        0.2, 0.1, 0.0, 0
    )

    self.ps:setPosition(x or 0, y or 0)

    return self
end

function Particle:update(dt)
    self.ps:update(dt)
end

function Particle:draw()
    love.graphics.draw(self.ps)
end

function Particle:setPosition(x, y)
    self.ps:setPosition(x, y)
end

function Particle:emit(n)
    self.ps:emit(n)
end

return Particle
