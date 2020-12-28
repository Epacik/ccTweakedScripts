os.loadAPI("/usr/apis/epatLib");
elb = epatLib;
os.loadAPI("/usr/apis/stringLib");

local args = {...};

local function newConfig(lines, linesNumber)
    local conf = {};
    for i = 1, linesNumber, 1 do
        if(lines[i]:startsWith("IDs")) then
            local ids = lines[i]:split(":");
            if(ids[2] ~= nil) then
                conf.IDs = ids[2]:split(";");
            end
        elseif (lines[i]:startsWith("pass")) then
            conf.pass = lines[i]:split(":")[2]
        end

    end

    return conf;
end

local function GetConfig()
    local file = io.open("etc/gate.conf", "r");
    if file == nil then
        return nil;
    end
    local lines = {};
    local index = 1;
    while true do
        local line = file:read();
        if line == nil then
            break
        end
        lines[index] = line; 
        index = index + 1;
    end
    return newConfig(lines, index);
end

local function ConnectToNetwork()

    local sides = {"top", "bottom", "front", "back", "left", "right" }


    for i = 1, 6, 1 do
        if peripheral.isPresent(sides[i]) and peripheral.getType(sides[i]) == "modem" then
            rednet.open(sides[i]);
            return
        end
    end
end

local function ResetRedstone()
    local sides = {"top", "bottom", "front", "back", "left", "right" }

    for i = 1, 6, 1 do
        redstone.setOutput(sides[i], false);
    end
end

local function SetupHost()
    local host = "epGateHost";

    if args[1] ~= nil then
        host = args[1];
    end

    rednet.host("epGate", host)
end


local function containsId(IDs, id)
    id = tonumber(id)
    local contains = false;
    local index = 1;
    while true do
        if(IDs[index] == nil) then
            break;
        end
        contains = tonumber(IDs[index]) == id;
        index = index + 1;
    end

    return contains
end

local GateOpened = false;

elb.SetMainLoopCallback(function ()
    local sender, message, protocol = rednet.receive("gate");
    local conf = GetConfig();
    if (containsId(conf.IDs, sender)) then

        local mss = message:split(":")
        if conf.pass == nil and mss[2] == "open" then
            redstone.setOutput("back", true);
            GateOpened = true;
        elseif conf.pass == nil and mss[2] == "close" then
            redstone.setOutput("back", false);
            GateOpened = false;
        elseif conf.pass ~= nil and conf.pass == mss[1] and mss[2] == "open" then
            redstone.setOutput("back", true);
            GateOpened = true;
        elseif conf.pass ~= nil and conf.pass == mss[1] and mss[2] == "close" then
            redstone.setOutput("back", false);
            GateOpened = false;
        end
    end
end)

ConnectToNetwork();

ResetRedstone();

SetupHost();

elb.Run();