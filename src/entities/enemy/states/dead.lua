DeadState = Class{ __includes = BaseState }

function DeadState:enter(body)
    self.body = body
    self.body.movementSpeed = 0
    self.body.viewDist = 0
    self.body.viewAngle = 0
end

function DeadState:update(dt)
end

function DeadState:draw()
    local crossSize = 16
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    love.graphics.draw(self.body.image, self.body.x, self.body.y, self.body.rot, 0.5, 0.5, 32, 32)
    love.graphics.setColor(0.75, 0, 0, 1)
    love.graphics.setLineWidth(3)
    love.graphics.line(self.body.x - crossSize / 2, self.body.y - crossSize / 2, self.body.x + crossSize / 2, self.body.y + crossSize / 2)
    love.graphics.line(self.body.x + crossSize / 2, self.body.y - crossSize / 2, self.body.x - crossSize / 2, self.body.y + crossSize / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
end