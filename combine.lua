writefile("combineOutput.lua", "")

local files = type(...)=="table" and ... or {...}
for _, file in next, files do
    local content = isfile(file) and readfile(file) or "-- Unable to find"..file.."!"
    appendfile("combineOutput.lua", content.."\n")
end