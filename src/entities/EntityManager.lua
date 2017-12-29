local entityManager = {}

local addEntity = function(self, entity)
    table.insert(self.entities, entity)
end

local getEntities = function(self)
    return self.entities
end

local getPlayer = function(self)
    for _, entity in ipairs(self:getEntities()) do
        -- TODO: Come up with a better way of identifying the player, tags maybe?
        if entity.tag == "player" then return entity end
    end
end

local _cleanUpDoneEntities = function(self)
    for i = #self.entities, 1, -1 do
        local e = self.entities[i]
        if e.done then
            table.remove(self.entities, i)
        end
    end
end

local update = function(self, dt)
    for i = 1, #self.entities do
        if self.entities[i].update then
            self.entities[i]:update(dt)
        end
    end
    _cleanUpDoneEntities(self)
end

local draw = function(self)
    for i = 1, #self.entities do
        if self.entities[i].draw then
            self.entities[i]:draw()
        end
    end
end

entityManager.create = function()
    local inst = {}

    inst.entities = {}

    inst.addEntity = addEntity
    inst.getEntities = getEntities
    inst.getPlayer = getPlayer

    inst.update = update
    inst.draw = draw

    return inst
end

return entityManager
