InvestigationState = Class{ __includes = BaseState }

function InvestigationState:enter(body)
    self.body = body
    self.viewDist = 90
    self.viewAngle = math.rad(120)
end

function InvestigationState:update(dt)
    if Vector2.distance(self.body, self.body.player) < 100 then
        self.body.stateMachine:change('caution', self.body)
    end
    if Vector2.distance(self.body, self.body.player) > 200 then
        self.body.stateMachine:change('idle', self.body)
    end
end

function InvestigationState:draw()
    love.graphics.setColor(0.5, 0.5, 1, 0.5)
    love.graphics.arc("fill", self.body.x, self.body.y, self.viewDist, self.body.rot + self.viewAngle / 2, -self.body.rot - self.viewAngle / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.body.image, self.body.x, self.body.y, self.body.rot, 0.5, 0.5, 32, 32)
end