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
    if Vector2.distance(self.body, self.body.player) < 50 then
        self.body.stateMachine:change('alert', self.body)
    end
    if Vector2.distance(self.body, self.body.player) > 100 then
        self.body.stateMachine:change('investigation', self.body)
    end
end