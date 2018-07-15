Player = Class{}

local baseSpeed = 50
local runSpeedMultiplier = 1.5
local crouchSpeedMultiplier = 0.5
local playerImage = love.graphics.newImage("assets/img/kenneyTest/player.png")

function Player:init(x, y, map)
    self.x = x or 0
    self.y = y or 0
    self.map = map
    self.rot = 0
    self.speed = 1
    self.colour = { 1, 1, 1, 1 }
end

function Player:move(dt)
    local dx, dy = 0, 0
    local mouseX, mouseY = love.mouse.getPosition()
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        dy = dy - 1
    end
    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        dy = dy + 1
    end
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        dx = dx - 1
    end
    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        dx = dx + 1
    end

    if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
        self.speed = baseSpeed * runSpeedMultiplier
    elseif love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl') then
        self.speed = baseSpeed * crouchSpeedMultiplier
    else 
        self.speed = baseSpeed
    end

    dx, dy = normalise(dx, dy)

    self.x = self.x + (dx * self.speed * dt)
    self.y = self.y + (dy * self.speed * dt)

    self:detectCollisions()

    self.rot = math.atan2(mouseY - self.y, mouseX - self.x)
end

function Player:getGridPos()
    local gridX = math.floor(self.x / CELL_SIZE)
    local gridY = math.floor(self.y / CELL_SIZE)
    return gridX, gridY
end

function Player:detectCollisions()
    local gridX, gridY = self:getGridPos()
    -- if table.equal(self.map[gridX][gridY], { 0, 0, 0, 1 }) then
    --     self.colour = { 1, 0, 0, 1 }
    -- elseif table.equal(self.map[gridX][gridY], { 0, 0, 1, 1 }) then
    --     self.colour = { 0, 0, 1, 1 }
    -- else 
    --     self.colour = { 1, 1, 1, 1 }
    -- end
    self.colour = mapData[gridX][gridY].drawColour
end

function Player:update(dt)
    self:move(dt)
end

function Player:draw()
    -- love.graphics.setColor(0, 0, 0, 1)
    -- love.graphics.circle('line', self.x, self.y, 10)
    -- love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.circle('fill', self.x, self.y, 10)
    love.graphics.setColor(unpack(self.colour))
    love.graphics.draw(playerImage, self.x, self.y, self.rot, 0.5, 0.5, 32, 32)
    love.graphics.setColor(1, 1, 1, 1)
end