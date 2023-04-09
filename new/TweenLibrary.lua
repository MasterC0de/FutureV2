-- engo's TweenLibrary

local TweenLibrary = {}

--[[
    USAGE:

    local t = TweenLibrary:Create(
        Drawing, 
        {Duration = 1, EasingDirection = Enum.EasingDirection.In, EasingStyle = Enum.EasingStyle.Linear}, 
        {
            Property = Value,
        }
    )

    t:Play()
]]

local TweenService = game:GetService("TweenService")
local getValue = TweenService.GetValue
local renderStepped = game:GetService("RunService").RenderStepped

local function ApplyAlpha(StartNum, GoalNum, Alpha) 
    return StartNum + ((GoalNum - StartNum) * Alpha)
end

local TweenMethods = {
    Vector2 = function(Start, Goal, Alpha) 
        local nx = ApplyAlpha(Start.X, Goal.X, Alpha)
        local ny = ApplyAlpha(Start.Y, Goal.Y, Alpha)

        return Vector2.new(nx, ny)
    end,
    UDim2 = function(Start, Goal, Alpha)
        local nSX = ApplyAlpha(Start.X.Scale, Goal.X.Scale, Alpha)
        local nSY = ApplyAlpha(Start.Y.Scale, Goal.Y.Scale, Alpha)
        local nOX = ApplyAlpha(Start.X.Offset, Goal.X.Offset, Alpha)
        local nOY = ApplyAlpha(Start.Y.Offset, Goal.Y.Offset, Alpha)

        return UDim2.new(nSX, nOX, nSY, nOY)
    end,
    Color3 = function(Start, Goal, Alpha) 
        local R1, G1, B1 = Start.R, Start.G, Start.B
        local R2, G2, B2 = Goal.R, Goal.G, Goal.B

        local nR, nG, nB = 
            ApplyAlpha(R1, R2, Alpha),
            ApplyAlpha(G1, G2, Alpha),
            ApplyAlpha(B1, B2, Alpha)

        return Color3.new(nR, nG, nB)
    end,
    Vector3 = function(Start, Goal, Alpha)
        local nx = ApplyAlpha(Start.X, Goal.X, Alpha)
        local ny = ApplyAlpha(Start.Y, Goal.Y, Alpha)
        local nz = ApplyAlpha(Start.Z, Goal.Z, Alpha)

        return Vector3.new(nx, ny, nz)
    end,
    CFrame = function(Start, Goal, Alpha)
        local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = Start:GetComponents()
        local _x, _y, _z, _R00, _R01, _R02, _R10, _R11, _R12, _R20, _R21, _R22 = Goal:GetComponents()

        local x_, y_, z_, R00_, R01_, R02_, R10_, R11_, R12_, R20_, R21_, R22_ =
            ApplyAlpha(x, _x, Alpha),
            ApplyAlpha(y, _y, Alpha),
            ApplyAlpha(z, _z, Alpha),
            ApplyAlpha(R00, _R00, Alpha),
            ApplyAlpha(R01, _R01, Alpha),
            ApplyAlpha(R02, _R02, Alpha),
            ApplyAlpha(R10, _R10, Alpha),
            ApplyAlpha(R11, _R11, Alpha),
            ApplyAlpha(R12, _R12, Alpha),
            ApplyAlpha(R20, _R20, Alpha),
            ApplyAlpha(R21, _R21, Alpha),
            ApplyAlpha(R22, _R22, Alpha)

        return CFrame.new(x_, y_, z_, R00_, R01_, R02_, R10, R11_, R12_, R20_, R21_, R22_)
    end,
    number = ApplyAlpha,
}

function TweenLibrary:GetValue(alpha, easingStyle, easingDirection) 
    return getValue(TweenService, alpha, easingStyle, easingDirection)
end

-- TweenInfo: {Duration: number}
function TweenLibrary:Create(object, tweenInfo, propTable) 
    local Tween = {}
    Tween.Clock = 0
    
    local OldValues = {}
    for property, value in next, propTable do 
        local oldValue = object[property]
        OldValues[property] = oldValue
    end

    function Tween:Update(deltaTime) 
        self.Clock = self.Clock + deltaTime
        self.Alpha = TweenLibrary:GetValue(self.Clock / tweenInfo.Duration, tweenInfo.EasingStyle, tweenInfo.EasingDirection)
       
        for property, value in next, propTable do 
            local currentValue = object[property]
            object[property] = TweenMethods[typeof(currentValue)](OldValues[property], value, self.Alpha)
        end
    end

    function Tween:Play() 
        self.Connection = renderStepped:Connect(function(deltaTime)
            Tween:Update(deltaTime)

            if self.Clock >= tweenInfo.Duration then 
                self.Connection:Disconnect()
                self.Completed = true
            end
        end)
    end

    return Tween
end

return TweenLibrary