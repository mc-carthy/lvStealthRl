CautionState = Class{ __includes = BaseState }

local cautionViewDist = 120
local cautionViewAngle = 140
local cautionConeColour = COLOURS['enemyCautionState']

function CautionState:enter(body)
    self.body = body
    self.body.viewDist = cautionViewDist
    self.body.viewAngle = math.rad(cautionViewAngle)
    self.body.coneColour = cautionConeColour
end

function CautionState:update(dt)
    if self.body:canSeePlayer() then
        self.body.stateMachine:change('alert', self.body)
    end
end