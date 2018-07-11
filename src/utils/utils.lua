function readMapFromImage(filePath)
    imageData = love.image.newImageData(filePath)
    imageWidth = imageData:getWidth()
    imageHeight = imageData:getHeight()

    mapData = {}

    for x = 1, imageWidth do
        mapData[x] = {}
        for y = 1, imageHeight do
            mapData[x][y] = { imageData:getPixel(x - 1, y - 1) }
            print('Colour at x:' .. x .. '-y:' .. y .. ' r: ' .. mapData[x][y][1] .. ' g: ' .. mapData[x][y][2] .. ' b: ' .. mapData[x][y][3] .. ' a: ' .. mapData[x][y][4])
        end
    end

    return mapData
end

function compareTables(t1, t2)
    for i = 1, #t1 do
        if t2[i] == nil then return false end
        if t1[i] ~= t2[i] then return false end
    end
    return true
end