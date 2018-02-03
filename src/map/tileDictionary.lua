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
    colour = { 31, 31, 31 }
}

return tileDictionary