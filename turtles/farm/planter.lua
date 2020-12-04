local EndBlockName = "minecraft:smooth_stone"
local CannotPlantBlockName = "minecraft:cobblestone"
local StartBlock = "mekanism:block_osmium"

local Tasks = {
    Checking = 1,
    Planting = 2,
}

local Task = Tasks.Planting;

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

local function DoAThing()
    

    if Task == Tasks.Planting and CanIPlant() then
        print("planting")
        Plant();
        
    elseif Task == Tasks.Checking then
        print ("checking")
    end
end

local function CheckIfEnd()
    local exists, item = turtle.inspectUp();
    if(exists and item.name == EndBlockName) then
        print("found end block");
        return true;
    else
        print("found end block")
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

HomingSequence()