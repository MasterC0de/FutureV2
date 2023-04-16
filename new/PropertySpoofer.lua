-- engo's property spoofer
-- trying to make a undetectable one

local oldIndex, oldNewIndex
local propertySpoofingFunctions = {}
local updateValueFunctions = {}

-- Unload functionality:
local unload = getgenv().SPOOF_PROP_UNLOAD_DATA
if (unload) then 
    hookmetamethod(game, "__index", unload.oldIndex)
    hookmetamethod(game, "__newindex", unload.oldNewIndex)
    propertySpoofingFunctions = unload.propertySpoofingFunctions
    updateValueFunctions = unload.updateValueFunctions
    getgenv().SPOOF_PROP_UNLOAD_DATA = nil
    unload = nil
end

local get_thread_identity = (syn and syn.get_thread_identity) or getthreadidentity
local set_thread_identity = (syn and syn.set_thread_identity) or setthreadidentity

local function cleanString(str) 
    local newStr = str:gsub("\0", "")
    return newStr
end

-- thread identity debug id
local function getDebugId(inst) 
    local oldThreadIdentity = get_thread_identity()
    set_thread_identity(7)
    local debugId = inst:GetDebugId()
    set_thread_identity(oldThreadIdentity)
    return debugId
end

local function rawsetproperty(obj, idx, val, customFunc) 
    local disabled = {}
    for i, v in next, getconnections(obj.Changed) do 
        table.insert(disabled, v)
        if v.Disable then
            local suc, err = pcall(function()
                v:Disable()
            end)
            if (not suc) then 
                warn("[PropertySpoofer] ERROR WHILE DISABLING CONNECTION (CHANGED) #" .. i .. " ON" .. obj:GetFullName() .. "\nERROR: " .. err)
            end
        else
            warn("[PropertySpoofer] FAILED DISABLING CONNECTION (CHANGED) #" .. i .. " ON" .. obj:GetFullName())
        end
    end
    for i, v in next, getconnections(obj:GetPropertyChangedSignal(idx)) do 
        table.insert(disabled, v)
        if v.Disable then
            local suc, err = pcall(function()
                v:Disable()
            end)
            if (not suc) then 
                warn("[PropertySpoofer] ERROR WHILE DISABLING CONNECTION (GPCS) #" .. i .. " ON" .. obj:GetFullName() .. "\nERROR: " .. err)
            end
        else
            warn("[PropertySpoofer] FAILED DISABLING CONNECTION (GPCS) #" .. i .. " ON" .. obj:GetFullName())
        end
    end
    if customFunc then
        customFunc(obj, idx, val)
    else
        obj[idx] = val
    end
    for i, v in next, disabled do 
        v:Enable()
    end
end

oldIndex = hookmetamethod(game, "__index", function(self, index) 
    local oldResult = oldIndex(self, index)
    if checkcaller() then 
        return oldResult
    end

    local typeOfSelf = typeof(self)
    local typeOfInd = typeof(index)
    if typeOfInd ~= "string" then 
        return oldResult
    end

    index = cleanString(index)

    if typeOfSelf == "Instance" then -- Should always be true, but what do i know
        local className = oldIndex(self, "ClassName") -- self.ClassName
        local debugId = getDebugId(self)

        local cnFunc, idFunc = propertySpoofingFunctions[className .. index], propertySpoofingFunctions[debugId .. index]
        if idFunc then 
            return idFunc(self, index)
        end
        if cnFunc then 
            return cnFunc(self, index)
        end
    end

    return oldResult
end)

oldNewIndex = hookmetamethod(game, "__newindex", function(self, index, value) 
    local caller = checkcaller()
    local typeOfSelf = typeof(self)
    local typeOfInd = typeof(index)
    if typeOfInd ~= "string" then 
        return oldNewIndex(self, index, value)
    end

    index = cleanString(index)

    if typeOfSelf == "Instance" then -- Should always be true, but what do i know
        local className = self.ClassName
        local debugId = getDebugId(self)

        local cnFunc, idFunc = updateValueFunctions[className .. index], updateValueFunctions[debugId .. index]
        if idFunc and not caller then 
            idFunc(self, index, value)
        end 
        if cnFunc and not caller then 
            cnFunc(self, index, value)
        end 
        
        if cnFunc or idFunc then 
            if caller then
                rawsetproperty(self, index, value, oldNewIndex) -- Prevents game knowing that you set the property after using spoofprop
            end

            return
        end
    end

    return oldNewIndex(self, index, value)
end)

-- This function basically sets the propertys value to the value and then returns it indexed from the instance, this removes quite a few detections.
local function validateValueForObject(self, index, value) 
    local oldValue = oldIndex(self, index)
    rawsetproperty(self, index, value)
    local realValue = oldIndex(self, index)
    rawsetproperty(self, index, oldValue)
    return realValue
end

-- toSpoof: a classname or instance, both should work
-- property: name of property
-- value: the value that the game thinks the property has, this may change if the game sets the value to attempt detections 
local function SpoofProperty(toSpoof, property, value) 
    local typeOf = typeof(toSpoof)
    if typeOf == "Instance" then 
        local debugId = getDebugId(toSpoof)
        local newValue = value
        propertySpoofingFunctions[debugId .. property] = function(self, index)
            return newValue
        end
        updateValueFunctions[debugId .. property] = function(self, index, val)
            local realVal = validateValueForObject(self, index, val)
            newValue = realVal
        end
    elseif typeOf == "string" then -- its a classname
        local debugIdValueTable = {}
        propertySpoofingFunctions[toSpoof .. property] = function(self, index) 
            local debugId = getDebugId(self)
            return debugIdValueTable[debugId] or value
        end
        updateValueFunctions[toSpoof .. property] = function(self, index, val)
            local debugId = getDebugId(self)
            local realVal = validateValueForObject(self, index, val)
            debugIdValueTable[debugId] = realVal
        end
    end
end

getgenv().SpoofProperty = SpoofProperty

getgenv().SPOOF_PROP_UNLOAD_DATA = {
    oldNewIndex = oldNewIndex,
    oldIndex = oldIndex,
    propertySpoofingFunctions = propertySpoofingFunctions,
    updateValueFunctions = updateValueFunctions,
}
