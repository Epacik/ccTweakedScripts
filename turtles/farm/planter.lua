os.loadAPI("/usr/apis/epatLibTurtle")
local trt = epatLibTurtle

local EndBlockName = "minecraft:smooth_stone"
local CannotPlantBlockName = "minecraft:cobblestone"
local StartBlock = "mekanism:block_osmium"

local Tasks = {
    Checking = 1,
    Planting = 2,
}

local Task = Tasks.Planting;

local function timer(sec)
_G.sleep(sec)
end


local function CanIPlant()
    local canIPlant = turtle.inspectDown()
    local isMiddle = turtle.inspectUp()

    print("Can I plant?")
    print(canIPlant)

    print("Am I in the middle?");
    print(isMiddle)

    return not canIPlant and not isMiddle;
end

local function Plant()
    local item = turtle.getItemDetail();

    if (item == nil or item["name"] ~= "minecraft:wheat_seeds") then
        for i = 1, 16, 1 do
            turtle.select(i);
            item = turtle.getItemDetail();
            if(item ~= nil and item["name"] == "minecraft:wheat_seeds") then
                break;
            end
        end
    end

    turtle.placeDown();


end

local StatesAmount = 0;
local States = {}

local function Check()
    local x, item = turtle.inspectDown();
    if(x and item.name == "minecraft:wheat") then
        StatesAmount = StatesAmount + 1;
        States[StatesAmount] = item.state.age;
    end
end

local function DoAThing()
    if Task == Tasks.Planting and CanIPlant() then
        print("planting")
        Plant();
        
    elseif Task == Tasks.Checking then
        print ("checking");
        Check();
    end
end

local function CheckIfEnd()
    local exists, item = turtle.inspectUp();
    if(exists and item.name == EndBlockName) then
        print("found end block");
        return true;
    else
        print("didn't found end block")
        return false;
    end

end

local Directions = {
    Left = 1,
    Right = 2,
}

local function GoBack(direction)
    local lost = false;
    -- if no direction is provided then it's lost
    if(direction == nil) then direction = Directions.Right; lost = true; print("I'm lost"); end

    -- go to the middle of farm
    print("going to the middle")
    while true do
        turtle.back()
        local exists, item = turtle.inspectUp();
        if(exists and item.name == CannotPlantBlockName) then
            print("I'm in the middle")
            break;
        end
    end

    print("turning")
    if (direction == Directions.Left) then
        turtle.turnLeft();
    else
        turtle.turnRight();
    end

    -- if lost then go forward, if cobble is above then go back until you see statup block, else turn around and go forward until you see startup block
    if (lost) then
        print("I'm lost, so I'm going forward");
        while turtle.forward() do
        end

        local exists, item = turtle.inspectUp();
        if item.name == CannotPlantBlockName then
            print("I'm not at the start, so I have to go back");
            while true do
                turtle.back();
                exists, item = turtle.inspectUp();
                if(exists and item.name == StartBlock) then break; end
            end
        else
            print("I'm almost at the start, I just need to turn around and get into position");
            turtle.turnLeft();
            turtle.turnLeft();
            while true do
                turtle.forward();
                exists, item = turtle.inspectUp();
                if(exists and item.name == StartBlock) then break; end
            end
        end

        print("done")

    else
        --if not lost then go back until you see startup block
        print("going back to the start");
        while true do
            turtle.back();
            local exists, item = turtle.inspectUp();
            if(exists and item.name == StartBlock) then
                break;
            end
        end
    end


end


local function HomingSequence()
    while turtle.forward() do
    end

    turtle.turnRight()

    while turtle.back() do
    end

    print("on position")

    while true do
        while turtle.forward() do
            DoAThing()
        end

        if(CheckIfEnd()) then
            print("going back");
            GoBack(Directions.Left);
            break;
        end

        turtle.turnRight()
        turtle.forward()
        turtle.turnRight()

        while turtle.forward() do
            DoAThing()
        end

        if(CheckIfEnd()) then
            print("going back");
            GoBack(Directions.Right);
            break;
        end

        turtle.turnLeft()
        turtle.forward()
        turtle.turnLeft()

        while turtle.forward() do
            DoAThing()
        end

        if(CheckIfEnd()) then
            print("going back");
            GoBack(Directions.Left);
            break;
        end
    end
end

local function CalculateGrowth()
    if StatesAmount == 0 then
        return 7;
    end
    local overallGrowth = 0;
    for i = 1, StatesAmount, 1 do
        overallGrowth = overallGrowth + States[i];
    end
    print("overall field growth")
    print(overallGrowth / StatesAmount)
    return overallGrowth / StatesAmount;
end

local function IsHomePos()
    local x, item = turtle.inspectUp();
    if not x or item.name ~= StartBlock then
        return false
    end

    -- correct rotation
    while true do
        turtle.turnLeft();
        x, item = turtle.inspect();
        if(x) then
            break;
        end
    end
    turtle.turnRight();

    return true;
end

local function GoBackHome()
    local px, pitem = false, nil;
    while not IsHomePos() do
        turtle.forward();
        local x, item = turtle.inspect();

        if x and item.name == "minecraft:piston_head" then
            turtle.turnLeft();
            turtle.turnLeft();
            turtle.forward();
        elseif x and item.name == "minecraft:stone_bricks" then
            turtle.turnLeft();
        elseif x and item.name == CannotPlantBlockName then
            turtle.turnLeft();
        elseif x and item.name == "minecraft:stone" then
            local x1, item1 = turtle.inspectUp();
            if x1 then
                turtle.turnLeft();
                turtle.turnLeft();
            else
                turtle.turnLeft();
            end
        end
        x, item = turtle.inspectUp();
        if(x and not px) then
            turtle.turnLeft();
        end

        px = x;
        pitem = item;


    end
end

local function Main()
    if not IsHomePos() then
        GoBackHome();
    end

    States = {};
    StatesAmount = 0;

    Task = Tasks.Checking;
    HomingSequence();
    if CalculateGrowth() > 6.5 then
        redstone.setOutput("top", true);
        timer(5)
        redstone.setOutput("top", false);

        local stacksInInv = 0;
        for i = 1, 16, 1 do
            turtle.select(i);
            local item = turtle.getItemDetail();
            if(item ~= nil and item["name"] == "minecraft:wheat_seeds") then
                stacksInInv = stacksInInv + 1;
            end
        end
        if stacksInInv < 16 then
            for i = 1, 16 - stacksInInv , 1 do
                turtle.suckDown()
            end
        end

        Task = Tasks.Planting;
        HomingSequence();
    end
    timer(60)
end

trt.SetMainLoopCallback(function ()
    Main()
end)

trt.Run()