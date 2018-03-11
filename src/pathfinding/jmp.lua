local Grid = require ("src.lib.jumper.grid")
local Pathfinder = require ("src.lib.jumper.pathfinder")

local jmp = {}

local map = {}
local grid
local jpsFinder
local walkable = 0

local function _load(self)
    _createjmpMap(self)
    grid = Grid(map) 
    jpsFinder = Pathfinder(grid, 'THETASTAR', walkable) 
    -- printMap()
end

function _createjmpMap(self)
    for y = 1, self.inputGrid.ySize do
        map[y] = {}
        for x = 1, self.inputGrid.xSize do
            if self.inputGrid:isWalkable(x, y) then
                map[y][x] = 0
            else
                map[y][x] = 1
            end
        end
    end
end

local function calculateMap(self, startX, startY, endX, endY)
    -- Calculates the path, and its length
    local path = jpsFinder:getPath(startX, startY, endX, endY)
    if path then
    -- print(('Path found! Length: %.2f'):format(path:getLength()))
    --     for node, count in path:nodes() do
    --     print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
    --     end
        self.points = {}
        for node, _ in path:nodes() do
            table.insert(self.points, { node:getX(), node:getY()})
        end
    end
end

local function _printMap()
    for i = 1, #jpsMap do
        for j = 1, #jpsMap[1] do
            io.write(jpsMap[i][j] == 0 and "X" or "-", " ")
        end
        io.write("\n")
    end
    io.write("\n")
end

jmp.create = function(grid)
    local inst = {}

    inst.inputGrid = grid
    _load(inst)
    inst.points = {}

    inst.calculateMap = calculateMap

    return inst
end

return jmp