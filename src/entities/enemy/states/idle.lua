IdleState = Class{ __includes = BaseState }

local idleViewDist = 60
local idleViewAngle = 100
local idleConeColour = COLOURS['enemyIdleState']

function IdleState:enter(body)
    self.body = body
    self.body.viewDist = idleViewDist
    self.body.viewAngle = math.rad(idleViewAngle)
    self.body.coneColour = idleConeColour
end

function IdleState:update(dt)
    if Vector2.distance(self.body, self.body.player) < 200 then
        self.body.stateMachine:change('investigation', self.body)
    end
end