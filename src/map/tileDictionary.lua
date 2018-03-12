local tileDictionary = {}

tileDictionary["caveWall"] = {
    walkable = false,
    colour = { 31, 31, 31, 255 }
}

tileDictionary["ground"] = {
    walkable = true,
    colour = { 137, 127, 63, 255 }
}

tileDictionary["buildingInterior"] = {
    walkable = true,
    colour = { 137, 127, 63, 255 }
}

tileDictionary["buildingOuterWall"] = {
    walkable = false,
    colour = { 15, 47, 47, 255 }
}

tileDictionary["doorLevel1"] = {
    walkable = false,
    colour = { 255, 0, 0, 255}
}

tileDictionary["doorLevel2"] = {
    walkable = false,
    colour = { 247, 84, 0, 255}
}

tileDictionary["doorLevel2"] = {
    walkable = false,
    colour = { 247, 255, 0, 255}
}

tileDictionary["doorLevel3"] = {
    walkable = false,
    colour = { 0, 216, 13, 255}
}

tileDictionary["doorLevel4"] = {
    walkable = false,
    colour = { 113, 75, 255, 255}
}

tileDictionary["doorLevel5"] = {
    walkable = false,
    colour = { 222, 58, 255, 255}
}

tileDictionary["doorLevel6"] = {
    walkable = false,
    colour = { 0, 191, 191, 255}
}

tileDictionary["doorLevel7"] = {
    walkable = false,
    colour = { 149, 144, 149, 255}
}

tileDictionary["doorLevel8"] = {
    walkable = false,
    colour = { 255, 255, 255, 255}
}

tileDictionary["doorLevel9"] = {
    walkable = false,
    colour = { 210, 155, 191, 255}
}

tileDictionary["doorLevel10"] = {
    walkable = false,
    colour = { 206, 203, 206, 255}
}

return tileDictionary