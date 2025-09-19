local Player = require "player"
local Planets = require "planets"
local Controls = require "controls"

local Main_hub = {}

local camera = {
    x = 0,
    y = 0
}

function Main_hub.load()
    Main_hub.plyr_img = love.graphics.newImage("assets/imgs/novapache2.png")
    Main_hub.projectile_img = love.graphics.newImage("assets/imgs/star.png")
    Main_hub.background = love.graphics.newImage("assets/imgs/bg.png")

    Planets.create(300, 1000, love.graphics.newImage("assets/imgs/planeta.png"), 2)
    Planets.create(1000, 300, love.graphics.newImage("assets/imgs/planeta2.png"), 3)
    Planets.create(1600, 900, love.graphics.newImage("assets/imgs/planeta3.png"), 4)

    Player:load(1400/2, 800/2, Main_hub.plyr_img)
end

function Main_hub.update(dt)
    Player:update(dt)

    camera.x = Player.x - 1400 / 2
    camera.y = Player.y - 800 / 2

    if camera.x < 0 then camera.x = 0 end
    if camera.y < 0 then camera.y = 0 end
    if camera.x > background:getWidth()*2 then camera.x = background:getWidth()*2 end
    if camera.y > background:getHeight()*2 then camera.y = background:getHeight()*2 end

    Controls.update(camera.x, camera.y)
end

function Main_hub.draw()
    love.graphics.translate(-camera.x, -camera.y)
    love.graphics.draw(Main_hub.background, 0, 0, 0, 4, 4)
    Planets.draw()
    Controls.draw_wasd(150, 600)
    Controls.draw_arrows(1150, 600)
    Player:draw()
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

return Main_hub