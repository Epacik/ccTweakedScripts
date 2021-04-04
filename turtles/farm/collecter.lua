os.loadAPI("/usr/apis/epatLibTurtle")
local trt = epatLibTurtle
local Seeds = "minecraft:wheat_seeds"
local side = "right"

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
        if(item ~= nil and item["name"] == Seeds) then
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
        if(item ~= nil and item["name"] == Seeds) then
            turtle.dropDown();
        end
    end
end

local function leaveRestOfItems()
    --go to chest
    if side == "right" then
        turtle.turnRight();
    else
        turtle.turnLeft()
    end

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
    while turtle.down() do
        local x, y = turtle.inspectDown()
        if x and y.name == "minecraft:lava" then 
            break;
        end
     end
    while turtle.back() do end
    if side == "right" then
        turtle.turnLeft();
    else
        turtle.turnRight()
    end
end


local function LoadCfg()
    local names = { 
        side = "side"; 
        seeds = "seeds";
    }
    
    if fs.exists("/cfg/collecter.cfg") then
        settings.load("/cfg/collecter.cfg");

        side = settings.get(names.side, side);
        Seeds = settings.get(names.seeds, Seeds);

        settings.save("/cfg/collecter.cfg");

    else
        fs.makeDir("/cfg");

        settings.set(names.side, side);
        settings.set(names.seeds, Seeds);

        settings.save("/cfg/collecter.cfg");

    end

end

LoadCfg()

trt.SetMainLoopCallback(function ()
    timer(60);
    Collect();
    LeaveSeeds();

    leaveRestOfItems();
end)

local function AmImLost()
    local exists, item = turtle.inspectDown();
    if (not exists) then
        while turtle.down() do
            local x, y = turtle.inspectDown()
            if x and y.name == "minecraft:lava" then 
                break;
            end
        end
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

