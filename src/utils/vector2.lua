Vector2 = {}

local pow = math.pow
local sqrt = math.sqrt
local PI = math.pi

function Vector2.distance(a, b)
    assert(type(a.x) == 'number' and type(a.y) == 'number' and type(b.x) == 'number' and type(b.y) == 'number', 'Both vectores must have x & y values')
    return Vector2.magnitude(a.x - b.x, a.y - b.y)
end

function Vector2.magnitude(x, y)
    assert(type(x) == 'number', 'x parameter is not a number')
    assert(type(y) == 'number', 'y parameter is not a number')
    return sqrt(pow(x, 2) + pow(y, 2))
end

function Vector2.angle(a, b)
    local x1, y1 = a.x, a.y
    local x2, y2 = b.x, b.y
    local ang = -math.atan2(y2 - y1, x2 - x1)

    if ang < 0 then ang = ang + (2 * PI) end

    return ang
end