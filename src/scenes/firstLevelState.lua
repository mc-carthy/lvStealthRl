FirstLevelState = Class{ __includes = BaseState }

function FirstLevelState:enter(params)
    self.em = EntityManager()
    self.em.map = params.map
    local playerX, playerY = self:findRandomFreeSpace()
    self.player = self.em:add(Player(playerX, playerY))
    self.em:add(Enemy(self:findRandomFreeSpace()))
    self.camera = Camera({
        target = self.player
    })
end

function FirstLevelState:checkCollisions()
    self.em:checkCircleCollisionsBetween('bullet', 'enemy')
end

function FirstLevelState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    self.camera:update(dt)
    MOUSE_X, MOUSE_Y = self.camera:screenToWorld(love.mouse.getPosition())
    self.em:update(dt)
    self:checkCollisions()
end

function FirstLevelState:draw()
    self.camera:set()
    self:drawMap()
    self.em:draw()
    self.camera:unset()
end

function FirstLevelState:drawMap()
    for x = 1, #self.em.map do
        for y = 1, #self.em.map[1] do
            love.graphics.setColor(self.em.map[x][y].drawColour)
            love.graphics.rectangle('fill', (x - 1) * GRID_SIZE, (y - 1) * GRID_SIZE, GRID_SIZE, GRID_SIZE)
        end
    end
end

function FirstLevelState:findRandomFreeSpace()
    while true do
        local x, y = math.floor(math.random() * self.em.map.xSize + 1), math.floor(math.random() * self.em.map.ySize + 1)
        if self.em.map[x][y].collidable == false then
            return x * GRID_SIZE, y * GRID_SIZE
        end
    end
end