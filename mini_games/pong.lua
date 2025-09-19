local Pong = {}

local Controls = require "controls"
local Particles = require "particles"

function Pong.load()
    Pong.speed = 600

    -- Player 1
    Pong.player_1 = {}
    Pong.player_1.y = 400
    Pong.player_1.score = 0
    Pong.player_1.img = love.graphics.newImage("imgs/tiburon.png")

    -- Player 2
    Pong.player_2 = {}
    Pong.player_2.y = 400
    Pong.player_2.score= 0
    Pong.player_2.img = love.graphics.newImage("imgs/novajolote.png")

    -- Particles
    Pong.burst = Particles.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

    -- Pong ball
    Pong.ball = {
        x = 700,
        y = 400,
        dir = {
            x = 270,
            y = 300
        }
    }
    Pong.ball_img = love.graphics.newImage("imgs/ball.png")

    -- Back ground
    Pong.pong_background = love.graphics.newImage("imgs/pong_bg.png")
end


function Pong.update(dt)
    -- Player 1 Controls
    if love.keyboard.isDown("w") then
        Pong.player_1.y = Pong.player_1.y - Pong.speed * dt
    end
    if love.keyboard.isDown("s") then
        Pong.player_1.y = Pong.player_1.y + Pong.speed * dt
    end
    -- Player 2 Controls
    if love.keyboard.isDown("up") then
        Pong.player_2.y = Pong.player_2.y - Pong.speed * dt
    end
    if love.keyboard.isDown("down") then
        Pong.player_2.y = Pong.player_2.y + Pong.speed * dt
    end

    -- Update players position
    Pong.ball.x = Pong.ball.x + Pong.ball.dir.x * dt
    Pong.ball.y = Pong.ball.y + Pong.ball.dir.y * dt

    -- score player 1
    if Pong.ball.x < 0 then
        Pong.ball.x = 700
        Pong.ball.y = 400
        Pong.player_2.score= Pong.player_2.score+ 1
        Pong.ball.dir.x, Pong.ball.dir.y = Normalize(Pong.ball.dir.x, Pong.ball.dir.y)
    end
    -- score player 2
    if Pong.ball.x > 1300 then
        Pong.ball.x = 700
        Pong.ball.y = 400
        Pong.player_1.score = Pong.player_1.score + 1
        Pong.ball.dir.x, Pong.ball.dir.y = Normalize(Pong.ball.dir.x, Pong.ball.dir.y)
    end

    -- Update particles position
    Pong.burst:update(dt)
    local particle_amount = 20

    -- collition with ciel and ground
    if Pong.ball.y < 0 or Pong.ball.y > 800 - Pong.ball_img:getHeight()*4 then
        Pong.ball.dir.y = -Pong.ball.dir.y * 1.05
        Pong.ball.dir.x = Pong.ball.dir.x * 1.05
        Pong.burst:setPosition(Pong.ball.x + Pong.ball_img:getWidth()/2, Pong.ball.y + Pong.ball_img:getHeight()/2)
        Pong.burst:emit(particle_amount)
    end

    -- collition Pong.ball with both players
    if CheckCollision(50+Pong.player_1.img:getWidth()*4, Pong.player_1.y, 1, Pong.player_1.img:getHeight()*4, Pong.ball.x, Pong.ball.y, Pong.ball_img:getWidth()*2, Pong.ball_img:getHeight()*2)
    or CheckCollision(1200, Pong.player_2.y, 1, Pong.player_2.img:getHeight()*4, Pong.ball.x, Pong.ball.y, Pong.ball_img:getWidth()*2, Pong.ball_img:getHeight()*2) then
        Pong.ball.dir.x = -Pong.ball.dir.x * 1.05
        Pong.ball.dir.y = Pong.ball.dir.y * 1.05
        Pong.burst:setPosition(Pong.ball.x + Pong.ball_img:getWidth()/2, Pong.ball.y + Pong.ball_img:getHeight()/2)
        Pong.burst:emit(particle_amount)
    end

    Controls.update(0, 0)
end

function Pong.draw()
    -- Draw background
    love.graphics.draw(Pong.pong_background, 0, 0, 0, 2, 2)

    -- Draw player 1 controls
    Controls.draw_w(50, 700)
    Controls.draw_s(114, 700)

    -- Draw player 2 controls
    Controls.draw_up(1250, 700)
    Controls.draw_down(1314, 700)

    -- Draw particles
    Pong.burst:draw()

    -- Draw pingpong ball
    love.graphics.draw(Pong.ball_img, Pong.ball.x, Pong.ball.y, 0, 2, 2)

    -- Draw players
    love.graphics.draw(Pong.player_1.img, 50, Pong.player_1.y, 0, 4, 4)
    love.graphics.draw(Pong.player_2.img, 1200, Pong.player_2.y, 0, 4, 4)

    -- Draw score player 1
    love.graphics.setColor(0,0,0)
    love.graphics.print("SCORE", 10, 50)
    love.graphics.setColor(1,0,1)
    love.graphics.print(Pong.player_1.score, 220, 50)
    love.graphics.setColor(0,0,0)

    -- Draw score player 2
    love.graphics.print("SCORE", 1050, 50)
    love.graphics.setColor(1,0,1)
    love.graphics.print(Pong.player_2.score, 1270, 50)
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