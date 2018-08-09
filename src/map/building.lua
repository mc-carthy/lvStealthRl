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
    self:setRoomNeighbours()
    self:demoNeighbourWalls()
    self:setRoomNeighbours()
    self:placeOuterDoor()
    self:layInteriorFloor()
end

function Building:createFoundation()
    for x = 1, self.w do
        self[x] = {}
        for y = 1, self.h do
            self[x][y] = {}
            if x == 1 or x == self.w or y == 1 or y == self.h then
                self[x][y] = TileDictionary['exteriorBuildingWall']
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
                if not self[i][j] then self[i][j] = TileDictionary['interiorBuildingWall'] end
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

function Building:setRoomNeighbours()
    for i, roomA in ipairs(self.rooms) do
        for x, edgeWallA in ipairs(roomA.edgeWalls) do
            for j, roomB in ipairs(self.rooms) do
                if roomA ~= roomB then
                    for y, edgeWallB in ipairs(roomB.edgeWalls) do
                        if edgeWallA.x == edgeWallB.x and edgeWallA.y == edgeWallB.y then
                            if not table.contains(roomA.neighbours, roomB) then
                                table.insert(roomA.neighbours, roomB)
                                table.insert(roomB.neighbours, roomA)
                                -- io.write(roomA.number .. " linked to " .. roomB.number)
                            end
                        end
                    end
                end
            end
        end
    end
end

function Building:demoNeighbourWalls()
    for i, room in ipairs(self.rooms) do
        while #room.neighbours ~= 0 do
            for j, neighbour in ipairs(room.neighbours) do
                table.removeElement(room.neighbours, neighbour)
                table.removeElement(neighbour.neighbours, room)
                self:demoNeighbourWall(room, neighbour)
            end
        end
    end
end

function Building:demoNeighbourWall(room, neighbour)
    local sharedWalls = {}
    for _, selfWall in pairs(room.edgeWalls) do
        for _, nWall in pairs(neighbour.edgeWalls) do
            if selfWall.x == nWall.x and selfWall.y == nWall.y then
                table.insert(sharedWalls, selfWall)
            end
        end
    end
    local demoWall = sharedWalls[math.random(1, #sharedWalls)]
    -- TODO: Consider replacing with interiot doors
    self[demoWall.x][demoWall.y] = TileDictionary["interiorFloor"]
end

function Building:addOuterDoor(x, y, attempt)
    -- TODO: Add doors to TileDictionary
    -- self[x][y] = TileDictionary["doorLevel" .. self.entranceLevel]
    self[x][y] = TileDictionary["exteriorFloor"]
end

function Building:placeOuterDoor(numAttempt)
    -- TODO: Ensure door is not blocked by level walls
    local attempt = numAttempt or 1
    local x, y = nil, nil
    local foundCorner = false
    local prob = math.random() * 100
    if prob < 25 then
        x, y = 1, math.random(2, self.h - 1)
    elseif prob < 50 then
        x, y = self.w, math.random(2, self.h - 1)
    elseif prob < 75 then
        x, y = math.random(2, self.w - 1), 1
    else
        x, y = math.random(2, self.w - 1), self.h
    end
    for _, room in pairs(self.rooms) do
        for _, corner in pairs(room.cornerWalls) do
            if corner.x == x and corner.y == y then
                self:placeOuterDoor(attempt + 1)
                return
            end
        end
    end
    self:addOuterDoor(x, y, attempt)
end

function Building:layInteriorFloor()
    for x = 1, self.w do
        for y = 1, self.h do
            if not self[x][y] then
                self[x][y] = TileDictionary['interiorFloor']
            end
        end
    end
end