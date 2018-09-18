Enemy = Class{}

local pathfindingPrecision = 1

function Enemy:init(x, y)
    self.player = nil
    self.tag = TAG.ENEMY
    self.image = SPRITES.enemy
    self.x = x
    self.y = y
    self.rot = 0--math.random() * 2 * math.pi
    self.rad = 7.5
    self.stateMachine = StateMachine {
        ['idle'] = function() return IdleState() end,
        ['investigation'] = function() return InvestigationState() end,
        ['caution'] = function() return CautionState() end,
        ['alert'] = function() return AlertState() end,
    }
    self.stateMachine:change('idle', self)
    self.alertSfx = love.audio.newSource('assets/audio/sfx/alert.wav', 'static')
    
    self.losPoints = {}
    self.playerInLos = false
    self.pathWaypoints = {}
    self.heardNoises = {}
end

function Enemy:hit(object)
    if object.damage then
        if self.hp then
            self.hp = self.hp - object.damage
            if self.hp <= 0 then
                SFX['enemyHit']:stop()
                SFX['enemyHit']:play()
                self.done = true
            end
        else
            SFX['enemyHit']:stop()
            SFX['enemyHit']:play()
            self.done = true
        end
    end
end

function Enemy:hearNoise(noise)
    -- print('Heard noise of type ' .. noise.type .. ' coming from ' .. noise.x .. '-' .. noise.y)
    -- TODO: Consider a method to prevent this table from getting too large
    -- Perhaps remove each noise from the table after a given time period
    if not table.contains(self.heardNoises, noise.id) then
        self.heardNoise = noise
        table.insert(self.heardNoises, noise.id)
    end
end

-- TODO: Create 'map' base class for celAutMap and imageMap to derive from and move this function there
function Enemy:lineOfSightPoints(target)
    local startX, startY = getGridPos(self.x, self.y)
    local endX, endY = getGridPos(target.x, target.y)
    local points, success = Bresenham.line(startX, startY, endX, endY, function(x, y)
        return not self.em.map:collidable(x, y)
    end)
    return points, success
end

function Enemy:lineOfSight(target)
    local startX, startY = getGridPos(self.x, self.y)
    local endX, endY = getGridPos(target.x, target.y)
    local success = Bresenham.los(startX, startY, endX, endY, function(x, y)
        return not self.em.map:collidable(x, y)
    end)
    return success
end

function Enemy:getDistanceToPlayer()
    return Vector2.distance(self, self.player)
end

function Enemy:getAngleToPlayer()
    local absoluteAngleToPlayer = Vector2.angle(self, self.player)
    local relativeAngleToPlayer = (absoluteAngleToPlayer - self.rot) % (2 * math.pi)
    if relativeAngleToPlayer > math.pi then relativeAngleToPlayer = relativeAngleToPlayer - (2 * math.pi) end
    relativeAngleToPlayer = math.abs(relativeAngleToPlayer)

    return relativeAngleToPlayer
end

function Enemy:canSeePlayer()
    if self.player ~= nil then
        if self:getDistanceToPlayer() < self.viewDist then
            if self:getAngleToPlayer() < self.viewAngle / 2 then
                if self:lineOfSight(self.player) then
                    return true
                end
            end
        end
    end
    return false
end

function Enemy:update(dt)
    if self.player == nil then self.player = self.em:getPlayer() end
    self.stateMachine:update(dt)
    self.losPoints, self.playerInLos = self:lineOfSightPoints(self.player)
    self:canSeePlayer()

    if #self.pathWaypoints > 0 then
        self:pathfind(dt)
    else
        self:wander(dt)
    end
end

function Enemy:findPathToTarget(target)
    local points = {}
    -- if love.keyboard.wasPressed('p') then
        local selfGridX, selfGridY = getGridPos(self.x, self.y)
        local targetGridX, targetGridY = getGridPos(target.x, target.y)
        success, points = self.em.map:getPath({ x = selfGridX, y = selfGridY },  { x = targetGridX, y = targetGridY })
        if success then
            self.pathWaypoints = points
            for i = 1, #points do
                -- print('x: ' .. points[i][1] .. ' y: ', points[i][2])
            end
        end
    -- end
end

function Enemy:pathfind(dt)
    local nextX, nextY = self.pathWaypoints[1][1] * GRID_SIZE - GRID_SIZE / 2, self.pathWaypoints[1][2] * GRID_SIZE - GRID_SIZE / 2
    local bearing = math.atan2(nextY - self.y, nextX - self.x)
    self:move(dt, bearing)

    if Vector2.distance(self, { x = nextX, y = nextY }) < pathfindingPrecision then
        _, self.pathWaypoints = table.dequeue(self.pathWaypoints)
    end
end

function Enemy:wander(dt)
    local whiskerLength = GRID_SIZE * 4
    local whiskerX, whiskerY = math.cos(self.rot) * whiskerLength, math.sin(self.rot) * whiskerLength
    local dx = math.cos(self.rot) * (self.movementSpeed * dt)
    local dy = math.sin(self.rot) * (self.movementSpeed * dt)
    local nextGridX, nextGridY = getGridPos(self.x + dx + whiskerX, self.y + dy + whiskerY)
    if self.em.map[nextGridX] == nil or self.em.map[nextGridX][nextGridY] == nil or self.em.map:collidable(nextGridX, nextGridY) then
        self.rot = math.floor(math.random() * 4) * math.pi / 2
    else
        self.x = self.x + dx
        self.y = self.y + dy
    end
end

function Enemy:move(dt, bearing)
    self.rot = bearing
    local dx = math.cos(bearing) * self.movementSpeed * dt
    local dy = math.sin(bearing) * self.movementSpeed * dt
    self.x = self.x + dx
    self.y = self.y + dy
end

function Enemy:draw()
    -- DEBUG info for player in sight
    -- if self.playerInLos then
    --     love.graphics.setColor(1, 0, 0, 0.5)
    -- else
    --     love.graphics.setColor(0, 1, 0, 0.5)
    -- end

    -- for i = 1, #self.losPoints do
    --     love.graphics.rectangle('fill', (self.losPoints[i][1] - 1) * GRID_SIZE, (self.losPoints[i][2] - 1) * GRID_SIZE, GRID_SIZE, GRID_SIZE)
    -- end

    if #self.pathWaypoints > 0 then
        love.graphics.setColor(0, 0, 0, 1)
        for i = 1, #self.pathWaypoints - 1 do
            love.graphics.line(
                self.pathWaypoints[i][1] * GRID_SIZE - GRID_SIZE / 2,
                self.pathWaypoints[i][2] * GRID_SIZE - GRID_SIZE / 2,
                self.pathWaypoints[i + 1][1] * GRID_SIZE - GRID_SIZE / 2,
                self.pathWaypoints[i + 1][2] * GRID_SIZE - GRID_SIZE / 2
            )
        end
        love.graphics.line(
            self.x,
            self.y,
            self.pathWaypoints[1][1] * GRID_SIZE - GRID_SIZE / 2,
            self.pathWaypoints[1][2] * GRID_SIZE - GRID_SIZE / 2
        )
    end

    love.graphics.setColor(unpack(self.coneColour))
    love.graphics.arc("fill", self.x, self.y, self.viewDist, self.rot + self.viewAngle / 2, self.rot - self.viewAngle / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.image, self.x, self.y, self.rot, 0.5, 0.5, 32, 32)
end