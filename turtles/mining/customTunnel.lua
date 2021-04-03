os.loadAPI("/usr/apis/epatLibTurtle")
local trt = epatLibTurtle

local args = {...}




-- convert arguments to dimentions 
local width = tonumber(args[1]);
local height = tonumber(args[2]);
local depth = tonumber(args[3]);

local function DigRow()
    local left = 0;
    local right = 0;
    if width > 1 then
        if math.fmod(width, 2) == 0 then
            -- divisible by 2
            left = width / 2;
            right = (width / 2) - 1;
        else
            -- not divisible by 2
            left = (width - 1) / 2;
            right = (width - 1) / 2;
        end
    else 
        return
    end


    -- for now width is always 3
    turtle.turnLeft();

    for i = 1, left - 1, 1 do
        while turtle.dig() do end
        if i + 1 < left then turtle.forward(); end
    end

    for i = 1, left - 1, 1 do
        turtle.back()
    end
    

    turtle.turnRight();
    turtle.turnRight();

    for i = 1, right - 1, 1 do
        while turtle.dig() do end
        if i + 1 < right then turtle.forward(); end
        
    end

    for i = 1, right - 1, 1 do
        turtle.back()
    end

    turtle.turnLeft();
    

end

local getFuelInfo = false;

local function Main()
    if( turtle.getFuelLevel() == 0 and not getFuelInfo) then
        print("Add fuel to continue");
        getFuelInfo = true;
        return;
    elseif getFuelInfo and turtle.getFuelLevel() > 0 then
        print("continuing")
        getFuelInfo = false;
    end

    if( arg[4] ~= nil and arg[4] == "--placeBlocks") then 
        turtle.placeDown();
    end

    for h = 1, height, 1 do
        DigRow();
        if h < height then
            while turtle.digUp() do end
            turtle.up();
        end
    end

    for h = 1, height - 1, 1 do
        turtle.down();
    end

    

    depth = depth - 1;

    if(depth >= 1) then 
        while turtle.dig() do end
        turtle.forward();
    end
end

if(args[1] == "--help" or width == nil or width == 0 or height == nil or height == 0 or depth == nil or depth == 0) then 
        print("usages: ")
        print(shell.getRunningProgram() .. " <width:number> <height:number> <depth:number>")
        print(shell.getRunningProgram() .. " <width:number> <height:number> <depth:number> --placeBlocks")
else
    turtle.dig();
    turtle.forward();

    trt.SetMainLoopCallback(function ()
        Main();
    end);

    trt.SetBreakCallback(function () 
        if depth <= 0 then 
            return true;
        else
            return false;
        end
    end);

    trt.Run()
end

