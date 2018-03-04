local entityManager = {}

local addEntity = function(self, entity)
    table.insert(self.entities, entity)
end

local getEntities = function(self)
    return self.entities
end

local getAudioBreadcrumbs = function(self)
    local audioCrumbTable = {}
    for i = 1, #self.entities do
        if self.entities[i].tag == "audioBreadcrumb" then
            table.insert(audioCrumbTable, self.entities[i])
        end
    end
    return audioCrumbTable
end

local getVisualBreadcrumbs = function(self)
    local visualCrumbTable = {}
    for i = 1, #self.entities do
        if self.entities[i].tag == "visualBreadcrumb" then
            table.insert(visualCrumbTable, self.entities[i])
        end
    end
    return visualCrumbTable
end

local getPlayer = function(self)
    for _, entity in ipairs(self:getEntities()) do
        if entity.tag == "player" then return entity end
    end
end

local getGrid = function(self)
    for _, entity in ipairs(self:getEntities()) do
        if entity.tag == "grid" then return entity end
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
        if self.entities[i].tag ~= "player" then 
            if self.entities[i].draw then
                self.entities[i]:draw()
            end
        end
    end
    -- TODO: This ensures the player is drawn on top of everything, refactor to use sorting layers
    for i = 1, #self.entities do
        if self.entities[i].tag == "player" then 
            if self.entities[i].draw then
                self.entities[i]:draw()
            end
        end
    end
end

local drawScreenSpace = function(self)
    for i = 1, #self.entities do
        if self.entities[i].drawScreenSpace then
            self.entities[i]:drawScreenSpace()
        end
    end
end

entityManager.create = function()
    local inst = {}

    inst.entities = {}

    inst.addEntity = addEntity
    inst.getEntities = getEntities
    inst.getPlayer = getPlayer
    inst.getGrid = getGrid
    inst.getAudioBreadcrumbs = getAudioBreadcrumbs

    inst.update = update
    inst.draw = draw
    inst.drawScreenSpace = drawScreenSpace

    return inst
end

return entityManager
