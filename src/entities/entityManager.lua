EntityManager = Class{}

function EntityManager:init()
    self.entities = {}
end

function EntityManager:cleanupEntities()
    for i = #self.entities, 1, -1 do
        local e = self.entities[i]
        if e.done then
            table.remove(self.entities, i)
        end
    end
end

function EntityManager:add(entity)
    entity.em = self
    table.insert(self.entities, entity)
    return entity
end

function EntityManager:remove(entity)
    for _, e in pairs(self.entities) do
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

function EntityManager:update(dt)
    for _, v in pairs(self.entities) do
        if v.update then
            v:update(dt)
        end
    end
    self:cleanupEntities()
end

function EntityManager:draw()
    for _, v in pairs(self.entities) do
        if v.draw then
            v:draw()
        end
    end
end