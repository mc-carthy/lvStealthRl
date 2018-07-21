Camera = Class{}

local zoomSpeed = 0.99
local maxZoom = 2
local minZoom = 0.5

function Camera:init(params)
    self.target = params.target
    self.x = self.target.x
    self.y = self.target.y
    self.zoomLevel = 1
end

function Camera:set()
    love.graphics.push()
    love.graphics.translate(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
    love.graphics.scale(self.zoomLevel, self.zoomLevel)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:update(dt)
    self.x = self.target.x
    self.y = self.target.y
    if love.keyboard.isDown('z') then
        self.zoomLevel = self.zoomLevel / zoomSpeed
    end
    if love.keyboard.isDown('x') then
        self.zoomLevel = self.zoomLevel * zoomSpeed
    end
    self.zoomLevel = math.clamp(self.zoomLevel, minZoom, maxZoom)
end

function Camera:screenToWorld(x, y)
    z = self.zoomLevel
    x = (x / z) + self.x - (SCREEN_WIDTH / z / 2) 
    y = (y / z) + self.y - (SCREEN_HEIGHT / z / 2)
    return x, y
end