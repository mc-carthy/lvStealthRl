Building = Class{}

function Building:init(parentGrid, params)
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

    self:createFoundation()
end

function Building:createFoundation()
    for x = 1, self.w do
        self[x] = {}
        for y = 1, self.h do
            self[x][y] = {}
            if x == 1 or x == self.w or y == 1 or y == self.h then
                self[x][y] = TileDictionary['stoneWall']
            else
                self[x][y] = TileDictionary['interiorFloor']
            end
        end
    end
end