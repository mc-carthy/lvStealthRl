CelAutMap = Class{}

local borderThickness = 2

function CelAutMap:init(params)
    self.xSize = params.xSize or 70
    self.ySize = params.ySize or 40
    self.percentFill = params.percentFill or 0.45
    self.smoothingIterations = params.smoothingIterations or 5
    self.mapScale = params.mapScale or 1
    self:createGrid()
    for i = 1, self.smoothingIterations do
        self:smoothGrid()
    end
    self:transformGridToTiles()
end

function CelAutMap:createGrid()
    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            if math.random() >= self.percentFill then
                self[x][y] = false
            else
                self[x][y] = true
            end

            if x <= borderThickness or x > self.xSize - borderThickness then
                self[x][y] = true
            end

            if y <= borderThickness or y > self.ySize - borderThickness then
                self[x][y] = true
            end
        end
    end
end

function CelAutMap:smoothGrid()
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            local neighbourCount = 0

            for dx = -1, 1 do
                for dy = -1, 1 do
                    if not (dx == 0 and dy == 0) and self[x + dx] and self[x + dx][y + dy] then
                        neighbourCount = neighbourCount + 1
                    end

                    if self[x + dx] == nil then
                        neighbourCount = neighbourCount + 1
                    elseif self[x + dx][y + dy] == nil then
                        neighbourCount = neighbourCount + 1
                    end
                end
            end

            if x <= borderThickness or x > self.xSize - borderThickness then
                self[x][y] = true
            end

            if y <= borderThickness or y > self.ySize - borderThickness then
                self[x][y] = true
            end

            if neighbourCount > 4 then
                self[x][y] = true
            elseif neighbourCount < 4 then
                self[x][y] = false
            end
        end
    end
end

function CelAutMap:transformGridToTiles()
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if self[x][y] then
                self[x][y] = TileDictionary['outerWall']
            else
                self[x][y] = TileDictionary['exteriorFloor']
            end
        end
    end
end