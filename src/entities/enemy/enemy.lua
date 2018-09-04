Enemy = Class{}

function Enemy:init(x, y)
    self.player = nil
    self.tag = 'enemy'
    self.image = SPRITES.enemy
    self.x = x
    self.y = y
    self.rot = 0
    self.rad = 7.5
    self.stateMachine = StateMachine {
        ['idle'] = function() return IdleState() end,
        ['investigation'] = function() return InvestigationState() end,
        ['caution'] = function() return CautionState() end,
        ['alert'] = function() return AlertState() end,
    }
    self.stateMachine:change('idle', self)
    self.depth = 10
    self.alertSfx = love.audio.newSource('assets/audio/sfx/alert.wav', 'static')
    
    self.losPoints = {}
    self.playerInLos = false
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

-- TODO: Create 'map' base class for celAutMap and imageMap to derive from and move this function there
function Enemy:lineOfSightPoints(target)
    local startX, startY = getGridPos(self.x, self.y)
    local endX, endY = getGridPos(target.x, target.y)
    local points, success = Bresenham.line(startX, startY, endX, endY, function(x, y)
        return not self.em.map:collidable(x, y)
    end)
    return points, success
end

function Enemy:update(dt)
    if self.player == nil then self.player = self.em:getPlayer() end
    self.stateMachine:update(dt)
    self.losPoints, self.playerInLos = self:lineOfSightPoints(self.player)
end

function Enemy:draw()
    if self.playerInLos then
        love.graphics.setColor(1, 0, 0, 0.5)
    else
        love.graphics.setColor(0, 1, 0, 0.5)
    end

    for i = 1, #self.losPoints do
        love.graphics.rectangle('fill', (self.losPoints[i][1] - 1) * GRID_SIZE, (self.losPoints[i][2] - 1) * GRID_SIZE, GRID_SIZE, GRID_SIZE)
    end

    self.stateMachine:draw()
end