local Vector2 = require("src.utils.Vector2")
local Col = require("src.utils.CircleCollider")

local enemy = {}

local update = function(self, dt)
    local rotSpeed = 36
    self.rot = self.rot + rotSpeed * dt

    if self.rot > 360 then self.rot = 0 end
end

local draw = function(self)
    love.graphics.setColor(191, 0, 0)
    love.graphics.circle("fill", self.x, self.y, self.radius)

    local focusX, focusY = Vector2.pointFromRotDist(self.rot, self.viewDist)
    local viewAngleX1, viewAngleY1 = Vector2.pointFromRotDist(self.rot - self.viewAngle / 2, self.viewDist)
    local viewAngleX2, viewAngleY2 = Vector2.pointFromRotDist(self.rot + self.viewAngle / 2, self.viewDist)

    love.graphics.setColor(191, 0, 0, 127)
    love.graphics.arc("fill", self.x, self.y, self.viewDist, -math.rad(self.rot + self.viewAngle / 2), -math.rad(self.rot - self.viewAngle / 2))

    love.graphics.setColor(0, 0, 0)
    love.graphics.line(self.x, self.y, self.x + viewAngleX1, self.y + viewAngleY1)
    love.graphics.line(self.x, self.y, self.x + viewAngleX2, self.y + viewAngleY2)
    love.graphics.line(self.x, self.y, self.x + focusX, self.y + focusY)

end

enemy.create = function(x, y, rot)
    local inst = {}

    inst.tag = "enemy"
    inst.x = x or 0
    inst.y = y or 0
    inst.radius = 10
    inst.col = Col.create(x, y, inst.radius)
    inst.rot = rot or 180
    inst.viewDist = 100
    inst.viewAngle = 120

    inst.update = update
    inst.draw = draw

    return inst
end

return enemy
