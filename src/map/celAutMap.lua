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
    if self.mapScale > 1 then
        self:expandGrid()
    end
    self:generateContourMap()
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

function CelAutMap:expandGrid()
    local tempGrid = {}
    for x = 1, self.xSize * self.mapScale do
        tempGrid[x] = {}
        for y = 1, self.ySize * self.mapScale do
            if self[math.floor((x + 1) / self.mapScale)] and self[math.floor((x + 1) / self.mapScale)][math.floor((y + 1) / self.mapScale)] then
                tempGrid[x][y] = self[math.floor((x + 1) / self.mapScale)][math.floor((y + 1) / self.mapScale)]
            end
        end
    end
    
    self.xSize = self.xSize * self.mapScale
    self.ySize = self.ySize * self.mapScale

    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            self[x][y] = tempGrid[x][y]     
        end
    end
end

function CelAutMap:generateContourMap()
    local currentContourValue = 0

    self.contourMap = {}
    for x = 1, self.xSize do
        self.contourMap[x] = {}
        for y = 1, self.ySize do
            if self[x][y] == true then
                self.contourMap[x][y] = 0
            else
                self.contourMap[x][y] = -1
            end
        end
    end

    while not self:countourMapComplete() do
        local contourMapLocal = {}
        for x = 1, self.xSize do
            contourMapLocal[x] = {}
            for y = 1, self.ySize do
                contourMapLocal[x][y] = self.contourMap[x][y]
            end
        end

        for x = 1, self.xSize do
            for y = 1, self.ySize do
                for neighbourX = x - 1, x + 1 do
                    for neighbourY = y - 1, y + 1 do
                        if neighbourX == x or neighbourY == y then
                            if self:isInGridRange(neighbourX, neighbourY) and self.contourMap[x][y] == -1 then
                                if self.contourMap[neighbourX][neighbourY] == currentContourValue then
                                    contourMapLocal[x][y] = currentContourValue + 1
                                end
                            end
                        end
                    end
                end
            end
        end

        for x = 1, self.xSize do
            for y = 1, self.ySize do
                self.contourMap[x][y] = contourMapLocal[x][y]
            end
        end
        currentContourValue = currentContourValue + 1
    end
end

function CelAutMap:countourMapComplete()
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if self.contourMap[x][y] == -1 then
                return false
            end
        end
    end
    return true
end

function CelAutMap:isInGridRange(x, y)
    return x > 0 and x < self.xSize and y > 0 and y < self.ySize
end

function CelAutMap:transformGridToTiles()
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if self[x][y] then
                self[x][y] = TileDictionary['stoneWall']
            else
                self[x][y] = TileDictionary['exteriorFloor']
            end
        end
    end
end

function CelAutMap:collidable(x, y)
    return self[x + 1][y + 1].collidable
end