FirstLevelState = Class{ __includes = BaseState }

function FirstLevelState:enter(params)
    self.map = params.map
    self.entityManager = EntityManager()
    self.player = self.entityManager:add(Player(250, 250, self.map))
end

function FirstLevelState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    local mX, mY = love.mouse.getPosition()
    MOUSE_X = mX + self.player.x - SCREEN_WIDTH / 2
    MOUSE_Y = mY + self.player.y - SCREEN_HEIGHT / 2
    self.entityManager:update(dt)
end

function FirstLevelState:draw()
    love.graphics.push()
    love.graphics.translate(-self.player.x + SCREEN_WIDTH / 2, -self.player.y + SCREEN_HEIGHT / 2)
    self:drawMap()
    self.entityManager:draw()
    love.graphics.pop()
end

function FirstLevelState:drawMap()
    for x = 1, #self.map do
        for y = 1, #self.map[1] do
            love.graphics.setColor(self.map[x][y].drawColour)
            love.graphics.rectangle('fill', x * GRID_SIZE, y * GRID_SIZE, GRID_SIZE, GRID_SIZE)
        end
    end
end