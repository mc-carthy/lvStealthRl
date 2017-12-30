local M = {}

function M.sign(value)
    if value > 0 then
        return 1
    elseif value < 0 then
        return -1
    else
        return 0
    end
end

function M.clamp(low, n, high)
    return math.min(math.max(low, n), high)
end

function M.lerp(a,b,t)
    return (1-t)*a + t*b
end

return M
