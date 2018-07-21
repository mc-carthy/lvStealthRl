FirstLevelState = Class{ __includes = BaseState }

function FirstLevelState:enter(params)
    self.map = params.map
    self.entityManager = EntityManager()
    local playerX, playerY = self:findRandomFreeSpaceForPlayer()
    self.player = self.entityManager:add(Player(playerX, playerY, self.map))
    self.entityManager:add(Enemy(0, 0))
    self.camera = Camera({
        target = self.player
    })
end

function FirstLevelState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    self.camera:update(dt)
    MOUSE_X, MOUSE_Y = self.camera:screenToWorld(love.mouse.getPosition())
    self.entityManager:update(dt)
end

function FirstLevelState:draw()
    self.camera:set()
    self:drawMap()
    self.entityManager:draw()
    self.camera:unset()
end

function FirstLevelState:drawMap()
    for x = 1, #self.map do
        for y = 1, #self.map[1] do
            love.graphics.setColor(self.map[x][y].drawColour)
            love.graphics.rectangle('fill', (x - 1) * GRID_SIZE, (y - 1) * GRID_SIZE, GRID_SIZE, GRID_SIZE)
        end
    end
end

function FirstLevelState:findRandomFreeSpaceForPlayer()
    while true do
        local x, y = math.floor(math.random() * self.map.xSize + 1), math.floor(math.random() * self.map.ySize + 1)
        if self.map[x][y].collidable == false then
            return x * GRID_SIZE, y * GRID_SIZE
        end
    end
end