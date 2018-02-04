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

    _createOuterWalls(inst)
    _addOuterDoor(inst, entranceLevel)

    return inst
end

return bspBuilding