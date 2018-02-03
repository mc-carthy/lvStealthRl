local EntityManager = require("src.entities.EntityManager")
local CelAut = require("src.map.CelAutCaveGen")
local BspBuilding = require("src.map.bspBuilding")
local tile = require("src.map.tileDictionary")

local grid = {}

local gridDebugFlag = true

local grid_rng = love.math.newRandomGenerator(os.time())

local playerX, playerY = 0, 0
local viewDistX = 33
local viewDistY = 19
local celAutGridScale = 4
local wallChancePercentage = 475

local function _generateGrid(self)
    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            self[x][y] = tile["ground"]
        end
    end
end

local function _populateGrid(self)
    local celAutGrid = CelAut.create(self.xSize / celAutGridScale, self.ySize / celAutGridScale, wallChancePercentage).grid
    for x = 1, self.xSize / celAutGridScale do
        for y = 1, self.ySize / celAutGridScale do
            -- local prob = grid_rng:random(100)
            -- if prob >= 85 then
            --     self[x][y].walkable = false
            -- end
            if celAutGrid[x][y] then
                if celAutGridScale == 1 then
                    self[celAutGridScale * x][celAutGridScale * y] = tile["caveWall"]
                elseif celAutGridScale == 2 then
                    self[celAutGridScale * x    ][celAutGridScale * y    ] = tile["caveWall"]
                    self[celAutGridScale * x - 1][celAutGridScale * y    ] = tile["caveWall"]
                    self[celAutGridScale * x    ][celAutGridScale * y - 1] = tile["caveWall"]
                    self[celAutGridScale * x - 1][celAutGridScale * y - 1] = tile["caveWall"]
                elseif celAutGridScale == 4 then
                    self[celAutGridScale * x    ][celAutGridScale * y    ] = tile["caveWall"]
                    self[celAutGridScale * x - 1][celAutGridScale * y    ] = tile["caveWall"]
                    self[celAutGridScale * x - 2][celAutGridScale * y    ] = tile["caveWall"]
                    self[celAutGridScale * x - 3][celAutGridScale * y    ] = tile["caveWall"]
                    self[celAutGridScale * x    ][celAutGridScale * y - 1] = tile["caveWall"]
                    self[celAutGridScale * x - 1][celAutGridScale * y - 1] = tile["caveWall"]
                    self[celAutGridScale * x - 2][celAutGridScale * y - 1] = tile["caveWall"]
                    self[celAutGridScale * x - 3][celAutGridScale * y - 1] = tile["caveWall"]
                    self[celAutGridScale * x    ][celAutGridScale * y - 2] = tile["caveWall"]
                    self[celAutGridScale * x - 1][celAutGridScale * y - 2] = tile["caveWall"]
                    self[celAutGridScale * x - 2][celAutGridScale * y - 2] = tile["caveWall"]
                    self[celAutGridScale * x - 3][celAutGridScale * y - 2] = tile["caveWall"]
                    self[celAutGridScale * x    ][celAutGridScale * y - 3] = tile["caveWall"]
                    self[celAutGridScale * x - 1][celAutGridScale * y - 3] = tile["caveWall"]
                    self[celAutGridScale * x - 2][celAutGridScale * y - 3] = tile["caveWall"]
                    self[celAutGridScale * x - 3][celAutGridScale * y - 3] = tile["caveWall"]
                end
            end
        end
    end
end

local function _initialiseContourMap(self)
    local grid = {}
    for x = 1, self.xSize do
        grid[x] = {}
        for y = 1, self.ySize do
            if self[x][y].walkable == false then
                grid[x][y] = 0
            else
                grid[x][y] = -1
            end
        end
    end
    return grid
end

local function _countourMapComplete(self)
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if self.contourMap[x][y] == -1 then
                return false
            end
        end
    end
    return true
end

local function _isInGridRange(self, x, y)
    return x > 0 and x < self.xSize and y > 0 and y < self.ySize
end

local function _isPeakContour(self, x, y)
    for i = -1, 1 do
        for j = -1, 1 do
            if self.contourMap[x + i] and self.contourMap[x + i][y + j] then
                if _isInGridRange(self, x + i, y + j) then
                    if not (i == 0 and j == 0) then
                        if self.contourMap[x][y] <= self.contourMap[x + i][y + j] and self.contourMap[x][y] > 0 then
                            return false
                        end
                    end
                end
            end
        end
    end
    return true
end

local function _calculateContourMap(self)
    local currentContourValue = 0
    while not _countourMapComplete(self) do
        local contourMapLocal = {}
        for x = 1, self.xSize do
            contourMapLocal[x] = {}
            for y = 1, self.ySize do
                contourMapLocal[x][y] = self.contourMap[x][y]
            end
        end

        for x = 1, self.xSize do
            for y = 1, self.ySize do
                for neighbourX = x - 1, x + 1 do
                    for neighbourY = y - 1, y + 1 do
                        if neighbourX == x or neighbourY == y then
                            if _isInGridRange(self, neighbourX, neighbourY) and self.contourMap[x][y] == -1 then
                                if self.contourMap[neighbourX][neighbourY] == currentContourValue then
                                    contourMapLocal[x][y] = currentContourValue + 1
                                end
                            end
                        end
                    end
                end
            end
        end

        for x = 1, self.xSize do
            for y = 1, self.ySize do
                self.contourMap[x][y] = contourMapLocal[x][y]
            end
        end
        currentContourValue = currentContourValue + 1
    end
end

local function _findLowestContourPeak(self, exludeEqualNeighbours)
    exludeEqualNeighbours = exludeEqualNeighbours or true
    local minPeak, minPeakX, minPeakY = 1000, 0, 0
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if _isPeakContour(self, x, y) then
                if exludeEqualNeighbours then
                    if self.contourMap[x][y] < minPeak and self.contourMap[x][y] > 0 then
                        minPeak = self.contourMap[x][y]
                        minPeakX = x
                        minPeakY = y
                    end
                else
                    if self.contourMap[x][y] <= minPeak and self.contourMap[x][y] > 0 then
                        minPeak = self.contourMap[x][y]
                        minPeakX = x
                        minPeakY = y
                    end
                end
            end
        end
    end
    print(minPeakX .. "-" .. minPeakY .. " : " .. minPeak)
    if minPeakX == 1 and minPeakY == 1 then
       minPeakX, minPeakY = _findLowestContourPeak(self, false)
    end
    -- return minPeakX, minPeakY
    return minPeakX * self.cellSize - self.cellSize / 2, minPeakY * self.cellSize - self.cellSize / 2
end

local function _findHighestContourValue(self)
    local maxVal, maxX, maxY = 0, 0, 0
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if self.contourMap[x][y] > maxVal then
                maxVal = self.contourMap[x][y]
                maxX = x
                maxY = y
            end
        end
    end
    print(maxX .. "-" .. maxY .. " : " .. maxVal)
    return maxVal, maxX, maxY
end

local function _addBuilding(self, buildingX, buildingY, buildingW, buildingH)
    local buildingX, buildingY = buildingX,buildingY
    local bspBuilding = BspBuilding.create(buildingW, buildingH)

    for x = 1, bspBuilding.w do
        for y = 1, bspBuilding.h do
            if bspBuilding.grid[x][y].outerWall then
                self[x + buildingX][y + buildingY] = tile["buildingOuterWall"]
            end
        end
    end
end

-- TODO: This function currently sets the value of tiles inside a building to 
-- zero, and those surrounding a building to -1, so they will be rechecked
-- Consider breaking into multiple functions
local function _zeroContourMapAroundPoint(self, x, y, w, h)
    for i = -w, w do
        for j = -h, h do
            if math.abs(i) < (w / 2) + 1 and math.abs(j) < (h / 2) + 1 or self.contourMap[x + i][y + j] == 0 then
                self.contourMap[x + i][y + j] = 0
            else
                self.contourMap[x + i][y + j] = -1
            end
        end
    end
end

local function _addBuildings(self, numberOfBuildings)
    for i = 1, numberOfBuildings do
        local buildingSize, buildingX, buildingY = _findHighestContourValue(self)
        local buildingRad = math.floor(buildingSize / 2)
        _addBuilding(self, buildingX - buildingRad, buildingY - buildingRad, buildingSize, buildingSize)
        _zeroContourMapAroundPoint(self, buildingX, buildingY, buildingSize, buildingSize)
        _calculateContourMap(self)
    end
end

local function worldSpaceToGrid(self, x, y)
    gridx = math.floor(x / self.cellSize) + 1
    gridy = math.floor(y / self.cellSize) + 1
    return gridx, gridy
end

local function isWalkable(self, gridX, gridY)
    if self[gridX] and self[gridX][gridY] then
        return self[gridX][gridY].walkable
    else
        return true
    end
end

local function update(self, dt)
    local player = self.entityManager:getPlayer()
    playerX, playerY = worldSpaceToGrid(self, player:getPosition())
end

local function draw(self)
    local l, t, w, h = gamera:getVisible()
    local slack = 40

    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if gridDebugFlag then
                -- if x < viewDistX + playerX and x > playerX - viewDistX and y < viewDistY + playerY and y > playerY - viewDistY then
                    local tl = (x - 1) * self.cellSize
                    local tt = (y - 1) * self.cellSize
                    local tr = tl + self.cellSize
                    local tb = tt + self.cellSize
                if tl > l - slack and tt > t - slack and tr < l + w + slack and tb < t + h + slack then
                    love.graphics.setColor(127, 127, 127)
                    if self[x][y].colour then
                        love.graphics.setColor(self[x][y].colour)
                    else
                        love.graphics.setColor(191, 0, 0)
                    end
                    love.graphics.rectangle('fill', (x - 1) * self.cellSize, (y - 1) * self.cellSize, self.cellDrawSize, self.cellDrawSize)
                    -- love.graphics.setColor(0, 255, 255, 255)
                    -- love.graphics.print(self.contourMap[x][y], (x - 1) * self.cellSize, (y - 1) * self.cellSize)
                end
            end
        end
    end
end

function grid.create(entityManager)
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
    
    -- _addBuilding(inst, 50, 50, 50, 50)
    inst.contourMap = _initialiseContourMap(inst)
    _calculateContourMap(inst)
    inst.lowestPeakX, inst.lowestPeakY = _findLowestContourPeak(inst)
    _addBuildings(inst, 5)

    inst.worldSpaceToGrid = worldSpaceToGrid
    inst.isWalkable = isWalkable
    inst.update = update
    inst.draw = draw

    return inst
end

return grid
