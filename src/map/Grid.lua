local EntityManager = require("src.entities.EntityManager")
local CelAut = require("src.map.CelAutCaveGen")
local BspBuilding = require("src.map.bspBuilding")
local tile = require("src.map.tileDictionary")
local los = require("src.utils.los")
local bresenham = require("src.utils.bresenham")
local jmp = require("src.pathfinding.jmp")

local grid = {}

local gridDebugFlag = false

local grid_rng = love.math.newRandomGenerator(os.time())

local playerX, playerY = 0, 0
local prevMouseX, prevMouseY = nil, nil
local viewDistX = 33
local viewDistY = 19
local celAutGridScale = 4
local wallChancePercentage = 475
local losColour = { 0, 191, 0, 255}

local dirtImage = love.graphics.newImage("assets/img/kenneyTest/dirt.png")
local grassImage = love.graphics.newImage("assets/img/kenneyTest/grass.png")
local sandImage = love.graphics.newImage("assets/img/kenneyTest/sand.png")
local stoneImage = love.graphics.newImage("assets/img/kenneyTest/stone.png")

local function _generateGrid(self)
    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            -- self[x][y] = {}
            -- TODO: This comes with a performance deficit of around 30% drop in fps
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

local function _isPeakContour(self, x, y, exludeEqualNeighbours)
    -- local exludeEqualNeighbours = exludeEqualNeighbours or true
    for i = -1, 1 do
        for j = -1, 1 do
            if self.contourMap[x + i] and self.contourMap[x + i][y + j] then
                if _isInGridRange(self, x + i, y + j) then
                    if not (i == 0 and j == 0) then
                        if exludeEqualNeighbours then
                            if self.contourMap[x][y] <= self.contourMap[x + i][y + j] and self.contourMap[x][y] > 0 then
                                return false
                            end
                        else
                            if self.contourMap[x][y] < self.contourMap[x + i][y + j] and self.contourMap[x][y] > 0 then
                                return false
                            end
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

local function _findLowestContourPeakGrid(self, exludeEqualNeighbours)
    local minPeak, minPeakX, minPeakY = 1000, 0, 0
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if _isPeakContour(self, x, y, exludeEqualNeighbours) then
                if self.contourMap[x][y] <= minPeak and self.contourMap[x][y] > 0 then
                    minPeak = self.contourMap[x][y]
                    minPeakX = x
                    minPeakY = y
                end
            end
        end
    end
    -- print(minPeakX .. "-" .. minPeakY .. " : " .. minPeak)
    if minPeakX == 0 and minPeakY == 0 then
        -- print("Include equal neighbours")
        minPeakX, minPeakY = _findLowestContourPeakGrid(self, false)
    end
    return minPeakX, minPeakY
end

local function _findLowestContourPeakWorld(self, exludeEqualNeighbours)
    local minPeakX, minPeakY = _findLowestContourPeakGrid(self, exludeEqualNeighbours)
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
    -- print(maxX .. "-" .. maxY .. " : " .. maxVal)
    return maxVal, maxX, maxY
end

local function _addBuilding(self, buildingX, buildingY, buildingW, buildingH, entranceLevel)
    local bspBuilding = BspBuilding.create(buildingX, buildingY, buildingW, buildingH, 0, entranceLevel)

    for x = 1, bspBuilding.w do
        for y = 1, bspBuilding.h do
            if bspBuilding.grid[x][y] then
                self[x + buildingX][y + buildingY] = bspBuilding.grid[x][y]
            end
        end
    end
    return bspBuilding
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
        local building = _addBuilding(self, buildingX - buildingRad, buildingY - buildingRad, buildingSize, buildingSize, i)
        table.insert(self.buildings, building)
        _zeroContourMapAroundPoint(self, buildingX, buildingY, buildingSize, buildingSize)
        _calculateContourMap(self)
    end
end

local function returnRandomGridPosOfTileType(self, tileType)
    tileType = tileType or "ground"
    assert(tile[tileType] ~= nil, "Please enter a valid tileType from tileDictionary")

    local tileFound = false
    while not tileFound do

        local randX = love.math.random(self.xSize)
        local randY = love.math.random(self.ySize)
        if self[randX][randY] == tile[tileType] then
            tileFound = true
            return randX, randY
        end
    end
end

local function returnRandomWorldPosOfTileType(self, tileType)
    worldX, worldY = returnRandomGridPosOfTileType(self, tileType)
    return worldX * self.cellSize - self.cellSize / 2, worldY * self.cellSize - self.cellSize / 2
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

local function setPoints(self, points, success)
    self.points = points
    if success then
        losColour = { 0, 191, 0, 255 }
    else
        losColour = { 191, 0, 0, 255 }
    end
end

local function getPath(self, startX, startY, mouseX, mouseY)
    if self.path:calculateMap(startX, startY, mouseX, mouseY) then
        -- self:setPoints(self.path.points, true)
        return self.path.points
    else
        return nil
    end
end

local function lineOfSight(self, startX, startY, endX, endY)
    startX, startY = self:worldSpaceToGrid(startX, startY)
    endX, endY = self:worldSpaceToGrid(endX, endY)
    local success = bresenham.los(startX, startY, endX, endY, function(x, y)
        return self:isWalkable(x, y)
    end)
    return success
end

local function lineOfSightPoints(self, startX, startY, endX, endY)
    startX, startY = self:worldSpaceToGrid(startX, startY)
    endX, endY = self:worldSpaceToGrid(endX, endY)
    local points, success = bresenham.line(startX, startY, endX, endY, function(x, y)
        return self:isWalkable(x, y)
    end)
    return points, success
end

local function update(self, dt)
    local player = self.entityManager:getPlayer()
    playerX, playerY = worldSpaceToGrid(self, player:getPosition())

    -- local mouseX, mouseY = self:worldSpaceToGrid(gamera:toWorld(love.mouse.getPosition()))
    -- if self:isWalkable(mouseX, mouseY) then
    --     if mouseX ~= prevMouseX or mouseY ~= prevMouseY then
    --         prevMouseX = mouseX
    --         prevMouseY = mouseY
    --         self.path.points = self:getPath(playerX, playerY, mouseX, mouseY)
    --         self:setPoints(self.path.points, true)
    --     end
    -- end
end

local _drawRoomCentres = function(self)
    love.graphics.setColor(191, 0, 0, 255)
    for i, building in ipairs(self.buildings) do
        for j, room in ipairs(building.rooms) do
            love.graphics.circle("fill", (building.x + room.x + room.w / 2) * self.cellSize, (building.y + room.y + room.h / 2) * self.cellSize, 5)
        end
    end
end

local _drawRoomFloors = function(self)
    for i, building in ipairs(self.buildings) do
        for j, room in ipairs(building.rooms) do
            for k, floorTile in ipairs(room.floor) do
                love.graphics.setColor(unpack(room.debugColour))
                love.graphics.rectangle("fill", (building.x + floorTile.x - 1) * self.cellSize, (building.y + floorTile.y - 1) * self.cellSize, self.cellDrawSize, self.cellDrawSize)
            end
        end
    end
end

local _loadCanvas = function(self)
    self.canvas = love.graphics.newCanvas(self.cellSize * self.xSize, self.cellSize * self.ySize)

    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            love.graphics.setColor(255, 255, 255, 255)
            -- love.graphics.setColor(127, 127, 127)
            -- if self[x][y].colour then
            --     love.graphics.setColor(self[x][y].colour)
            -- else
            --     love.graphics.setColor(tile["ground"].colour)
            -- end
            -- love.graphics.rectangle('fill', (x - 1) * self.cellSize, (y - 1) * self.cellSize, self.cellDrawSize, self.cellDrawSize)
            
            if self[x][y] == tile["ground"] then
                love.graphics.draw(sandImage, (x - 1) * self.cellSize, (y - 1) * self.cellSize, 0, 0.3125, 0.3125)
            elseif self[x][y] == tile["caveWall"] then
                love.graphics.draw(dirtImage, (x - 1) * self.cellSize, (y - 1) * self.cellSize, 0, 0.3125, 0.3125)
            elseif self[x][y] == tile["buildingOuterWall"] then
                love.graphics.draw(stoneImage, (x - 1) * self.cellSize, (y - 1) * self.cellSize, 0, 0.3125, 0.3125)
            elseif self[x][y] == tile["buildingInterior"] then
                love.graphics.setColor(63, 63, 63, 255)
                love.graphics.rectangle('fill', (x - 1) * self.cellSize, (y - 1) * self.cellSize, self.cellDrawSize, self.cellDrawSize)
                -- love.graphics.draw(stoneImage, (x - 1) * self.cellSize, (y - 1) * self.cellSize, 0, 0.3125, 0.3125)
            else
                if self[x][y].colour then
                    love.graphics.setColor(self[x][y].colour)
                else
                    love.graphics.setColor(tile["ground"].colour)
                end
                love.graphics.rectangle('fill', (x - 1) * self.cellSize, (y - 1) * self.cellSize, self.cellDrawSize, self.cellDrawSize)
            end
            -- love.graphics.setColor(0, 255, 255, 255)
            -- love.graphics.print(self.contourMap[x][y], (x - 1) * self.cellSize, (y - 1) * self.cellSize)
        end
    end

    if gridDebugFlag then
        _drawRoomFloors(self)
        _drawRoomCentres(self)
    end

    love.graphics.setCanvas()
end

local function draw(self)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.canvas, 0, 0)
end

function grid.create(entityManager)
    local inst = {}

    inst.tag = "grid"
    inst.entityManager = entityManager
    inst.cellSize = 20
    inst.worldScaleInScreens = 12
    local border = 0
    inst.cellDrawSize = inst.cellSize - border
    inst.xSize = love.graphics.getWidth() / inst.cellSize * inst.worldScaleInScreens
    inst.ySize = love.graphics.getHeight() / inst.cellSize * inst.worldScaleInScreens
    inst.points = {}
    inst.buildings = {}

    -- inst.xSize = 420
    -- inst.ySize = 420
    gamera:setWorld(0, 0, inst.xSize * inst.cellSize, inst.ySize * inst.cellSize)
    _generateGrid(inst)
    _populateGrid(inst)
    
    inst.contourMap = _initialiseContourMap(inst)
    _calculateContourMap(inst)
    inst.lowestPeakX, inst.lowestPeakY = _findLowestContourPeakWorld(inst, true)
    _addBuildings(inst, 10)

    inst.worldSpaceToGrid = worldSpaceToGrid
    inst.isWalkable = isWalkable
    inst.lineOfSight = lineOfSight
    inst.lineOfSightPoints = lineOfSightPoints
    inst.getPath = getPath
    inst.setPoints = setPoints
    inst.returnRandomWorldPosOfTileType = returnRandomWorldPosOfTileType
    inst.returnRandomGridPosOfTileType = returnRandomGridPosOfTileType

    inst.canvas = nil
    _loadCanvas(inst)

    inst.update = update
    inst.draw = draw

    inst.path = jmp.create(inst)

    return inst
end

return grid
