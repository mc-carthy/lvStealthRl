local Vector2 = require("src.utils.Vector2")
local Col = require("src.utils.CircleCollider")
local AudioCrumb = require("src.entities.audioBreadcrumb")

local bullet = {}

local _collisionCheck = function(self)
    for i = 1, #self.entityManager.entities do
        local other = self.entityManager.entities[i]
        if other.tag == "enemy" and other.col then
            if self.col:trigger(other.col) then
                self.done = true
                if other.takeDamage then other:takeDamage() end
            end
        end
        if other.tag == "grid" then
            local grid = other
            local gridX, gridY = grid.worldSpaceToGrid(grid, self.x, self.y)
            if grid[gridX][gridY].walkable == false then
                -- TODO: Remove hard-coded value for bullet impact noise and distance from impact point to create crumb
                local dx, dy = Vector2.pointFromRotDist(self.rot, 5)
                self.entityManager:addEntity(AudioCrumb.create(self.entityManager, self.x - dx, self.y - dy, 200, self.tag))
                self.done = true
            end
        end
    end
end

local update = function(self, dt)
    local dx, dy = Vector2.pointFromRotDist(self.rot, self.speed * dt)
    self.x = self.x + dx
    self.y = self.y + dy
    self.col:update(self.x, self.y)
    _collisionCheck(self)
end

local draw = function(self)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", self.x, self.y, self.radius + 1)
    love.graphics.setColor(255, 191, 0)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

bullet.create = function(entityManager, x, y, rot, speed)
    local inst = {}

    -- TODO pass tag in as a variable once enemies start creating bullets
    inst.tag = "playerBullet"
    inst.entityManager = entityManager
    inst.x = x
    inst.y = y
    inst.radius = 3
    inst.col = Col.create(x, y, inst.radius)
    inst.rot = rot
    inst.speed = speed
    inst.done = false

    inst.update = update
    inst.draw = draw

    return inst
end

return bullet
