local tile = require("src.map.tileDictionary")
local Utils = require("src.utils.utils")

local bspBuilding = {}

local bsp_rng = love.math.newRandomGenerator(os.time())

local iteration = 0
local roomNumber = 1

local function _createOuterWalls(self)
    for x = 1, self.w do
        self.grid[x] = {}
        for y = 1, self.h do
            self.grid[x][y] = {}
            if x == 1 or x == self.w or y == 1 or y == self.h then
                self.grid[x][y] = tile["buildingOuterWall"]
            else
                self.grid[x][y] = tile["buildingInterior"]
            end
        end
    end
end

local function _createRoom(self, x, y, w, h)
    for i = x, x + w do
        for j = y, y + h do
            if i == x or i == x + w or j == y or j == y + h then
                self.grid[i][j] = tile["buildingOuterWall"]
            end
        end
    end
    self._splitRoom(self, x, y, w, h)
end

local _createFinalRoom = function(self, x, y, w, h)
    local room = {
        number = roomNumber,
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
    roomNumber = roomNumber + 1
    table.insert(self.rooms, room)
end

local function _demoWalls(self)
    for x = 1, self.w do
        for y = 1, self.h do
            local prob = bsp_rng:random(100)
            if self.grid[x][y] == tile["buildingOuterWall"] and prob > 95 then
                self.grid[x][y] = tile["buildingInterior"]
            end
        end
    end
end

local _demoRoomWalls = function(self)
    for _, room in ipairs(self.rooms) do
        for _ = 1, 2 do
            local i = math.random(1, #room.edgeWalls)
            local demoWall = room.edgeWalls[i]
            self.grid[demoWall.x][demoWall.y] = tile["buildingInterior"]
        end
    end
end

local _demoNeighbourWall = function(self, room, neighbour)
    local sharedWalls = {}
    for _, selfWall in pairs(room.edgeWalls) do
        for _, nWall in pairs(neighbour.edgeWalls) do
            if selfWall.x == nWall.x and selfWall.y == nWall.y then
                table.insert(sharedWalls, selfWall)
            end
        end
    end
    local demoWall = sharedWalls[math.random(1, #sharedWalls)]
    self.grid[demoWall.x][demoWall.y] = tile["buildingInterior"]
end

local _demoNeighbourWalls = function(self)
    for i, room in ipairs(self.rooms) do
        while #room.neighbours ~= 0 do
            for j, neighbour in ipairs(room.neighbours) do
                Utils.tableRemove(room.neighbours, neighbour)
                Utils.tableRemove(neighbour.neighbours, room)
                _demoNeighbourWall(self, room, neighbour)
            end
        end
    end
end

local _setRoomNeighbours = function(self)
    for i, roomA in ipairs(self.rooms) do
        for x, edgeWallA in ipairs(roomA.edgeWalls) do
            for j, roomB in ipairs(self.rooms) do
                if roomA ~= roomB then
                    for y, edgeWallB in ipairs(roomB.edgeWalls) do
                        if edgeWallA.x == edgeWallB.x and edgeWallA.y == edgeWallB.y then
                            if not Utils.tableContains(roomA.neighbours, roomB) then
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

local _printRoomStatus = function(self)
    for i, room in ipairs(self.rooms) do
        io.write("Room number: " .. room.number .. "\n")
        io.write("Room centre: " .. room.x + room.w / 2 .. "-" .. room.y + room.h / 2 .. "\n")
        for j, wall in ipairs(room.cornerWalls) do
            io.write("Room number: " .. i .. " Wall at: " .. room.cornerWalls[j].x .. "-" .. room.cornerWalls[j].y .. "\n")
        end
        for j, wall in ipairs(room.edgeWalls) do
            io.write("Room number: " .. i .. " Wall at: " .. room.edgeWalls[j].x .. "-" .. room.edgeWalls[j].y .. "\n")
        end
    end
end

--[[
    x and y represent top-left corner coord
--]] 
local function _splitRoom(self, x, y, w, h, minRoomSize)
    iteration = iteration + 1
    local minRoomSize = minRoomSize or 10
    local prob = bsp_rng:random(100)
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

    local prob2 = bsp_rng:random(100)
    -- TODO remove hard-coded values
    if max < minRoomSize or iteration > 2 and prob2 < 35 then
        _createFinalRoom(self, x, y, w, h)
        return
    end

    local split = love.math.random(minRoomSize, max)

    if splitH then
        self:_createRoom(x, y + split, w, h - split)
        iteration = 0
        self:_createRoom(x, y, w, split)
        iteration = 0
    else
        self:_createRoom(x + split, y, w - split, h)
        iteration = 0
        self:_createRoom(x, y, split, h)
        iteration = 0
    end

    return true

end

local function _addOuterDoor(self, entranceLevel)
    local prob = bsp_rng:random(100)
    if prob < 25 then
        self.grid[1][math.random(2, self.h - 1)] = tile["doorLevel" .. entranceLevel]
    elseif prob < 50 then
        self.grid[self.w][math.random(2, self.h - 1)] = tile["doorLevel" .. entranceLevel]
    elseif prob < 75 then
        self.grid[math.random(2, self.w - 1)][1] = tile["doorLevel" .. entranceLevel]
    else
        self.grid[math.random(2, self.w - 1)][self.h] = tile["doorLevel" .. entranceLevel]
    end
end

bspBuilding.create = function(x, y, w, h, minRoomSize, entranceLevel)
    local inst = {}

    inst.grid = {}
    inst.rooms = {}
    inst.x = x
    inst.y = y
    inst.w = w
    inst.h = h
    inst.minRoomSize = minRoomSize or 5
    inst.entranceLevel = entranceLevel or 1
    inst.numIterations = 0

    _createOuterWalls(inst)

    inst._createRoom = _createRoom
    inst._splitRoom = _splitRoom

    _createRoom(inst, 1, 1, w - 1, h - 1)
    _setRoomNeighbours(inst)
    -- _demoWalls(inst)
    -- _demoRoomWalls(inst)
    _demoNeighbourWalls(inst)
    _setRoomNeighbours(inst)
    -- _printRoomStatus(inst)

    _addOuterDoor(inst, entranceLevel)

    return inst
end

return bspBuilding