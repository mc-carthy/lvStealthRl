local Camera = require("src.utils.Camera")
local Vector2 = require("src.utils.Vector2")
local Math = require("src.utils.Math")
local Bullet = require("src.entities.Bullet")
local tile = require("src.map.tileDictionary")
local bresenham = require("src.utils.bresenham")

local player = {}

local playerDebugFlag = true

local playerImage = love.graphics.newImage("assets/img/kenneyTest/player.png")
local GRID_SIZE
local mouseButtonDown = false
local collisionBuffer = 0.05
local keycardLevel = 5

local _unlockDoors = function(self)
    for i = 1, keycardLevel do
        if tile["doorLevel" .. i] then
            tile["doorLevel" .. i].walkable = true
        end
    end
end

local load = function(self)
    GRID_SIZE = self.entityManager:getGrid().cellSize
    _unlockDoors(self)
end


local createBullet = function(self)
    local bullet = Bullet.create(self.entityManager, self.x, self.y, self.rot, 300)
    self.entityManager:addEntity(bullet)
end

local getSpeedMultiplier = function(self)
    return self.speedMultiplier * math.sqrt(math.pow(self.moveX, 2) + math.pow(self.moveY, 2)) / self.nominalSpeed
end

local getInput = function(self)
    self.inputX = 0
    self.inputY = 0

    if love.keyboard.isDown("d") and not love.keyboard.isDown("a") then
        self.inputX = 1
    end
    if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
        self.inputX = -1
    end
    if love.keyboard.isDown("s") and not love.keyboard.isDown("w") then
        self.inputY = 1
    end
    if love.keyboard.isDown("w") and not love.keyboard.isDown("s") then
        self.inputY = -1
    end

    if self.inputX ~= 0 and self.inputY ~= 0 then
        self.inputX = self.inputX / 1.41
        self.inputY = self.inputY / 1.41
    end

    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
        self.speedMultiplier = Math.lerp(self.speedMultiplier, self.crouchSpeedMultiplier, self.moveSpeedDampening)
    elseif love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        self.speedMultiplier = Math.lerp(self.speedMultiplier, self.runSpeedMultiplier, self.moveSpeedDampening)
    else
        self.speedMultiplier = Math.lerp(self.speedMultiplier, 1, self.moveSpeedDampening)
    end

    self.moveX = Math.lerp(self.moveX, self.inputX * self.nominalSpeed * self.speedMultiplier, self.moveSpeedDampening)
    self.moveY = Math.lerp(self.moveY, self.inputY * self.nominalSpeed * self.speedMultiplier, self.moveSpeedDampening)

    local buttonPressed = love.mouse.isDown(1)

    if buttonPressed and not mouseButtonDown then
        mouseButtonDown = true
        createBullet(self)
    end

    if not buttonPressed then
        mouseButtonDown = false
    end

    -- self.mouseX, self.mouseY = love.mouse.getPosition()
    -- self.mouseX, self.mouseY = Camera:mousePosition()
    self.mouseX, self.mouseY = gamera:toWorld(love.mouse.getPosition())
    self.rot = Vector2.angle(self.x, self.y, self.mouseX, self.mouseY)
end

local move = function(self, dt)
    if not self:horizontalCollision(dt) then
        self.x = self.x + self.moveX * dt
    end
    if not self:verticalCollision(dt) then
        self.y = self.y + self.moveY * dt
    end
end

local horizontalCollision = function(self, dt)
    -- Horizontal colisions
    for i, col in ipairs(self.cornerOffsets) do
        local nextGridSpaceX, nextGridSpaceY = self.grid.worldSpaceToGrid(self.grid, self.x + self.moveX * dt + col.x, self.y + col.y)
        if self.grid:isWalkable(nextGridSpaceX, nextGridSpaceY) == false then
            -- TODO: This line below only works when framerate is 35 fps+
            self.x = Math.roundToNearest(self.x, GRID_SIZE) - col.x - Math.sign(self.moveX) * collisionBuffer
            return true
        end
    end
    return false
end

local verticalCollision = function(self, dt)
    -- Vertical colisions
    for i, col in ipairs(self.cornerOffsets) do
        local nextGridSpaceX, nextGridSpaceY = self.grid.worldSpaceToGrid(self.grid, self.x + col.x, self.y + self.moveY * dt + col.y)
        if self.grid:isWalkable(nextGridSpaceX, nextGridSpaceY) == false then
            -- TODO: This line below only works when framerate is 35 fps+
            self.y = Math.roundToNearest(self.y, GRID_SIZE) - col.y - Math.sign(self.moveY) * collisionBuffer
            return true
        end
    end
    return false
end

local getPosition = function(self)
    return self.x, self.y
end

local update = function(self, dt)
    self.dt = dt
    self:getInput()

    self.gridX, self.gridY = self.grid.worldSpaceToGrid(self.grid, self.x, self.y)

    self:move(dt)
end

local draw = function(self)
    if playerDebugFlag then
        love.graphics.setColor(63, 63, 63)
        love.graphics.line(self.x, self.y, self.mouseX, self.mouseY)
        -- for _, col in ipairs(self.cornerOffsets) do
        --     love.graphics.setColor(191, 0, 191, 255)
        --     love.graphics.circle("fill", self.x + self.moveX * self.dt + col.x, self.y + self.moveY * self.dt + col.y, 5)
        -- end
        
    end
    -- love.graphics.setColor(0, 255, 0)
    -- love.graphics.circle("fill", self.x, self.y, self.r)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(playerImage, self.x, self.y, -math.rad(self.rot), 0.5, 0.5, 32, 32)
end

local drawScreenSpace = function(self)
    if playerDebugFlag then
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print("Current grid pos: " .. self.gridX .. "-" .. self.gridY, 50, 10)
        love.graphics.print("Player rotation: " .. math.floor(self.rot), 50, 30)
        love.graphics.print("Speed multiplier: " .. string.format("%.2f", getSpeedMultiplier(self)), 50, 50)
    end
end

player.create = function(entityManager, x, y)
    local inst = {}

    inst.tag = "player"
    inst.x = x
    inst.y = y
    inst.inputX = 0
    inst.inputY = 0
    inst.entityManager = entityManager
    inst.grid = inst.entityManager:getGrid()
    inst.mouseX = 0
    inst.mouseY = 0
    inst.rot = 0
    inst.r = 5
    inst.nominalSpeed = 150
    inst.speedMultiplier = 1
    inst.crouchSpeedMultiplier = 0.5
    inst.runSpeedMultiplier = 1.5
    inst.moveSpeedDampening = 0.2
    inst.moveX = 0
    inst.moveY = 0
    inst.cornerOffsets = {
        { x = inst.r,  y = -inst.r },
        { x = -inst.r, y = -inst.r },
        { x = -inst.r, y = inst.r  },
        { x = inst.r,  y = inst.r  }
    }

    inst.move = move
    inst.horizontalCollision = horizontalCollision
    inst.verticalCollision = verticalCollision
    inst.getInput = getInput
    inst.getPosition = getPosition
    inst.getSpeedMultiplier = getSpeedMultiplier

    load(inst)

    inst.update = update
    inst.draw = draw
    inst.drawScreenSpace = drawScreenSpace

    return inst
end

return player
