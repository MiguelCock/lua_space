local Selector = {}

local player = require "player"
local mh = require "main_hub"
local pong = require "mini_games.pong"
local invaders = require "mini_games.invaders"
local tanks = require "mini_games.tanks"
local planets = require "planets"

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

-- mini game state
local state = 1
-- game state timer
local state_timer = 0

function Selector.load()
    mh.load()
    pong.load()
    invaders.load()
    invaders.load()
    tanks.load()
end

function Selector.update(dt)
    -- Select planet when hovering it
    state_timer = state_timer + 1
    if love.keyboard.isDown("space") and state_timer > 60 then
        state = planets.checkCollision(player)
    end

    -- Select a planet manualy, for debugging
    if love.keyboard.isDown("1") then state = 1 end
    if love.keyboard.isDown("2") then state = 2 end
    if love.keyboard.isDown("3") then state = 3 end
    if love.keyboard.isDown("4") then state = 4 end

    updates[state](dt)
end

function Selector.draw()
    draws[state]()
end

return Selector