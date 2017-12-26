local grid = {}

local draw = function(self)
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            -- if x == grid_x and y == grid_y then
                -- love.graphics.setColor(0, 255, 0, 255)
            -- else
                love.graphics.setColor(220, 220, 220)
            -- end
            if DEBUG then
                love.graphics.rectangle('fill', (x - 1) * self.cellSize, (y - 1) * self.cellSize, self.cellDrawSize, self.cellDrawSize)
            end
        end
    end
end

grid.create = function(cellSize)
    local inst = {}

    inst.cellSize = 40
    local border = 2
    inst.cellDrawSize = inst.cellSize - border
    inst.xSize = love.graphics.getWidth() / inst.cellSize
    inst.ySize = love.graphics.getHeight() / inst.cellSize

    for x = 1, inst.xSize do
        inst[x] = {}
        for y = 1, inst.ySize do
            inst[x][y] = false
        end
    end

    inst.draw = draw

    return inst
end

return grid
