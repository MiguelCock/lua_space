_G.love = require "love"

local game_selector = require "mini_games.selector"
local shader = require "shader"
local controls = require "controls"
local player = require "player"
local mh = require "main_hub"
local pong = require "mini_games.pong"
local invaders = require "mini_games.invaders"
local tanks = require "mini_games.tanks"
local planets = require "planets"

-- mini game state
local state = 1
-- game state timer
local state_timer = 0
-- full screen timer
local fs_timer = 0

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
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(love.graphics.newFont("assets/fonts/daydream.otf", 32))

    game_selector.load()

    controls.load()
    shader.load()
end

function love.update(dt)
    -- Quit game
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    -- Change from or to fullscreen
    fs_timer = fs_timer + 1
    if love.keyboard.isDown("f11") and fs_timer > 30 then
        love.window.setFullscreen(not love.window.getFullscreen())
        fs_timer = 0
    end

    -- Select planet when hovering it
    state_timer = state_timer + 1
    if love.keyboard.isDown("space") and state_timer > 60 then
        state = planets.checkCollision(player)
    end

    game_selector.update(dt)

    shader.update(dt)
end

function love.draw()
    shader:draw(function()
        game_selector.draw()
    end)
end