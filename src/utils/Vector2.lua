local V = {}

local pow = math.pow
local sqrt = math.sqrt

function V.magnitude(x, y)
    return sqrt(pow(x, 2) + pow(y, 2))
end

function V.normalised(x, y)
    mag = V.magnitude(x, y)
    nX = x / mag
    ny = y / mag
    return nx, ny
end

return V