EntityManager = Class{}

function EntityManager:init()
    -- TODO: Consider removing drawnEntities table and instead sorting and unsorting entities table prior to drawing.
    self.entities = {}
    self.drawnEntities = {}
end

function EntityManager:cleanupEntities()
    for i = #self.entities, 1, -1 do
        local e = self.entities[i]
        if e.done then
            table.remove(self.entities, i)
        end
    end

    for i = #self.drawnEntities, 1, -1 do
        local e = self.drawnEntities[i]
        if e.done then
            table.remove(self.drawnEntities, i)
        end
    end
end

function EntityManager:add(entity)
    entity.em = self
    table.insert(self.entities, entity)
    table.insert(self.drawnEntities, entity)
    self:sortTableByDrawingDepth()
    return entity
end

function EntityManager:remove(entity)
    for _, e in pairs(self.entities) do
        if e == entity then
            e.done = true
        end
    end

    for _, e in pairs(self.drawnEntities) do
        if e == entity then
            e.done = true
        end
    end
end

function EntityManager:getObjectsByTag(tag)
    local taggedEntites = {}
    for _, e in pairs(self.entities) do
        if e.tag == tag then
            table.insert(taggedEntites, e)
        end
    end
    if #taggedEntites == 0 then
        return
    else
        return taggedEntites
    end
end

function EntityManager:getObjectByTag(tag)
    return self:getObjectsByTag(tag)[1]
end

function EntityManager:getPlayer()
    return self:getObjectByTag(TAG.PLAYER)
end

function EntityManager:checkCircleCollisionsBetween(a, b)
    local tableA = self:getObjectsByTag(a)
    local tableB = self:getObjectsByTag(b)
    
    if tableA ~= nil and tableB ~= nil then
        if #tableA > 0 and #tableB > 0 then
            for _, a in pairs(tableA) do
                for _, b in pairs(tableB) do
                    if Vector2.distance(a, b) < (a.rad + b.rad) then
                        a:hit(b)
                        b:hit(a)
                    end
                end
            end
        end
    end
end

function EntityManager:sortTableByDrawingDepth()
    for _, v in pairs(self.drawnEntities) do
        assert(tonumber(v.depth), v.tag .. ' entity must have a depth value')
        -- print('Entity: ' .. v.tag .. ' Depth: ' .. v.depth)
    end
    local sortFunc = function(a, b)
        if a.depth and b.depth then
            return a.depth > b.depth
        end
    end
    table.sort(self.drawnEntities, sortFunc)
end

function EntityManager:update(dt)
    for _, v in pairs(self.entities) do
        if v.update then
            v:update(dt)
        end
    end
    self:cleanupEntities()
end

function EntityManager:draw()
    for _, v in pairs(self.drawnEntities) do
        if v.draw then
            v:draw()
        end
    end
end