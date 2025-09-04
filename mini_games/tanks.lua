local Tanks = {}

function Tanks.load()
    love.window.setTitle("Tank Duel")
    love.window.setMode(800, 600)

    -- Tank template
    function newTank(x, y, color, controls)
        return {
            x = x, y = y,
            angle = 0,
            speed = 200,
            health = 3,
            color = color,
            bullets = {},
            controls = controls
        }
    end

    -- Player 1 (WASD + Space)
    tank1 = newTank(100, 300, {1, 0, 0}, {
        up = "w", down = "s", left = "a", right = "d", shoot = "space"
    })

    -- Player 2 (Arrows + Return)
    tank2 = newTank(700, 300, {0, 0, 1}, {
        up = "up", down = "down", left = "left", right = "right", shoot = "return"
    })
end

function Tanks.update(dt)
    updateTank(tank1, dt)
    updateTank(tank2, dt)

    updateBullets(tank1, tank2, dt)
    updateBullets(tank2, tank1, dt)
end

function Tanks.draw()
    drawTank(tank1)
    drawTank(tank2)

    love.graphics.setColor(1,1,1)
    love.graphics.print("Red Health: " .. tank1.health, 10, 10)
    love.graphics.print("Blue Health: " .. tank2.health, 650, 10)

    if tank1.health <= 0 then
        love.graphics.print("Blue Wins!", 350, 280)
    elseif tank2.health <= 0 then
        love.graphics.print("Red Wins!", 350, 280)
    end
end

-- === TANK FUNCTIONS ===
local function updateTank(tank, dt)
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
end

local function drawTank(tank)
    love.graphics.setColor(tank.color)
    love.graphics.push()
    love.graphics.translate(tank.x, tank.y)
    love.graphics.rotate(tank.angle)
    love.graphics.rectangle("fill", -15, -10, 30, 20) -- body
    love.graphics.rectangle("fill", 0, -5, 20, 10) -- turret
    love.graphics.pop()

    -- Draw bullets
    for _, b in ipairs(tank.bullets) do
        love.graphics.setColor(1,1,0)
        love.graphics.circle("fill", b.x, b.y, 4)
    end
end

-- === BULLETS ===
function Tanks.keypressed(key)
    if key == tank1.controls.shoot and tank1.health > 0 then
        shootBullet(tank1)
    elseif key == tank2.controls.shoot and tank2.health > 0 then
        shootBullet(tank2)
    end
end

local function shootBullet(tank)
    table.insert(tank.bullets, {
        x = tank.x + math.cos(tank.angle) * 20,
        y = tank.y + math.sin(tank.angle) * 20,
        dx = math.cos(tank.angle) * 300,
        dy = math.sin(tank.angle) * 300
    })
end

local function updateBullets(tank, enemy, dt)
    for i = #tank.bullets, 1, -1 do
        local b = tank.bullets[i]
        b.x = b.x + b.dx * dt
        b.y = b.y + b.dy * dt

        -- Remove if off screen
        if b.x < 0 or b.x > 800 or b.y < 0 or b.y > 600 then
            table.remove(tank.bullets, i)
        -- Collision with enemy
        elseif distance(b.x, b.y, enemy.x, enemy.y) < 20 then
            enemy.health = enemy.health - 1
            table.remove(tank.bullets, i)
        end
    end
end

local function distance(x1, y1, x2, y2)
    return ((x2-x1)^2 + (y2-y1)^2)^0.5
end

return Tanks