os.loadAPI("/usr/apis/stringLib");
os.loadAPI("/usr/apis/sha1");

local function cls()
    term.clear()
    term.setCursorPos(1,1)
end

local function ConnectToNetwork()

    --print("Enabling modem");
    local sides = {"top", "bottom", "front", "back", "left", "right" }


    for i = 1, 6, 1 do
        if peripheral.isPresent(sides[i]) and peripheral.getType(sides[i]) == "modem" then
            --print(sides[i]);
            rednet.open(sides[i]);
            return
        end
    end
end

local function DisconnectFromNetwork()

    --print("Enabling modem");
    local sides = {"top", "bottom", "front", "back", "left", "right" }


    for i = 1, 6, 1 do
        if peripheral.isPresent(sides[i]) and peripheral.getType(sides[i]) == "modem" then
            --print(sides[i]);
            rednet.close(sides[i]);
            return
        end
    end
end

local function PrintServers()
    settings.load("/etc/gateCli.conf");
    local servers = settings.get("servers");
    if servers == nil then servers = {} end
    local index = 1;
    while true do
        local srv = servers[index];
        if(srv == nil) then
            break;
        end

        print(srv);

        index = index + 1;
    end
end


cls();
print("Co chcesz zrobic?")
print("1. Wybierz serwer")
print("2. Dodaj serwer")
print("3. Edytuj serwer")
local input = read();
cls();
if input == "1" then
    
    PrintServers();

    print("Podaj ID serwera");
    local id = read();

    cls();

    print("Podaj haslo serwera (jesli jest wymagane)");
    local pass = read("*");
    if pass == "" then
        pass = "none";
    end

    cls();

    print("Chcesz otworzyc czy zamknac brame?")
    print("1. Otworzyc");
    print("2. Zamknac");
    local task = read();
    if task == "1" then
        task = "open";
    else
        task = "close";
    end

    pass = sha1.sha1(pass);

    ConnectToNetwork();

    rednet.send(tonumber(id), pass .. ":" .. task, "epGate");

    DisconnectFromNetwork();
    
elseif input == "2" then
    print("Podaj ID serwera");
    local id = read();

    cls();

    print("Podaj opis serwera (dla ulatwienia identyfikacji)");
    local desc = read();

    cls();

    settings.load("/etc/gateCli.conf");
    local servers = settings.get("servers");
    if servers == nil then servers = {} end

    local index = 1;
    while true do
        local srv = servers[index];
        if(srv == nil) then
            servers[index] = tostring(id) .. ". " .. desc;
            break;
        end

        index = index + 1;
    end

    settings.set("servers", servers);
    settings.save("/etc/gateCli.conf");


elseif input == "3" then
    PrintServers();
    print("Podaj ID serwera");
    local id = read();
    cls();

    print("Podaj nowy opis serwera (pozostawienie pustego anuluje zmiane)");
    local desc = read();
    cls();
    
    if desc ~= "" then
        settings.load("/etc/gateCli.conf");
        local servers = settings.get("servers");
        if servers == nil then servers = {}; end

        local index = 1;
        while true do
            local srv = servers[index];
            if(srv == nil) then
                break;
            elseif string.sub(srv,1,string.len(id)) == id then
                servers[index] = tostring(id) .. ". " .. desc;
                break;
            end

            index = index + 1;
        end

        settings.set("servers", servers);
        settings.save("/etc/gateCli.conf");

    end
end

