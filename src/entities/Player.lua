local Vector2 = require("src.utils.Vector2")

local player = {}

local getInput = function(self)
    local inputX = 0
    local inputY = 0
    if love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
        inputX = 1
    end
    if love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
        inputX = -1
    end
    if love.keyboard.isDown("down") and not love.keyboard.isDown("up") then
        inputY = 1
    end
    if love.keyboard.isDown("up") and not love.keyboard.isDown("down") then
        inputY = -1
    end

    if inputX ~= 0 and inputY ~= 0 then
        inputX = inputX / 1.41
        inputY = inputY / 1.41
    end

    self.moveX = inputX * self.speed
    self.moveY = inputY * self.speed
end

local update = function(self, dt)
    self:getInput()

    self.x = self.x + self.moveX * dt
    self.y = self.y + self.moveY * dt
end

local draw = function(self)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", self.x, self.y, self.r)
end

player.create = function(x, y)
    local inst = {}

    inst.x = x
    inst.y = y
    inst.r = 10
    inst.speed = 150
    inst.moveX = 0
    inst.moveY = 0

    inst.getInput = getInput
    inst.update = update
    inst.draw = draw

    return inst
end

return player
