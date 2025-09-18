local Invaders = {}

local love = require "love"
local Controls = require "controls"
local Particles = require "particles"

function Invaders.load()
    Invaders.X = 600
    Invaders.X_2 = 800

    Invaders.speed = 600
    Invaders.projectiles = {}
    Invaders.projectile_fire_rate = 0
    Invaders.projectile_fire_rate_2 = 0
    Invaders.enemies = {}
    Invaders.enemy_speed = 40
    Invaders.score = 0

    Invaders.VIRTUAL_HEIGHT = 800

    _G.plyr_img = love.graphics.newImage("imgs/novapache2.png")
    _G.plyr_img_2 = love.graphics.newImage("imgs/novajolote.png")
    _G.projectile_img = love.graphics.newImage("imgs/star.png")
    _G.enemy_img = love.graphics.newImage("imgs/frog.png")
    _G.background = love.graphics.newImage("imgs/bg.png")

    Invaders.burst = Particles.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

    CreateEnemies()
end

function Invaders.update(dt)
    if love.keyboard.isDown("a") then
        Invaders.X = Invaders.X - Invaders.speed * dt
    end
    if love.keyboard.isDown("d") then
        Invaders.X = Invaders.X + Invaders.speed * dt
    end
    if love.keyboard.isDown("left") then
        Invaders.X_2 = Invaders.X_2 - Invaders.speed * dt
    end
    if love.keyboard.isDown("right") then
        Invaders.X_2 = Invaders.X_2 + Invaders.speed * dt
    end

    Controls.update(0, 0)

    Invaders.projectile_fire_rate = Invaders.projectile_fire_rate + dt
    Invaders.projectile_fire_rate_2 = Invaders.projectile_fire_rate_2 + dt

    if love.keyboard.isDown("space") and Invaders.projectile_fire_rate > 0.1 then
        Invaders.projectiles[#Invaders.projectiles + 1] = {
            x = Invaders.X + _G.plyr_img:getWidth() / 1.5,
            y = 600,
        }
        Invaders.projectile_fire_rate = 0
    end

    if love.keyboard.isDown("l") and Invaders.projectile_fire_rate_2 > 0.1 then
        Invaders.projectiles[#Invaders.projectiles + 1] = {
            x = Invaders.X_2 + _G.plyr_img_2:getWidth() / 1.5,
            y = 600,
        }
        Invaders.projectile_fire_rate_2 = 0
    end

    for i = #Invaders.projectiles, 1, -1 do
        local p = Invaders.projectiles[i]
        p.y = p.y - 1000 * dt
        if p.y < 0 then
            table.remove(Invaders.projectiles, i)
        end
    end

    -- if there are no Invaders.enemies spawn them again
    if #(Invaders.enemies) == 0 then
        CreateEnemies()
        Invaders.enemy_speed = Invaders.enemy_speed * 1.1
        Invaders.score = Invaders.score + 1000
    end

    Invaders.burst:update(dt)
    local particle_amount = 10

    -- proyectiles collision with Invaders.enemies
    for i = #Invaders.enemies, 1, -1 do
        local enemy = Invaders.enemies[i]
        for j = #Invaders.projectiles, 1, -1 do
            local p = Invaders.projectiles[j]
            if CheckCollision(p.x, p.y, _G.projectile_img:getWidth()*4, _G.projectile_img:getHeight()*4, enemy.x, enemy.y, _G.enemy_img:getWidth()*4, _G.enemy_img:getHeight()*4) then
                table.remove(Invaders.projectiles, j)
                table.remove(Invaders.enemies, i)
                Invaders.burst:setPosition(enemy.x + _G.enemy_img:getWidth()/2, enemy.y + _G.enemy_img:getHeight()/2)
                Invaders.burst:emit(particle_amount)
                Invaders.score = Invaders.score + 50
            end
        end
    end

    -- move Invaders.enemies down
    for _, enemy in ipairs(Invaders.enemies) do
        enemy.x = enemy.x + math.cos(enemy.y/10)
        enemy.y = enemy.y + Invaders.enemy_speed * dt
        if enemy.y > Invaders.VIRTUAL_HEIGHT then
            Invaders.score = 0
            Invaders.enemy_speed = 40
            CreateEnemies()
        end
    end
end

function Invaders.draw()
    love.graphics.draw(_G.background, 0, 0, 0, 2, 2)

    Controls.draw_a(50, 700)
    Controls.draw_d(114, 700)

    Controls.draw_left(1250, 700)
    Controls.draw_right(1314, 700)

    Invaders.burst:draw()
    for _, enemy in ipairs(Invaders.enemies) do
        love.graphics.draw(_G.enemy_img, enemy.x, enemy.y, 0, 4, 4)
    end

    for _, p in ipairs(Invaders.projectiles) do
        love.graphics.draw(_G.projectile_img, p.x, p.y, 0, 4, 4)
    end

    love.graphics.draw(_G.plyr_img, Invaders.X, 600, 0, 4, 4)
    love.graphics.draw(_G.plyr_img_2, Invaders.X_2, 600, 0, 4, 4)

    love.graphics.setColor(0,0,0)
    love.graphics.print("SCORE", 10, 50)
    love.graphics.setColor(0.6,0.5,0.4)
    love.graphics.print(Invaders.score, 250, 50)
    love.graphics.setColor(1,1,1)
end

function CreateEnemies()
    for i = 1, 45 do
        local y = 50
        local x = 0
        if i >= 16 then
            y = 150
            x = -(15 * (_G.enemy_img:getWidth() + 60))
        end
        if i >= 30 then
            y = 250
            x = -(30 * (_G.enemy_img:getWidth() + 60))
        end
        Invaders.enemies[i] = {
            x = 100 + x + (i - 1) * (_G.enemy_img:getWidth() + 60),
            y = y
        }
    end
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

return Invaders