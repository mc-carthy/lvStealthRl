local Vector2 = require("src.utils.Vector2")
local Math = require("src.utils.Math")
local Col = require("src.utils.CircleCollider")

local enemy = {}

local enemyDebugFlag = true

local angleToPlayer = nil
local playerInViewAngle = nil
local relativeAngleToPlayer = nil
local nearRotThreshold = 10

local takeDamage = function(self)
    self.done = true
end

local _chasePlayer = function(self, dt)
    local player = self.entityManager:getPlayer()
    local rot = Vector2.angle(self.x, self.y, player.x, player.y)
    local dx, dy = Vector2.pointFromRotDist(rot, self.moveSpeed * dt)

    local dRot = 0
    self.targetRot = rot
    if math.abs((self.targetRot - self.rot) % 360) > nearRotThreshold then
        if relativeAngleToPlayer < 180 then
            dRot = self.rotSpeed * dt
        elseif relativeAngleToPlayer < 360 then
            dRot = -self.rotSpeed * dt
        end
    end
    self.rot = self.rot + dRot

    self.x = self.x + dx
    self.y = self.y + dy
end

local _updateCollider = function(self)
    self.col:update(self.x, self.y)
end

local update = function(self, dt)
    local player = self.entityManager:getPlayer()

    self.viewDist = self.nominalViewDist * player:getSpeedMultiplier()
    -- local rotSpeed = 36
    -- self.rot = self.rot + rotSpeed * dt
    -- if self.rot > 360 then self.rot = 0 end

    _updateCollider(self)


    local playerInViewDist = Vector2.magnitude(self.x - player.x, self.y - player.y) < self.viewDist

    angleToPlayer = Vector2.angle(self.x, self.y, player.x, player.y)

    -- TODO: Tidy up this angle check
    relativeAngleToPlayer = (angleToPlayer - self.rot) % 360
    if relativeAngleToPlayer < 0 then relativeAngleToPlayer = relativeAngleToPlayer + 360 end
    -- if relativeAngleToPlayer > 180 then relativeAngleToPlayer = -relativeAngleToPlayer + 360 end
    playerInViewAngle = (relativeAngleToPlayer < self.viewAngle / 2) or (-relativeAngleToPlayer + 360 < self.viewAngle / 2)

    if playerInViewDist and playerInViewAngle then
        self.canSeePlayer = true
    else
        self.canSeePlayer = false
    end

    if self.canSeePlayer then
        _chasePlayer(self, dt)
    end
end

local draw = function(self)
    local focusX, focusY = Vector2.pointFromRotDist(self.rot, self.viewDist)
    local viewAngleX1, viewAngleY1 = Vector2.pointFromRotDist(self.rot - self.viewAngle / 2, self.viewDist)
    local viewAngleX2, viewAngleY2 = Vector2.pointFromRotDist(self.rot + self.viewAngle / 2, self.viewDist)

    love.graphics.setColor(191, 0, 0, 127)
    love.graphics.arc("fill", self.x, self.y, self.viewDist, -math.rad(self.rot + self.viewAngle / 2), -math.rad(self.rot - self.viewAngle / 2))

    love.graphics.setColor(0, 0, 0)
    -- love.graphics.line(self.x, self.y, self.x + viewAngleX1, self.y + viewAngleY1)
    -- love.graphics.line(self.x, self.y, self.x + viewAngleX2, self.y + viewAngleY2)
    -- love.graphics.line(self.x, self.y, self.x + focusX, self.y + focusY)

    love.graphics.setColor(191, 0, 0)
    love.graphics.circle("fill", self.x, self.y, self.radius)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("line", self.x, self.y, self.radius)

    if enemyDebugFlag then
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("Angle to player: " .. string.format("%.2f", angleToPlayer), self.x, self.y - 90)
        love.graphics.print("Facing angle: " .. string.format("%.2f", self.rot), self.x, self.y - 70)
        love.graphics.print("Relative angle to player: " .. string.format("%.2f", relativeAngleToPlayer), self.x, self.y - 50)
        love.graphics.print("Player in view angle: " .. tostring(playerInViewAngle), self.x, self.y - 30)
    end
end

enemy.create = function(entityManager, x, y, rot)
    local inst = {}

    inst.tag = "enemy"
    inst.entityManager = entityManager
    inst.x = x or 0
    inst.y = y or 0
    inst.radius = 5
    inst.col = Col.create(x, y, inst.radius)
    inst.rot = rot or 180
    inst.targetRot = nil
    inst.rotSpeed = 100
    inst.viewDist = 100
    inst.nominalViewDist = 200
    inst.viewAngle = 120
    inst.canSeePlayer = true
    inst.moveSpeed = 100

    inst.takeDamage = takeDamage
    inst.update = update
    inst.draw = draw

    return inst
end

return enemy
