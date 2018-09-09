local Grid = require ("src.lib.jumper.grid")
local JmpPathfinder = require ("src.lib.jumper.pathfinder")

Pathfinder = Class{}

local jpsFinder
local walkable = 0

function Pathfinder:init(gameMap)    
    local map = self:createJmpMap(gameMap)
    local grid = Grid(map) 
    jmpFinder = JmpPathfinder(grid, 'THETASTAR', walkable) 
end

function Pathfinder:createJmpMap(gameMap)
    local map = {}
    for y = 1, gameMap.ySize do
        map[y] = {}
        for x = 1, gameMap.xSize do
            if gameMap:collidable(x, y) then
                map[y][x] = 1
            else
                map[y][x] = 0
            end
        end
    end
    return map
end

function Pathfinder:findPath(startX, startY, endX, endY)
    -- Calculates the path, and its length
    local path = jmpFinder:getPath(startX, startY, endX, endY)
    -- print('Attempting to find path from ' .. startX .. '-' .. startY .. ' to ' .. endX .. '-' .. endY)
    if path then
        -- print(('Path found! Length: %.2f'):format(path:getLength()))
        for node, count in path:nodes() do
            -- print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
            end
            local points = {}
            for node, _ in path:nodes() do
                table.insert(points, { node:getX(), node:getY() })
            end
            return true, points
        end
    -- print('Did not find path')
    return false, nil
end