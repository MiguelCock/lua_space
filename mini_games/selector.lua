local Selector = {}

local player = require "player"
local mh = require "main_hub"
local planets = require "planets"

local pong = require "mini_games.pong"
local invaders = require "mini_games.invaders"
local tanks = require "mini_games.tanks"
local racing = require "mini_games.racing"
local candy = require "mini_games.candy"
local flappybirds = require "mini_games.flappy_birds"
local sumo = require "mini_games.sumo"
local shooting = require "mini_games.shooting"
local labyrinth = require "mini_games.labyrinth"

local updates = {
    mh.update,
    pong.update,
    invaders.update,
    tanks.update,
    racing.update,
    candy.update,
    flappybirds.update,
    sumo.update,
    shooting.update,
    labyrinth.update
}

local draws = {
    mh.draw,
    pong.draw,
    invaders.draw,
    tanks.draw,
    racing.draw,
    candy.draw,
    flappybirds.draw,
    sumo.draw,
    shooting.draw,
    labyrinth.draw
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
    racing.load()
    candy.load()
    flappybirds.load()
    sumo.load()
    shooting.load()
    labyrinth.load()
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
    if love.keyboard.isDown("5") then state = 5 end
    if love.keyboard.isDown("6") then state = 6 end
    if love.keyboard.isDown("7") then state = 7 end
    if love.keyboard.isDown("8") then state = 8 end
    if love.keyboard.isDown("9") then state = 9 end
    if love.keyboard.isDown("0") then state = 0 end

    updates[state](dt)
end

function Selector.draw()
    draws[state]()
end

return Selector