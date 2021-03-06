function worldToGrid(x, y)
    local gridX = math.ceil(x / GRID_SIZE)
    local gridY = math.ceil(y / GRID_SIZE)
    return gridX, gridY
end

function gridToWorld(x, y)
    local worldX = x * GRID_SIZE - GRID_SIZE / 2
    local worldY = y * GRID_SIZE - GRID_SIZE / 2
    return worldX, worldY
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

function table.dequeue(tbl)
    local newTbl = {}
    local firstElement = tbl[1]
    for i = 1, #tbl - 1 do
        table.insert(newTbl, tbl[i + 1])
    end

    return firstElement, newTbl
end

function table.equal(t1, t2)
    for i = 1, #t1 do
        if t2[i] == nil then return false end
        if t1[i] ~= t2[i] then return false end
    end
    return true
end

function table.getIndex(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    assert(false, 'Value ' .. value .. ' not found in table.')
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