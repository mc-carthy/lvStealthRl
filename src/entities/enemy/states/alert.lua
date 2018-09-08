AlertState = Class{ __includes = BaseState }

local alertViewDist = 150
local alertViewAngle = 160
local alertConeColour = COLOURS['enemyAlertState']

function AlertState:enter(body)
    self.body = body
    self.body.viewDist = alertViewDist
    self.body.viewAngle = math.rad(alertViewAngle)
    self.body.coneColour = alertConeColour

    self.body.alertSfx:stop()
    self.body.alertSfx:play()
end

function AlertState:update(dt)
    if Vector2.distance(self.body, self.body.player) > 50 then
        self.body.stateMachine:change('caution', self.body)
    end
end