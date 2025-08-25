Player = require("player")
Planets = require("planets")

Main_hub = {}

local fs_timer = 0

local camera = {
    x = 0,
    y = 0
}

function Main_hub.load()
    love.graphics.setBackgroundColor(1, 1, 1, 1)
    love.graphics.setDefaultFilter("nearest", "nearest")

    _G.plyr_img = love.graphics.newImage("imgs/novapache2.png")
    _G.projectile_img = love.graphics.newImage("imgs/star.png")
    _G.background = love.graphics.newImage("imgs/bg.png")

    _G.planeta_1 = love.graphics.newImage("imgs/planeta.png")

    Planets.create(300, 1000, _G.planeta_1, 2)
    Planets.create(1000, 300, _G.planeta_1, 3)

    Player:load(800, 400, _G.plyr_img)
end

function Main_hub.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    fs_timer = fs_timer + 1
    if love.keyboard.isDown("f11") and fs_timer > 30 then
        love.window.setFullscreen(not love.window.getFullscreen())
        fs_timer = 0
    end

    Player:update(dt)

    camera.x = Player.x - love.graphics.getWidth() / 2
    camera.y = Player.y - love.graphics.getHeight() / 2

    if camera.x < 0 then camera.x = 0 end
    if camera.y < 0 then camera.y = 0 end
    if camera.x > background:getWidth()*2 then camera.x = background:getWidth()*2 end
    if camera.y > background:getHeight()*2 then camera.y = background:getHeight()*2 end
end

function Main_hub.draw()
    love.graphics.translate(-camera.x, -camera.y)
    love.graphics.draw(_G.background, 0, 0, 0, 4, 4)
    Planets.draw()
    Player:draw()
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

return Main_hub