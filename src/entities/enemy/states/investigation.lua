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
    if self.body:canSeeTarget(self.body.player) then
        self.body.state:change('alert', self.body)
    end

    if self.body.heardNoise then
        self:hearNoise(self.body.heardNoise)
    end
end

function InvestigationState:hearNoise(noise)
    self.body.heardNoise = nil
    if noise.type == 'playerGunshotNoise' then
        self.body.state:change('caution', self.body)
        self.body:findPathToTarget(noise)
    elseif noise.type == 'bulletImpactNoise' then
        self.body:findPathToTarget(noise)
    end
end

function InvestigationState:draw()
    love.graphics.setColor(unpack(self.body.coneColour))
    love.graphics.arc("fill", self.body.x, self.body.y, self.body.viewDist, self.body.rot + self.body.viewAngle / 2, self.body.rot - self.body.viewAngle / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.body.image, self.body.x, self.body.y, self.body.rot, 0.5, 0.5, 32, 32)
end