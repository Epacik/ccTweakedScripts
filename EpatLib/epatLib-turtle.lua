local TurtleFuels = {
    "minecraft:coal_block",
    "minecraft:coal",
    "minecraft:charcoal",
    "mekanism:block_charcoal",
}
local function Refuel()
    local fl = turtle.getFuelLevel();
    if fl < 20 then
        local coalAvailable = false;
        local coalId = 1;
        for i = 1, 16, 1 do
            turtle.select(i)
            local item = turtle.getItemDetail()

            if (item ~= nil) then
                if(
                    item["name"] == "minecraft:coal" or
                    item["name"] == "minecraft:coal_block" or
                    item["name"] == "minecraft:charcoal" or
                    item["name"] == "mekanism:block_charcoal" ) then
                        coalAvailable = true;
                        coalId = i;
                        break;
                    end
            end
        end

        if( coalAvailable) then
            turtle.select(coalId)
            turtle.refuel(1)
            turtle.select(1)
        else

            --goBackAndLowFuelAlarm()
        end
    elseif fl == 0 then
        local coalAvailable = false;
        local coalId = 0;
        local showMsg = true;
        while true do
            for i = 1, 16, 1 do
                turtle.select(i)
                local item = turtle.getItemDetail()

                if (item ~= nil) then
                    if(
                        item["name"] == "minecraft:coal" or
                        item["name"] == "minecraft:coal_block" or
                        item["name"] == "minecraft:charcoal" or
                        item["name"] == "mekanism:block_charcoal" ) then
                            coalAvailable = true;
                            coalId = i;
                            break;
                        end
                end
            end
            if coalAvailable then 
                break;
            elseif showMsg then
                print("Add fuel to continue")
                showMsg = true;
            end
        end

        if(coalAvailable) then
            turtle.select(coalId)
            turtle.refuel(1)
            turtle.select(1)
        end
    end

end

function Main()
    Refuel();
end




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
        if (type(turtle) ~= "nil") then
           Refuel();
        end
    
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
