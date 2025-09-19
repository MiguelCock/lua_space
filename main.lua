_G.love = require "love"

local game_selector = require "mini_games.selector"
local shader = require "shader"
local controls = require "controls"

-- full screen timer
local fs_timer = 0

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

    game_selector.update(dt)

    shader.update(dt)
end

function love.draw()
    shader:draw(function()
        game_selector.draw()
    end)
end