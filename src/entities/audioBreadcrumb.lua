local ab = {}

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
        love.graphics.setColor(255, 255, 255, math.pow((self.currentLifetime / self.initialLifetime), 4) * 64)
        love.graphics.setLineWidth(3)
        love.graphics.circle("line", self.x, self.y, self.range * math.pow((self.currentLifetime / self.initialLifetime), 4))
        -- love.graphics.setColor(0, 191, 191, self.currentLifetime * 255/ self.initialLifetime)
        -- love.graphics.circle("fill", self.x, self.y, 5)
        -- love.graphics.setColor(0, 0, 0, self.currentLifetime * 255/ self.initialLifetime)
        -- love.graphics.circle("line", self.x, self.y, 5)
    end
end

function ab.create(entityManager, x, y, range, lifetime)
    local inst = {}

    inst.tag = "audioBreadcrumb"
    inst.x = x
    inst.y = y
    inst.range = range or defaultRange
    inst.initialLifetime = lifetime or defaultLifetime
    inst.currentLifetime = lifetime or defaultLifetime

    inst.update = update
    inst.draw = draw

    return inst
end

return ab