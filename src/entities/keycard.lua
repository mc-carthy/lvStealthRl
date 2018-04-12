local tile = require("src.map.tileDictionary")

local keycard = {}

local w, h = 10, 6

local function _update(self, dt)
    self.ringRad = self.ringBaseRad + math.sin(love.timer.getTime() * 20) * self.ringRadVar
end

local function _draw(self)
    love.graphics.push()
        love.graphics.setColor(tile["doorLevel" .. self.level].colour)
        love.graphics.setLineWidth(1)
        love.graphics.circle("line", self.x, self.y, self.ringRad)
        love.graphics.rectangle('fill', self.x - w / 2, self.y - h / 2, w, h)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle('line', self.x - w / 2, self.y - h / 2, w, h)
    love.graphics.pop()
end

function keycard.create(entityManager, x, y, level)
    local inst = {}

    inst.entityManager = entityManager
    inst.x = x
    inst.y = y
    inst.level = level or 1
    inst.rot = 0
    inst.ringRad = 15
    inst.ringBaseRad = 15
    inst.ringRadVar = 3

    inst.update = _update
    inst.draw = _draw

    return inst
end

return keycard