local Vector2 = require("src.utils.Vector2")
local Math = require("src.utils.Math")
local Col = require("src.utils.CircleCollider")

local enemy = {}

local enemyDebugFlag = true

local nearRotThreshold = 10
local enemyImage = love.graphics.newImage("assets/img/kenneyTest/enemy.png")


local takeDamage = function(self)
    self.done = true
end

local function _checkForAudioBreadcrumbs(self)
    for k,v in pairs(self.audibleBreadcrumbs) do self.audibleBreadcrumbs[k]=nil end

    local audioCrumbs = self.entityManager:getAudioBreadcrumbs()
    for i = #audioCrumbs, 1, -1 do
        local ac = audioCrumbs[i]
        if Vector2.magnitude(ac.x - self.x, ac.y - self.y) < ac.range then
            table.insert(self.audibleBreadcrumbs, ac)
        end
    end
end

local function _checkForVisualBreadcrumbs(self)
    for k,v in pairs(self.visualBreadcrumbs) do self.visualBreadcrumbs[k]=nil end

    local visualCrumbs = self.entityManager:getVisualBreadcrumbs()
    for i = #visualCrumbs, 1, -1 do
        local vc = visualCrumbs[i]
        if Vector2.magnitude(vc.x - self.x, vc.y - self.y) < vc.range then
            if self.grid:lineOfSight(self.x, self.y, self.player.x, self.player.y) then
                table.insert(self.visualBreadcrumbs, vc)
            end
        end
    end
end

local function _targetInViewRange(self, target)
    return Vector2.magnitude(self.x - target.x, self.y - target.y) < self.viewDist
end

local function _targetInViewAngle(self, target)
    local angleToTarget = Vector2.angle(self.x, self.y, target.x, target.y)
    -- TODO: Tidy up this angle check
    local relativeAngleToTarget = (angleToTarget - self.rot) % 360
    if relativeAngleToTarget < 0 then relativeAngleToTarget = relativeAngleToTarget + 360 end
    if target.tag ~= nil and target.tag == "player" then self.relativeAngleToPlayer = relativeAngleToTarget end
    return (relativeAngleToTarget < self.viewAngle / 2) or (-relativeAngleToTarget + 360 < self.viewAngle / 2)
end

local function _targetInLineOfSight(self, target)
    -- TODO: Consider starting los 1 block away from enemy so they don't get trapped inside an unwalkable tile
    local targetInLos = self.grid:lineOfSight(self.x, self.y, target.x, target.y)
    -- NOTE: The below should only be used for a single target (i.e. the player), 
    -- otherwise the enemyVisionTiles table will be overwritten by other targets
    -- self.enemyVisionTiles, self.targetInLos = self.grid:lineOfSightPoints(self.x, self.y, self.target.x, self.target.y)
    return targetInLos
end

local function _canSeeTarget(self, target)
    assert(target.x ~= nil and target.y ~= nil, "Target must have x and y attributes")
    return _targetInViewRange(self, target) and _targetInViewAngle(self, target) and _targetInLineOfSight(self, target)
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

local function _checkForPlayer(self, dt)
    if _canSeeTarget(self, self.player) then
        _chasePlayer(self, dt)
    end
end

local _updateCollider = function(self)
    self.col:update(self.x, self.y)
end

local update = function(self, dt)
    self.viewDist = self.nominalViewDist * (1 + self.player:getSpeedMultiplier())

    _updateCollider(self)
    _checkForPlayer(self, dt)
    -- _checkForAudioBreadcrumbs(self)
    -- _checkForVisualBreadcrumbs(self)
end

local draw = function(self)
    if enemyDebugFlag then
        -- love.graphics.setColor(255, 255, 255)
        -- love.graphics.print("Angle to player: " .. string.format("%.2f", self.angleToPlayer), self.x, self.y - 90)
        -- love.graphics.print("Facing angle: " .. string.format("%.2f", self.rot), self.x, self.y - 70)
        -- love.graphics.print("Relative angle to player: " .. string.format("%.2f", self.relativeAngleToPlayer), self.x, self.y - 50)
        -- love.graphics.print("Player in view angle: " .. tostring( self.playerInViewAngle), self.x, self.y - 30)
        -- if self.playerInLos then
        --     love.graphics.setColor(0, 191, 0, 255)
        -- else
        --     love.graphics.setColor(191, 0, 0, 255)
        -- end
        -- for i = 1, #self.enemyVisionTiles do
        --     love.graphics.rectangle('fill', (self.enemyVisionTiles[i][1] - 1) * self.grid.cellSize, (self.enemyVisionTiles[i][2] - 1) * self.grid.cellSize, self.grid.cellDrawSize, self.grid.cellDrawSize)
        -- end
        love.graphics.setColor(255, 255, 255, 255)
        for i = 1, #self.audibleBreadcrumbs do
            love.graphics.line(self.x, self.y, self.audibleBreadcrumbs[i].x, self.audibleBreadcrumbs[i].y)
        end
        love.graphics.setColor(127, 0, 127, 255)
        for i = 1, #self.visualBreadcrumbs do
            love.graphics.line(self.x, self.y, self.visualBreadcrumbs[i].x, self.visualBreadcrumbs[i].y)
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

    -- love.graphics.setColor(191, 0, 0)
    -- love.graphics.circle("fill", self.x, self.y, self.radius)
    -- love.graphics.setColor(0, 0, 0)
    -- love.graphics.circle("line", self.x, self.y, self.radius)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(enemyImage, self.x, self.y, -math.rad(self.rot), 0.5, 0.5, 32, 32)
    -- love.graphics.draw(drawable (Drawable), x (number), y (number), r (number), sx (number), sy (number), ox (number), oy (number), kx (number), ky (number))
end

enemy.create = function(entityManager, x, y, rot)
    local inst = {}

    inst.tag = "enemy"
    inst.entityManager = entityManager
    inst.grid = entityManager:getGrid()
    inst.x = x or 0
    inst.y = y or 0
    inst.radius = 16
    inst.col = Col.create(x, y, inst.radius)
    inst.rot = rot or love.math.random(4) * 90
    inst.targetRot = nil
    inst.rotSpeed = 200
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
    inst.visualBreadcrumbs = {}
    inst.audibleBreadcrumbs = {}
    inst.moveSpeed = 100

    inst.takeDamage = takeDamage
    inst.update = update
    inst.draw = draw

    return inst
end

return enemy
