local args = {...}

local filename = function()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("^.*/(.*).lua$") or str
end

local function PrintHelp()
    print("Usage:");
    print(filename() .. " [pastebinId] [filename]")
end

local function Update()
    fs.delete(arg[2]);
    shell.run("pastebin get " .. arg[1] .. " " .. arg[2]);
end

if(args[1] == "help" or args[1] == "--help" or args[1] == "-h") then
    PrintHelp();
elseif (type(args[1]) == "string" and type(args[2]) == "string") then
    Update();
else
    PrintHelp();
end
