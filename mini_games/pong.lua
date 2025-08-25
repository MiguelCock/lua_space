Shader = require("shader")

Pong = {}

local Y = 400
local Y_2 = 400

local ball = {
    x = 700,
    y = 400,
    dir = {
        x = 3.6,
        y = 4
    }
}

local speed = 6

local p1_score = 0
local p2_score = 0

_G.plyr_img = love.graphics.newImage("imgs/tiburon.png")
_G.plyr_img_2 = love.graphics.newImage("imgs/novajolote.png")
_G.projectile_img = love.graphics.newImage("imgs/star.png")
_G.pong_background = love.graphics.newImage("mini_games/imgs/pong_bg.png")

function Pong.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if love.keyboard.isDown("w") then
        Y = Y - speed
    end
    if love.keyboard.isDown("s") then
        Y = Y + speed
    end
    if love.keyboard.isDown("up") then
        Y_2 = Y_2 - speed
    end
    if love.keyboard.isDown("down") then
        Y_2 = Y_2 + speed
    end

    ball.x = ball.x + ball.dir.x
    ball.y = ball.y + ball.dir.y

    -- score of players
    if ball.x < 0 then
        ball.x = 700
        ball.y = 400
        p2_score = p2_score + 1
        ball.dir.x, ball.dir.y = Normalize(ball.dir.x, ball.dir.y)
    end
    if ball.x > 1300 then
        ball.x = 700
        ball.y = 400
        p1_score = p1_score + 1
        ball.dir.x, ball.dir.y = Normalize(ball.dir.x, ball.dir.y)
    end

    -- collition with ciel and ground
    if ball.y < 0 then
        ball.dir.y = -ball.dir.y * 1.1
        ball.dir.x = ball.dir.x * 1.1
    end
    if ball.y > 800-_G.projectile_img:getHeight()*4 then
        ball.dir.y = -ball.dir.y * 1.05
        ball.dir.x = ball.dir.x * 1.05
    end

    -- collition ball with players
    if CheckCollision(50+_G.plyr_img:getWidth()*4, Y, 1, _G.plyr_img:getHeight()*4, ball.x, ball.y, _G.projectile_img:getWidth()*4, _G.projectile_img:getHeight()*4) then
        ball.dir.x = -ball.dir.x * 1.05
        ball.dir.y = ball.dir.y * 1.05
    end
    if CheckCollision(1200, Y_2, 1, _G.plyr_img_2:getHeight()*4, ball.x, ball.y, _G.projectile_img:getWidth()*4, _G.projectile_img:getHeight()*4) then
        ball.dir.x = -ball.dir.x * 1.05
        ball.dir.y = ball.dir.y * 1.05
    end

    Shader.update(dt)
end

function Pong.draw()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.draw(_G.pong_background, 0, 0, 0, 2, 2)

    love.graphics.draw(_G.projectile_img, ball.x, ball.y, 0, 4, 4)

    love.graphics.draw(_G.plyr_img, 50, Y, 0, 4, 4)
    love.graphics.draw(_G.plyr_img_2, 1200, Y_2, 0, 4, 4)
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function Normalize(x, y)
    local length = math.sqrt(x*x + y*y)
    return x/length * 4, y/length * 4
end

return Pong