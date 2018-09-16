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
end