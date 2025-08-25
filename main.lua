_G.love = require("love")
local shader = require("shader")
local player = require("player")
local mh = require("main_hub")
local pong = require("mini_games.pong")
local invaders = require("mini_games.invaders")
local planets = require("planets")

local state = 1
local state_timer = 0

local updates = {
    mh.update,
    pong.update,
    invaders.update,
}

local draws = {
    mh.draw,
    pong.draw,
    invaders.draw,
}

function love.load()
    invaders.load()
    mh.load()
end

function love.update(dt)
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

    updates[state](dt)

    state_timer = state_timer + 1

    shader.update(dt)
end

function love.draw()
    shader:draw(function()
        draws[state]()
    end)
end