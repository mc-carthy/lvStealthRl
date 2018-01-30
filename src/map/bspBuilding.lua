local bspBuilding = {}

local bsp_rng = love.math.newRandomGenerator(os.time())

local function createOuterWalls(self)
    local grid = {}
    for x = 1, self.w do
        grid[x] = {}
        for y = 1, self.h do
            grid[x][y] = {}
            local prob = bsp_rng:random(100)
            if prob <= 95 then
                if x == 1 or x == self.w or y == 1 or y == self.h then
                    grid[x][y].outerWall = true
                end
            end
        end
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