local TileDictionary = {}

TileDictionary['interiorBuildingWall'] = {
    collidable = true,
    importColour = { 0, 0, 0, 1 },
    sprite = SPRITES.stoneTile,
    tintColour = { 0.75, 0.75, 0.75, 1 },
    drawColour = { 0.5, 0.5, 0.5, 1 }
}

TileDictionary['exteriorBuildingWall'] = {
    collidable = true,
    importColour = { 0, 0, 1, 1 },
    sprite = SPRITES.stoneTile,
    tintColour = { 0.5, 0.5, 0.5, 1 },
    drawColour = { 0, 0.5, 0.5, 1 }
}

TileDictionary['exteriorWall'] = {
    collidable = true,
    importColour = { 0, 0, 1, 1 },
    sprite = SPRITES.stoneTile,
    tintColour = { 0.25, 0.25, 0.25, 1 },
    drawColour = { 0, 0.5, 0.5, 1 }
}

TileDictionary['interiorFloor'] = {
    collidable = false,
    importColour = { 1, 1, 1, 1 },
    drawColour = { 0.1, 0.1, 0.1, 1 }
}

TileDictionary['exteriorFloor'] = {
    collidable = false,
    importColour = { 0.25, 0.25, 0, 1 },
    -- tintColour = { 0.5, 0.5, 0, 0.5 },
    sprite = SPRITES.sandTile,
    drawColour = { 0.25, 0.25, 0, 1 }
}

TileDictionary["doorLevel1"] = {
    walkable = false,
    pathable = true,
    drawColour = { 255, 0, 0, 255}
}

-- TODO: Investigate duplication here
TileDictionary["doorLevel2"] = {
    walkable = false,
    pathable = true,
    drawColour = { 247, 84, 0, 255}
}

TileDictionary["doorLevel2"] = {
    walkable = false,
    pathable = true,
    drawColour = { 247, 255, 0, 255}
}

TileDictionary["doorLevel3"] = {
    walkable = false,
    pathable = true,
    drawColour = { 0, 216, 13, 255}
}

TileDictionary["doorLevel4"] = {
    walkable = false,
    pathable = true,
    drawColour = { 113, 75, 255, 255}
}

TileDictionary["doorLevel5"] = {
    walkable = false,
    pathable = true,
    drawColour = { 222, 58, 255, 255}
}

TileDictionary["doorLevel6"] = {
    walkable = false,
    pathable = true,
    drawColour = { 0, 191, 191, 255}
}

TileDictionary["doorLevel7"] = {
    walkable = false,
    pathable = true,
    drawColour = { 149, 144, 149, 255}
}

TileDictionary["doorLevel8"] = {
    walkable = false,
    pathable = true,
    drawColour = { 255, 255, 255, 255}
}

TileDictionary["doorLevel9"] = {
    walkable = false,
    pathable = true,
    drawColour = { 210, 155, 191, 255}
}

TileDictionary["doorLevel10"] = {
    walkable = false,
    pathable = true,
    drawColour = { 206, 203, 206, 255}
}

return TileDictionary