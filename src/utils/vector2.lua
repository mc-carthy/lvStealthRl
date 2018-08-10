Vector2 = {}

local pow = math.pow
local sqrt = math.sqrt

function Vector2.distance(a, b)
    assert(type(a.x) == 'number' and type(a.y) == 'number' and type(b.x) == 'number' and type(b.y) == 'number', 'Both vectores must have x & y values')
    return Vector2.magnitude(a.x - b.x, a.y - b.y)
end

function Vector2.magnitude(x, y)
    assert(type(x) == 'number', 'x parameter is not a number')
    assert(type(y) == 'number', 'y parameter is not a number')
    return sqrt(pow(x, 2) + pow(y, 2))
end