local EntityManager = require("src.entities.EntityManager")
local CelAut = require("src.map.CelAutCaveGen")
local BspBuilding = require("src.map.bspBuilding")

local grid = {}

local gridDebugFlag = true

local grid_rng = love.math.newRandomGenerator(os.time())

local playerX, playerY = 0, 0
local viewDistX = 33
local viewDistY = 19
local celAutGridScale = 4

local _generateGrid = function(self)
    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            self[x][y] = {}
            -- TODO: Consider only checking for walkable is false to reduce number of checks
            -- self[x][y].walkable = true
        end
    end
end

local _populateGrid = function(self)
    local celAutGrid = CelAut.create(self.xSize / celAutGridScale, self.ySize / celAutGridScale, 460).grid
    for x = 1, self.xSize / celAutGridScale do
        for y = 1, self.ySize / celAutGridScale do
            -- local prob = grid_rng:random(100)
            -- if prob >= 85 then
            --     self[x][y].walkable = false
            -- end
            if celAutGrid[x][y] then
                if celAutGridScale == 1 then
                    self[celAutGridScale * x][celAutGridScale * y].walkable = false
                elseif celAutGridScale == 2 then
                    self[celAutGridScale * x    ][celAutGridScale * y    ].walkable = false
                    self[celAutGridScale * x - 1][celAutGridScale * y    ].walkable = false
                    self[celAutGridScale * x    ][celAutGridScale * y - 1].walkable = false
                    self[celAutGridScale * x - 1][celAutGridScale * y - 1].walkable = false
                elseif celAutGridScale == 4 then
                    self[celAutGridScale * x    ][celAutGridScale * y    ].walkable = false
                    self[celAutGridScale * x - 1][celAutGridScale * y    ].walkable = false
                    self[celAutGridScale * x - 2][celAutGridScale * y    ].walkable = false
                    self[celAutGridScale * x - 3][celAutGridScale * y    ].walkable = false
                    self[celAutGridScale * x    ][celAutGridScale * y - 1].walkable = false
                    self[celAutGridScale * x - 1][celAutGridScale * y - 1].walkable = false
                    self[celAutGridScale * x - 2][celAutGridScale * y - 1].walkable = false
                    self[celAutGridScale * x - 3][celAutGridScale * y - 1].walkable = false
                    self[celAutGridScale * x    ][celAutGridScale * y - 2].walkable = false
                    self[celAutGridScale * x - 1][celAutGridScale * y - 2].walkable = false
                    self[celAutGridScale * x - 2][celAutGridScale * y - 2].walkable = false
                    self[celAutGridScale * x - 3][celAutGridScale * y - 2].walkable = false
                    self[celAutGridScale * x    ][celAutGridScale * y - 3].walkable = false
                    self[celAutGridScale * x - 1][celAutGridScale * y - 3].walkable = false
                    self[celAutGridScale * x - 2][celAutGridScale * y - 3].walkable = false
                    self[celAutGridScale * x - 3][celAutGridScale * y - 3].walkable = false
                end
            end
        end
    end
end

local function _addBuilding(self, buildingX, buildingY, buildingW, buildingH)
    local buildingX, buildingY = buildingX,buildingY
    local bspBuilding = BspBuilding.create(buildingW, buildingH)

    for x = 1, bspBuilding.w do
        for y = 1, bspBuilding.h do
            if bspBuilding.grid[x][y].outerWall then
                self[x + buildingX][y + buildingY].walkable = false
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
    local l, t, w, h = gamera:getVisible()
    local slack = 40

    for x = 1, self.xSize do
        for y = 1, self.ySize do
            -- if x == playerX and y == playerY then
            --     love.graphics.setColor(0, 127, 0, 255)
            -- else
            --     love.graphics.setColor(127, 127, 127)
            -- end
            if gridDebugFlag then
                -- if x < viewDistX + playerX and x > playerX - viewDistX and y < viewDistY + playerY and y > playerY - viewDistY then
                    local tl = (x - 1) * self.cellSize
                    local tt = (y - 1) * self.cellSize
                    local tr = tl + self.cellSize
                    local tb = tt + self.cellSize
                if tl > l - slack and tt > t - slack and tr < l + w + slack and tb < t + h + slack then
                    love.graphics.setColor(127, 127, 127)
                    if self[x][y].walkable == false then
                        love.graphics.setColor(31, 31, 31)
                    end
                    love.graphics.rectangle('fill', (x - 1) * self.cellSize, (y - 1) * self.cellSize, self.cellDrawSize, self.cellDrawSize)
                end
            end
        end
    end
end

grid.create = function(entityManager)
    local inst = {}

    inst.tag = "grid"
    inst.entityManager = entityManager
    inst.cellSize = 20
    inst.worldScaleInScreens = 10
    local border = 0
    inst.cellDrawSize = inst.cellSize - border
    inst.xSize = love.graphics.getWidth() / inst.cellSize * inst.worldScaleInScreens
    inst.ySize = love.graphics.getHeight() / inst.cellSize * inst.worldScaleInScreens

    -- inst.xSize = 420
    -- inst.ySize = 420
    gamera:setWorld(0, 0, inst.xSize * inst.cellSize, inst.ySize * inst.cellSize)
    _generateGrid(inst)
    _populateGrid(inst)
    _addBuilding(inst, 150, 150, 50, 50)

    inst.worldSpaceToGrid = worldSpaceToGrid
    inst.isWalkable = isWalkable
    inst.update = update
    inst.draw = draw

    return inst
end

return grid
