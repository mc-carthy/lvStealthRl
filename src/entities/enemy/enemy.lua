Enemy = Class{}

function Enemy:init(x, y)
    self.image = love.graphics.newImage('assets/img/kenneyTest/enemy.png')
    self.x = x
    self.y = y
    self.rot = 0
end

function Enemy:update(dt)

end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y, self.rot, 0.5, 0.5, 32, 32)
end