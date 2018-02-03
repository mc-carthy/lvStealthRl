local tile = require("src.map.tileDictionary")

local bspBuilding = {}

local bsp_rng = love.math.newRandomGenerator(os.time())

local function createOuterWalls(self)
    local grid = {}
    for x = 1, self.w do
        grid[x] = {}
        for y = 1, self.h do
            grid[x][y] = {}
            if x == 1 or x == self.w or y == 1 or y == self.h then
                grid[x][y] = tile["buildingOuterWall"]
            else
                grid[x][y] = tile["ground"]
            end
        end
    end
    local prob = bsp_rng:random(100)
    if prob < 25 then
        grid[1][math.random(2, self.h - 1)] = tile["ground"]
    elseif prob < 50 then
        grid[self.w][math.random(2, self.h - 1)] = tile["ground"]
    elseif prob < 75 then
        grid[math.random(2, self.w - 1)][1] = tile["ground"]
    else
        grid[math.random(2, self.w - 1)][self.h] = tile["ground"]
    end
    return grid
end

bspBuilding.create = function(w, h, minRoomSize)
    local inst = {}

    inst.grid = {}
    inst.w = w
    inst.h = h
    inst.minRoomSize = minRoomSize or 5

    inst.grid = createOuterWalls(inst)

    return inst
end

return bspBuilding