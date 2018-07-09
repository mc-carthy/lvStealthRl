local bresenham = require("src.utils.bresenham")

local function bresLos(x0,y0,x1,y1,callback)
    bresenham.los(x0,y0,x1,y1,callback)
end

local function bresLine(x0,y0,x1,y1,callback)
    bresenham.line(x0,y0,x1,y1,callback)
end

return {
    los = bresLos,
    line = bresLine
}