local Enemy = require("src.entities.Enemy")

local enemyManager = {}

local numEnemies = 40

local function _placeEnemies(self, numEnemies)
    local grid = self.entityManager:getGrid()
    for i = 1, numEnemies do
        local x, y = grid:returnRandomWorldPosOfTileType("ground")
        self.entityManager:addEntity(Enemy.create(self.entityManager, x, y))
    end
end

enemyManager.create = function(entityManager)
    local inst = {}

    inst.entityManager = entityManager

    _placeEnemies(inst, numEnemies)

    return inst
end

return enemyManager