local trt = require("usr.apis.epatLib-turtle")

local function timer(sec)
    _G.sleep(sec)
end

local function Collect()
    while turtle.forward() do
        local x, item = turtle.inspectUp();

        if(x == true and item["name"] == "minecraft:hopper") then
            while turtle.suckUp() do end
        end
    end
    while turtle.back() do end
end

local function LeaveSeeds()
    while turtle.up() do end
    for i = 1, 16, 1 do
        turtle.select(i);
        local item = turtle.getItemDetail();
        if(item ~= nil and item["name"] == "minecraft:wheat_seeds") then
            turtle.dropUp();
        end
    end
    while turtle.down() do end
end

local function leaveRestOfItems()
    --go to chest
    turtle.turnRight();
    while turtle.forward() do end
    while turtle.up() do end

    --drop items
    for i = 1, 16, 1 do
        turtle.select(i);
        local item = turtle.getItemDetail();
        if(item ~= nil) then
            turtle.dropUp();
        end
    end

    --go back
    while turtle.down() do end
    while turtle.back() do end
    turtle.turnLeft();
end

trt.SetMainLoopCallback(function ()
    timer(5);
    if (redstone.getInput("back")) then
        Collect();
        LeaveSeeds();
        leaveRestOfItems();
    end
end)

