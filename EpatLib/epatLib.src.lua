local TurtleLib = require("./turtleLib.src")

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
 end


function SetMainLoopCallback(callback)
    if(type(callback) == "function") then mcb = callback end
end

local mcb = function() end





local function MainLoop()
    while true do
        if (type(turtle) ~= "nil") then
            TurtleLib.Turtle()
        end
    
        mcb()
    end
end

MainLoop();