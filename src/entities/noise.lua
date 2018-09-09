Noise = Class{}

function Noise:init(params)
    self.tag = 'noise'
    self.depth = 0
    self.x = 1000
    self.y = 1000
    self.rad = 100
    self.type = 'test'
    self.x = params.x or 0
    self.y = params.y or 0
    self.rad = params.rad or 0
    self.type = params.type or 'noise'
end

function Noise:collisionCheck()
    local enemies = self.em:getObjectsByTag('enemy')
    if enemies ~= nil then
        for _, e in pairs(enemies) do
            if Vector2.distance(self, e) < self.rad then
                if e.hearNoise then
                    e:hearNoise(self)
                end
            end
        end
    end
end

function Noise:update(dt)
    local decayRate = 1000
    self.rad = self.rad - decayRate * dt
    self:collisionCheck()
    if self.rad <= 0 then self.done = true end
end

function Noise:draw()
    love.graphics.setColor(1, 1, 1, 0.25)
    love.graphics.setLineWidth(3)
    love.graphics.circle('line', self.x, self.y, self.rad)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
end