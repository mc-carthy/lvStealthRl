AlertState = Class{ __includes = BaseState }

function AlertState:enter(body)
    self.body = body
    self.viewDist = 150
    self.viewAngle = math.rad(160)
    self.body.alertSfx:stop()
    self.body.alertSfx:play()
end

function AlertState:update(dt)
    if Vector2.distance(self.body, self.body.player) > 50 then
        self.body.stateMachine:change('caution', self.body)
    end
end

function AlertState:draw()
    love.graphics.setColor(unpack(COLOURS['enemyAlertState']))
    love.graphics.arc("fill", self.body.x, self.body.y, self.viewDist, self.body.rot + self.viewAngle / 2, -self.body.rot - self.viewAngle / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.body.image, self.body.x, self.body.y, self.body.rot, 0.5, 0.5, 32, 32)
end