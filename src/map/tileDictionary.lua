local tileDictionary = {}

tileDictionary["caveWall"] = {
    walkable = false,
    colour = { 63, 31, 17, 255 }
}

tileDictionary["ground"] = {
    walkable = true,
    colour = { 255, 191, 159, 255 }
}

tileDictionary["buildingOuterWall"] = {
    walkable = false,
    colour = { 31, 31, 31, 255 }
}

-- TODO: Make a new table for each level door, have the player change the value
-- of walkable when the player card level is greater than the door card level
tileDictionary["doorLevel1"] = {
    walkable = false,
    colour = { 0, 191, 191, 255}
}

return tileDictionary