Bullet = Class{}

function Bullet:init(params)
    self.tag = 'bullet'
    self.x = params.x or 0
    self.y = params.y or 0
    self.dx, self.dy = 0, 0
    self.rot = params.rot or 0
    self.speed = params.speed or 500
    self.rad = 2.5
    self.damage = 10
end

function Bullet:gridCollisionCheck()
    local gridX, gridY = getGridPos(self.x + self.rad * math.cos(self.rot), self.y + self.rad * math.sin(self.rot))                        
    if self.em.map:collidable(gridX, gridY) then
        self:hit(self.em.map)
    end
end

function Bullet:hit(object)
    SFX['bulletImpact']:stop()
    SFX['bulletImpact']:play()
    self.done = true
end

function Bullet:update(dt)
    self.dx = self.speed * dt * math.cos(self.rot)
    self.dy = self.speed * dt * math.sin(self.rot)

    
    self.x = self.x + self.dx
    self.y = self.y + self.dy
    
    self:gridCollisionCheck()
end

function Bullet:draw()
    love.graphics.setColor(0.5, 0.5, 0, 1)
    love.graphics.circle('fill', self.x, self.y, self.rad)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle('line', self.x, self.y, self.rad)
    love.graphics.setColor(1, 1, 1, 1)
end