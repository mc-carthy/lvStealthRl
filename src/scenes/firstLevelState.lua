FirstLevelState = Class{ __includes = BaseState}

CELL_SIZE = 20

function FirstLevelState:enter(params)
    self.map = params.map
end

function FirstLevelState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function FirstLevelState:draw()
    for x = 1, #self.map do
        for y = 1, #self.map[1] do
            if compareTables(mapData[x][y],{ 0, 0, 0, 1 }) == true then
                love.graphics.setColor(0.5, 0.5, 0.5, 1)
            elseif compareTables(mapData[x][y],{ 0, 0, 1, 1 }) == true then
                love.graphics.setColor(0, 0.75, 0.75, 1)
            else
                love.graphics.setColor(1, 1, 1, 1)
            end
            love.graphics.rectangle('fill', x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
        end
    end
end