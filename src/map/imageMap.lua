ImageMap = Class{}

function ImageMap:init(filePath)
    self.tag = 'map'
    self.depth = 1000
    imageData = love.image.newImageData(filePath)
    imageWidth = imageData:getWidth()
    imageHeight = imageData:getHeight()

    self.xSize, self.ySize = imageWidth, imageHeight

    for x = 1, imageWidth do
        self[x] = {}
        for y = 1, imageHeight do
            local colourTable = { imageData:getPixel(x - 1, y - 1) }
            for k, v in pairs(TileDictionary) do
                if v.importColour then
                    if table.equal(colourTable, v.importColour) then
                        self[x][y] = v
                    end
                end
            end
        end
    end
end

function ImageMap:collidable(x, y)
    return self[x][y].collidable
end

-- TODO: Consider extracting this to a 'map' base class
function ImageMap:findRandomTileOfType(tileType)
    while true do
        local x, y = math.floor(math.random() * self.xSize + 1), math.floor(math.random() * self.ySize + 1)
        if self[x][y] == TileDictionary[tileType] then
            return x * GRID_SIZE - GRID_SIZE / 2, y * GRID_SIZE - GRID_SIZE / 2
        end
    end
end