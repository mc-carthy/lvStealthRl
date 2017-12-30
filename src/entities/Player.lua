local Vector2 = require("src.utils.Vector2")
local Bullet = require("src.entities.Bullet")

local player = {}

local mouseButtonDown = false

local createBullet = function(self)
    local bullet = Bullet.create(self.entityManager, self.x, self.y, self.rot, 100)
    self.entityManager:addEntity(bullet)
end

local getSpeedMultiplier = function(self)
    return self.speedMultiplier
end

local getInput = function(self)
    local inputX = 0
    local inputY = 0
    if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) and
    not (love.keyboard.isDown("a") or love.keyboard.isDown("left")) then
        inputX = 1
    end
    if (love.keyboard.isDown("a") or love.keyboard.isDown("left")) and
    not (love.keyboard.isDown("d") or love.keyboard.isDown("right")) then
        inputX = -1
    end
    if (love.keyboard.isDown("s") or love.keyboard.isDown("down")) and
    not (love.keyboard.isDown("w") or love.keyboard.isDown("up")) then
        inputY = 1
    end
    if (love.keyboard.isDown("w") or love.keyboard.isDown("up")) and
    not (love.keyboard.isDown("s") or love.keyboard.isDown("down")) then
        inputY = -1
    end

    if inputX ~= 0 and inputY ~= 0 then
        inputX = inputX / 1.41
        inputY = inputY / 1.41
    end

    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
        self.speedMultiplier = self.crouchSpeedMultiplier
    elseif love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        self.speedMultiplier = self.runSpeedMultiplier
    else
        self.speedMultiplier = 1
    end

    self.moveX = inputX * self.nominalSpeed * self.speedMultiplier
    self.moveY = inputY * self.nominalSpeed * self.speedMultiplier

    local buttonPressed = love.mouse.isDown(1)

    if buttonPressed and not mouseButtonDown then
        mouseButtonDown = true
        createBullet(self)
    end

    if not buttonPressed then
        mouseButtonDown = false
    end

    self.mouseX, self.mouseY = love.mouse.getPosition()
    self.rot = Vector2.angle(self.x, self.y, self.mouseX, self.mouseY)
end

local getPosition = function(self)
    return self.x, self.y
end

local update = function(self, dt)
    self:getInput()

    self.x = self.x + self.moveX * dt
    self.y = self.y + self.moveY * dt
end

local draw = function(self)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", self.x, self.y, self.r)


    if DEBUG then
        love.graphics.line(self.x, self.y, self.mouseX, self.mouseY)
        love.graphics.print(math.floor(self.rot), 10, 10)
        love.graphics.print("Speed multiplier: " .. self.speedMultiplier, 50, 10)
    end
end

player.create = function(entityManager, x, y)
    local inst = {}

    inst.tag = "player"
    inst.x = x
    inst.y = y
    inst.entityManager = entityManager
    inst.mouseX = 0
    inst.mouseY = 0
    inst.rot = 0
    inst.r = 10
    inst.nominalSpeed = 150
    inst.speedMultiplier = 1
    inst.crouchSpeedMultiplier = 0.5
    inst.runSpeedMultiplier = 1.5
    inst.moveX = 0
    inst.moveY = 0

    inst.getInput = getInput
    inst.getPosition = getPosition
    inst.getSpeedMultiplier = getSpeedMultiplier

    inst.update = update
    inst.draw = draw

    return inst
end

return player
