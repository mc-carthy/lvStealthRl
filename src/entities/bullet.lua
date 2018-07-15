Bullet = Class{}

function Bullet:init(params)
    self.x = params.x or 0
    self.y = params.y or 0
    self.dx, self.dy = 0, 0
    self.rot = params.rot or 0
    self.speed = params.speed or 250
    self.rad = 5
end

function Bullet:update(dt)
    self.dx = self.speed * dt * math.cos(self.rot)
    self.dy = self.speed * dt * math.sin(self.rot)

    self.x = self.x + self.dx
    self.y = self.y + self.dy
end

function Bullet:draw()
    love.graphics.setColor(0.5, 0.5, 0, 1)
    love.graphics.circle('fill', self.x, self.y, self.rad)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle('line', self.x, self.y, self.rad)
    love.graphics.setColor(1, 1, 1, 1)
end