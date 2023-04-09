-- engo's property spoofer
-- trying to make a undetectable one

local oldIndex, oldNewIndex
local propertySpoofingFunctions = {}
local updateValueFunctions = {}

local get_thread_identity = (syn and syn.get_thread_identity) or getthreadidentity
local set_thread_identity = (syn and syn.set_thread_identity) or setthreadidentity

-- thread identity debug id
local function getDebugId(inst) 
    local oldThreadIdentity = get_thread_identity()
    set_thread_identity(7)
    local debugId = inst:GetDebugId()
    set_thread_identity(oldThreadIdentity)
    return debugId
end

oldIndex = hookmetamethod(game, "__index", function(self, index) 
    if checkcaller() then 
        return oldIndex(self, index)
    end

    local typeOf = typeof(self)
    if typeOf == "Instance" then -- Should always be true, but what do i know
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

    return oldIndex(self, index)
end)

oldNewIndex = hookmetamethod(game, "__newindex", function(self, index, value) 
    if checkcaller() then 
        return oldNewIndex(self, index, value)
    end

    local typeOf = typeof(self)
    if typeOf == "Instance" then -- Should always be true, but what do i know
        local className = self.ClassName
        local debugId = getDebugId(self)

        local cnFunc, idFunc = updateValueFunctions[className .. index], updateValueFunctions[debugId .. index]
        if idFunc then 
            idFunc(self, value)
        end 
        if cnFunc then 
            cnFunc(self, value)
        end 
        
        if cnFunc or idFunc then 
            return
        end
    end

    return oldNewIndex(self, index, value)
end)

-- toSpoof: a classname or instance, both should work
-- property: name of property
-- value: the value that the game thinks the property has, this may change if the game sets the value to attempt detections 
local function SpoofProperty(toSpoof, property, value) 
    local typeOf = typeof(toSpoof)
    if typeOf == "Instance" then 
        local debugId = getDebugId(toSpoof)
        local newValue = (typeof(value) == "function" and value(toSpoof)) or value
        propertySpoofingFunctions[debugId .. property] = function(self) 
            return newValue
        end
        updateValueFunctions[debugId .. property] = function(self, val) 
            newValue = val
        end
    elseif typeOf == "string" then -- its a classname
        local debugIdValueTable = {}
        propertySpoofingFunctions[toSpoof .. property] = function(self) 
            local debugId = getDebugId(self)
            return debugIdValueTable[debugId] or (typeof(value) == "function" and value(toSpoof)) or value
        end
        updateValueFunctions[toSpoof .. property] = function(self, val) 
            local debugId = getDebugId(self)
            debugIdValueTable[debugId] = val
        end
    end
end

getgenv().SpoofProperty = SpoofProperty
return SpoofProperty
