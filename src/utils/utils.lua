function getGridPos(x, y)
    local gridX = math.floor(x / GRID_SIZE)
    local gridY = math.floor(y / GRID_SIZE)
    return gridX, gridY
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