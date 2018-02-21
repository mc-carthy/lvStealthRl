local vb = {}

local debugFlag = true

local defaultRange = 40
local defaultLifetime = 5

local function update(self, dt)
    self.currentLifetime = self.currentLifetime - dt
    if self.currentLifetime < 0 then
        self.done = true
    end
end

local function draw(self)
    if debugFlag then
        love.graphics.setColor(191, 0, 191)
        love.graphics.circle("fill", self.x, self.y, 5)
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("line", self.x, self.y, 5)
    end
end

function vb.create(entityManager, x, y, range, lifetime)
    local inst = {}

    inst.x = x
    inst.y = y
    inst.range = range or defaultRange
    inst.lifetime = lifetime or defaultLifetime
    inst.currentLifetime = inst.lifetime

    inst.update = update
    inst.draw = draw

    return inst
end

return vb