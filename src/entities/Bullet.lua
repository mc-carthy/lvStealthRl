local Vector2 = require("src.utils.Vector2")

local bullet = {}

local update = function(self, dt)
    local dx, dy = Vector2.pointFromRotDist(self.rot, self.speed * dt)
    self.x = self.x + dx
    self.y = self.y + dy
end

local draw = function(self)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

bullet.create = function(x, y, rot, speed)
    local inst = {}

    inst.x = x
    inst.y = y
    inst.rot = rot
    inst.speed = speed
    inst.radius = 5

    inst.update = update
    inst.draw = draw

    return inst
end

return bullet
