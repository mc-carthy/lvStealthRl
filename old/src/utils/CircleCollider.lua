local V = require("src.utils.Vector2")

local C = {}

local update = function(self, x, y)
    self.x = x
    self.y = y
end

local trigger = function(self, other)
    local c2cDist = V.magnitude(math.abs(self.x - other.x), math.abs(self.y - other.y))
    return c2cDist < self.radius + other.radius
end

C.create = function(x, y, radius)
    local inst = {}

    inst.x = x
    inst.y = y
    inst.radius = radius

    inst.update = update
    inst.trigger = trigger

    return inst
end

return C
