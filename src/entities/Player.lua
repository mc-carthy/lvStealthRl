local Vector2 = require("src.utils.Vector2")
local Bullet = require("src.entities.Bullet")

local player = {}

local mouseButtonDown = false

local createBullet = function(self)
    local bullet = Bullet.create(self.x, self.y, self.rot, 100)
    self.entityManager:addEntity(bullet)
end

local getInput = function(self)
    local inputX = 0
    local inputY = 0
    if love.keyboard.isDown("d") and not love.keyboard.isDown("left") then
        inputX = 1
    end
    if love.keyboard.isDown("a") and not love.keyboard.isDown("right") then
        inputX = -1
    end
    if love.keyboard.isDown("s") and not love.keyboard.isDown("up") then
        inputY = 1
    end
    if love.keyboard.isDown("w") and not love.keyboard.isDown("down") then
        inputY = -1
    end

    if inputX ~= 0 and inputY ~= 0 then
        inputX = inputX / 1.41
        inputY = inputY / 1.41
    end

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

    self.moveX = inputX * self.speed
    self.moveY = inputY * self.speed
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
        love.graphics.print(self.rot, 10, 10)
    end
end

player.create = function(entityManager, x, y)
    local inst = {}

    inst.x = x
    inst.y = y
    inst.entityManager = entityManager
    inst.mouseX = 0
    inst.mouseY = 0
    inst.rot = 0
    inst.r = 10
    inst.speed = 150
    inst.moveX = 0
    inst.moveY = 0

    inst.getInput = getInput
    inst.getPosition = getPosition

    inst.update = update
    inst.draw = draw

    return inst
end

return player
