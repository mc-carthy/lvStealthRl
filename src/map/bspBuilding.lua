local tile = require("src.map.tileDictionary")

local bspBuilding = {}

local bsp_rng = love.math.newRandomGenerator(os.time())

local function _createOuterWalls(self)
    for x = 1, self.w do
        self.grid[x] = {}
        for y = 1, self.h do
            self.grid[x][y] = {}
            if x == 1 or x == self.w or y == 1 or y == self.h then
                self.grid[x][y] = tile["buildingOuterWall"]
            else
                self.grid[x][y] = tile["ground"]
            end
        end
    end
end

local function _createRoom(self, x, y, w, h)
    for i = x, x + w do
        for j = y, y + h do
            if i == x or i == x + w or j == y or j == y + h then
                self.grid[i][j] = tile["buildingOuterWall"]
            end
        end
    end
    if self.numIterations < 8 then
        self._splitRoom(self, x, y, w, h)
        self.numIterations = self.numIterations + 1
    end
end

--[[
    x and y represent top-left corner coord
--]] 
local function _splitRoom(self, x, y, w, h, minRoomSize)
    local minRoomSize = minRoomSize or 5
    local prob = love.math.random()
    local splitH = nil
    
    if prob > 0.5 then
        splitH = true
    else
        splitH = false
    end

    if h / w > 1.25 then
        splitH = true
    elseif w / h > 1.25 then
        splitH = false
    end

    local max = 0

    if splitH then
        max = h - minRoomSize
    else
        max = w - minRoomSize
    end

    if max < minRoomSize then 
        return
    end

    local split = love.math.random(minRoomSize, max)

    if splitH then
        self:_createRoom(x, y + split, w, h - split)
        self:_createRoom(x, y, w, split)
    else
        self:_createRoom(x + split, y, w - split, h)
        self:_createRoom(x, y, split, h)
    end

    return true

end

local function _addOuterDoor(self, entranceLevel)
    local prob = bsp_rng:random(100)
    if prob < 25 then
        self.grid[1][math.random(2, self.h - 1)] = tile["doorLevel" .. entranceLevel]
    elseif prob < 50 then
        self.grid[self.w][math.random(2, self.h - 1)] = tile["doorLevel" .. entranceLevel]
    elseif prob < 75 then
        self.grid[math.random(2, self.w - 1)][1] = tile["doorLevel" .. entranceLevel]
    else
        self.grid[math.random(2, self.w - 1)][self.h] = tile["doorLevel" .. entranceLevel]
    end
end

bspBuilding.create = function(w, h, minRoomSize, entranceLevel)
    local inst = {}

    inst.grid = {}
    inst.w = w
    inst.h = h
    inst.minRoomSize = minRoomSize or 5
    inst.entranceLevel = entranceLevel or 1
    inst.numIterations = 0

    _createOuterWalls(inst)

    inst._createRoom = _createRoom
    inst._splitRoom = _splitRoom

    _createRoom(inst, 1, 1, w - 1, h - 1)

    _addOuterDoor(inst, entranceLevel)

    return inst
end

return bspBuilding