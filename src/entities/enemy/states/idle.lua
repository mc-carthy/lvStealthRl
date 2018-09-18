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
        self.body.stateMachine:change('alert', self.body)
    end

    if self.body.heardNoise then
        self:hearNoise(self.body.heardNoise)
    end
end

function IdleState:hearNoise(noise)
    self.body.heardNoise = nil
    if noise.type == 'playerGunshotNoise' then
        -- TODO: When the state is changed to caution, it still finds the heardNoise on the body and goes to alert. Investigate.
        self.body.stateMachine:change('caution', self.body)
        self.body:findPathToTarget(noise)
    elseif noise.type == 'bulletImpactNoise' then
        self.body.stateMachine:change('investigation', self.body)
        self.body:findPathToTarget(noise)
    end
end