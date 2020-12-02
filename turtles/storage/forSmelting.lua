
function startupRotate()
    while turtle.inspect() == false do
        turtle.turnRight()
    end
end

startupRotate();

function timer(sec)
    _G.sleep(sec)
end

function getWhatYouCan()
    while turtle.suckUp() do
        print("sucking item")
    end
end

function goBackAndLowFuelAlarm()

end


function refuelIfNeeded()
    if turtle.getFuelLevel() < 20 then
        local coalAvailable = false
        for i = 1, 16, 1 do
            turtle.select(i)
            local item = turtle.getItemDetail()

            if (item ~= nil and item["name"] == "minecraft:coal" ) then
                coalAvailable = true;
                break;
            end
        end

        if( coalAvailable) then
            turtle.refuel()
            turtle.select(1)
        else
            goBackAndLowFuelAlarm()
        end
    end
end

function shouldIGo()
    local shouldGo = false
    for i = 1, 16, 1 do
        turtle.select(i)
        local item = turtle.getItemDetail()

        if (item ~= nil and item["name"] ~= "minecraft:coal" ) then
            shouldGo = true;
            break;
        end
    end
    return shouldGo
end

function goToSmelter()
    while turtle.back() do
        print("going back")
    end

    while turtle.up() do
        print("going up")
    end

    while turtle.forward() do
        print("going forward")
    end
end

function initSmelterRotate()
    while turtle.inspect() == false do
        turtle.turnRight()
    end
end

function goFromSmelter()
    while turtle.back() do
        print("going back")
    end

    while turtle.down() do
        print("going up")
    end

    while turtle.forward() do
        print("going forward")
    end
end

function sleepMode()
    while true do
        print("waiting")
        timer(30)

        print("checking if I can get items")

        if turtle.suckUp() then
            print("items available")
            getWhatYouCan()

        else
            print("no items available")
        end

        refuelIfNeeded()

        if shouldIGo() then


            goToSmelter();
            turtle.turnRight()
            -- local numberOfFurnances = 0
            -- while turtle.forward() do
            --     numberOfFurnances = numberOfFurnances + 1
            -- end
            -- turtle.turnRight()
            -- turtle.turnRight()
            for i = 1, 16, 1 do
                turtle.select(i)
                local item = turtle.getItemDetail()
        
                if (item ~= nil and item["name"] ~= "minecraft:coal" ) then
                    turtle.dropDown()
                    if not turtle.forward() then
                        while turtle.back() do
                            
                        end
                    end
                end
            end

            while turtle.back() do
                            
            end
            turtle.turnLeft()
            
            goFromSmelter();


            if turtle.suckUp() then
                print("items available")
                getWhatYouCan()
    
            else
                print("no items available")
            end
        end

    end
end

sleepMode()