FirstLevelState = Class{ __includes = BaseState }

function FirstLevelState:enter(params)
    love.mouse.setVisible(false)
    self.em = EntityManager()
    map.lockAllDoors()
    if params.map.type == 'ImageMap' then
        self.em.map = self.em:add(ImageMap(params.map.filePath))
    elseif params.map.type == 'CelAutMap' then
        self.em.map = self.em:add(CelAutMap({
            xSize = params.map.xSize,
            ySize = params.map.ySize,
            percentFill = params.map.percentFill,
            smoothingIterations = params.map.smoothingIterations,
            mapScale = params.map.mapScale,
            numBuildings = params.map.numBuildings or 5
        }))
        self.em.map:addKeycards()
    end

    self:writeMapToCanvas()
    -- writeCanvasToFileSystem(self.canvas, 'celAutMap.png', 'png')
    local playerX, playerY = self.em.map:findRandomTileOfType('exteriorFloor')
    self.em.map.playerX, self.em.map.playerY = playerX, playerY
    self.player = self.em:add(Player(playerX, playerY))
    self.em:add(Enemy(self.em.map:findRandomTileOfType('exteriorFloor')))
    self.em.camera = Camera({
        target = self.player
    })
end

function FirstLevelState:exit()
    love.mouse.setVisible(true)
end

function FirstLevelState:checkCollisions()
    self.em:checkCircleCollisionsBetween('bullet', 'enemy')
end

function FirstLevelState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    self.em:update(dt)
    self:checkCollisions()
    self.em.camera:update(dt)
    MOUSE_X, MOUSE_Y = self.em.camera:screenToWorld(love.mouse.getPosition())
end

function FirstLevelState:draw()
    self.em.camera:set()
    -- TODO: Consider moving map drawing function to map
    love.graphics.draw(self.canvas, 0, 0)
    self.em:draw()
    self.em.camera:unset()
    -- love.graphics.print('Zoom level: x' .. string.format("%.2f", self.em.camera.zoomLevel), 10, 30)
    self:drawCursor()
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

function FirstLevelState:drawCursor()
    local mouse_x, mouse_y = love.mouse.getPosition()
    love.graphics.setLineWidth(2)
    
    love.graphics.circle('line', mouse_x, mouse_y, 5)
    love.graphics.setLineWidth(1)
end