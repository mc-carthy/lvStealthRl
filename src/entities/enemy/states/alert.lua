AlertState = Class{ __includes = BaseState }

function AlertState:enter(body)
    self.body = body
    self.body.alertSfx:stop()
    self.body.alertSfx:play()
end

function AlertState:update(dt)
    if Vector2.distance(self.body, self.body.player) > 50 then
        self.body.stateMachine:change('caution', self.body)
    end
end

function AlertState:draw()
    love.graphics.setLineWidth(3)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle('line', self.body.x, self.body.y, 20)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.circle('fill', self.body.x, self.body.y, 20)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.body.image, self.body.x, self.body.y, self.body.rot, 0.5, 0.5, 32, 32)
end