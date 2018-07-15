FirstLevelState = Class{ __includes = BaseState }

CELL_SIZE = 20

function FirstLevelState:enter(params)
    self.map = params.map
    self.entityManager = EntityManager()
    self.player = self.entityManager:add(Player(100, 100, self.map))
end

function FirstLevelState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    self.entityManager:update(dt)
end

function FirstLevelState:draw()
    self:drawMap()
    self.entityManager:draw()
end

function FirstLevelState:drawMap()
    for x = 1, #self.map do
        for y = 1, #self.map[1] do
            love.graphics.setColor(mapData[x][y].drawColour)
            love.graphics.rectangle('fill', x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
        end
    end
end