CautionState = Class{ __includes = BaseState }

local cautionViewDist = 120
local cautionViewAngle = 140
local cautionConeColour = COLOURS['enemyCautionState']

function CautionState:enter(body)
    self.body = body
    self.body.viewDist = cautionViewDist
    self.body.viewAngle = math.rad(cautionViewAngle)
    self.body.coneColour = cautionConeColour
    self.cautionTimer = body.cautionTimer or 100
end

function CautionState:update(dt)
    self.cautionTimer = self.cautionTimer - dt
    if self.body:canSeePlayer() then
        self.body.stateMachine:change('alert', self.body)
    end
    if self.cautionTimer < 0 then
        self.body.stateMachine:change('idle', self.body)
    end
end