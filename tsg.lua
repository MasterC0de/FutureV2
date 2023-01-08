-- // The Survival Game Script, orignally written for v3, ported to v2. Enjoy!

--[[ TODO
    - CONFIG SYSTEM

]]

if getgenv().TSG_LOADED then 
    return warn("[tgs.lua] script already loaded, rejoin to re-execute.")
else
    getgenv().TSG_LOADED = true
end

local entity = loadstring(game:HttpGet("https://github.com/joeengo/VapeV4ForRoblox/blob/main/Libraries/entityHandler.lua?raw=true", true))()
entity.fullEntityRefresh()

local library = loadstring(game:HttpGet("https://github.com/joeengo/exploiting/blob/main/UILibrary.lua?raw=true", true))()
library:Init("tsg.lua v1.03a | discord.gg/WYvnhbkwAA | engo#0320")

local collectionService = game:GetService("CollectionService")
local guiService = game:GetService("GuiService")
local players = game:GetService("Players")
local lplr = players.LocalPlayer
local cam = workspace.CurrentCamera
local rs = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local tsg = {}
local resolvePath

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

    function funcs.getBestTool(type, stat) 
        local hotbar = tsg.ClientData.getHotbar()
        local most, best = 0, nil
        for hotbarSlot, itemId in next, hotbar do 
            if itemId < 0 then 
                continue 
            end

            local itemData = tsg.Items.getItemData(itemId)
            if table.find(itemData.itemType, type) then 
                if itemData.itemStats[stat] > most then 
                    best = hotbarSlot
                    most = itemData.itemStats[stat]
                end
            end
        end
        
        return best
    end

    function funcs.getBestId(type, stat) 
        local inv = tsg.ClientData.getInventory()
        local most, best = 0, nil
        for itemId, amount in next, inv do 
            if itemId < 0 then 
                continue 
            end

            local itemData = tsg.Items.getItemData(itemId)
            if table.find(itemData.itemType, type) then 
                if itemData.itemStats[stat] > most then 
                    best = itemId
                    most = itemData.itemStats[stat]
                end
            end
        end
        
        return best
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

    function funcs.getEquippedId() 
        if not entity.isAlive then
            return -1
        end

        local hotbar = tsg.ClientData.getHotbar()
        for i, v in next, hotbar do 
            local tool = lplr.Character:FindFirstChild(tostring(i))
            if tool and tool:IsA("Tool") then 
                return v
            end
        end

        return -1
    end

    -- This function is just skidded from in game code lol (players.LocalPlayer.Character["1"].slotTool.Ranged_CHARGED)
    function funcs.getShootTarget() 
        if tsg.fpsUtil.inFirstPerson() then
            local cf = cam.CFrame
            return cf.Position + (cf.LookVector * 1000)
        end

        local mousePos = uis:GetMouseLocation() - guiService:GetGuiInset()
        local ray = cam:ScreenPointToRay(mousePos.X, mousePos.Y)
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = {
            lplr.Character,
            resolvePath(workspace, "snaps")
        }

        local hit = workspace:Raycast(ray.Origin, ray.Direction * 500, rayParams)
        if hit then
            return hit.Position
        end
        return ray.Origin + (ray.Direction * 1000)
    end

    function funcs.getShootCF() 
        if not entity.isAlive then
            return
        end

        if tsg.fpsUtil.inFirstPerson() then 
            return cam.CFrame
        end

        return CFrame.new(lplr.Character:GetPivot().Position, funcs.getShootTarget())
    end

    function funcs.solveQuadratic(a, b, c) -- Solves quadratic equation, always returns the positive output.
        local d = (b ^ 2) - (a * c * 4)
        local e = (-b) + (d ^ 0.5)
        return e / (a * 2)
    end

    --[[
    function funcs.prediction(selfPart, part, speed) 
        local speed = speed.Magnitude
        local targetPosition = part.Position
        local targetVelocity = part.Velocity
        local shooterPosition = selfPart.Position
        local relative = shooterPosition - targetPosition
        local angle = math.acos(relative.Unit:Dot(targetVelocity.Unit))

        if targetVelocity == Vector3.zero then 
            return targetPosition
        end
       
        local a,b,c =
            (targetVelocity.magnitude ^ 2) - (speed ^ 2),
            -2 * relative.magnitude * math.cos(angle) * targetVelocity.magnitude,
            relative.magnitude ^ 2
       
        print("------------------")
        print(a, b, c)
        print(speed)
        print(targetPosition)
        print(targetVelocity)
        print(shooterPosition)
        print(relative)
        print(angle)
        local t = funcs.solveQuadratic(a,b,c)
        return targetPosition + targetVelocity * t
    end
    ]]

    local FACTOR = 0.15
    local Y_OFFSET = 2
    local Y_FACTOR = 0.08
    function funcs.prediction(selfPart, part, speed) 
        local add = part.Velocity
        add = Vector3.new(add.X * FACTOR, (add.Y * Y_FACTOR) + Y_OFFSET, add.Z * FACTOR) 
        return part.Position + add
    end
end

function resolvePath(parent, ...)
    local last = parent
    for i, v in next, {...} do 
        last = funcs.waitForChild(last, v)
    end

    return last
end

local hookfunc = hookfunction
function hookfunction(from, to, backup)
    local suc, res = pcall(hookfunc, from, to)
    if suc then 
        return res
    end
    return backup()
end

tsg = {
    ClientData = require(resolvePath(rs, "modules", "player", "ClientData")),
    Sounds = require(resolvePath(rs, "modules", "misc", "Sounds")),
    Items = require(resolvePath(rs, "game", "Items")),
    Effects = require(resolvePath(rs, "game", "Effects")),
    fpsUtil  = require(resolvePath(rs, "modules", "misc", "fpsUtil")),

    MeleePlayerRemote = resolvePath(rs, "remoteInterface", "interactions", "meleePlayer"),
    MeleeAnimalRemote = resolvePath(rs, "remoteInterface", "interactions", "meleeAnimal"),
    EatRemote = resolvePath(rs, "remoteInterface", "interactions", "eat"),
    MineRemote = resolvePath(rs, "remoteInterface", "interactions", "mine"),
    ChopRemote = resolvePath(rs, "remoteInterface", "interactions", "chop"),
    ShootRemote = resolvePath(rs, "remoteInterface", "interactions", "shoot"),
    ShotPlayerHitRemote = resolvePath(rs, "remoteInterface", "interactions", "shotHitPlayer"),
    PickupRemote = resolvePath(rs, "remoteInterface", "inventory", "pickupItem"),
    RespawnRemote = resolvePath(rs, "remoteInterface", "character", "respawn"),
    FireRemote = resolvePath(rs, "remoteInterface", "world", "onFire"),

    SetHungerEvent = resolvePath(rs, "remoteInterface", "playerData", "setHunger"),
}

getgenv().tsg = tsg -- So i can do testing outside of this script.

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
    local lastAnim = 0
    local circle, circleSpeed, circleRadius
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
                        local bestWeapon = funcs.getBestTool("Melee Weapon", "meleeDamage")
                        local shouldAttack = (tick() - lastHit >= 0.25)
                        local shouldAnim = (tick() - lastAnim >= 1)


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
                                    funcs.circle(entity.character.HumanoidRootPart, (closestEntity or closestAnimal).HumanoidRootPart, circleRadius.Value, 0, circleSpeed.Value, function() 
                                        return not ((closestAnimal and closestEntity) or killaura.Enabled or circle.Enabled)
                                    end, nil, 0)
                                    circling = false
                                end)
                            end

                            if shouldAnim then
                                funcs.playAnimation("rbxassetid://11370416454") -- TODO: make this use game funcs because good!!!
                                tsg.Sounds.playGameSound("HitPlayer")
                                lastAnim = tick()
                            end

                            if not shouldAttack then 
                                continue
                            end

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

    circleSpeed = library:Slider({
        Name = "Circle Speed",
        Function = function() end,
        Min = 1,
        Max = 50,
        Default = 10,
        Decimals = 0,
    })

    circleRadius = library:Slider({
        Name = "Circle Radius",
        Function = function() end,
        Min = 1,
        Max = 15,
        Default = 13.5,
        Decimals = 2,
    })

    highlight = library:Toggle({
        Name = "Highlight Target",
        Default = true,
        Function = function(value) 
            highlightInstance.Enabled = value
        end
    })

    players = library:Toggle({
        Name = "Target Players",
        Default = true,
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

library:Seperator()

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

library:Seperator()

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

library:Seperator()

do -- SERVER LAGGER
    local lagger; lagger = library:Toggle({
        Name = "Server Lagger", -- credits to Babyhamsta#0173
        Default = false,
        Function = function(value)
            if value then 
                task.spawn(function()
                    repeat task.wait()
                        task.spawn(function()
                            for i = 1, 5 do
                                tsg.RespawnRemote:InvokeServer(15382674, 1, 1, 20, 15382674, 15382674, false)
                                tsg.FireRemote:FireServer()
                            end
                        end)
                    until not lagger.Enabled
                end)
            end
        end
    })
end

library:Seperator()

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

library:Seperator()

do -- ANTI ENCUMBER
    local speedFactor
    local antiEncumber = library:Toggle({
        Name = "Anti Encumbered",
        Default = false,
        Function = function(value) 
            if value then 
                speedFactor = tsg.Effects.getEffectData("Over_Encumbered").speedFactor
                tsg.Effects.getEffectData("Over_Encumbered").speedFactor = 1
            else
                tsg.Effects.getEffectData("Over_Encumbered").speedFactor = speedFactor
                speedFactor = nil
            end
        end
    })
end

library:Seperator()

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

library:Seperator()


do -- BOW AIMBOT
    local bowAimbot

    local function hook(requiredScript) 
        local old
        local function bowAimbotHook(...) 
            if bowAimbot.Enabled and entity.isAlive then
                local closestEntity = funcs.getClosestEntity(200)
                if not closestEntity then
                    return old(...)
                end

                local equippedId = funcs.getEquippedId()
                local itemData = tsg.Items.getItemData(equippedId)
                local projVelocity = itemData.projectileVelocity
                local lookVec = CFrame.lookAt(entity.character.HumanoidRootPart.Position, closestEntity.HumanoidRootPart.Position).LookVector
                local predicted = funcs.prediction(entity.character.HumanoidRootPart, closestEntity.HumanoidRootPart, projVelocity)
                --printtable(predicted)
                return CFrame.lookAt(entity.character.HumanoidRootPart.Position, predicted)
            end
            return old(...)
        end

        old = hookfunction(requiredScript._getShootCF, bowAimbotHook, function() 
            local old = requiredScript._getShootCF
            requiredScript._getShootCF = bowAimbotHook
            return old
        end)
    end

    -- using the below 3 sections of code, we hook any present and future instances of the bow, allowing for no holes where the aimbot will fail.

    local oldRequire
    local function requireHook(scr) -- setup require to hook any future bows
        local requiredScript = oldRequire(scr)
        if scr.Name == "Ranged_NORMAL" or scr.Name == "Ranged_CHARGE" and (scr:IsDescendantOf(lplr.Backpack) or scr:IsDescendantOf(lplr.Character)) then 
            hook(requiredScript)
        end

        return requiredScript
    end

    oldRequire = hookfunction(getrenv().require, requireHook, function() 
        local old = getrenv().require
        getrenv().require = requireHook
        return old
    end)

    for i, v in next, lplr.Backpack:GetChildren() do -- setup the hook on any bows in inv
        local slotTool = v:FindFirstChild("slotTool")
        if slotTool then
            local script1, script2 = slotTool:FindFirstChild("Ranged_CHARGE"), slotTool:FindFirstChild("Ranged_NORMAL")
            if script1 and script2 then
                hook(require(script1))
                hook(require(script2))
            end
        end
    end

    if entity.isAlive then
        local slotTool = lplr.Character:FindFirstChildWhichIsA("Tool") -- setup the hook on any currently selected bow
        slotTool = slotTool and slotTool:FindFirstChild("slotTool")
        if slotTool then
            local script1, script2 = slotTool:FindFirstChild("Ranged_CHARGE"), slotTool:FindFirstChild("Ranged_NORMAL")
            if script1 and script2 then
                hook(require(script1))
                hook(require(script2))
            end
        end
    end

    bowAimbot = library:Toggle({
        Name = "Bow Aimbot",
        Default = false,
        Function = function(value) 
        end
    })
end

library:Seperator()

do -- AUTO MINE
    local wr = resolvePath(workspace, "worldResources")
    local mineableToggles = {}
    local connections = {}

    local oreEsp, oreEspDist, oreEspMaxDist
    local oreEsps = {}
    local espFuncs = {
        Add = function(instance) 
            if not instance then 
                return
            end

            if instance:GetAttribute("health") <= 0 then 
                return
            end

            local name = instance.Parent.Name
            local selected = mineableToggles[name].Selected.Value
            if selected ~= "ESP" and selected ~= "Both" then 
                return
            end

            local instPos = instance:GetAttribute("cf").Position
            local pos, vis = cam:WorldToViewportPoint(instPos)
            local dist = lplr:DistanceFromCharacter(instPos)
            vis = dist < oreEspMaxDist.Value

            if dist == 0 then 
                vis = false
            end

            local text = name
            if oreEspDist.Enabled then 
                text = text .. " [" .. math.floor(dist) .. "]"
            end

            local drawing = Drawing.new("Text")
            drawing.Visible = vis
            drawing.Color = Color3.new(1, 1, 1)
            drawing.Text = text
            drawing.Size = 18
            drawing.Position = Vector2.new(pos.X, pos.Y)
            drawing.ZIndex = pos.Z
            drawing.Outline = true
            drawing.OutlineColor = Color3.new(0, 0, 0)
            drawing.Center = true

            table.insert(oreEsps, {
                drawing = drawing,
                instance = instance,
                name = name,
                instPos = instPos -- Store Instance Position because its unlikely it will change
            })
        end,
        Update = function(esp, index) 
            local drawing = esp.drawing
            local instPos = esp.instPos
            local pos, vis = cam:WorldToViewportPoint(instPos)
            local dist = lplr:DistanceFromCharacter(instPos)
            if vis then
                vis = dist < oreEspMaxDist.Value
            end

            if dist == 0 then 
                vis = false
            end

            local selected = mineableToggles[esp.name].Selected.Value
            if selected ~= "ESP" and selected ~= "Both" then 
                drawing:Remove()
                table.remove(oreEsps, index)
                return
            end

            drawing.Visible = vis
            if vis then
                local text = esp.name
                if oreEspDist.Enabled then 
                    text = text .. " [" .. math.floor(dist) .. "]"
                end

                drawing.Position = Vector2.new(pos.X, pos.Y)
                drawing.ZIndex = pos.Z
                drawing.Text = text
            end
        end,
    }

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

        if oreEsp.Enabled then
            espFuncs.Add(v3)
        end
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
                if mineableToggles[v2.Name].Selected.Value ~= "None" then 
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
                            local selected = mineableToggles[v.i.Parent.Name].Selected.Value
                            if selected ~= "AutoMine" and selected ~= "Both" then 
                                continue
                            end
                            if (v.cf.Position - selfPos).Magnitude < 16 then 
                                local remote = v.t == 'mineable' and tsg.MineRemote or tsg.ChopRemote
                                local bestTool = v.t == 'mineable' and bestPick or bestAxe

                                highlightInstance.Parent = v.i
                                highlightInstance.Adornee = v.i

                                for i = 1, 10 do
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

    library:Seperator()

    local oreEspConnection
    oreEsp = library:Toggle({
        Name = "Resource ESP",
        Default = false,
        Function = function(value) 
            if value then 
                for i, v in next, tsg.Mineables do 
                    espFuncs.Add(v.i)
                end
                oreEspConnection = runService.RenderStepped:Connect(function() 
                    for i, v in next, oreEsps do 
                        espFuncs.Update(v, i)
                    end
                end)
            else
                oreEspConnection:Disconnect()
                for i, v in next, oreEsps do 
                    v.drawing:Remove()
                end
                oreEsps = {}
            end
        end
    })

    oreEspDist = library:Toggle({
        Name = "Show Distance From Player",
        Default = true,
        Function = function() end
    })

    oreEspMaxDist = library:Slider({
        Name = "Max Render Distance",
        Default = 200,
        Min = 0,
        Max = 2000,
        Function = function() end,
        Decimals = 2
    })

    library:Seperator()

    library:Element("Resource Toggles", false)

    local doneLoading = false
    for i, v in next, wr:GetChildren() do 
        for i2, v2 in next, v:GetChildren() do
            mineableToggles[v2.Name] = library:Selector({
                Name = v2.Name,
                List = {"None", "ESP", "AutoMine", "Both"},
                Function = function(value) 
                    if not doneLoading then
                        return
                    end
                    updateMineables()
                end,
                Default = "Both",
            })
        end
    end
    doneLoading = true
    updateMineables()

end

-- UI HIDE:
uis.InputBegan:Connect(function(input) 
    if input.KeyCode == Enum.KeyCode.RightControl then 
        library.ScreenGui.Enabled = not library.ScreenGui.Enabled
    end
end)
