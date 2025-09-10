local Player = require("player")
local Planets = require("planets")
local Controls = require("controls")

local Main_hub = {}

local camera = {
    x = 0,
    y = 0
}

function Main_hub.load()
    --love.graphics.setBackgroundColor(1, 1, 1, 1)
    _G.plyr_img = love.graphics.newImage("imgs/novapache2.png")
    _G.projectile_img = love.graphics.newImage("imgs/star.png")
    _G.background = love.graphics.newImage("imgs/bg.png")

    _G.planeta_1 = love.graphics.newImage("imgs/planeta.png")
    _G.planeta_2 = love.graphics.newImage("imgs/planeta2.png")
    _G.planeta_3 = love.graphics.newImage("imgs/planeta3.png")

    Planets.create(300, 1000, _G.planeta_1, 2)
    Planets.create(1000, 300, _G.planeta_2, 3)
    Planets.create(1600, 900, _G.planeta_3, 4)

    Player:load(1400/2, 800/2, _G.plyr_img)
end

function Main_hub.update(dt)
    Player:update(dt)

    camera.x = Player.x - 1400 / 2 --+ Player.img:getWidth() * 2
    camera.y = Player.y - 800 / 2 --+ Player.img:getHeight() * 2

    if camera.x < 0 then camera.x = 0 end
    if camera.y < 0 then camera.y = 0 end
    if camera.x > background:getWidth()*2 then camera.x = background:getWidth()*2 end
    if camera.y > background:getHeight()*2 then camera.y = background:getHeight()*2 end

    Controls.update(camera.x + love.graphics.getWidth() / 2, camera.y + love.graphics.getHeight() / 2)
end

function Main_hub.draw()
    love.graphics.translate(-camera.x, -camera.y)
    love.graphics.draw(_G.background, 0, 0, 0, 4, 4)
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