FirstLevelState = Class{ __includes = BaseState }

function FirstLevelState:enter(params)
    self.map = params.map
    self.entityManager = EntityManager()
    local playerX, playerY = self:findRandomFreeSpaceForPlayer()
    self.player = self.entityManager:add(Player(playerX, playerY, self.map))
    self.zoomLevel = 1
end

function FirstLevelState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    if love.keyboard.isDown('z') then
        self.zoomLevel = self.zoomLevel / 0.99
    end
    if love.keyboard.isDown('x') then
        self.zoomLevel = self.zoomLevel * 0.99
    end
    self.zoomLevel = math.clamp(self.zoomLevel, 0.5, 2)
    MOUSE_X, MOUSE_Y = self:screenToWorld(love.mouse.getPosition())
    self.entityManager:update(dt)
end

function FirstLevelState:draw()
    love.graphics.push()
    love.graphics.translate(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
    love.graphics.scale(self.zoomLevel, self.zoomLevel)
    love.graphics.translate(-self.player.x, -self.player.y)
    self:drawMap()
    self.entityManager:draw()
    love.graphics.pop()
end

function FirstLevelState:screenToWorld(x, y)
    z = self.zoomLevel
    x = (x / z) + self.player.x - (SCREEN_WIDTH / z / 2) 
    y = (y / z) + self.player.y - (SCREEN_HEIGHT / z / 2)
    return x, y
end

function FirstLevelState:drawMap()
    for x = 1, #self.map do
        for y = 1, #self.map[1] do
            love.graphics.setColor(self.map[x][y].drawColour)
            love.graphics.rectangle('fill', x * GRID_SIZE, y * GRID_SIZE, GRID_SIZE, GRID_SIZE)
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