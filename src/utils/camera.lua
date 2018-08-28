Camera = Class{}

local zoomSpeed = 0.99
local maxZoom = 2
local minZoom = 0.2
local shakeDampSpeed = 10
local shakeTranslationTarget = 0
local shakeRotationTarget = 0
local shakeScaleTarget = 1
local shakeShearTarget = 0

function Camera:init(params)
    self.target = params.target
    self.x = self.target.x
    self.y = self.target.y
    self.zoomLevel = 1

    self.shakeTranslation = 0
    self.shakeRotation = 0
    self.shakeScale = 1
    self.shakeShear = 0
end

function Camera:set()
    love.graphics.push()
    love.graphics.translate(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
    love.graphics.scale(self.zoomLevel, self.zoomLevel)
    love.graphics.rotate((math.random() - 0.5) * self.shakeRotation)
    love.graphics.scale(self.shakeScale, self.shakeScale)
    love.graphics.shear(self.shakeShear * 0.01, self.shakeShear * 0.01)
    love.graphics.translate(-self.x, -self.y)
    
    love.graphics.translate((math.random() - 0.5) * self.shakeTranslation, (math.random() - 0.5) * self.shakeTranslation)
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:update(dt)
    self.x = self.target.x
    self.y = self.target.y


    if love.keyboard.isDown('z') then
        self.zoomLevel = self.zoomLevel - (zoomSpeed * dt)
    end
    if love.keyboard.isDown('x') then
        self.zoomLevel = self.zoomLevel + (zoomSpeed * dt)
    end
    self.zoomLevel = math.clamp(self.zoomLevel, minZoom, maxZoom)

    self.shakeTranslation = math.lerp(self.shakeTranslation, shakeTranslationTarget, shakeDampSpeed * dt)
    self.shakeRotation = math.lerp(self.shakeRotation, shakeRotationTarget, shakeDampSpeed * dt)
    self.shakeScale = math.lerp(self.shakeScale, shakeScaleTarget, shakeDampSpeed * dt)
    self.shakeShear = math.lerp(self.shakeShear, shakeShearTarget, shakeDampSpeed * dt)
end

function Camera:setShakeTranslation(value)
    self.shakeTranslation = value or 0
end

function Camera:setShakeRotation(value)
    self.shakeRotation = value or 0
end

function Camera:setShakeScale(value)
    self.shakeScale = 1 + value or 1
end


function Camera:setShakeShear(value)
    self.shakeShear = value or 0
end

function Camera:screenToWorld(x, y)
    z = self.zoomLevel
    x = (x / z) + self.x - (SCREEN_WIDTH / z / 2) 
    y = (y / z) + self.y - (SCREEN_HEIGHT / z / 2)
    return x, y
end