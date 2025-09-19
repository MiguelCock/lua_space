local Tanks = {}

function Tanks.load()
    local function newTank(x, y, angle, color, controls)
        return {
            x = x, y = y,
            angle = angle,
            speed = 400,
            points = 0,
            color = color,
            bullets = {},
            controls = controls,
            attk_peed = 60,
        }
    end

    Tanks.grass_bg = love.graphics.newImage("assets/imgs/pasto.png")

    -- Player 1 (WASD + Space)
    Tanks.tank1 = newTank(200, 400, 0, {1, 0, 0}, {
        up = "w", down = "s", left = "a", right = "d", shoot = "space"
    })

    Tanks.tank1.img = love.graphics.newImage("assets/imgs/tank_pacho.png")

    -- Player 2 (Arrows + l)
    Tanks.tank2 = newTank(1200, 400, math.pi, {0, 0, 1}, {
        up = "up", down = "down", left = "left", right = "right", shoot = "l"
    })
    Tanks.tank2.img = love.graphics.newImage("assets/imgs/tank_pacho.png")
end

function Tanks.update(dt)
    UpdateTank(Tanks.tank1, dt)
    UpdateTank(Tanks.tank2, dt)

    UpdateBullets(Tanks.tank1, Tanks.tank2, dt)
    UpdateBullets(Tanks.tank2, Tanks.tank1, dt)
end

function Tanks.draw()
    love.graphics.draw(Tanks.grass_bg)

    DrawTank(Tanks.tank1)
    DrawTank(Tanks.tank2)

    love.graphics.setColor(0,0,0)
    love.graphics.print("Red Points", 10, 10)
    love.graphics.setColor(1,0,0)
    love.graphics.print(Tanks.tank1.points, 330, 10)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Blue Points", 1000, 10)
    love.graphics.setColor(0,0,1)
    love.graphics.print(Tanks.tank2.points, 1350, 10)
end

-- === TANK FUNCTIONS ===
function UpdateTank(tank, dt)
    if love.keyboard.isDown(tank.controls.up) then
        tank.x = tank.x + math.cos(tank.angle) * tank.speed * dt
        tank.y = tank.y + math.sin(tank.angle) * tank.speed * dt
    end
    if love.keyboard.isDown(tank.controls.down) then
        tank.x = tank.x - math.cos(tank.angle) * tank.speed * dt
        tank.y = tank.y - math.sin(tank.angle) * tank.speed * dt
    end
    if love.keyboard.isDown(tank.controls.left) then
        tank.angle = tank.angle - 4 * dt
    end
    if love.keyboard.isDown(tank.controls.right) then
        tank.angle = tank.angle + 4 * dt
    end
    if love.keyboard.isDown(tank.controls.shoot) and tank.attk_peed <= 0 then
        ShootBullet(tank)
        tank.attk_peed = 60
    end
    tank.attk_peed = tank.attk_peed - 1
end

function DrawTank(tank)
    for _, b in ipairs(tank.bullets) do
        love.graphics.setColor(0,0,0)
        love.graphics.circle("fill", b.x, b.y, 10)
    end

    love.graphics.setColor(1,1,1)
    love.graphics.draw(tank.img, tank.x, tank.y, tank.angle, 2, 2, tank.img:getWidth()/2, tank.img:getHeight()/2)
end

function ShootBullet(tank)
    table.insert(tank.bullets, {
        x = tank.x + math.cos(tank.angle) * 20,
        y = tank.y + math.sin(tank.angle) * 20,
        dx = math.cos(tank.angle) * 700,
        dy = math.sin(tank.angle) * 700
    })
end

function UpdateBullets(tank, enemy, dt)
    for i = #tank.bullets, 1, -1 do
        local b = tank.bullets[i]
        b.x = b.x + b.dx * dt
        b.y = b.y + b.dy * dt

        -- Remove if off screen
        if b.x < 0 or b.x > 1400 or b.y < 0 or b.y > 800 then
            table.remove(tank.bullets, i)
        -- Collision with enemy
        elseif Distance(b.x, b.y, enemy.x, enemy.y) < 32 then
            tank.points = tank.points + 1
            table.remove(tank.bullets, i)
        end
    end
end

function Distance(x1, y1, x2, y2)
    return ((x2-x1)^2 + (y2-y1)^2)^0.5
end

return Tanks