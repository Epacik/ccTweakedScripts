os.loadAPI("/usr/apis/epatLibTurtle")
local trt = epatLibTurtle

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
    while turtle.down() do
        local x, y = turtle.inspectDown()
        if x and y.name == "minecraft:lava" then 
            break;
        end
    end
    for i = 1, 16, 1 do
        turtle.select(i);
        local item = turtle.getItemDetail();
        if(item ~= nil and item["name"] == "minecraft:wheat_seeds") then
            turtle.dropDown();
        end
    end
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
    timer(60);
    Collect();
    LeaveSeeds();

    leaveRestOfItems();
end)

local function AmImLost()
    local exists, item = turtle.inspectDown();
    if (not exists) then
        while turtle.down() do end
    end

    exists, item = turtle.inspectDown();

    if(exists and item.name == "minecraft:lava") then
        return
    elseif (exists) then
        while turtle.back() do end
    end
    turtle.turnLeft();
    exists, item = turtle.inspect();
    if(exists) then turtle.turnRight(); end
end

AmImLost()

trt.Run()

