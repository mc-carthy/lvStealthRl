local Vector2 = require("src.utils.Vector2")
local Math = require("src.utils.Math")
local Col = require("src.utils.CircleCollider")

local enemy = {}

local enemyDebugFlag = true

local nearRotThreshold = 10

local takeDamage = function(self)
    self.done = true
end

local _chasePlayer = function(self, dt)
    local rot = Vector2.angle(self.x, self.y, self.player.x, self.player.y)
    local dx, dy = Vector2.pointFromRotDist(rot, self.moveSpeed * dt)

    local dRot = 0
    self.targetRot = rot
    if math.abs((self.targetRot - self.rot) % 360) > nearRotThreshold then
        if self.relativeAngleToPlayer < 180 then
            dRot = self.rotSpeed * dt
        elseif self.relativeAngleToPlayer < 360 then
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
    self.viewDist = self.nominalViewDist * (1 + self.player:getSpeedMultiplier())
    -- local rotSpeed = 36
    -- self.rot = self.rot + rotSpeed * dt
    -- if self.rot > 360 then self.rot = 0 end

    _updateCollider(self)


    local playerInViewDist = Vector2.magnitude(self.x - self.player.x, self.y - self.player.y) < self.viewDist

    self.angleToPlayer = Vector2.angle(self.x, self.y, self.player.x, self.player.y)

    -- TODO: Tidy up this angle check
    self.relativeAngleToPlayer = (self.angleToPlayer - self.rot) % 360
    if self.relativeAngleToPlayer < 0 then self.relativeAngleToPlayer = self.relativeAngleToPlayer + 360 end
    -- if self.relativeAngleToPlayer > 180 then self.relativeAngleToPlayer = -self.relativeAngleToPlayer + 360 end
    self.playerInViewAngle = (self.relativeAngleToPlayer < self.viewAngle / 2) or (-self.relativeAngleToPlayer + 360 < self.viewAngle / 2)
    -- TODO: Consider starting los 1 block away from enemy so they don't get trapped inside an unwalkable tile
    -- self.playerInLos = self.grid:lineOfSight(self.x, self.y, self.player.x, self.player.y)
    self.enemyVisionTiles, self.playerInLos = self.grid:lineOfSightPoints(self.x, self.y, self.player.x, self.player.y)
    
    if playerInViewDist and  self.playerInViewAngle and self.playerInLos then
        self.canSeePlayer = true
    else
        self.canSeePlayer = false
    end

    if self.canSeePlayer then
        _chasePlayer(self, dt)
    end
end

local draw = function(self)
    if enemyDebugFlag then
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("Angle to player: " .. string.format("%.2f", self.angleToPlayer), self.x, self.y - 90)
        love.graphics.print("Facing angle: " .. string.format("%.2f", self.rot), self.x, self.y - 70)
        love.graphics.print("Relative angle to player: " .. string.format("%.2f", self.relativeAngleToPlayer), self.x, self.y - 50)
        love.graphics.print("Player in view angle: " .. tostring( self.playerInViewAngle), self.x, self.y - 30)
        if self.playerInLos then
            love.graphics.setColor(0, 191, 0, 255)
        else
            love.graphics.setColor(191, 0, 0, 255)
        end
        for i = 1, #self.enemyVisionTiles do
            love.graphics.rectangle('fill', (self.enemyVisionTiles[i][1] - 1) * self.grid.cellSize, (self.enemyVisionTiles[i][2] - 1) * self.grid.cellSize, self.grid.cellDrawSize, self.grid.cellDrawSize)
        end
    end

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
end

enemy.create = function(entityManager, x, y, rot)
    local inst = {}

    inst.tag = "enemy"
    inst.entityManager = entityManager
    inst.grid = entityManager:getGrid()
    inst.x = x or 0
    inst.y = y or 0
    inst.radius = 5
    inst.col = Col.create(x, y, inst.radius)
    inst.rot = rot or love.math.random(4) * 90
    inst.targetRot = nil
    inst.rotSpeed = 100
    inst.viewDist = 100
    inst.nominalViewDist = 200
    inst.viewAngle = 120
    inst.player = entityManager:getPlayer()
    inst.angleToPlayer = nil
    inst.playerInViewAngle = nil
    inst.relativeAngleToPlayer = nil
    inst.enemyVisionTiles = nil
    inst.playerInLos = nil
    inst.canSeePlayer = true
    inst.moveSpeed = 100

    inst.takeDamage = takeDamage
    inst.update = update
    inst.draw = draw

    return inst
end

return enemy
