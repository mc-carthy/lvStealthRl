Enemy = Class{}

function Enemy:init(x, y)
    self.tag = 'enemy'
    self.image = love.graphics.newImage('assets/img/kenneyTest/enemy.png')
    self.x = x
    self.y = y
    self.rot = 0
    self.rad = 5
    self.stateMachine = StateMachine {
        ['idle'] = function() return IdleState() end,
        ['investigation'] = function() return InvestigationState() end,
        ['caution'] = function() return CautionState() end,
        ['alert'] = function() return AlertState() end,
    }
    self.stateMachine:change('idle', self)
    self.stateMachine:change('investigation', self)
    -- self.stateMachine:change('caution', self)
    -- self.stateMachine:change('alert', self)
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
    self.stateMachine:update(dt)
end

function Enemy:draw()
    -- love.graphics.draw(self.image, self.x, self.y, self.rot, 0.5, 0.5, 32, 32)
    self.stateMachine:draw()
end