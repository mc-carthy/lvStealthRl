Player = Class{}

local speed = 50

function Player:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Player:update(dt)
    local dx, dy = 0, 0
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

    self.x = self.x + (dx * speed * dt)
    self.y = self.y + (dy * speed * dt)
end

function Player:draw()
    love.graphics.circle('fill', self.x, self.y, 10)
end