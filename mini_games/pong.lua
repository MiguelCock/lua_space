local Pong = {}

local Shader = require "shader"
local Controls = require "controls"
local Particles = require "particles"

local Y = 400
local Y_2 = 400

local burst = Particles.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

local ball = {
    x = 700,
    y = 400,
    dir = {
        x = 270,
        y = 300
    }
}

local speed = 600

local p1_score = 0
local p2_score = 0

local plyr_img = love.graphics.newImage("imgs/tiburon.png")
local plyr_img_2 = love.graphics.newImage("imgs/novajolote.png")
local ball_img = love.graphics.newImage("imgs/ball.png")
local pong_background = love.graphics.newImage("imgs/pong_bg.png")

function Pong.update(dt)
    if love.keyboard.isDown("w") then
        Y = Y - speed * dt
    end
    if love.keyboard.isDown("s") then
        Y = Y + speed * dt
    end
    if love.keyboard.isDown("up") then
        Y_2 = Y_2 - speed * dt
    end
    if love.keyboard.isDown("down") then
        Y_2 = Y_2 + speed * dt
    end

    ball.x = ball.x + ball.dir.x * dt
    ball.y = ball.y + ball.dir.y * dt

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

    burst:update(dt)
    local particle_amount = 20

    -- collition with ciel and ground
    if ball.y < 0 or ball.y > 800 - ball_img:getHeight()*4 then
        ball.dir.y = -ball.dir.y * 1.05
        ball.dir.x = ball.dir.x * 1.05
        burst:setPosition(ball.x + ball_img:getWidth()/2, ball.y + ball_img:getHeight()/2)
        burst:emit(particle_amount)
    end

    -- collition ball with players
    if CheckCollision(50+plyr_img:getWidth()*4, Y, 1, plyr_img:getHeight()*4, ball.x, ball.y, ball_img:getWidth()*2, ball_img:getHeight()*2)
    or CheckCollision(1200, Y_2, 1, plyr_img_2:getHeight()*4, ball.x, ball.y, ball_img:getWidth()*2, ball_img:getHeight()*2) then
        ball.dir.x = -ball.dir.x * 1.05
        ball.dir.y = ball.dir.y * 1.05
        burst:setPosition(ball.x + ball_img:getWidth()/2, ball.y + ball_img:getHeight()/2)
        burst:emit(particle_amount)
    end

    Shader.update(dt)
    Controls.update(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end

function Pong.draw()
    love.graphics.draw(pong_background, 0, 0, 0, 2, 2)

    Controls.draw_w(50, 700)
    Controls.draw_s(114, 700)

    Controls.draw_up(1250, 700)
    Controls.draw_down(1314, 700)

    burst:draw()

    love.graphics.draw(ball_img, ball.x, ball.y, 0, 2, 2)

    love.graphics.draw(plyr_img, 50, Y, 0, 4, 4)
    love.graphics.draw(plyr_img_2, 1200, Y_2, 0, 4, 4)

    love.graphics.setColor(0,0,0)
    love.graphics.print("SCORE P1", 10, 50)
    love.graphics.setColor(1,0,1)
    love.graphics.print(p1_score, 250, 50)
    love.graphics.setColor(0,0,0)
    love.graphics.print("SCORE P2", 1050, 50)
    love.graphics.setColor(1,0,1)
    love.graphics.print(p2_score, 1300, 50)
    love.graphics.setColor(1,1,1)
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function Normalize(x, y)
    local length = math.sqrt(x*x + y*y)
    return x/length * 400, y/length * 400
end

return Pong