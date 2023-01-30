-- utilities.lua
-- Written by @engo#0320 // 30th January 2023

local utilities = {
    remotes = {},
}

-- CONSTANTS
local tsgPlaceIds = {11156779721} -- This could use GameID in the future.
local lastCheckedUpdate = 4429

-- VARIABLES
local httpService = game:GetService("HttpService")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local placeVersion = game.PlaceVersion
local islclosure = islclosure or (iscclosure and function(x) return not iscclosure(x) end)
local getfunctionname = function(x) return debug.getinfo and debug.getinfo(x).name or debug.info and debug.info(x, "n") end
local getsenv = getsenv or function(...) local gsf = getscriptclosure or getscriptfunction if gsf then return getfenv(gsf(...)) end end

-- FUNCTIONS

-- shallowClone: shallow clone a table
local function shallowClone(tab) 
    if not tab then 
        return 
    end

    local t = {}
    for i, v in next, tab do
        t[i] = v
    end
    
    return t
end

-- init: check place id, get remotes, bypass ac
function utilities.init()
    if not table.find(tsgPlaceIds, game.PlaceId) then 
        return warn("[utilities.lua] Invalid Place ID!")
    end

    local FiOne = replicatedStorage:FindFirstChild("FiOne", true)
    for i,v in next, getgc(true) do 
        local method, methodStr = utilities.remoteCheck(v)
        if method then 
            local upvals = debug.getupvalues(method)
            local remote = utilities.findInFiOne(upvals, "Instance", function(x) 
                return x:IsA("RemoteEvent") or x:IsA("RemoteFunction")
            end)

            if remote then
                utilities.remotes[remote.Name] = shallowClone(v)
            else
                warn("[utilities.lua] Remote was almost finalized, but something went wrong! (", remote or "NIL REMOTE", ")")
            end
        end
    end

    local oldJSONEncode; oldJSONEncode = hookfunction(httpService.JSONEncode, newcclosure(function(self, tab, ...) 
        local tab = shallowClone(tab)
        if tab then
            if rawget(tab, "clientInfo") then 
                rawset(tab, "clientInfo", "_")
            end
        end
        return oldJSONEncode(self, tab, ...)
    end))

    local oldTableFind; oldTableFind = hookfunction(getrenv().table.find, newcclosure(function(tab, val, ...)
        if oldTableFind(tab, "Collector") and oldTableFind(tab, "client") then
            return true
        end
        return oldTableFind(tab, val, ...)
    end))

    local oldDebugInfo; oldDebugInfo = hookfunction(getrenv().debug.info, newcclosure(function(level, inf, ...) 
        if level == 1 and inf == "s" then 
            return FiOne:GetFullName()
        end
        return oldDebugInfo(level, inf, ...)
    end))
end

-- isUpdated: return if the utils are updated/checked to latest tsg update
function utilities.isUpdated() 
    return placeVersion <= lastCheckedUpdate
end

-- findInFiOne: find a value of type typeOf with checkFunc returning true on it
function utilities.findInFiOne(tab, typeOf, checkFunc)
    for i,v in next, tab do
        if type(v) == "table" then 
            local value = rawget(v, "value")
            if typeof(value) == typeOf and checkFunc(value) then 
                return value
            end 

            for i2, v2 in next, v do 
                if typeof(v2) == "table" then 
                    local value = rawget(v2, "value")
                    if typeof(value) == typeOf and checkFunc(value) then 
                        return value
                    end 
                end
            end
        end
    end
end

-- remoteCheck: check if a table is a tsg remote table, return method and method name
function utilities.remoteCheck(tab) 
    if typeof(tab) == "table" then
        if rawget(tab, "Instance") then 
            return
        end

        local fireServer = rawget(tab, "FireServer")
        local method = fireServer or rawget(tab, "InvokeServer")
        method = typeof(method) == "function" and islclosure(method) and method

        return method, method == fireServer and "FireServer" or "InvokeServer"
    end
end 



return utilities
