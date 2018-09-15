ImageMap = Class{ __includes = Map }

function ImageMap:init(filePath)
    self.tag = TAG.MAP
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