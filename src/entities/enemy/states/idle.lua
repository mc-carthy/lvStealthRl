IdleState = Class{ __includes = BaseState }

local idleViewDist = 60
local idleViewAngle = 100
local idleConeColour = COLOURS['enemyIdleState']
local idleMovementSpeed = 75

function IdleState:enter(body)
    self.body = body
    self.body.movementSpeed = idleMovementSpeed
    self.body.viewDist = idleViewDist
    self.body.viewAngle = math.rad(idleViewAngle)
    self.body.coneColour = idleConeColour
end

function IdleState:update(dt)
    if self.body:canSeePlayer() then
        self.body.state:change('alert', self.body)
    end

    if self.body.heardNoise then
        self:hearNoise(self.body.heardNoise)
    end
end

function IdleState:hearNoise(noise)
    self.body.heardNoise = nil
    if noise.type == 'playerGunshotNoise' then
        -- TODO: When the state is changed to caution, it still finds the heardNoise on the body and goes to alert. Investigate.
        -- This is because the noise is triggering hearNoise on the body when it is within range, so when the body's heardNoise
        -- is set to nil above, if the noise radius is still greater than the distance from body, it will set itself as the body's
        -- heard noise again.
        self.body.state:change('caution', self.body)
        self.body:findPathToTarget(noise)
    elseif noise.type == 'bulletImpactNoise' then
        self.body.state:change('investigation', self.body)
        self.body:findPathToTarget(noise)
    end
end

function IdleState:draw()
    love.graphics.setColor(unpack(self.body.coneColour))
    love.graphics.arc("fill", self.body.x, self.body.y, self.body.viewDist, self.body.rot + self.body.viewAngle / 2, self.body.rot - self.body.viewAngle / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.body.image, self.body.x, self.body.y, self.body.rot, 0.5, 0.5, 32, 32)
end