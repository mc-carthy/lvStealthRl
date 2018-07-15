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