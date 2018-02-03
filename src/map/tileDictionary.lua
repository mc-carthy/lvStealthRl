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

tileDictionary["buildingOuterDoor"] = {
    walkable = true,
    colour = { 0, 191, 191, 255}
}

return tileDictionary