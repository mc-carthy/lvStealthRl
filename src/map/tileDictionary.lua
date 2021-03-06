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
    importColour = { 0.25, 0.25, 0, 1 },
    drawColour = { 0.1, 0.1, 0.1, 1 }
}

TileDictionary['exteriorFloor'] = {
    collidable = false,
    -- TODO: Temp fix for player/enemy placement, switch with interior floor after map image is changed
    importColour = { 1, 1, 1, 1 },
    -- tintColour = { 0.5, 0.5, 0, 0.5 },
    sprite = SPRITES.sandTile,
    drawColour = { 0.25, 0.25, 0, 1 }
}

TileDictionary["doorLevel1"] = {
    collidable = true,
    pathable = true,
    drawColour = { 255 / 255, 0, 0, 255 / 255}
}

-- TODO: Investigate duplication here
TileDictionary["doorLevel2"] = {
    collidable = true,
    pathable = true,
    drawColour = { 247 / 255, 84 / 255, 0, 255 / 255}
}

TileDictionary["doorLevel2"] = {
    collidable = true,
    pathable = true,
    drawColour = { 247 / 255, 255 / 255, 0, 255 / 255}
}

TileDictionary["doorLevel3"] = {
    collidable = true,
    pathable = true,
    drawColour = { 0, 216 / 255, 13 / 255, 255 / 255}
}

TileDictionary["doorLevel4"] = {
    collidable = true,
    pathable = true,
    drawColour = { 113 / 255, 75 / 255, 255 / 255, 255 / 255}
}

TileDictionary["doorLevel5"] = {
    collidable = true,
    pathable = true,
    drawColour = { 222 / 255, 58 / 255, 255 / 255, 255 / 255}
}

TileDictionary["doorLevel6"] = {
    collidable = true,
    pathable = true,
    drawColour = { 0, 191 / 255, 191 / 255, 255 / 255}
}

TileDictionary["doorLevel7"] = {
    collidable = true,
    pathable = true,
    drawColour = { 149 / 255, 144 / 255, 149 / 255, 255 / 255}
}

TileDictionary["doorLevel8"] = {
    collidable = true,
    pathable = true,
    drawColour = { 255 / 255, 255 / 255, 255 / 255, 255 / 255}
}

TileDictionary["doorLevel9"] = {
    collidable = true,
    pathable = true,
    drawColour = { 210 / 255, 155 / 255, 191 / 255, 255 / 255}
}

TileDictionary["doorLevel10"] = {
    collidable = true,
    pathable = true,
    drawColour = { 206 / 255, 203 / 255, 206 / 255, 255 / 255}
}

TileDictionary["exit"] = {
    collidable = false,
    pathable = true,
    drawColour = { 255 / 255, 0, 255 / 255, 255 / 255 }
}

return TileDictionary