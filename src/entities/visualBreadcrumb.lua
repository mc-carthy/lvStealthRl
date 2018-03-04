local vb = {}

local debugFlag = true

local defaultRange = 40
local defaultLifetime = 2.5

local function update(self, dt)
    self.currentLifetime = self.currentLifetime - dt
    if self.currentLifetime < 0 then
        self.done = true
    end
end

local function draw(self)
    if debugFlag then
        -- TODO: Check value of (self.currentLifetime / self.initialLifetime), does not seem to drop linearly from 1 to 0
        love.graphics.setColor(0, 191, 0, self.currentLifetime * 127 / self.initialLifetime)
        love.graphics.circle("fill", self.x, self.y, 5)
        love.graphics.setColor(0, 0, 0, self.currentLifetime * 127 / self.initialLifetime)
        love.graphics.circle("line", self.x, self.y, 5)
    end
end

function vb.create(entityManager, x, y, range, lifetime)
    local inst = {}

    inst.tag = "visualBreadcrumb"
    inst.x = x
    inst.y = y
    inst.range = range or defaultRange
    inst.initialLifetime = lifetime or defaultLifetime
    inst.currentLifetime = lifetime or defaultLifetime

    inst.update = update
    inst.draw = draw

    return inst
end

return vb