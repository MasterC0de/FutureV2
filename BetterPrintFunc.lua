local tab = 0

function it(t)
    tab = tab + 1
    for i,v in next,t do 
        print(string.rep("    ", tab), v)  
        if type(v) == "table" then 
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
