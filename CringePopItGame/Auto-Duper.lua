local item = "Gummy Rainbow" -- change to item u want to dupe
local timing = 0 -- change this to the timing, you will need to adjust this to your internet ect. 

local TeleportService = game:GetService("TeleportService")
local lplr = game.Players.LocalPlayer

function dupe()
    wait(0.2)
    game:GetService("ReplicatedStorage").RemoteEvents.Jumped:FireServer()
    wait(timing) -- for some reason 0 works for me.
    TeleportService:Teleport(7346416636)
end

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
        game:GetService("ReplicatedStorage").RemoteEvents.Drop:FireServer(item)
        wait(0.5)
        game:GetService("ReplicatedStorage").RemoteEvents.Equip:FireServer(item)
        wait(0.5)
        game:GetService("ReplicatedStorage").RemoteEvents.Drop:FireServer(item)
    end
end

function autodupe()
    repeat wait() until game:IsLoaded()
    getEmptyBoard()
    wait(0.5)
    local brd = getBoard()
    local x = brd.Controls.Close.Pad
    wait()
    autodrop(15)
    wait(0.2)
    lplr.Character:MoveTo(x.Position)
    wait(0.05)
    dupe()
end
autodupe()

game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        syn.queue_on_teleport("loadstring(game:HttpGet("github.com/joeengo/exploiting/CringePopItGame/edithere"))()")
    end
end)
