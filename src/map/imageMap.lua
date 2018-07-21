ImageMap = Class{}

function ImageMap:init(filePath)
    imageData = love.image.newImageData(filePath)
    imageWidth = imageData:getWidth()
    imageHeight = imageData:getHeight()

    self.xSize, self.ySize = imageWidth, imageHeight

    for x = 1, imageWidth do
        self[x] = {}
        for y = 1, imageHeight do
            local colourTable = { imageData:getPixel(x - 1, y - 1) }
            for k, v in pairs(TileDictionary) do
                if table.equal(colourTable, v.importColour) then
                    self[x][y] = v
                end
            end
        end
    end
end

function ImageMap:collidable(x, y)
    return self[x + 1][y + 1].collidable
end