local celAut = {}

local cellSize = 20
local border = 1
local cellDrawSize = cellSize - border
local wallChance = 450
local mapBorderThickness = 2
local rng = love.math.newRandomGenerator(os.time())

local _createGrid = function(self)
    local grid = {}
    for x = 1, self.xSize do
        grid[x] = {}
        for y = 1, self.ySize do
            if rng:random(1000) >= self.wallPercentage then
                grid[x][y] = false
            else
                grid[x][y] = true
            end

            if x <= mapBorderThickness or x > self.xSize - mapBorderThickness then
                grid[x][y] = true
            end

            if y <= mapBorderThickness or y > self.ySize - mapBorderThickness then
                grid[x][y] = true
            end
        end
    end

    return grid
end

local _smoothMap = function(self)
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            local neighbourCount = 0

            for dx = -1, 1 do
                for dy = -1, 1 do
                    if not (dx == 0 and dy == 0) and self.grid[x + dx] and self.grid[x + dx][y + dy] then
                        neighbourCount = neighbourCount + 1
                    end

                    if self.grid[x + dx] == nil then
                        neighbourCount = neighbourCount + 1
                    elseif self.grid[x + dx][y + dy] == nil then
                        neighbourCount = neighbourCount + 1
                    end
                end
            end

            if x <= mapBorderThickness or x > self.xSize - mapBorderThickness then
                self.grid[x][y] = true
            end

            if y <= mapBorderThickness or y > self.ySize - mapBorderThickness then
                self.grid[x][y] = true
            end

            if neighbourCount > 4 then
                self.grid[x][y] = true
            elseif neighbourCount < 4 then
                self.grid[x][y] = false
            end
        end
    end
end

celAut.create = function(xSize, ySize, wallPercentage, smoothingIterations)
    local inst = {}

    inst.xSize = xSize
    inst.ySize = ySize
    inst.wallPercentage = wallPercentage or wallChance
    inst.smoothingIterations = smoothingIterations or 5
    
    inst.grid = _createGrid(inst)

    for i = 0, inst.smoothingIterations do
        _smoothMap(inst)
    end

    return inst
end

return celAut