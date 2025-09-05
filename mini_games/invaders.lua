local love = require "love"
local Controls = require "controls"
local Invaders = {}

X = 600
X_2 = 800

local speed = 6
local projectiles = {}
local projectile_fire_rate = 0
local projectile_fire_rate_2 = 0
local enemies = {}
local enemy_speed = 0.4
local fs_timer = 0
local score = 0

local VIRTUAL_HEIGHT = 800

_G.plyr_img = love.graphics.newImage("imgs/novapache2.png")
_G.plyr_img_2 = love.graphics.newImage("imgs/novajolote.png")
_G.projectile_img = love.graphics.newImage("imgs/star.png")
_G.enemy_img = love.graphics.newImage("imgs/frog.png")
_G.background = love.graphics.newImage("imgs/bg.png")

function Invaders.load()
    CreateEnemies()
end

function Invaders.update()
    if love.keyboard.isDown("a") then
        X = X - speed
    end
    if love.keyboard.isDown("d") then
        X = X + speed
    end
    if love.keyboard.isDown("left") then
        X_2 = X_2 - speed
    end
    if love.keyboard.isDown("right") then
        X_2 = X_2 + speed
    end

    Controls.update(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

    projectile_fire_rate = projectile_fire_rate + 1
    projectile_fire_rate_2 = projectile_fire_rate_2 + 1

    if love.keyboard.isDown("space") and projectile_fire_rate > 15 then
        projectiles[#projectiles + 1] = {
            x = X + _G.plyr_img:getWidth() / 1.5,
            y = 600,
        }
        projectile_fire_rate = 0
    end

    if love.keyboard.isDown("l") and projectile_fire_rate_2 > 15 then
        projectiles[#projectiles + 1] = {
            x = X_2 + _G.plyr_img_2:getWidth() / 1.5,
            y = 600,
        }
        projectile_fire_rate_2 = 0
    end

    for i = #projectiles, 1, -1 do
        local p = projectiles[i]
        p.y = p.y - 10
        if p.y < 0 then
            table.remove(projectiles, i)
        end
    end

    -- if there are no enemies spawn them again
    if #(enemies) == 0 then
        CreateEnemies()
        enemy_speed = enemy_speed + 0.1
        score = score + 1000
    end

    -- proyectiles collision with enemies
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        for j = #projectiles, 1, -1 do
            local p = projectiles[j]
            if CheckCollision(p.x, p.y, _G.projectile_img:getWidth()*4, _G.projectile_img:getHeight()*4, enemy.x, enemy.y, _G.enemy_img:getWidth()*4, _G.enemy_img:getHeight()*4) then
                table.remove(projectiles, j)
                table.remove(enemies, i)
                score = score + 50
                break
            end
        end
    end

    -- move enemies down
    for _, enemy in ipairs(enemies) do
        enemy.x = enemy.x + math.cos(enemy.y/10)
        enemy.y = enemy.y + enemy_speed
        if enemy.y > VIRTUAL_HEIGHT then
            score = 0
            enemy_speed = 0.4
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

    for _, enemy in ipairs(enemies) do
        love.graphics.draw(_G.enemy_img, enemy.x, enemy.y, 0, 4, 4)
    end

    for _, p in ipairs(projectiles) do
        love.graphics.draw(_G.projectile_img, p.x, p.y, 0, 4, 4)
    end

    love.graphics.draw(_G.plyr_img, X, 600, 0, 4, 4)
    love.graphics.draw(_G.plyr_img_2, X_2, 600, 0, 4, 4)
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
        enemies[i] = {
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