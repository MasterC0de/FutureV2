local tab = 0

function it(t)
    tab = tab + 1
    for i,v in next,t do 
        local a = type(v)
        print(string.rep("    ", tab), (a == "table" and tostring(i).." - " or "")..tostring(v))  
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

return newprint
