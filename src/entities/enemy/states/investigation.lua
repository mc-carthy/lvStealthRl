InvestigationState = Class{ __includes = BaseState }

local investigationViewDist = 90
local investigationViewAngle = 120
local investigationConeColour = COLOURS['enemyInvestigationState']

function InvestigationState:enter(body)
    self.body = body
    self.body.viewDist = investigationViewDist
    self.body.viewAngle = math.rad(investigationViewAngle)
    self.body.coneColour = investigationConeColour
end

function InvestigationState:update(dt)
    if self.body:canSeePlayer() then
        self.body.stateMachine:change('alert', self.body)
    end

    if self.body.heardNoise then
        self:hearNoise(self.body.heardNoise)
    end
end

function InvestigationState:hearNoise(noise)
    self.body.heardNoise = nil
    if noise.type == 'playerGunshotNoise' then
        self.body.stateMachine:change('caution', self.body)
        self.body:findPathToTarget(noise)
    elseif noise.type == 'bulletImpactNoise' then
        self.body:findPathToTarget(noise)
    end
end