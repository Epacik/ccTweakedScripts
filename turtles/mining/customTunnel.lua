os.loadAPI("/usr/apis/epatLibTurtle")
local trt = epatLibTurtle

local args = {...}




-- convert arguments to dimentions 
local width = tonumber(args[1]);
local height = tonumber(args[2]);
local depth = tonumber(args[3]);

local function DigRow()
    -- for now width is always 3
    turtle.turnLeft();

    while turtle.dig() do end

    turtle.turnRight();
    turtle.turnRight();
    while turtle.dig() do end

    turtle.turnLeft();
    

end

local function Main()

    for h = 1, height, 1 do
        while turtle.digUp() do end
        DigRow();
    end

    for h = 1, height, 1 do
        turtle.down();
    end

    

    depth = depth - 1;

    if(depth >= 1) then 
        while turtle.dig() do end
        turtle.forward();
    end
end

if(args[1] == "--help" or width == nil or height == nil or depth == nil) then 
        print("usages: ")
        print(shell.getRunningProgram() .. " <width:number> <height:number> <depth:number>")
        print(shell.getRunningProgram() .. " <width:number> <height:number> <depth:number> --placeBlocks")
else
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

