local TurtleFuels = {
    "minecraft:coal_block",
    "minecraft:coal",
    "minecraft:charcoal",
    "mekanism:block_charcoal",
}
local function Refuel()
    if turtle.getFuelLevel() < 20 then
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
            turtle.refuel()
            turtle.select(1)
        else
            --goBackAndLowFuelAlarm()
        end
    end
end



function Main()
    Refuel();
end

