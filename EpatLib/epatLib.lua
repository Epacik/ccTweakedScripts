local mcb = function() end
local brkClbc 


function SetMainLoopCallback(callback)
    if(type(callback) == "function") then mcb = callback end
end

function SetBreakCallback(callback)
    if(type(callback) == "function") then brkClbc = callback end
end
 
local function MainLoop()
    while true do
    
        mcb()

        os.queueEvent("randomEvent")
        os.pullEvent()


        if brkClbc ~= nil and brkClbc() then
            break;
        end
    end
end

function Run()
    MainLoop();
end