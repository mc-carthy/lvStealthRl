local utils = {}

function utils.tableContains(tbl, element)
    for _, value in pairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

function utils.tableRemove(tbl, element)
    for i, value in ipairs(tbl) do
        if value == element then
            table.remove(tbl, i)
        end
    end
end

return utils