local Pong = {}

local Shader = require "shader"
local Controls = require "controls"
local Particles = require "particles"

function Pong.load()
    Pong.Y = 400
    Pong.Y_2 = 400

    Pong.burst = Particles.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

    Pong.ball = {
        x = 700,
        y = 400,
        dir = {
            x = 270,
            y = 300
        }
    }

    Pong.speed = 600

    Pong.p1_score = 0
    Pong.p2_score = 0

    Pong.plyr_img = love.graphics.newImage("imgs/tiburon.png")
    Pong.plyr_img_2 = love.graphics.newImage("imgs/novajolote.png")
    Pong.ball_img = love.graphics.newImage("imgs/ball.png")
    Pong.pong_background = love.graphics.newImage("imgs/pong_bg.png")
end


function Pong.update(dt)
    if love.keyboard.isDown("w") then
        Pong.Y = Pong.Y - Pong.speed * dt
    end
    if love.keyboard.isDown("s") then
        Pong.Y = Pong.Y + Pong.speed * dt
    end
    if love.keyboard.isDown("up") then
        Pong.Y_2 = Pong.Y_2 - Pong.speed * dt
    end
    if love.keyboard.isDown("down") then
        Pong.Y_2 = Pong.Y_2 + Pong.speed * dt
    end

    Pong.ball.x = Pong.ball.x + Pong.ball.dir.x * dt
    Pong.ball.y = Pong.ball.y + Pong.ball.dir.y * dt

    -- score of players
    if Pong.ball.x < 0 then
        Pong.ball.x = 700
        Pong.ball.y = 400
        Pong.p2_score = Pong.p2_score + 1
        Pong.ball.dir.x, Pong.ball.dir.y = Normalize(Pong.ball.dir.x, Pong.ball.dir.y)
    end
    if Pong.ball.x > 1300 then
        Pong.ball.x = 700
        Pong.ball.y = 400
        Pong.p1_score = Pong.p1_score + 1
        Pong.ball.dir.x, Pong.ball.dir.y = Normalize(Pong.ball.dir.x, Pong.ball.dir.y)
    end

    Pong.burst:update(dt)
    local particle_amount = 20

    -- collition with ciel and ground
    if Pong.ball.y < 0 or Pong.ball.y > 800 - Pong.ball_img:getHeight()*4 then
        Pong.ball.dir.y = -Pong.ball.dir.y * 1.05
        Pong.ball.dir.x = Pong.ball.dir.x * 1.05
        Pong.burst:setPosition(Pong.ball.x + Pong.ball_img:getWidth()/2, Pong.ball.y + Pong.ball_img:getHeight()/2)
        Pong.burst:emit(particle_amount)
    end

    -- collition Pong.ball with players
    if CheckCollision(50+Pong.plyr_img:getWidth()*4, Pong.Y, 1, Pong.plyr_img:getHeight()*4, Pong.ball.x, Pong.ball.y, Pong.ball_img:getWidth()*2, Pong.ball_img:getHeight()*2)
    or CheckCollision(1200, Pong.Y_2, 1, Pong.plyr_img_2:getHeight()*4, Pong.ball.x, Pong.ball.y, Pong.ball_img:getWidth()*2, Pong.ball_img:getHeight()*2) then
        Pong.ball.dir.x = -Pong.ball.dir.x * 1.05
        Pong.ball.dir.y = Pong.ball.dir.y * 1.05
        Pong.burst:setPosition(Pong.ball.x + Pong.ball_img:getWidth()/2, Pong.ball.y + Pong.ball_img:getHeight()/2)
        Pong.burst:emit(particle_amount)
    end

    Shader.update(dt)
    Controls.update(0, 0)
end

function Pong.draw()
    love.graphics.draw(Pong.pong_background, 0, 0, 0, 2, 2)

    Controls.draw_w(50, 700)
    Controls.draw_s(114, 700)

    Controls.draw_up(1250, 700)
    Controls.draw_down(1314, 700)

    Pong.burst:draw()

    love.graphics.draw(Pong.ball_img, Pong.ball.x, Pong.ball.y, 0, 2, 2)

    love.graphics.draw(Pong.plyr_img, 50, Pong.Y, 0, 4, 4)
    love.graphics.draw(Pong.plyr_img_2, 1200, Pong.Y_2, 0, 4, 4)

    love.graphics.setColor(0,0,0)
    love.graphics.print("SCORE P1", 10, 50)
    love.graphics.setColor(1,0,1)
    love.graphics.print(Pong.p1_score, 250, 50)
    love.graphics.setColor(0,0,0)
    love.graphics.print("SCORE P2", 1050, 50)
    love.graphics.setColor(1,0,1)
    love.graphics.print(Pong.p2_score, 1300, 50)
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