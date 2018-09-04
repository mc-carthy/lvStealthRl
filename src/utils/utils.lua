function getGridPos(x, y)
    local gridX = math.ceil(x / GRID_SIZE)
    local gridY = math.ceil(y / GRID_SIZE)
    return gridX, gridY
end

function table.contains(tbl, element)
    for _, value in pairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

function table.removeElement(tbl, element)
    for i, value in ipairs(tbl) do
        if value == element then
            table.remove(tbl, i)
        end
    end
end

function table.equal(t1, t2)
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

function math.clamp(value, min, max)
    return math.max(math.min(value, max), min)
end

function math.lerp(a, b, k)
    if a == b then
        return a
    else
        if math.abs(a - b) < 0.005 then 
            return b 
        else 
            return a * (1 - k) + b * k 
        end
    end
end

function writeCanvasToFileSystem(canvas, filePath, extension)
    local imageData = canvas:newImageData()
    local imageFile = imageData:encode(extension, filePath)
    -- print(imageFile:getFilename())
end

map = {}

function map.lockAllDoors()
    local level = 1
    while TileDictionary["doorLevel" .. level] do
        TileDictionary["doorLevel" .. level].collidable = true
        level = level + 1
    end
end

function map.unlockDoors(level)
    for i = 1, level do
        if TileDictionary["doorLevel" .. i] then
            TileDictionary["doorLevel" .. i].collidable = false
        end
    end
end