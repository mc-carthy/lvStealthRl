FirstLevelState = Class{ __includes = BaseState }

function FirstLevelState:enter(params)
    self.em = EntityManager()
    self.em.map = params.map
    self:writeMapToCanvas()
    -- writeCanvasToFileSystem(self.canvas, 'celAutMap.png', 'png')
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
    MOUSE_X, MOUSE_Y = self.camera:screenToWorld(love.mouse.getPosition())
    self.em:update(dt)
    self:checkCollisions()
    self.camera:update(dt)
end

function FirstLevelState:draw()
    self.camera:set()
    love.graphics.draw(self.canvas, 0, 0)
    self.em:draw()
    self.camera:unset()
    love.graphics.print('Zoom level: x' .. string.format("%.2f", self.camera.zoomLevel), 10, 30)
end

function FirstLevelState:writeMapToCanvas()
    self.canvas = love.graphics.newCanvas(GRID_SIZE * self.em.map.xSize, GRID_SIZE * self.em.map.ySize)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    for x = 1, #self.em.map do
        for y = 1, #self.em.map[1] do
            if self.em.map[x][y].sprite then
                local spriteW, spriteH = self.em.map[x][y].sprite:getDimensions()
                local scaleX, scaleY = GRID_SIZE / spriteW, GRID_SIZE / spriteH
                if self.em.map[x][y].tintColour then
                    love.graphics.setColor(1, 1, 1, 1)
                    love.graphics.rectangle('fill', (x - 1) * GRID_SIZE, (y - 1) * GRID_SIZE, GRID_SIZE, GRID_SIZE)
                    love.graphics.setColor(unpack(self.em.map[x][y].tintColour))
                    -- love.graphics.rectangle('fill', (x - 1) * GRID_SIZE, (y - 1) * GRID_SIZE, GRID_SIZE, GRID_SIZE)
                    love.graphics.draw(self.em.map[x][y].sprite, (x - 1) * GRID_SIZE, (y - 1) * GRID_SIZE, 0, scaleX, scaleY)
                    love.graphics.setColor(1, 1, 1, 1)
                else
                    love.graphics.draw(self.em.map[x][y].sprite, (x - 1) * GRID_SIZE, (y - 1) * GRID_SIZE, 0, scaleX, scaleY)
                end
            else
                love.graphics.setColor(self.em.map[x][y].drawColour)
                love.graphics.rectangle('fill', (x - 1) * GRID_SIZE, (y - 1) * GRID_SIZE, GRID_SIZE, GRID_SIZE)
            end
            -- love.graphics.setColor(0.5, 0.5, 0.5, 1)
            -- love.graphics.print(self.em.map.contourMap[x][y], (x - 1) * GRID_SIZE, (y - 1) * GRID_SIZE)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
    love.graphics.setCanvas()
end

function FirstLevelState:findRandomFreeSpace()
    while true do
        local x, y = math.floor(math.random() * self.em.map.xSize + 1), math.floor(math.random() * self.em.map.ySize + 1)
        if self.em.map[x][y].collidable == false then
            return x * GRID_SIZE, y * GRID_SIZE
        end
    end
end