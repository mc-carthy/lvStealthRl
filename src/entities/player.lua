Player = Class{}

local speed = 50
local playerImage = love.graphics.newImage("assets/img/kenneyTest/player.png")

function Player:init(x, y)
    self.x = x or 0
    self.y = y or 0
    self.rot = 0
end

function Player:update(dt)
    local dx, dy = 0, 0
    local mouseX, mouseY = love.mouse.getPosition()
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        dy = dy - 1
    end
    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        dy = dy + 1
    end
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        dx = dx - 1
    end
    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        dx = dx + 1
    end

    dx, dy = normalise(dx, dy)

    self.x = self.x + (dx * speed * dt)
    self.y = self.y + (dy * speed * dt)
    self.rot = math.atan2(mouseY - self.y, mouseX - self.x)
end

function Player:draw()
    -- love.graphics.setColor(0, 0, 0, 1)
    -- love.graphics.circle('line', self.x, self.y, 10)
    -- love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.circle('fill', self.x, self.y, 10)
    love.graphics.draw(playerImage, self.x, self.y, self.rot, 0.5, 0.5, 32, 32)
end