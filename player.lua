local Player = {}

local Particles = require "particles"

local burst

function Player.load(self, x, y, img)
    self.x = x
    self.y = y
    self.img = img
    self.sx = 0
    self.sy = 0
    self.angle = 0
    self.radius = 16*4
    self.top_speed = 5
    self.acceleration = 1

    burst = Particles.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end

function Player.update(self, dt)
    burst:update(dt)
    burst:setPosition(Player.x, Player.y)

    local friction = 0.2

    if self.sx > 0 then
        self.sx = self.sx - friction
    elseif self.sx < 0 then
        self.sx = self.sx + friction
    end
    if self.sy > 0 then
        self.sy = self.sy - friction
    elseif self.sy < 0 then
        self.sy = self.sy + friction
    end

    if self.sx < 0.0001 and self.sx > -0.0001 then
        self.sx = 0
    end
    if self.sy < 0.0001 and self.sy > -0.0001 then
        self.sy = 0
    end

    local particle_amount = 30
    if (love.keyboard.isDown("a") or love.keyboard.isDown("left")) and self.sx > -self.top_speed then
        self.sx = self.sx - self.acceleration
        burst:emit(particle_amount)
    end
    if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) and self.sx < self.top_speed then
        self.sx = self.sx + self.acceleration
        burst:emit(particle_amount)
    end
    if (love.keyboard.isDown("w") or love.keyboard.isDown("up")) and self.sy > -self.top_speed then
        self.sy = self.sy - self.acceleration
        burst:emit(particle_amount)
    end
    if (love.keyboard.isDown("s") or love.keyboard.isDown("down")) and self.sy < self.top_speed then
        self.sy = self.sy + self.acceleration
        burst:emit(particle_amount)
    end

    self.x = self.x + self.sx
    self.y = self.y + self.sy

    self.angle = self.sx/20
    print(self.angle)
end

function Player.draw(self)
    burst:draw()
    love.graphics.draw(self.img, self.x, self.y, self.angle, 4, 4, self.img:getWidth()/2, self.img:getHeight()/2)
end

return Player