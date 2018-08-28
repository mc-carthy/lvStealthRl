IdleState = Class{ __includes = BaseState }

function IdleState:enter(body)
    self.body = body
    self.viewDist = 60
    self.viewAngle = math.rad(100)
end

function IdleState:update(dt)
    if Vector2.distance(self.body, self.body.player) < 200 then
        self.body.stateMachine:change('investigation', self.body)
    end
end

function IdleState:draw()
    love.graphics.setColor(unpack(COLOURS['enemyIdleState']))
    love.graphics.arc("fill", self.body.x, self.body.y, self.viewDist, self.body.rot + self.viewAngle / 2, -self.body.rot - self.viewAngle / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.body.image, self.body.x, self.body.y, self.body.rot, 0.5, 0.5, 32, 32)
end