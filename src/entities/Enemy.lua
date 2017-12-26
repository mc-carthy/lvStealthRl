local Vector2 = require("src.utils.Vector2")

local enemy = {}

local update = function(self, dt)
    local rotSpeed = 360
    self.rot = self.rot + rotSpeed * dt

    if self.rot > 360 then self.rot = 0 end
end

local draw = function(self)
    love.graphics.setColor(191, 0, 0)
    love.graphics.circle("fill", self.x, self.y, 10)

    local focusX, focusY = Vector2.pointFromRotDist(self.rot, self.viewDist)
    love.graphics.line(self.x, self.y, self.x + focusX, self.y + focusY)
end

enemy.create = function(x, y, rot)
    local inst = {}

    inst.x = x or 0
    inst.y = y or 0
    inst.rot = rot or 0
    inst.viewDist = 100

    inst.update = update
    inst.draw = draw

    return inst
end

return enemy
