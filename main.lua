_G.love = require("love")

love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setFont(love.graphics.newFont("assets/daydream.otf", 32))

local shader = require("shader")
local player = require("player")
local mh = require("main_hub")

-- Mini games
local pong = require("mini_games.pong")
local invaders = require("mini_games.invaders")
local tanks = require("mini_games.tanks")
local planets = require("planets")

local state = 1
local state_timer = 0

local updates = {
    mh.update,
    pong.update,
    invaders.update,
    tanks.update,
}

local draws = {
    mh.draw,
    pong.draw,
    invaders.draw,
    tanks.draw,
}

function love.load()
    invaders.load()
    pong.load()
    invaders.load()
    mh.load()
    tanks.load()
end

local fs_timer = 0

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if love.keyboard.isDown("f11") and fs_timer > 30 then
        love.window.setFullscreen(not love.window.getFullscreen())
        fs_timer = 0
    end
    fs_timer = fs_timer + 1

    if love.keyboard.isDown("p") and state_timer > 60 then
        state_timer = 0
        if state == #updates then
            state = 1
        else
            state = state + 1
        end
    end

    if love.keyboard.isDown("space") and state_timer > 60 then
        state = planets.checkCollision(player)
    end

    if love.keyboard.isDown("1") then state = 1 end
    if love.keyboard.isDown("2") then state = 2 end
    if love.keyboard.isDown("3") then state = 3 end
    if love.keyboard.isDown("4") then state = 4 end

    updates[state](dt)

    state_timer = state_timer + 1

    shader.update(dt)
end

function love.draw()
    shader:draw(function()
        draws[state]()
    end)
end