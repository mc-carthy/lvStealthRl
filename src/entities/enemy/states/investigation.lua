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
    if Vector2.distance(self.body, self.body.player) < 100 then
        self.body.stateMachine:change('caution', self.body)
    end
    if Vector2.distance(self.body, self.body.player) > 200 then
        self.body.stateMachine:change('idle', self.body)
    end
end