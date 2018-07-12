function readMapFromImage(filePath)
    imageData = love.image.newImageData(filePath)
    imageWidth = imageData:getWidth()
    imageHeight = imageData:getHeight()

    mapData = {}

    for x = 1, imageWidth do
        mapData[x] = {}
        for y = 1, imageHeight do
            mapData[x][y] = { imageData:getPixel(x - 1, y - 1) }
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

function normalise(x, y)
    if x == 0 or y == 0 then return x, y end
    local ratio = 1 / math.sqrt(math.pow(x, 2) + math.pow(y, 2))
    return x * ratio, y * ratio
end