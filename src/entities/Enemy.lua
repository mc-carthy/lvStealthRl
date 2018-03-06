local Vector2 = require("src.utils.Vector2")
local Math = require("src.utils.Math")
local Col = require("src.utils.CircleCollider")
local Utils = require("src.utils.utils")

local enemy = {}

local enemyDebugFlag = true

local nearRotThreshold = 10
local enemyImage = love.graphics.newImage("assets/img/kenneyTest/enemy.png")


local takeDamage = function(self)
    self.done = true
end

local function _relativeAngleToTarget(self, target)
    local angleToTarget = Vector2.angle(self.x, self.y, target.x, target.y)
    -- TODO: Tidy up this angle check
    local relativeAngleToTarget = (angleToTarget - self.rot) % 360
    if relativeAngleToTarget < 0 then relativeAngleToTarget = relativeAngleToTarget + 360 end
    return relativeAngleToTarget
end

local function _targetInViewRange(self, target)
    return Vector2.magnitude(self.x - target.x, self.y - target.y) < self.viewDist
end

local function _targetInViewAngle(self, target)
    local relativeAngleToTarget = _relativeAngleToTarget(self, target)
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

local function _canHearTarget(self, target)
    assert(target.x ~= nil and target.y ~= nil, "Target must have x and y attributes")
    assert(target.range ~= nil, "Target must have a range attribute")
    return Vector2.magnitude(self.x - target.x, self.y - target.y) < target.range
end

local function _highestPriorityCrumb(crumbs)
    local priorityCrumb = nil
    for i = 1, #crumbs do
        if priorityCrumb == nil or crumbs[i].currentLifetime > priorityCrumb.currentLifetime then
            priorityCrumb = crumbs[i]
        end
    end
    return priorityCrumb
end

local function _checkForAudioBreadcrumbs(self)
    for k,v in pairs(self.audibleBreadcrumbs) do self.audibleBreadcrumbs[k]=nil end

    local audioCrumbs = self.entityManager:getAudioBreadcrumbs()
    for i = #audioCrumbs, 1, -1 do
        local ac = audioCrumbs[i]
        if _canHearTarget(self, ac) then
            table.insert(self.audibleBreadcrumbs, ac)
        end
    end
    local pac = _highestPriorityCrumb(self.audibleBreadcrumbs)
    if pac ~= nil then
        self.priorityAudibleBreadcrumb = {
            x = pac.x,
            y = pac.y,
            tag = "visualTarget"
        }
    end
end

local function _checkForVisualBreadcrumbs(self)
    -- TODO: Keep an eye on this function in terms of the self.visualBreadcrumbs table
    -- Currently it's not causing any issues, but looks like it could cause memory leak
    local visualCrumbs = self.entityManager:getVisualBreadcrumbs()
    for i = 1, #visualCrumbs do
        local vc = visualCrumbs[i]
        if _canSeeTarget(self, vc) then
            if not Utils.contains(self.visualBreadcrumbs, vc) then
                table.insert(self.visualBreadcrumbs, vc)
            end
        end
        if vc == nil or vc.currentLifetime < 0.1 then
            for j, v in ipairs(self.visualBreadcrumbs) do
                if v == vc then
                    table.remove(self.visualBreadcrumbs, j)
                end
            end
        end
    end
    -- if #self.visualBreadcrumbs > 0 then
    --     print(#self.visualBreadcrumbs)
    -- end
    local pvc = _highestPriorityCrumb(self.visualBreadcrumbs)
    if pvc ~= nil then
        self.priorityVisualBreadcrumb = {
            x = pvc.x,
            y = pvc.y,
            tag = "visualTarget"
        }
    end
end

local _moveToTarget = function(self, target, dt)
    assert(target.x ~= nil and target.y ~= nil, "Target must have x and y attributes")
    local rot = Vector2.angle(self.x, self.y, target.x, target.y)
    local dx, dy = Vector2.pointFromRotDist(rot, self.moveSpeed * dt)
    local dRot = 0
    local targetRot = rot

    local relativeAngleToTarget = _relativeAngleToTarget(self, target)
    if math.abs((targetRot - self.rot) % 360) > nearRotThreshold then
        if relativeAngleToTarget < 180 then
            dRot = self.rotSpeed * dt
        elseif relativeAngleToTarget < 360 then
            dRot = -self.rotSpeed * dt
        end
    end
    self.rot = self.rot + dRot

    if (Vector2.distance(self, target)) > 5 then
        self.x = self.x + dx
        self.y = self.y + dy
    else
        if target.tag == "visualTarget" then
            self.priorityVisualBreadcrumb = nil
            self.priorityAudibleBreadcrumb = nil
        elseif target.tag == "audioTarget" then
            self.priorityAudibleBreadcrumb = nil
        end
    end
end

local function _checkForTargets(self, dt)
    if _canSeeTarget(self, self.player) then
        _moveToTarget(self, self.player, dt)
    elseif self.priorityVisualBreadcrumb ~= nil then
        _moveToTarget(self, self.priorityVisualBreadcrumb, dt)
    elseif self.priorityAudibleBreadcrumb ~= nil then
        _moveToTarget(self, self.priorityAudibleBreadcrumb, dt)
    end
end

local _updateCollider = function(self)
    self.col:update(self.x, self.y)
end

local update = function(self, dt)
    self.viewDist = self.nominalViewDist * (1 + self.player:getSpeedMultiplier())

    _updateCollider(self)
    _checkForAudioBreadcrumbs(self)
    _checkForVisualBreadcrumbs(self)
    _checkForTargets(self, dt)

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
        for _, v in pairs(self.audibleBreadcrumbs) do
            love.graphics.setColor(255, 255, 255, 255 * v.currentLifetime / v.initialLifetime)
            love.graphics.line(self.x, self.y, v.x, v.y)
        end
        for _, v in pairs(self.visualBreadcrumbs) do
            love.graphics.setColor(191, 0, 191, 191 * v.currentLifetime / v.initialLifetime)
            love.graphics.line(self.x, self.y, v.x, v.y)
        end
        if self.priorityAudibleBreadcrumb then
            love.graphics.setColor(127, 127, 127, 255)
            love.graphics.line(self.x, self.y, self.priorityAudibleBreadcrumb.x, self.priorityAudibleBreadcrumb.y)
        end
        if self.priorityVisualBreadcrumb then
            love.graphics.setColor(127, 0, 127, 255)
            love.graphics.line(self.x, self.y, self.priorityVisualBreadcrumb.x, self.priorityVisualBreadcrumb.y)
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
    inst.priorityVisualBreadcrumb = nil
    inst.priorityAudibleBreadcrumb = nil

    inst.moveSpeed = 100

    inst.takeDamage = takeDamage
    inst.update = update
    inst.draw = draw

    return inst
end

return enemy
