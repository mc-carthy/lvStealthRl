local TileDictionary = {}

TileDictionary['interiorWall'] = {
    collidable = true,
    importColour = { 0, 0, 0, 1 },
    sprite = SPRITES.stoneTile,
    tintColour = { 0.75, 0.75, 0.75, 1 },
    drawColour = { 0.5, 0.5, 0.5, 1 }
}

TileDictionary['stoneWall'] = {
    collidable = true,
    importColour = { 0, 0, 1, 1 },
    sprite = SPRITES.stoneTile,
    tintColour = { 0.75, 0.75, 0.75, 1 },
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

return TileDictionary