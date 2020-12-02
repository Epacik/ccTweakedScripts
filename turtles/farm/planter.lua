local EndBlockName = "minecraft:smooth_stone"
local CannotPlantBlockName = "minecraft:cobblestone"

local Tasks = {
    Checking = 1,
    Planting = 2,
}

local Task = Tasks.Planting;



local function DoAThing()
    print("a thing")
    
    if Task == Tasks.Planting and CanIPlant() then
        turtle.turnLeft()
        turtle.turnRight()
    elseif Task == Tasks.Checking then
        print ("checking")
    end
end

local function CheckIfEnd()
    
end

local function CanIPlant()
    local canIPlant = turtle.inspectDown()
    local isMiddle = turtle.inspectUp()

    print(canIPlant)
    print(isMiddle)

    return not canIPlant and not isMiddle;
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
        
        turtle.turnRight()
        turtle.forward()
        turtle.turnRight()

        while turtle.forward() do
            DoAThing()
        end
    
        turtle.turnLeft()
        turtle.forward()
        turtle.turnLeft()

        while turtle.forward() do
            DoAThing()
        end
    end
end

HomingSequence()