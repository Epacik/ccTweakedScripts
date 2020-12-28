os.loadAPI("/usr/apis/epatLib");
elb = epatLib;
os.loadAPI("/usr/apis/stringLib");

local args = {...};

local function newConfig(lines, linesNumber)
    print("Parsing config");
    local conf = {};
    for i = 1, linesNumber, 1 do
        print("parsing line: ");
        print(lines[i]);

        if(lines[i]:startsWith("IDs")) then
            local ids = lines[i]:split(":");
            if(ids[2] ~= nil) then
                print("ids");
                print(ids[2]);
                conf.IDs = ids[2]:split(";");
            end
        elseif (lines[i]:startsWith("pass")) then
            print("pass");
            print(lines[i]:split(":")[2]);
            conf.pass = lines[i]:split(":")[2];
        end

    end

    return conf;
end

local function GetConfig()
    print("Opening config file");
    local file = io.open("/etc/gate.conf", "r");
    if file == nil then
        print("configfile doesn't exist")
        return nil;
    end

    print("Reading lines");
    local lines = {};
    local index = 1;
    while true do
        print("Line no" .. tostring(index));
        local line = file:read();
        if line == nil then
            print("EOF");
            break
        end
        print("Current line");
        print(line);

        lines[index] = line;
        index = index + 1;
    end
    return newConfig(lines, index);
end

local function ConnectToNetwork()

    print("Enabling modem");
    local sides = {"top", "bottom", "front", "back", "left", "right" }


    for i = 1, 6, 1 do
        if peripheral.isPresent(sides[i]) and peripheral.getType(sides[i]) == "modem" then
            print(sides[i]);
            rednet.open(sides[i]);
            return
        end
    end
end

local function ResetRedstone()
    print("Reseting redstone");
    local sides = {"top", "bottom", "front", "back", "left", "right" }

    for i = 1, 6, 1 do
        print(sides[i]);
        redstone.setOutput(sides[i], false);
    end
end

local function SetupHost()
    print("setting up host")
    local host = "epGateHost";

    if args[1] ~= nil then
        host = args[1];
    end

    print("protocol: epGate, hostname: " .. host);
    rednet.host("epGate", host)
end


local function containsId(IDs, id)

    id = tonumber(id)
    local index = 1;
    while true do
        if(IDs[index] == nil) then
            break;
        end
        local contains = tonumber(IDs[index]) == id;
        print("found ID: " .. tostring(contains));
        if contains then
            return true;
        end
        index = index + 1;
    end

    return false;
end

local GateOpened = false;

elb.SetMainLoopCallback(function ()
    print("waiting");
    local sender, message, protocol = rednet.receive("gate");
    print("Got a message");
    local conf = GetConfig();
    if (containsId(conf.IDs, sender)) then

        local mss = message:split(":")
        if conf.pass == nil and mss[2] == "open" then
            print("Opening");
            redstone.setOutput("back", true);
            GateOpened = true;
        elseif conf.pass == nil and mss[2] == "close" then
            print("Closing");
            redstone.setOutput("back", false);
            GateOpened = false;
        elseif conf.pass ~= nil and conf.pass == mss[1] and mss[2] == "open" then
            print("Opening");
            redstone.setOutput("back", true);
            GateOpened = true;
        elseif conf.pass ~= nil and conf.pass == mss[1] and mss[2] == "close" then
            print("Closing");
            redstone.setOutput("back", false);
            GateOpened = false;
        end
    end
end)

ConnectToNetwork();

ResetRedstone();

SetupHost();

elb.Run();