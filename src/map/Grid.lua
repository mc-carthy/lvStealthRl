local EntityManager = require("src.entities.EntityManager")

local grid = {}

local grid_rng = love.math.newRandomGenerator(os.time())

local playerX, playerY = 0, 0

local worldSpaceToGrid = function(self, x, y)
    gridx = math.floor(x / self.cellSize) + 1
    gridy = math.floor(y / self.cellSize) + 1
    return gridx, gridy
end

local update = function(self, dt, player)
    playerX, playerY = worldSpaceToGrid(self, player:getPosition())
end

local draw = function(self)
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if x == playerX and y == playerY then
                love.graphics.setColor(0, 255, 0, 255)
            else
                love.graphics.setColor(220, 220, 220)
            end
            if not self[x][y].walkable then
                love.graphics.setColor(0, 0, 0)
            end
            if DEBUG then
                love.graphics.rectangle('fill', (x - 1) * self.cellSize, (y - 1) * self.cellSize, self.cellDrawSize, self.cellDrawSize)
            end
        end
    end
end

grid.create = function()
    local inst = {}

    inst.cellSize = 40
    local border = 2
    inst.cellDrawSize = inst.cellSize - border
    inst.xSize = love.graphics.getWidth() / inst.cellSize
    inst.ySize = love.graphics.getHeight() / inst.cellSize

    for x = 1, inst.xSize do
        inst[x] = {}
        for y = 1, inst.ySize do
            inst[x][y] = {}
            local prob = grid_rng:random(100)
            if prob >= 85 then
                inst[x][y].walkable = false
            else
                inst[x][y].walkable = true
            end
        end
    end

    inst.update = update
    inst.draw = draw

    return inst
end

return grid
