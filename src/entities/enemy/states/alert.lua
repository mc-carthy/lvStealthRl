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
        self.body.state:change('caution', self.body)
    end
    if self.body:canSeeTarget(self.body.player) then
        self.body.rot = Vector2.angle(self.body, self.body.player)
    end
end

function AlertState:hearNoise(noise)
    self.body.heardNoise = nil
end

function AlertState:draw()
    love.graphics.setColor(unpack(self.body.coneColour))
    love.graphics.arc("fill", self.body.x, self.body.y, self.body.viewDist, self.body.rot + self.body.viewAngle / 2, self.body.rot - self.body.viewAngle / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.body.image, self.body.x, self.body.y, self.body.rot, 0.5, 0.5, 32, 32)
end