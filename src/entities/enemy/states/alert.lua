AlertState = Class{ __includes = BaseState }

local alertViewDist = 150
local alertViewAngle = 160
local alertConeColour = COLOURS['enemyAlertState']

function AlertState:enter(body)
    self.body = body
    self.body.viewDist = alertViewDist
    self.body.viewAngle = math.rad(alertViewAngle)
    self.body.coneColour = alertConeColour
    self.alertTimer = body.alertTimer or 100

    self.body.alertSfx:stop()
    self.body.alertSfx:play()
end

function AlertState:update(dt)
    self.alertTimer = self.alertTimer - dt
    if self.alertTimer < 0 then 
        self.body.stateMachine:change('caution', self.body)
    end
end