Player = Class{}

local baseSpeed = 100
local runSpeedMultiplier = 1.5
local crouchSpeedMultiplier = 0.5
local playerImage = love.graphics.newImage("assets/img/kenneyTest/player.png")

function Player:init(x, y, map)
    self.x = x or 0
    self.y = y or 0
    self.map = map
    self.rot = 0
    self.speed = 1
    self.dx, self.dy = 0, 0
    self.colour = { 1, 1, 1, 1 }
    self.bullets = {}
end

function Player:fire()
    if love.mouse.wasPressed(1) then
        SFX['shot']:stop()
        SFX['shot']:play()
        local b = Bullet({
            x = self.x,
            y = self.y,
            rot = self.rot
        })
        table.insert(self.bullets, b)
    end
end

function Player:move(dt)
    self.dx, self.dy = 0, 0
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self.dy = self.dy - 1
    end
    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self.dy = self.dy + 1
    end
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.dx = self.dx - 1
    end
    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.dx = self.dx + 1
    end

    if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
        self.speed = baseSpeed * runSpeedMultiplier
    elseif love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl') then
        self.speed = baseSpeed * crouchSpeedMultiplier
    else 
        self.speed = baseSpeed
    end

    self.dx, self.dy = normalise(self.dx, self.dy)
    self.dx, self.dy = self.dx * self.speed * dt, self.dy * self.speed * dt
    self:detectCollisions()

    self.x = self.x + self.dx
    self.y = self.y + self.dy

    self.rot = math.atan2(MOUSE_Y - self.y, MOUSE_X - self.x)
end

function Player:detectCollisions()
    local gridX, gridY = getGridPos(self.x, self.y)
    local nextGridX, nextGridY = getGridPos(self.x + self.dx, self.y + self.dy)

    if self.map:collidable(nextGridX, gridY) then self.dx = 0 end
    if self.map:collidable(gridX, nextGridY) then self.dy = 0 end
end

function Player:update(dt)
    self:fire()
    for i, v in ipairs(self.bullets) do
        local gridX, gridY = getGridPos(v.x + v.dx + v.rad * math.cos(v.rot), v.y + v.dy + v.rad * math.sin(v.rot))

        v:update(dt)
        
        if self.map:collidable(gridX, gridY) then
            SFX['bulletImpact']:stop()
            SFX['bulletImpact']:play()
            table.remove(self.bullets, i)
        end
    end

    self:move(dt)
end

function Player:draw()
    for k, v in pairs(self.bullets) do
        v:draw()
    end
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    love.graphics.line(self.x, self.y, MOUSE_X, MOUSE_Y)
    love.graphics.setColor(unpack(self.colour))
    -- TODO: Extract the image size constants below
    love.graphics.draw(playerImage, self.x, self.y, self.rot, 0.5, 0.5, 32, 32)
    love.graphics.setColor(1, 1, 1, 1)
end