local EntityManager = require("src.entities.EntityManager")
local CelAut = require("src.map.CelAutCaveGen")

local grid = {}

local gridDebugFlag = true

local grid_rng = love.math.newRandomGenerator(os.time())

local playerX, playerY = 0, 0

local _generateGrid = function(self)
    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            self[x][y] = {}
            self[x][y].walkable = true
        end
    end
end

local _populateGrid = function(self)
    local celAutGrid = CelAut.create(self.xSize, self.ySize).grid
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            -- local prob = grid_rng:random(100)
            -- if prob >= 85 then
            --     self[x][y].walkable = false
            -- end
            if celAutGrid[x][y] then
                print(x .. "-" .. y)
                self[x][y].walkable = false
            end
        end
    end
end

local worldSpaceToGrid = function(self, x, y)
    gridx = math.floor(x / self.cellSize) + 1
    gridy = math.floor(y / self.cellSize) + 1
    return gridx, gridy
end

local isWalkable = function(self, gridX, gridY)
    if self[gridX] and self[gridX][gridY] then
        return self[gridX][gridY].walkable
    else
        return true
    end
end

local update = function(self, dt)
    local player = self.entityManager:getPlayer()
    playerX, playerY = worldSpaceToGrid(self, player:getPosition())
end

local draw = function(self)
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if x == playerX and y == playerY then
                love.graphics.setColor(0, 127, 0, 255)
            else
                love.graphics.setColor(127, 127, 127)
            end
            if not self[x][y].walkable then
                love.graphics.setColor(0, 0, 0)
            end
            if gridDebugFlag then
                love.graphics.rectangle('fill', (x - 1) * self.cellSize, (y - 1) * self.cellSize, self.cellDrawSize, self.cellDrawSize)
            end
        end
    end
end

grid.create = function(entityManager)
    local inst = {}

    inst.tag = "grid"
    inst.entityManager = entityManager
    inst.cellSize = 10
    local border = 2
    inst.cellDrawSize = inst.cellSize - border
    inst.xSize = love.graphics.getWidth() / inst.cellSize
    inst.ySize = love.graphics.getHeight() / inst.cellSize
    _generateGrid(inst)
    _populateGrid(inst)

    inst.worldSpaceToGrid = worldSpaceToGrid
    inst.isWalkable = isWalkable
    inst.update = update
    inst.draw = draw

    return inst
end

return grid
