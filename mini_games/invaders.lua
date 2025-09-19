local Invaders = {}

local love = require "love"
local Controls = require "controls"
local Particles = require "particles"

function Invaders.load()
    Invaders.VIRTUAL_HEIGHT = 800
    
    Invaders.players_speed = 600

    -- Player 1
    Invaders.player_1 = {}
    Invaders.player_1.x = 600
    Invaders.player_1.fire_rate = 0
    _G.plyr_img = love.graphics.newImage("assets/imgs/novapache2.png")

    -- Player 2
    Invaders.player_2 = {}
    Invaders.player_2.x = 800
    Invaders.player_2.fire_rate = 0
    _G.plyr_img_2 = love.graphics.newImage("assets/imgs/novajolote.png")

    -- Projectiles
    Invaders.projectiles = {}
    Invaders.projectile_speed = 1000
    _G.projectile_img = love.graphics.newImage("assets/imgs/star.png")

    -- Enemies
    Invaders.enemies = {}
    Invaders.enemy_speed = 40
    Invaders.score = 0
    _G.enemy_img = love.graphics.newImage("assets/imgs/frog.png")

    -- Background
    _G.background = love.graphics.newImage("assets/imgs/bg.png")

    -- Particles
    Invaders.burst = Particles.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

    CreateEnemies()
end

function Invaders.update(dt)
    -- Player 1 Controls
    if love.keyboard.isDown("a") then
        Invaders.player_1.x = Invaders.player_1.x - Invaders.players_speed * dt
    end
    if love.keyboard.isDown("d") then
        Invaders.player_1.x = Invaders.player_1.x + Invaders.players_speed * dt
    end

    -- Player 2 Controls
    if love.keyboard.isDown("left") then
        Invaders.player_2.x = Invaders.player_2.x - Invaders.players_speed * dt
    end
    if love.keyboard.isDown("right") then
        Invaders.player_2.x = Invaders.player_2.x + Invaders.players_speed * dt
    end

    -- Controls images positions 
    Controls.update(0, 0)

    -- Player 1 shooting projectiles
    Invaders.player_2.fire_rate = Invaders.player_2.fire_rate + dt
    if love.keyboard.isDown("space") and Invaders.player_1.fire_rate > 0.1 then
        Invaders.projectiles[#Invaders.projectiles + 1] = {
            x = Invaders.player_1.x + _G.plyr_img:getWidth() / 1.5,
            y = 600,
        }
        Invaders.player_1.fire_rate = 0
    end

    -- Player 2 shooting projectiles
    Invaders.player_1.fire_rate = Invaders.player_1.fire_rate + dt
    if love.keyboard.isDown("l") and Invaders.player_2.fire_rate > 0.1 then
        Invaders.projectiles[#Invaders.projectiles + 1] = {
            x = Invaders.player_2.x + _G.plyr_img_2:getWidth() / 1.5,
            y = 600,
        }
        Invaders.player_2.fire_rate = 0
    end

    -- Update proyectiles positions
    for i = #Invaders.projectiles, 1, -1 do
        local p = Invaders.projectiles[i]
        p.y = p.y - Invaders.projectile_speed * dt
        if p.y < 0 then
            table.remove(Invaders.projectiles, i)
        end
    end

    -- if there are no Invaders.enemies spawn them again
    -- increase the speed when this happens
    if #(Invaders.enemies) == 0 then
        CreateEnemies()
        Invaders.enemy_speed = Invaders.enemy_speed * 1.1
        Invaders.score = Invaders.score + 1000
    end

    -- Partilce Update
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

    -- Update enemies positions
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

    -- Draw player 1 controls
    Controls.draw_a(50, 700)
    Controls.draw_d(114, 700)

    -- Draw player 2 controls
    Controls.draw_left(1250, 700)
    Controls.draw_right(1314, 700)

    -- Draw Particles
    Invaders.burst:draw()

    -- Draw Enemies
    for _, enemy in ipairs(Invaders.enemies) do
        love.graphics.draw(_G.enemy_img, enemy.x, enemy.y, 0, 4, 4)
    end

    -- Draw projectiles
    for _, p in ipairs(Invaders.projectiles) do
        love.graphics.draw(_G.projectile_img, p.x, p.y, 0, 4, 4)
    end

    -- Draw Players
    love.graphics.draw(_G.plyr_img, Invaders.player_1.x, 600, 0, 4, 4)
    love.graphics.draw(_G.plyr_img_2, Invaders.player_2.x, 600, 0, 4, 4)

    -- Draw score
    love.graphics.setColor(0,0,0)
    love.graphics.print("SCORE", 10, 50)
    love.graphics.setColor(0.6,0.5,0.4)
    love.graphics.print(Invaders.score, 250, 50)
    love.graphics.setColor(1,1,1)
end

-- Function for creation and spawn them again
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