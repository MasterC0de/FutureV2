-- engo#0320/https://engo.plasmic.site Pop it dupe script automatic
repeat wait() until game:IsLoaded()
wait(2)
if game.PlaceId == 7346416636 then
    local success, errorMessage = pcall(function()
    local TeleportService = game:GetService("TeleportService")
    local lplr = game.Players.LocalPlayer
    local char = lplr.Character
    local hum = char.Humanoid
    local hrp = char.HumanoidRootPart
    local dropped = game.Workspace.Dropped
    
    function dupe()
        wait(0.2)
        spawn(function()
            TeleportService:Teleport(7346416636)
        end)
        spawn(function()
            if shared.timing ~= nil then
                wait(shared.timing)
            end
            game:GetService("ReplicatedStorage").RemoteEvents.Jumped:FireServer()
        end)
    end
    function antiPickup()
       for i,v in pairs(dropped:GetDescendants()) do
            if v:FindFirstChild("Owner") then
                if v:WaitForChild("Owner").Value == lplr then
                wait()
                v.Parent = game:GetService("ReplicatedStorage")
                end
            end
        end
    end
    antiPickup()


    function getBoard(plr)
        for i,v in pairs(game:GetService("Workspace").Boards:GetChildren()) do
            local plr1 = v.Player1.Value
            local plr2 = v.Player2.Value
            if plr then
                if plr1 == plr or plr2 == plr then
                    return v
                end
            else
                if plr1 == lplr or plr2 == lplr then
                    return v
                end
            end
        end
    end

    function getEmptyBoard()
        for i,v in pairs(game:GetService("Workspace").Boards:GetChildren()) do
            local plr1 = v.Player1.Value
            local plr2 = v.Player2.Value
            if plr then
                if plr1 == nil or plr2 == nil then
                    lplr.Character:MoveTo(v.PrimaryPart.Position)
                end
            else
                if plr1 == nil or plr2 == nil then
                    lplr.Character:MoveTo(v.PrimaryPart.Position)
                end
            end
        end
    end

    function autodrop(b)
        for i = 1,b do
            game:GetService("ReplicatedStorage").RemoteEvents.Drop:FireServer(shared.item)
            wait()
            antiPickup()
            wait(0.5)
            game:GetService("ReplicatedStorage").RemoteEvents.Equip:FireServer(shared.item)
            wait()
            antiPickup()
            wait(0.5)
            game:GetService("ReplicatedStorage").RemoteEvents.Drop:FireServer(shared.item)
            wait()
            antiPickup()
        end
    end

    function autodupe()
        repeat
        getEmptyBoard()
        wait()
        until getBoard() ~= nil
        wait(2)
        local brd = getBoard()
        local x = brd:WaitForChild("Controls").Close.Pad
        wait()
        autodrop(15)
        wait(0.2)
        lplr.Character:MoveTo(x.Position)
        wait(0.05)
        dupe()
    end
    autodupe()
    end)

    if success then
        warn(success)
    else
        print(errorMessage)
        TeleportService:Teleport(7346416636)
    end
end
