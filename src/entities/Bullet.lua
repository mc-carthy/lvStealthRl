local Vector2 = require("src.utils.Vector2")
local Col = require("src.utils.CircleCollider")

local bullet = {}

local update = function(self, dt)
    local dx, dy = Vector2.pointFromRotDist(self.rot, self.speed * dt)
    self.x = self.x + dx
    self.y = self.y + dy
    self.col:update(self.x, self.y)

    for i = 1, #self.entityManager.entities do
        local other = self.entityManager.entities[i]
        if other ~= self and other.col then
            if self.col:trigger(other.col) then
                print("Collision!")
            end
        end
    end
end

local draw = function(self)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

bullet.create = function(entityManager, x, y, rot, speed)
    local inst = {}

    -- TODO pass tag in as a variable once enemies start creating bullets
    inst.tag = "playerBullet"
    inst.entityManager = entityManager
    inst.x = x
    inst.y = y
    inst.radius = 5
    inst.col = Col.create(x, y, inst.radius)
    inst.rot = rot
    inst.speed = speed

    inst.update = update
    inst.draw = draw

    return inst
end

return bullet
