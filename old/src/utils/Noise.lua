local Noise = {}

local draw = function(self)
    if DEBUG then
        love.graphics.setColor(127, 127, 0, 63)
        love.graphics.circle("fill", self.x, self.y, self.radius)
    end
end

Noise.create = function(x, y, maxRadius)
    local inst = {}

    inst.maxRadius = maxRadius
    inst.radius = 0
    inst.propagationSpeed = 10

    inst.draw = draw

    return inst
end

return Noise
