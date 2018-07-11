function readMapFromImage(filePath)
    imageData = love.image.newImageData(filePath)
    imageWidth = imageData:getWidth() - 1
    imageHeight = imageData:getHeight() - 1

    mapData = {}

    for x = 0, imageWidth do
        mapData[x] = {}
        for y = 0, imageHeight do
            mapData[x][y] = { imageData:getPixel(x, y) }
            print('Colour at x:' .. x .. '-y:' .. y .. ' r: ' .. mapData[x][y][1] .. ' g: ' .. mapData[x][y][2] .. ' b: ' .. mapData[x][y][3] .. ' a: ' .. mapData[x][y][4])
        end
    end
end