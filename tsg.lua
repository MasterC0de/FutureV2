-- // The Survival Game Script, orignally written for v3, ported to v2. Enjoy!

--[[ TODO
    - CONFIG SYSTEM

]]

local entity = loadstring(game:HttpGet("https://github.com/joeengo/VapeV4ForRoblox/blob/main/Libraries/entityHandler.lua?raw=true", true))()
entity.fullEntityRefresh()

local library = loadstring(game:HttpGet("https://github.com/joeengo/exploiting/blob/main/UILibrary.lua?raw=true", true))()
library:Init("tsg.lua v1.01 | discord.gg/WYvnhbkwAA | engo#0320")

local collectionService = game:GetService("CollectionService")
local players = game:GetService("Players")
local lplr = players.LocalPlayer
local cam = workspace.CurrentCamera
local rs = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local tsg = {}

local funcs = {}; do 
    function funcs.getEntityFromPlayerName(name)
        local player = players:FindFirstChild(name)
        if not player then 
            return
        end

        local ind, ent = entity.getEntityFromPlayer(player)
        return ent
    end

    function funcs.getClosestEntity(max) 
        if not entity.isAlive then 
            return
        end

        local selfPos = entity.character.HumanoidRootPart.Position
        local dist, res = max or 9e9, nil
        for i, ent in next, entity.entityList do 
            if ent.Targetable then
                local d = (ent.HumanoidRootPart.Position - selfPos).Magnitude
                if (d < dist) then 
                    res = ent
                    dist = d
                end
            end
        end

        return res
    end
    
    function funcs.getColorFromHealthPercentage(percentage) 
        return Color3.fromHSV(percentage / 3, 1, 1) -- Makes 100% health = 0.33333 which is green.
    end

    local waitCache = {}
    function funcs.waitForChild(parent, childName, timeOut)
        local key = parent:GetDebugId(99999) .. childName
        if not waitCache[key] then
            waitCache[key] = parent:FindFirstChild(childName) or parent:WaitForChild(childName, timeOut)
        end
        return waitCache[key]
    end

    function funcs.createAngleInc(Start, DefaultInc, Goal) 
        local i = Start or 0
        return function(Inc) 
            local Inc = Inc or DefaultInc or 1
            i = math.clamp(i + Inc, Start, Goal)
            return i
        end
    end
    
    function funcs.circle(Self, Target, Radius, Delay, Speed, stopIf, onStop, YOffset)
        local AngleInc = funcs.createAngleInc(0, Speed, 360)
        for i = 1, 360 / Speed do 
            local Angle = AngleInc(Speed)
            Self.CFrame = CFrame.new(Target.CFrame.p) * CFrame.Angles(0, math.rad(Angle), 0) * CFrame.new(0, YOffset, Radius)
            task.wait(Delay)
            if stopIf and stopIf() then
                return onStop and onStop()
            end
        end
    end

    function funcs.getBestWeapon() 
        local hotbar = tsg.ClientData.getHotbar()
        local mostDmg, bestWeapon = 0, nil
        for hotbarSlot, itemId in next, hotbar do 
            if itemId < 0 then 
                continue 
            end

            local itemData = tsg.Items.getItemData(itemId)
            if table.find(itemData.itemType, "Melee Weapon") then 
                if itemData.itemStats.meleeDamage > mostDmg then 
                    bestWeapon = hotbarSlot
                    mostDmg = itemData.itemStats.meleeDamage
                end
            end
        end
        
        return bestWeapon
    end

    function funcs.getBestTool(type, stat) 
        local hotbar = tsg.ClientData.getHotbar()
        local mostDmg, bestTool = 0, nil
        for hotbarSlot, itemId in next, hotbar do 
            if itemId < 0 then 
                continue 
            end

            local itemData = tsg.Items.getItemData(itemId)
            if table.find(itemData.itemType, type) then 
                if itemData.itemStats[stat] > mostDmg then 
                    bestTool = hotbarSlot
                    mostDmg = itemData.itemStats[stat]
                end
            end
        end
        
        return bestTool
    end

    function funcs.getClosestAnimal(max) 
        if not entity.isAlive then 
            return
        end

        local selfPos = entity.character.HumanoidRootPart.Position
        local dist, res = max or 9e9, nil
        for i, animal in next, tsg.Animals do 
            if animal.PrimaryPart and (not animal:GetAttribute("deadFrom")) then
                local d = (animal.PrimaryPart.Position - selfPos).Magnitude
                if (d < dist) then 
                    res = animal
                    dist = d
                end
            end
        end

        return res
    end

    function funcs.playAnimation(id)
        if entity.isAlive then 
            local animation = Instance.new("Animation")
            animation.AnimationId = id
            local animatior = entity.character.Humanoid.Animator
            animatior:LoadAnimation(animation):Play()
        end
    end
end

local function resolvePath(parent, ...)
    local last = parent
    for i, v in next, {...} do 
        last = funcs.waitForChild(last, v)
    end

    return last
end

tsg = {
    ClientData = require(resolvePath(rs, "modules", "player", "ClientData")),
    Sounds = require(resolvePath(rs, "modules", "misc", "Sounds")),
    Items = require(resolvePath(rs, "game", "Items")),

    MeleePlayerRemote = resolvePath(rs, "remoteInterface", "interactions", "meleePlayer"),
    MeleeAnimalRemote = resolvePath(rs, "remoteInterface", "interactions", "meleeAnimal"),
    EatRemote = resolvePath(rs, "remoteInterface", "interactions", "eat"),
    MineRemote = resolvePath(rs, "remoteInterface", "interactions", "mine"),
    ChopRemote = resolvePath(rs, "remoteInterface", "interactions", "chop"),
    PickupRemote = resolvePath(rs, "remoteInterface", "inventory", "pickupItem"),

    SetHungerEvent = resolvePath(rs, "remoteInterface", "playerData", "setHunger"), -- Just a client event, not a serversided hunger cheat or smth LOL
}


local animalContainer = resolvePath(workspace, "animals"); do 
    local function addAnimal(v) 
        table.insert(tsg.Animals, v)
    end

    tsg.Animals = tsg.Animals or {}
    animalContainer.ChildAdded:Connect(addAnimal)
    for i, v in next, animalContainer:GetChildren() do 
        addAnimal(v)
    end 
end


do -- KILLAURA

    local circling
    local lastHit = 0
    local circle
    local animals
    local players
    local highlight
    local highlightInstance = Instance.new("Highlight")
    highlightInstance.FillColor = Color3.new(1, 0, 0)
    highlightInstance.OutlineColor = Color3.new(1, 1, 1)
    highlightInstance.FillTransparency = 0.2
    highlightInstance.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local killaura; killaura = library:Toggle({
        Name = "Killaura",
        Default = false,
        Function = function(value) 
            if value then 
                task.spawn(function() 
                    repeat task.wait()
                        local closestEntity = players.Enabled and funcs.getClosestEntity(16)
                        local closestAnimal = animals.Enabled and funcs.getClosestAnimal(16)
                        local bestWeapon = funcs.getBestWeapon()
                        local shouldAttack = (tick() - lastHit >= 1)


                        -- TODO: make highlight for animal while attacking player and animal
                        if bestWeapon and (closestEntity or closestAnimal) then 
                            if highlight.Enabled then
                                highlightInstance.Parent = closestEntity and closestEntity.Character or closestAnimal
                                highlightInstance.Adornee = closestEntity and closestEntity.Character or closestAnimal
                            else
                                highlightInstance.Parent = nil
                                highlightInstance.Adornee = nil
                            end

                            if circle.Enabled then   
                                --cam.CameraSubject = closestEntity and closestEntity.Character or closestAnimal

                                task.spawn(function()
                                    if circling then 
                                        return
                                    end
                                    circling = true
                                    funcs.circle(entity.character.HumanoidRootPart, (closestEntity or closestAnimal).HumanoidRootPart, 14.5, 0, 30, function() 
                                        return not ((closestAnimal and closestEntity) or killaura.Enabled or circle.Enabled)
                                    end, nil, 0)
                                    circling = false
                                end)
                            end

                            if not shouldAttack then 
                                continue
                            end

                            tsg.Sounds.playGameSound("HitPlayer")
                            funcs.playAnimation("rbxassetid://11370416454") -- TODO: make this use game funcs because good!!!
                            lastHit = tick()

                            if closestEntity then
                                tsg.MeleePlayerRemote:FireServer(bestWeapon, closestEntity.Player)
                            end

                            if closestAnimal then
                                tsg.MeleeAnimalRemote:FireServer(bestWeapon, closestAnimal)
                            end

                        elseif shouldAttack then
                            cam.CameraSubject = lplr.Character
                            highlightInstance.Parent = nil
                            highlightInstance.Adornee = nil
                        end
                    until not killaura.Enabled
                end)
            else
                cam.CameraSubject = lplr.Character
                highlightInstance.Parent = nil
                highlightInstance.Adornee = nil
            end
        end
    })

    circle = library:Toggle({
        Name = "Circle Target",
        Default = false,
        Function = function(value) 
            if value then 
            else
                --cam.CameraSubject = lplr.Character
            end
        end
    })

    highlight = library:Toggle({
        Name = "Highlight Target",
        Default = false,
        Function = function(value) 
            highlightInstance.Enabled = value
        end
    })

    players = library:Toggle({
        Name = "Target Players",
        Default = false,
        Function = function(value) 

        end
    })

    animals = library:Toggle({
        Name = "Target Animals",
        Default = false,
        Function = function(value) 

        end
    })

end

library:Element("", false)

do -- SPEED
    local speed
    local function onHeartbeat(dt) 
        if not speed.Enabled then 
            return
        end

        if not entity.isAlive then 
            return
        end

        local humanoid = entity.character.Humanoid 
        local humanoidRootPart = entity.character.HumanoidRootPart
        local originalVelocity = humanoidRootPart.Velocity
        local moveDirection = humanoid.MoveDirection

        local factor = 27 - humanoid.WalkSpeed
        local multMD = (moveDirection * dt) * factor

        lplr.Character:TranslateBy(multMD)
    end
    
    speed = library:Toggle({
        Name = "Speed",
        Default = false,
        Function = function() end
    } )

    runService.Heartbeat:Connect(onHeartbeat)
end

library:Element("", false)

do -- AUTOEAT
    local eatRaw
    local hungerThreshold
    local autoEatConnection
    local autoEat = library:Toggle({
        Name = "Auto Eat",
        Default = false,
        Function = function(value) 
            if value then
                -- NOTE: Possibly the sethunger wont fire when ur on 0, possible item pickup check so if your on 0 then it will eat any items picked up to counter that.
                autoEatConnection = tsg.SetHungerEvent.OnClientEvent:Connect(function(hunger) 
                    if hunger >= hungerThreshold.Value - 0.1 then 
                        return
                    end

                    for itemId, amount in next, tsg.ClientData.getInventory() do 
                        local itemData = tsg.Items.getItemData(itemId)
                        if not table.find(itemData.itemType, "Consumable") then 
                            continue
                        end

                        local shouldntEat = not eatRaw.Enabled and itemData.effectsOnEat and table.find(itemData.effectsOnEat, "Food_Poisoning")
                        if shouldntEat then 
                            continue 
                        end

                        tsg.Sounds.playGameSound("Eat Food")
                        tsg.EatRemote:FireServer(itemId)
                        break
                    end
                end)
            else
                autoEatConnection:Disconnect()
            end
        end,
    })

    eatRaw = library:Toggle({
        Name = "Eat Raw Food",
        Default = false,
        Function = function() end
    })

    hungerThreshold = library:Slider({
        Name = "Goal Hunger",
        Function = function() end,
        Min = 1,
        Max = resolvePath(rs, "game", "maxHunger").Value,
        Default = 500,
        Decimals = 0,
    })

end

library:Element("", false)

do -- INF STAM
    local oldStamina
    local infStaminaConnection
    local infStamina = library:Toggle({
        Name = "Infinite Stamina",
        Default = false,
        Function = function(value) 
            if value then 
                oldStamina = lplr:GetAttribute("stamina")
                lplr:SetAttribute("stamina", math.huge)
                infStaminaConnection = lplr:GetAttributeChangedSignal("stamina"):Connect(function()
                    oldStamina = lplr:GetAttribute("stamina")
                    lplr:SetAttribute("stamina", math.huge)
                end)
            else
                infStaminaConnection:Disconnect()
                lplr:SetAttribute("stamina", oldStamina)
            end
        end
    })
end

library:Element("", false)

do 
    local fastPickup; fastPickup = library:Toggle({
        Name = "Fast Pickup",
        Default = false,
        Function = function(value)
            if value then 
                task.spawn(function() 
                    repeat task.wait(0.05)
                        if not entity.isAlive then 
                            continue
                        end

                        local selfPos = entity.character.HumanoidRootPart.Position
                        for i, v in next, collectionService:GetTagged("DROPPED_ITEM") do -- TODO: Possibly cache/store dropped items in table, because gettagged maybe slow?
                            local dist = (v.Position - selfPos).Magnitude
                            if dist <= 5 then 
                                tsg.PickupRemote:FireServer(v)
                            end
                        end

                    until not fastPickup.Enabled
                end)
            end
        end
    })

end

library:Element("", false)

do -- AUTO MINE
    local wr = resolvePath(workspace, "worldResources")
    local mineableToggles = {}
    local connections = {}

    local function handleChild(v, v3) 
        local t = {i=v3,t=v.Name,cf=v3:GetAttribute("cf")} 
        table.insert(tsg.Mineables, t)
        local connection; connection = v3:GetAttributeChangedSignal("health"):Connect(function() 
            if v3:GetAttribute("health") <= 0 then 
                table.remove(tsg.Mineables, table.find(tsg.Mineables, t))
            end
            connection:Disconnect()
        end)
        table.insert(connections, connection)
    end

    local function updateMineables() 
        tsg.Mineables = {}
        for i, v in next, connections do 
            if v.Connected then
                v:Disconnect()
            end
            connections[i] = nil
        end

        for i, v in next, wr:GetChildren() do 
            for i2, v2 in next, v:GetChildren() do 
                if mineableToggles[v2.Name].Enabled then 
                    for i3, v3 in next, v2:GetChildren() do
                        handleChild(v, v3)
                    end

                    table.insert(connections, v2.ChildAdded:Connect(function(v3) 
                        handleChild(v, v3)
                    end))
                end
            end
        end
    end

    local highlight
    local highlightInstance = Instance.new("Highlight")
    highlightInstance.FillColor = Color3.new(0, 0, 1)
    highlightInstance.OutlineColor = Color3.new(1, 1, 1)
    highlightInstance.FillTransparency = 0.2
    highlightInstance.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop


    local lastHit = tick()
    local automine; automine = library:Toggle({
        Name = "Auto Mine",
        Default = false,
        Function = function(value)
            if value then 
                task.spawn(function() 
                    repeat task.wait()
                        if not entity.isAlive then 
                            continue
                        end

                        local thisTick = tick()
                        local shouldHit = (thisTick - lastHit >= 1/3)
                        if not shouldHit then
                            continue
                        end
                        
                        local selfPos = entity.character.HumanoidRootPart.Position
                        local bestPick = funcs.getBestTool("Pickaxe",  "pickaxeStrength")
                        local bestAxe = funcs.getBestTool("Axe",  "axeStrength")

                        for i, v in next,tsg.Mineables do 
                            if (v.cf.Position - selfPos).Magnitude < 16 then 
                                local remote = v.t == 'mineable' and tsg.MineRemote or tsg.ChopRemote
                                local bestTool = v.t == 'mineable' and bestPick or bestAxe

                                highlightInstance.Parent = v.i
                                highlightInstance.Adornee = v.i

                                for i = 1, 15 do
                                    task.spawn(function()
                                        remote:FireServer(bestTool, v.i, v.cf)
                                    end)
                                end

                                lastHit = thisTick
                                break
                            else
                                --highlightInstance.Parent = nil
                                --highlightInstance.Adornee = nil
                            end
                        end
                    until not automine.Enabled
                end)
            else
                highlightInstance.Parent = nil
                highlightInstance.Adornee = nil
            end
        end,
    })

    highlight = library:Toggle({
        Name = "Highlight Target",
        Default = false,
        Function = function(value) 
            highlightInstance.Enabled = value
        end
    })

    library:Element("Resource Toggles", false)

    local doneLoading = false
    for i, v in next, wr:GetChildren() do 
        for i2, v2 in next, v:GetChildren() do
            mineableToggles[v2.Name] = library:Toggle({
                Name = v2.Name,
                Function = function(value) 
                    if not doneLoading then
                        return
                    end
                    updateMineables()
                end,
                Default = true,
            })
        end
    end
    doneLoading = true
    updateMineables()

end
