local tab = -1

function it(t)
    tab = tab + 1
    for i,v in next,t do 
        local a = typeof(v)
        print(tab ~= 0 and string.rep("    ", tab) or "", (((a == "table" or a == "function" or not tonumber(i)) and tab ~= 0) and tostring(i).." = " or (tab == 0 and a == "table") and "start-" or "")..(a=="Instance" and "game."..v:GetFullName() or tostring(v)))  
        if a == "table" then 
            it(v)
        end
    end
    tab = tab - 1
end

function newprint(...)
    local args = {...}
    it(args)
end

if getgenv then
    getgenv().printtable = newprint
end

return newprint
