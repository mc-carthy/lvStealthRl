Enemy = Class{}

function Enemy:init(x, y)
    self.tag = 'enemy'
    self.image = love.graphics.newImage('assets/img/kenneyTest/enemy.png')
    self.x = x
    self.y = y
    self.rot = 0
    self.rad = 5
end

function Enemy:hit(object)
    if object.damage then
        if self.hp then
            self.hp = self.hp - object.damage
            if self.hp <= 0 then
                self.done = true
            end
        else
            self.done = true
        end
    end
end

function Enemy:update(dt)

end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y, self.rot, 0.5, 0.5, 32, 32)
end