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
    if self.body:canSeeTarget(self.body.player) then
        self.body.state:change('alert', self.body)
    end
    if self.cautionTimer < 0 then
        self.body.state:change('idle', self.body)
    end

    if self.body.heardNoise then
        self:hearNoise(self.body.heardNoise)
    end
end

function CautionState:hearNoise(noise)
    self.body.heardNoise = nil
    if noise.type == 'playerGunshotNoise' then
        self.body.state:change('alert', self.body)
        self.body:findPathToTarget(noise)
    elseif noise.type == 'bulletImpactNoise' then
        self.body:findPathToTarget(noise)
    end
end

function CautionState:draw()
    love.graphics.setColor(unpack(self.body.coneColour))
    love.graphics.arc("fill", self.body.x, self.body.y, self.body.viewDist, self.body.rot + self.body.viewAngle / 2, self.body.rot - self.body.viewAngle / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.body.image, self.body.x, self.body.y, self.body.rot, 0.5, 0.5, 32, 32)
end