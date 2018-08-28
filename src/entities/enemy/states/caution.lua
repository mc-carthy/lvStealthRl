CautionState = Class{ __includes = BaseState }

function CautionState:enter(body)
    self.body = body
    self.viewDist = 120
    self.viewAngle = math.rad(140)
end

function CautionState:update(dt)
    if Vector2.distance(self.body, self.body.player) < 50 then
        self.body.stateMachine:change('alert', self.body)
    end
    if Vector2.distance(self.body, self.body.player) > 100 then
        self.body.stateMachine:change('investigation', self.body)
    end
end

function CautionState:draw()
    love.graphics.setColor(1, 1, 0.5, 0.5)
    love.graphics.arc("fill", self.body.x, self.body.y, self.viewDist, self.body.rot + self.viewAngle / 2, -self.body.rot - self.viewAngle / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.body.image, self.body.x, self.body.y, self.body.rot, 0.5, 0.5, 32, 32)
end