FirstLevelState = Class{ __includes = BaseState }

CELL_SIZE = 20

function FirstLevelState:enter(params)
    self.map = params.map
    self.player = Player(100, 100, self.map)
end

function FirstLevelState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    self.player:update(dt)
end

function FirstLevelState:draw()
    self:drawMap()
    self.player:draw()
end

function FirstLevelState:drawMap()
    for x = 1, #self.map do
        for y = 1, #self.map[1] do
            if table.equal(mapData[x][y],TileDictionary['interiorWall'].importColour) then
                love.graphics.setColor(unpack(TileDictionary['interiorWall'].drawColour))
            elseif table.equal(mapData[x][y], TileDictionary['outerWall'].importColour) then
                love.graphics.setColor(unpack(TileDictionary['outerWall'].drawColour))
            elseif table.equal(mapData[x][y], TileDictionary['interiorFloor'].importColour) then
                love.graphics.setColor(unpack(TileDictionary['interiorFloor'].drawColour))
            end
            love.graphics.rectangle('fill', x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
        end
    end
end