wait(5)
local TeleportService = game:GetService("TeleportService")
local lplr = game.Players.LocalPlayer
local cha = lplr.Character
local busPos = Vector3.new(226.89, 199.18, 217.92)

function Main()
print("Loaded Auto-Timmeh! [In-Game]")
wait(25)
local map = workspace:WaitForChild("Map") -- map model
local Doors = map.Doors --folder
local toyStoreDoor = Doors.DoorToy
local toyProx = toyStoreDoor.Part.Door
local wall = map.BreakableWalls.GoalWall.PrimaryPart
local wal = Vector3.new(134.29765319824, 4.618682384491, -297.63818359375)
local toy = Vector3.new(154, 4, -267)
local end2 = Vector3.new(113.699, 3.469, -315.2)
    function findItem(name)
        if name == "Crowbar" and map.Objects:FindFirstChild("Crowbar") then
            return map.Objects:WaitForChild("Crowbar")
        elseif name == "Toy Store Key" and map.Objects:FindFirstChild("TSKey")then
                return map.Objects:WaitForChild("TSKey")["Toy Store Key"]
        elseif name == "Dynamite" and map.Objects:FindFirstChild("Dynamite") then
            return map.Objects:WaitForChild("Dynamite")
        end
    end

    function findProx(part)
        for i,v in pairs(part:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                return v
            end
        end
    end

    function moveToItem(item)
        for i,v in pairs(map.Objects:GetDescendants()) do
            if v.Name == item.Name then
                if not v:IsA("Model") and not v:IsA("ProximityPrompt") and v:IsA("Part") or v:IsA("MeshPart") then
                    game.Players.LocalPlayer.Character:MoveTo(v.Position + Vector3.new(0,3,0))
                    wait(0.25)
                    fireproximityprompt(findProx(v), 30)
                end
            end
        end
    end

    function unlockWithItem(part)
        if part == "Crowbar" then
            game.Players.LocalPlayer.Character:MoveTo(wal)
            wait(0.25)
            fireproximityprompt(findProx(map.BreakableWalls.GoalWall.Main), 100)
        elseif part == "Toy Store Key" then
            game.Players.LocalPlayer.Character:MoveTo(toy)
            wait(0.25)
            fireproximityprompt(toyProx, 100)
        elseif part == "Dynamite" then
            game.Players.LocalPlayer.Character:MoveTo(wal)
            wait(0.25)
            fireproximityprompt(findProx(map.BreakableWalls.GoalWall.Main), 100)
        end
    end

    function autowin()
        local ValueChanged = map.Doors.DoorToy.Part.IsLocked.Value
        local Crowbar = findItem("Crowbar")
        local Dynamite = findItem("Dynamite")
        if map.Doors.DoorToy.Part.IsLocked.Value then

            map.Doors.DoorToy.Part.IsLocked.Changed:Connect(function()
                ValueChanged= not ValueChanged
            end)
            local e,r = pcall(function()
                findItem("Toy Store Key")
            end)
            if e then 
                local toyStoreKey = findItem("Toy Store Key")
                moveToItem(toyStoreKey)
                wait(1)
                unlockWithItem("Toy Store Key")
            else
                repeat wait() until ValueChanged.Value == true
            end
        end
        wait(1)
        moveToItem(Crowbar)
        wait(1)
        unlockWithItem("Crowbar")
        wait(1)
        moveToItem(Dynamite)
        wait(0.05)
        moveToItem(Dynamite)
        wait(0.05)
        moveToItem(Dynamite)
        wait(1)
        unlockWithItem("Dynamite")
        wait(8)
        game.Players.LocalPlayer.Character:MoveTo(end2)
        wait(0.5)
        local goal = map.Goal.Main  -- part
        local goalPrompt = goal.Goal  -- prox prompt
        fireproximityprompt(goalPrompt, 10)
        wait(30)
        TeleportService:Teleport(7278039197)
    end

    function autoKill()
        for i,v in pairs(game.Players:GetChildren()) do
            if v.Name ~= game.Players.LocalPlayer.Name then
                spawn(function()
                    repeat
                    game.Players.LocalPlayer.Character:MoveTo(v.Character.HumanoidRootPart.Position)
                    wait()
                    game:GetService("ReplicatedStorage"):WaitForChild("Knit").Services.InteractionService.RE.AttackPlayers:FireServer({v})
                    wait(0.2)
                    until v.Character.Humanoid.Health == 0
                end)
            end
            wait(1)
        end
    end

    if cha:FindFirstChild("Goop Hound") then
        autoKill()
    else
        autowin()
    end
end

function autoJoin()
    wait(10)
    game.Players.LocalPlayer.Character:MoveTo(busPos)
    wait(0.05)
    for i,v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v, 4)
            wait(0.1)
        end
    end
    wait(1)
end

function lobby()
	print("Loaded Auto-Timmeh! [Lobby]")
    repeat              
        autoJoin()
        wait(1)
    until game:GetService("Workspace").LocalPlayer.Humanoid.Sit == true
end

if game.PlaceId == 7391229924 then
    Main()
elseif game.PlaceId == 7278039197 then
    lobby()
    game:GetService("Workspace").LocalPlayer.Humanoid.Sit:GetPropertyChangedSignal("Value"):Connect(function()
        lobby()
    end)
end