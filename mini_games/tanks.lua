local Tanks = {}

function Tanks.load()
    -- Tank template
    local function newTank(x, y, angle, color, controls)
        return {
            x = x, y = y,
            angle = angle,
            speed = 200,
            health = 3,
            color = color,
            bullets = {},
            controls = controls,
            attk_peed = 40,
        }
    end

    -- Player 1 (WASD + Space)
    Tanks.tank1 = newTank(200, 400, 0, {1, 0, 0}, {
        up = "w", down = "s", left = "a", right = "d", shoot = "space"
    })

    -- Player 2 (Arrows + Return)
    Tanks.tank2 = newTank(1200, 400, math.pi, {0, 0, 1}, {
        up = "up", down = "down", left = "left", right = "right", shoot = "l"
    })
end

function Tanks.update(dt)
    updateTank(Tanks.tank1, dt)
    updateTank(Tanks.tank2, dt)

    updateBullets(Tanks.tank1, Tanks.tank2, dt)
    updateBullets(Tanks.tank2, Tanks.tank1, dt)
end

function Tanks.draw()
    love.graphics.clear(1, 1, 1, 1)

    drawTank(Tanks.tank1)
    drawTank(Tanks.tank2)

    love.graphics.setColor(0,0,0)
    love.graphics.print("Red Health: " .. Tanks.tank1.health, 10, 10)
    love.graphics.print("Blue Health: " .. Tanks.tank2.health, 650, 10)

    if Tanks.tank1.health <= 0 then
        love.graphics.print("Blue Wins!", 350, 280)
    elseif Tanks.tank2.health <= 0 then
        love.graphics.print("Red Wins!", 350, 280)
    end
end

-- === TANK FUNCTIONS ===
function updateTank(tank, dt)
    if love.keyboard.isDown(tank.controls.up) then
        tank.x = tank.x + math.cos(tank.angle) * tank.speed * dt
        tank.y = tank.y + math.sin(tank.angle) * tank.speed * dt
    end
    if love.keyboard.isDown(tank.controls.down) then
        tank.x = tank.x - math.cos(tank.angle) * tank.speed * dt
        tank.y = tank.y - math.sin(tank.angle) * tank.speed * dt
    end
    if love.keyboard.isDown(tank.controls.left) then
        tank.angle = tank.angle - 2 * dt
    end
    if love.keyboard.isDown(tank.controls.right) then
        tank.angle = tank.angle + 2 * dt
    end
    if love.keyboard.isDown(tank.controls.shoot) and tank.attk_peed <= 0 then
        shootBullet(tank)
        tank.attk_peed = 40
    end
    tank.attk_peed = tank.attk_peed - 1
end

function drawTank(tank)
    love.graphics.setColor(tank.color)
    love.graphics.push()
    love.graphics.translate(tank.x, tank.y)
    love.graphics.rotate(tank.angle)
    love.graphics.rectangle("fill", -15, -10, 30, 20) -- body
    love.graphics.rectangle("fill", 0, -5, 20, 10) -- turret
    love.graphics.pop()

    -- Draw bullets
    for _, b in ipairs(tank.bullets) do
        love.graphics.setColor(0,0,0)
        love.graphics.circle("fill", b.x, b.y, 4)
    end
end

function shootBullet(tank)
    table.insert(tank.bullets, {
        x = tank.x + math.cos(tank.angle) * 20,
        y = tank.y + math.sin(tank.angle) * 20,
        dx = math.cos(tank.angle) * 300,
        dy = math.sin(tank.angle) * 300
    })
end

function updateBullets(tank, enemy, dt)
    for i = #tank.bullets, 1, -1 do
        local b = tank.bullets[i]
        b.x = b.x + b.dx * dt
        b.y = b.y + b.dy * dt

        -- Remove if off screen
        if b.x < 0 or b.x > 1400 or b.y < 0 or b.y > 800 then
            table.remove(tank.bullets, i)
        -- Collision with enemy
        elseif distance(b.x, b.y, enemy.x, enemy.y) < 20 then
            enemy.health = enemy.health - 1
            table.remove(tank.bullets, i)
        end
    end
end

function distance(x1, y1, x2, y2)
    return ((x2-x1)^2 + (y2-y1)^2)^0.5
end

return Tanks