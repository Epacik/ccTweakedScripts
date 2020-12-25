os.loadAPI("/usr/apis/epatLibTurtle")
local trt = epatLibTurtle

local names = {
    wheat = "minecraft:wheat",
    bread = "minecraft:bread"
} 

local function timer(sec)
    _G.sleep(sec)
end



trt.SetMainLoopCallback(function ()
    timer(30);

    print("remobing bread from eq");
    for i = 1, 16, 1 do
        turtle.select(i)
        local item = turtle.getItemDetail();
        if item ~= nil and item.name == names.bread then
            turtle.dropUp();
        end
    end

    print("counting wheat");

    local wheatCount = 0;
    for i = 1, 16, 1 do
        turtle.select(i)
        local item = turtle.getItemDetail();
        if item ~= nil and item.name == names.wheat then
            wheatCount = wheatCount + item.count;
        end
    end
    print(wheatCount);

    if wheatCount < 3 then
        print("Getting more wheat")
        turtle.suck()
    elseif wheatCount > 192 then
        print("removing excess wheat from eq")

        local wheatToThrow = wheatCount - 192;
        for i = 1, 16, 1 do
            turtle.select(i)
            local item = turtle.getItemDetail();
            if item ~= nil and item.name == names.wheat then
                if(wheatToThrow > 64) then 
                    wheatToThrow = wheatToThrow - 64;
                    turtle.dropUp()
                else
                    wheatToThrow = 0
                    turtle.dropUp(wheatToThrow)
                end
                
            end
        end
    end

    print("counting wheat");
    wheatCount = 0;
    for i = 1, 16, 1 do
        turtle.select(i)
        local item = turtle.getItemDetail();
        if item ~= nil and item.name == names.wheat then
            wheatCount = wheatCount + item.count;
        end
    end
    print(wheatCount);

    print("amount of bread that can be made")
    local breadAmount = math.floor(wheatCount / 3);
    print(breadAmount);

    print("mmaking a recipe")
    for i = 1, 16, 1 do
        turtle.select(i)
        if( not turtle.transferTo(1) and not turtle.transferTo(2)) then
            turtle.transferTo(3)
        end
    end
    local posCounts = {};
    turtle.select(1)
    posCounts[1] = turtle.getItemCount();
    turtle.select(2)
    posCounts[2] = turtle.getItemCount();
    turtle.select(3)
    posCounts[3] = turtle.getItemCount();

    if breadAmount ~= 64 then
        if posCounts[2] < breadAmount then
            local mss = breadAmount - posCounts[2];
            turtle.select(1);
            turtle.transferTo(2, mss);
        end

        if posCounts[3] < breadAmount then
            local mss = breadAmount - posCounts[3];
            turtle.select(1);
            turtle.transferTo(3, mss);
        end

        if posCounts[1] < breadAmount then
            local mss = breadAmount - posCounts[1];
            turtle.select(2);
            turtle.transferTo(1, mss);
        end
    end
    
    turtle.craft();


    
end)



trt.Run()
