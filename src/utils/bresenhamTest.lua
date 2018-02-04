local bresenham = require("src.utils.bresenham")

local map = {
  {'#','#','#','#','#','#','#','#'},
  {'#','A',' ',' ',' ','B',' ','#'},
  {'#',' ',' ',' ',' ',' ',' ','#'},
  {'#',' ',' ',' ','#','#','#','#'},
  {'#',' ',' ',' ',' ',' ',' ','#'},
  {'#',' ',' ',' ',' ','G',' ','#'},
  {'#',' ',' ',' ',' ',' ',' ','#'},
  {'#','#','#','#','#','#','#','#'},
}

local function printMap()
  print()
  for x=1,8 do
    print(table.concat(map[x]))
  end
  print()
end

print "Initial map:"

printMap()

local A = bresenham.los(2,2,6,6, function(x,y)
  if map[x][y] == '#' then return false end
  map[x][y] = 'A'
  return true
end)

if A then print("Straight line for A was found:") end

printMap()

local B = bresenham.los(2,6,6,6, function(x,y)
  if map[x][y] == '#' then
    map[x][y] = 'X'
    return false
  end
  map[x][y] = 'B'
  return true
end)

if not B then print("Straight line for B was not found:") end

printMap()