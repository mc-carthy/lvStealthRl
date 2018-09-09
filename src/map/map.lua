Map = Class{}

function Map:isInGridRange(x, y)
    return x > 0 and x < self.xSize and y > 0 and y < self.ySize
end

function Map:collidable(x, y)
    return self[x][y].collidable
end

function Map:findRandomTileOfType(tileType)
    while true do
        local x, y = math.floor(math.random() * self.xSize + 1), math.floor(math.random() * self.ySize + 1)
        if self[x][y] == TileDictionary[tileType] then
            return x * GRID_SIZE - GRID_SIZE / 2, y * GRID_SIZE - GRID_SIZE / 2
        end
    end
end