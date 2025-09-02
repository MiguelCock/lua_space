Controls = {
    spriteSheet = love.graphics.newImage("imgs/WASD.png"),
    quads = {
        w_up = love.graphics.newQuad(0, 0, 16, 16, 128, 32),
        w_down = love.graphics.newQuad(16, 0, 16, 16, 128, 32),
        a_up = love.graphics.newQuad(32, 0, 16, 16, 128, 32),
        a_down = love.graphics.newQuad(48, 0, 16, 16, 128, 32),
        s_up = love.graphics.newQuad(64, 0, 16, 16, 128, 32),
        s_down = love.graphics.newQuad(80, 0, 16, 16, 128, 32),
        d_up = love.graphics.newQuad(96, 0, 16, 16, 128, 32),
        d_down = love.graphics.newQuad(112, 0, 16, 16, 128, 32),
        arrow_up_up = love.graphics.newQuad(0, 16, 16, 16, 128, 32),
        arrow_up_down = love.graphics.newQuad(16, 16, 16, 16, 128, 32),
        arrow_left_up = love.graphics.newQuad(32, 16, 16, 16, 128, 32),
        arrow_left_down = love.graphics.newQuad(48, 16, 16, 16, 128, 32),
        arrow_down_up = love.graphics.newQuad(64, 16, 16, 16, 128, 32),
        arrow_down_down = love.graphics.newQuad(80, 16, 16, 16, 128, 32),
        arrow_right_up = love.graphics.newQuad(96, 16, 16, 16, 128, 32),
        arrow_right_down = love.graphics.newQuad(112, 16, 16, 16, 128, 32),
    },
    offset = { x = 0, y = 0 }
}

local key_pressed = {
    w = false,
    a = false,
    s = false,
    d = false,
    up = false,
    down = false,
    left = false,
    right = false
}

function Controls.update(camera_x, camera_y)
    key_pressed.w = love.keyboard.isDown("w")
    key_pressed.a = love.keyboard.isDown("a")
    key_pressed.s = love.keyboard.isDown("s")
    key_pressed.d = love.keyboard.isDown("d")
    key_pressed.up = love.keyboard.isDown("up")
    key_pressed.down = love.keyboard.isDown("down")
    key_pressed.left = love.keyboard.isDown("left")
    key_pressed.right = love.keyboard.isDown("right")

    Controls.offset.x = camera_x - love.graphics.getWidth() / 2
    Controls.offset.y = camera_y - love.graphics.getHeight() / 2
end

function Controls.draw()
    if key_pressed.w then
        love.graphics.draw(Controls.spriteSheet, Controls.quads.w_down, 200 + Controls.offset.x, 200 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    else
        love.graphics.draw(Controls.spriteSheet, Controls.quads.w_up, 200 + Controls.offset.x, 200 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    end

    if key_pressed.a then
        love.graphics.draw(Controls.spriteSheet, Controls.quads.a_down, 136 + Controls.offset.x, 264 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    else
        love.graphics.draw(Controls.spriteSheet, Controls.quads.a_up, 136 + Controls.offset.x, 264 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    end

    if key_pressed.s then
        love.graphics.draw(Controls.spriteSheet, Controls.quads.s_down, 200 + Controls.offset.x, 264 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    else
        love.graphics.draw(Controls.spriteSheet, Controls.quads.s_up, 200 + Controls.offset.x, 264 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    end

    if key_pressed.d then
        love.graphics.draw(Controls.spriteSheet, Controls.quads.d_down, 264 + Controls.offset.x, 264 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    else
        love.graphics.draw(Controls.spriteSheet, Controls.quads.d_up, 264 + Controls.offset.x, 264 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    end

    -- ARROW KEYS

    if key_pressed.up then
        love.graphics.draw(Controls.spriteSheet, Controls.quads.arrow_up_down, 200 + Controls.offset.x, 50 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    else
        love.graphics.draw(Controls.spriteSheet, Controls.quads.arrow_up_up, 200 + Controls.offset.x, 50 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    end

    if key_pressed.left then
        love.graphics.draw(Controls.spriteSheet, Controls.quads.arrow_left_down, 136 + Controls.offset.x, 114 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    else
        love.graphics.draw(Controls.spriteSheet, Controls.quads.arrow_left_up, 136 + Controls.offset.x, 114 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    end

    if key_pressed.down then
        love.graphics.draw(Controls.spriteSheet, Controls.quads.arrow_down_down, 200 + Controls.offset.x, 114 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    else
        love.graphics.draw(Controls.spriteSheet, Controls.quads.arrow_down_up, 200 + Controls.offset.x, 114 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    end

    if key_pressed.right then
        love.graphics.draw(Controls.spriteSheet, Controls.quads.arrow_right_down, 264 + Controls.offset.x, 114 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    else
        love.graphics.draw(Controls.spriteSheet, Controls.quads.arrow_right_up, 264 + Controls.offset.x, 114 + Controls.offset.y, 0, 4, 4) -- Scaled by 4 for visibility
    end

end

return Controls