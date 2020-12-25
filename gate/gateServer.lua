os.loadAPI("/usr/apis/epatLib");
elb = epatLib;

local function ConnectToNetwork()

    local sides = {"top", "bottom", "front", "back", "left", "right" }


    for i = 1, 6, 1 do
        if peripheral.isPresent(sides[i]) and peripheral.getType(sides[i]) == "modem" then
            rednet.open(sides[i]);
            return
        end
    end
end

local function SetupHost()
    
end

elb.SetMainLoopCallback(function ()
    local sender, message, protocol = rednet.receive("gate");
end)

ConnectToNetwork();

elb.Run();