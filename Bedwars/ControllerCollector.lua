local filename = "collection.txt"

local name = "Bedwars controller collection v1.04"
local path = "bedwars/"..filename
rconsoleclear()
if game.PlaceId ~= 6872274481 then rconsoleprint("@@RED@@");rconsoleprint("This game is not bedwars!") return end
rconsoleprint("@@LIGHT_BLUE@@");rconsoleprint("engo's ")
rconsoleprint("@@YELLOW@@");rconsoleprint(name.."\n\n")
writefile(path, "")

function addtofile(text, bypass) -- bypass removes the newline, please dont use it lol
	makefolder("bedwars")
	bypass=bypass or false
	for _, content in pairs(text) do 
		content = tostring(content)
		if _ ~= #text then 
			content = content.." "
		end
		appendfile(path, content)
	end
	if not bypass then
		appendfile(path, "\n")
	end
end

function newline(num)
	num = num or 1
	for i = 1, num do 
		addtofile({"\n"}, true)
	end
end

function c(v)
	local x = typeof(v)
	if x == "instance" then 
		return v:GetFullName()
	end
	v = tostring(v)
	if typeof(x) ~= "string" then 
	print(x, v)
	end
	return v
end

function n(v)
	local x = typeof(v)

	return tostring(v)
end
addtofile({"// Saved by engo's "..name})
newline()
local startTime = os.clock()
-- // What is this...
for i,v in pairs(getgc(true)) do 
	if type(v) == "table" then 
		if rawget(v, "BedwarsController") then
			for i2,v2 in pairs(v) do 
				newline(2)
				addtofile({n(i2)..":", c(v2)})
				if type(v2) == "table" then 
					for i3,v3 in pairs(v2) do 
						addtofile({"    ", n(i3)..":", c(v3)})
						if type(v3) == "table" then 
							for i4,v4 in pairs(v3) do
								addtofile({"           ", n(i4)..":", c(v4)}) 
								if type(v4) == "table" then 
									for i5,v5 in pairs(v4) do
										addtofile({"                      ", n(i5)..":", c(v5)})
										if type(v5) == "table" then 
											for i6, v6 in pairs(v5) do 
												addtofile({"                                 ", n(i6)..":", c(v6)})
												if type(v6) == "table" then 
													for i7,v7 in pairs(v6) do
														addtofile({"                                            ", n(i7)..":", c(v7)})
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
newline(2)
addtofile({"// Saved by engo's "..name})
local deltaTime = math.floor((os.clock() - startTime) * 1000) / 1000
addtofile({"// Time taken: "..deltaTime.."s"})
rconsoleprint("@@LIGHT_GREEN@@")
rconsoleprint("done")
rconsoleprint("@@LIGHT_GRAY@@")
rconsoleprint(" ("..deltaTime.."s)\n")
rconsoleprint("@@YELLOW@@")
rconsoleprint("located in "..path)
