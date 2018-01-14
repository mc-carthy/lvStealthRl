local Vector2 = require("src.utils.Vector2")
local Math = require("src.utils.Math")
local Bullet = require("src.entities.Bullet")

local player = {}

local playerDebugFlag = true

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
        self.speedMultiplier = Math.lerp(self.speedMultiplier, self.crouchSpeedMultiplier, self.moveSpeedDampening)
    elseif love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        self.speedMultiplier = Math.lerp(self.speedMultiplier, self.runSpeedMultiplier, self.moveSpeedDampening)
    else
        self.speedMultiplier = Math.lerp(self.speedMultiplier, 1, self.moveSpeedDampening)
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

local checkCollisionWithGrid = function(self)
    local currentX, currentY = self:getPosition()
    local dPos = { x = self.moveX, y = self.moveY }
    local grid = self.entityManager:getGrid()
    self.gridX, self.gridY = grid.worldSpaceToGrid(grid, currentX, currentY)
    local nextGridSpaceX, nextGridSpaceY = grid.worldSpaceToGrid(grid, currentX + dPos.x, currentY + dPos.y)
    if not grid:isWalkable(self.gridX, self.gridY) then
        self.isColliding = true
    else
        self.isColliding = false
    end
end

local getPosition = function(self)
    return self.x, self.y
end

local update = function(self, dt)
    self:getInput()

    self:checkCollisionWithGrid()

    self.x = self.x + self.moveX * dt
    self.y = self.y + self.moveY * dt
end

local draw = function(self)
    love.graphics.setColor(0, 0, 0)
    if self.isColliding then
        love.graphics.setColor(0, 191, 191)
    end
    love.graphics.circle("fill", self.x, self.y, self.r)
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("line", self.x, self.y, self.r)


    if playerDebugFlag then
        love.graphics.setColor(63, 63, 63)
        love.graphics.line(self.x, self.y, self.mouseX, self.mouseY)
        love.graphics.print("Current grid pos: " .. self.gridX .. "-" .. self.gridY, 10, 10)
        love.graphics.print("Player rotation: " .. math.floor(self.rot), 10, 30)
        love.graphics.print("Speed multiplier: " .. self.speedMultiplier, 10, 50)
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
    inst.moveSpeedDampening = 0.2
    inst.moveX = 0
    inst.moveY = 0
    inst.isColliding = false

    inst.checkCollisionWithGrid = checkCollisionWithGrid
    inst.getInput = getInput
    inst.getPosition = getPosition
    inst.getSpeedMultiplier = getSpeedMultiplier

    inst.update = update
    inst.draw = draw

    return inst
end

return player
