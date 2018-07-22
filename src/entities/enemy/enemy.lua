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

function Enemy:update(dt)
    if self.player == nil then self.player = self.em:getPlayer() end
    self.stateMachine:update(dt)
end

function Enemy:draw()
    -- love.graphics.draw(self.image, self.x, self.y, self.rot, 0.5, 0.5, 32, 32)
    self.stateMachine:draw()
end