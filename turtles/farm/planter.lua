os.loadAPI("/usr/apis/epatLibTurtle")
local trt = epatLibTurtle

local EndBlockName = "minecraft:smooth_stone"
local CannotPlantBlockName = "minecraft:cobblestone"
local StartBlock = "mekanism:block_osmium"
local Seeds = "minecraft:wheat_seeds"
local Crop = "minecraft:wheat"
local SideWall = "minecraft:cobblestone"
local EndWall = "minecraft:stone"
local GrowthBoundary = 6.95

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

    if (item == nil or item["name"] ~= Seeds) then
        for i = 1, 16, 1 do
            turtle.select(i);
            item = turtle.getItemDetail();
            if(item ~= nil and item["name"] == Seeds) then
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
    if(x and item.name == Crop) then
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

local function AmILost()
    
    if(not IsHomePos()) then 
        local goBack1 = false;
        local goBack2 = false;
        while turtle.forward() do
            if turtle.inspectUp() and  turtle.inspect() then
                local x, y = turtle.inspect();
                local x1, y1 = turtle.inspectUp();
                if x and (y.name == "minecraft:piston_head" or  y.name == SideWall) then
                    goBack1 = true;
                    break
                elseif x and y.name == EndWall then
                    goBack2 = true;
                    break;
                elseif x1 and y1.name == StartBlock then
                    turtle.turnLeft();
                    turtle.turnLeft();
                    return;
                end
            end
        end

        local pistonLeft = false;
        local pistonRight = false;
        if(goBack1) then
            turtle.turnRight();
            pistonLeft = true;
            while turtle.forward() do 
            end

            local x, y = turtle.inspectUp();
            if(x and y.name == EndBlockName) then
                turtle.turnLeft();

                GoBack(Directions.Left)
            else
                turtle.turnLeft();

                GoBack(Directions.Right)
            end
        elseif(goBack2) then
            while turtle.back() do
                local x1, y1 = turtle.inspectUp();
                if x1 and y1.name == StartBlock then
                    return;
                end
            end

        end
    end

end

local function Main()
    AmILost()

    States = {};
    StatesAmount = 0;

    Task = Tasks.Checking;
    HomingSequence();
    if CalculateGrowth() > GrowthBoundary then
        redstone.setOutput("top", true);
        timer(5)
        redstone.setOutput("top", false);

        local stacksInInv = 0;
        for i = 1, 16, 1 do
            turtle.select(i);
            local item = turtle.getItemDetail();
            if(item ~= nil and item["name"] == Seeds) then
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

local function LoadCfg()
    local names = { 
        crop = "crop"; 
        seeds = "seeds"; 
        endBlock = "endBlock";
        startBlock = "startBlock";
        growthBoundary = "growthBoundary";
        endWall = "endWall";
        sideWall = "sideWall";
        cantPlant = "cantPlant";
    }
    
    if fs.exists("/cfg/planter.cfg") then
        settings.load("/cfg/planter.cfg");

        Crop = settings.set(names.crop, Crop);
        Seeds = settings.set(names.seeds, Seeds);
        EndBlockName = settings.set(names.endBlock, EndBlockName);
        StartBlock = settings.set(names.startBlock, StartBlock);
        GrowthBoundary = settings.set(names.growthBoundary, GrowthBoundary);
        EndWall = settings.set(names.endWall, EndWall);
        SideWall = settings.set(names.sideWall, SideWall);
        CannotPlantBlockName = settings.set(names.cantPlant, CannotPlantBlockName);
        print("cfg")

        print(names.crop)
        print(Crop)

        print(names.seeds)
        print(Seeds)

        print(names.endBlock)
        print(EndBlockName)

        print(names.startBlock)
        print(StartBlock)

        print(names.growthBoundary)
        print(GrowthBoundary)

        print(names.endWall)
        print(EndWall)

        print(names.sideWall)
        print(SideWall)

        print(names.cantPlant)
        print(CannotPlantBlockName)

        settings.save("/cfg/planter.cfg");

    else
        fs.makeDir("/cfg");

        settings.set(names.crop, Crop);
        settings.set(names.seeds, Seeds);
        settings.set(names.endBlock, EndBlockName);
        settings.set(names.startBlock, StartBlock);
        settings.set(names.growthBoundary, GrowthBoundary);
        settings.set(names.endWall, EndWall);
        settings.set(names.sideWall, SideWall);
        settings.set(names.cantPlant, CannotPlantBlockName);

        settings.save("/cfg/planter.cfg");

    end

end

LoadCfg();

trt.SetMainLoopCallback(function ()
    Main()
end)

trt.Run()