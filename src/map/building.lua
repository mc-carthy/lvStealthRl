Building = Class{}

function Building:init(parentGrid, params)
    math.randomseed(os.time())

    self.parentGrid = parentGrid
    self.x = params.x
    self.y = params.y
    self.w = params.w
    self.h = params.h
    self.entranceLevel = params.entranceLevel or 1
    self.minRoomSize = params.minRoomSize or 5
    
    self.grid = {}
    self.rooms = {}
    self.numIterations = 0
    self.currentRoomNumber = 1

    self:generate()
end

function Building:generate()
    self:createFoundation()
    self:createRooms(1, 1, self.w - 1, self.h - 1)
end

function Building:createFoundation()
    for x = 1, self.w do
        self[x] = {}
        for y = 1, self.h do
            self[x][y] = {}
            if x == 1 or x == self.w or y == 1 or y == self.h then
                self[x][y] = TileDictionary['exteriorWall']
            else
                self[x][y] = nil
            end
        end
    end
end

function Building:createRooms(x, y, w, h)
    for i = x, x + w do
        for j = y, y + h do
            if i == x or i == x + w or j == y or j == y + h then
                if not self[i][j] then self[i][j] = TileDictionary['interiorWall'] end
            end
        end
    end
    self:splitRoom(x, y, w, h)
end

function Building:splitRoom(x, y, w, h, minRoomSize)
    self.numIterations = self.numIterations + 1
    local minRoomSize = minRoomSize or self.minRoomSize
    local prob = math.random() * 100
    local splitH = nil
    
    if prob > 50 then
        splitH = true
    else
        splitH = false
    end

    if h / w > 1.25 then
        splitH = true
    elseif w / h > 1.25 then
        splitH = false
    end

    local max = 0

    if splitH then
        max = h - minRoomSize
    else
        max = w - minRoomSize
    end

    local prob2 = math.random() * 10
    -- TODO remove hard-coded values
    if max < minRoomSize or self.numIterations > 2 and prob2 < 35 then
        self:createRoom(x, y, w, h)
        return
    end

    local split = math.random(minRoomSize, max)

    if splitH then
        self:createRooms(x, y + split, w, h - split)
        self.numIterations = 0
        self:createRooms(x, y, w, split)
        self.numIterations = 0
    else
        self:createRooms(x + split, y, w - split, h)
        self.numIterations = 0
        self:createRooms(x, y, split, h)
        self.numIterations = 0
    end

    return true
end

function Building:createRoom(x, y, w, h)
    local room = {
        number = self.currentRoomNumber,
        x = x,
        y = y,
        w = w,
        h = h,
        floor = {},
        edgeWalls = {},
        cornerWalls = {},
        neighbours = {},
        debugColour = { math.random(0, 255), math.random(0, 255), math.random(0, 255), 127 }
    }
    for i = x, x + w do
        for j = y, y + h do
            if i == x or i == x + w or j == y or j == y + h then
                local wall = {
                    x = i,
                    y = j
                }
                if (i == x or i == x + w) and (j == y or j == y + h) then
                    table.insert(room.cornerWalls, wall)
                else
                    table.insert(room.edgeWalls, wall)
                end
            else 
                local floor = {
                    x = i,
                    y = j
                }
                table.insert(room.floor, floor)
            end
        end
    end
    self.currentRoomNumber = self.currentRoomNumber + 1
    table.insert(self.rooms, room)
end