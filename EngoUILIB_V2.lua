-- // EngoUI V2
local mouse = game.Players.LocalPlayer:GetMouse()
local RS = game:GetService("RunService")
local Keys = loadstring(game:HttpGet("https://raw.githubusercontent.com/joeengo/roblox/main/AlphanumericKeys.lua"))()

function getTextFromKeyCode(keycode)
    for i,v in pairs(Keys) do
        if v == keycode then
            return tostring(i)
        end
    end
    return nil
end

function isValidKey(keycode)
    if getTextFromKeyCode(keycode) then
        return true
    end
end

local library = {}
function library:CreateMain(title, description, keycode)
    local userInputConnection
    local closeconnection 
    function onSelfDestroy()
        if userInputConnection then
            userInputConnection:Disconnect()
        end
        if closeconnection then
            closeconnection:Disconnect()
        end
    end
    if getgenv().EngoUILib then 
        getgenv().EngoUILib:Destroy() 
        onSelfDestroy()
    end
    local firstTab
    local EngoUI = Instance.new("ScreenGui")
    if syn then 
        syn.protect_gui(EngoUI)
    end
    EngoUI.Parent = gethui and gethui() or game.CoreGui
    getgenv().EngoUILib = EngoUI
    closeconnection = game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.KeyCode == keycode then
            EngoUI.Enabled = not EngoUI.Enabled
        end
    end)

    local Main = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")
    local UICorner = Instance.new("UICorner")
    local Sidebar = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local Topbar = Instance.new("Frame")
    local Info = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Description = Instance.new("TextLabel")

    EngoUI.Name = "EngoUI"
    EngoUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Main.Name = "Main"
    Main.Parent = EngoUI
    Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Main.Position = UDim2.new(0.54207927, 0, 0.307602346, 0)
    Main.Size = UDim2.new(0, 550, 0, 397)
    Main.Active = true
    Main.Draggable = true

    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(3, 5, 16)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(4, 4, 22))}
    UIGradient.Offset = Vector2.new(-0.25, 0)
    UIGradient.Parent = Main

    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Main

    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.Active = true
    Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Sidebar.BackgroundTransparency = 1.000
    Sidebar.Position = UDim2.new(0.043636363, 0, 0.158690169, 0)
    Sidebar.Size = UDim2.new(0, 93, 0, 314)
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.ScrollBarThickness = 0
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y

    UIListLayout.Parent = Sidebar
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 15)

    Topbar.Name = "Topbar"
    Topbar.Parent = Main
    Topbar.BackgroundColor3 = Color3.fromRGB(1, 1, 1)
    Topbar.BackgroundTransparency = 1.000
    Topbar.Size = UDim2.new(0, 550, 0, 53)

    Info.Name = "Info"
    Info.Parent = Topbar
    Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Info.BackgroundTransparency = 1.000
    Info.Position = UDim2.new(0, 0, 0.113207549, 0)
    Info.Size = UDim2.new(0, 151, 0, 47)

    Title.Name = "Title"
    Title.Parent = Info
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.158940405, 0, 0.132075474, 0)
    Title.Size = UDim2.new(0, 116, 0, 21)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    Description.Name = "Description"
    Description.Parent = Info
    Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Description.BackgroundTransparency = 1.000
    Description.Position = UDim2.new(0.158940405, 0, 0.528301895, 0)
    Description.Size = UDim2.new(0, 116, 0, 16)
    Description.Font = Enum.Font.Gotham
    Description.Text = description
    Description.TextColor3 = Color3.fromRGB(207, 207, 207)
    Description.TextSize = 11.000
    Description.TextXAlignment = Enum.TextXAlignment.Left

    local library2 = {}
    library2["Tabs"] = {}
    function library2:CreateTab(name)

        local library3 = {}

        local UIListLayout_2 = Instance.new("UIListLayout") 
        local TabButton = Instance.new("TextButton")
        local Tab = Instance.new("ScrollingFrame")

        TabButton.Parent = Sidebar
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 1.000
        TabButton.Size = UDim2.new(0, 121, 0, 26)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 14.000
        TabButton.TextWrapped = true
        TabButton.TextXAlignment = Enum.TextXAlignment.Left

        Tab.Name = name.."Tab"
        Tab.Parent = Main
        Tab.Active = true
        Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Tab.BackgroundTransparency = 1.000
        Tab.BorderSizePixel = 0
        Tab.Position = UDim2.new(0.289090902, 0, 0.151133507, 0)
        Tab.Size = UDim2.new(0, 375, 0, 309)
        Tab.CanvasSize = UDim2.new(0, 0, 0, 0)
        Tab.ScrollBarThickness = 0
        Tab.TopImage = ""
        Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

        UIListLayout_2.Parent = Tab
        UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_2.Padding = UDim.new(0, 3)

        library2["Tabs"][name] = {
            Instance = Tab,
            Button = TabButton,
        }

        if not firstTab then 
            firstTab = library2["Tabs"][name]
        else
            Tab.Visible = false
            TabButton.TextColor3 = Color3.fromRGB(130, 130, 130)
        end

        function library2:OpenTab(tab)
            for i,v in pairs(library2["Tabs"]) do 
                if i ~= tab then
                    v.Instance.Visible = false
                    v.Button.TextColor3 = Color3.fromRGB(130, 130, 130)
                else
                    v.Instance.Visible = true
                    v.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end

        TabButton.MouseButton1Click:Connect(function()
            library2:OpenTab(name)
        end)

        function library3:CreateButton(text, callback)
            callback = callback or function() end
            local Button = Instance.new("TextButton")
            local UICorner_2 = Instance.new("UICorner")
            local Title_2 = Instance.new("TextLabel")
            local Icon = Instance.new("ImageLabel")

            Button.Name = text.."Button"
            Button.Parent = Tab
            Button.BackgroundColor3 = Color3.fromRGB(40, 43, 86)
            Button.BackgroundTransparency = 0.700
            Button.Size = UDim2.new(0, 375, 0, 49)
            Button.Font = Enum.Font.SourceSans
            Button.Text = ""
            Button.TextColor3 = Color3.fromRGB(0, 0, 0)
            Button.TextSize = 14.000

            UICorner_2.CornerRadius = UDim.new(0, 6)
            UICorner_2.Parent = Button

            Title_2.Name = "Title"
            Title_2.Parent = Button
            Title_2.AnchorPoint = Vector2.new(0, 0.5)
            Title_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_2.BackgroundTransparency = 1.000
            Title_2.Position = UDim2.new(0.141000003, 0, 0.5, 0)
            Title_2.Size = UDim2.new(0, 263, 0, 21)
            Title_2.Font = Enum.Font.GothamSemibold
            Title_2.Text = text
            Title_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_2.TextSize = 14.000
            Title_2.TextXAlignment = Enum.TextXAlignment.Left

            Icon.Name = "Icon"
            Icon.Parent = Button
            Icon.AnchorPoint = Vector2.new(0, 0.5)
            Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon.BackgroundTransparency = 1.000
            Icon.ClipsDescendants = true
            Icon.Position = UDim2.new(0.0400000028, 0, 0.5, 0)
            Icon.Size = UDim2.new(0, 19, 0, 24)
            Icon.Image = "rbxassetid://8284791761"
            Icon.ScaleType = Enum.ScaleType.Stretch

            Button.MouseButton1Click:Connect(callback)
        end

        function library3:CreateToggle(text, callback)
            local library4 = {}
            library4["Enabled"] = false
            callback = callback or function() end
            local Toggle = Instance.new("TextButton")
            local UICorner_3 = Instance.new("UICorner")
            local Title_3 = Instance.new("TextLabel")
            local Icon_2 = Instance.new("ImageLabel")

            Toggle.Name = text.."Toggle"
            Toggle.Parent = Tab
            Toggle.BackgroundColor3 = Color3.fromRGB(40, 43, 86)
            Toggle.BackgroundTransparency = 0.700
            Toggle.Size = UDim2.new(0, 375, 0, 49)
            Toggle.Font = Enum.Font.SourceSans
            Toggle.Text = ""
            Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.TextSize = 14.000

            UICorner_3.CornerRadius = UDim.new(0, 6)
            UICorner_3.Parent = Toggle

            Title_3.Name = "Title"
            Title_3.Parent = Toggle
            Title_3.AnchorPoint = Vector2.new(0, 0.5)
            Title_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_3.BackgroundTransparency = 1.000
            Title_3.Position = UDim2.new(0.138999999, 0, 0.520408154, 0)
            Title_3.Size = UDim2.new(0, 264, 0, 21)
            Title_3.Font = Enum.Font.GothamSemibold
            Title_3.Text = text
            Title_3.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_3.TextSize = 14.000
            Title_3.TextXAlignment = Enum.TextXAlignment.Left

            Icon_2.Name = "Icon"
            Icon_2.Parent = Toggle
            Icon_2.AnchorPoint = Vector2.new(0, 0.5)
            Icon_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon_2.BackgroundTransparency = 1.000
            Icon_2.ClipsDescendants = true
            Icon_2.Position = UDim2.new(0.0320000015, 0, 0.5, 0)
            Icon_2.Size = UDim2.new(0, 25, 0, 24)
            Icon_2.Image = "rbxassetid://3926305904"
            Icon_2.ImageColor3 = Color3.fromRGB(255, 119, 119)
            Icon_2.ImageRectOffset = Vector2.new(4, 4)
            Icon_2.ImageRectSize = Vector2.new(24, 24)
            Icon_2.SliceScale = 0.500

            function library4:Toggle(bool)
                if bool == nil then 
                    bool = not library4["Enabled"]
                end
                library4["Enabled"] = bool
                if not bool then 
                    Icon_2.ImageColor3 = Color3.fromRGB(255, 119, 119)
                    Icon_2.ImageRectOffset = Vector2.new(4, 4)
                    Icon_2.ImageRectSize = Vector2.new(24, 24)
                    callback(false)
                else
                    callback(true)
                    Icon_2.ImageRectOffset = Vector2.new(284, 924)
                    Icon_2.ImageColor3 = Color3.fromRGB(119, 255, 135)
                    Icon_2.ImageRectSize = Vector2.new(36, 36)
                end
            end

            Toggle.MouseButton1Click:Connect(function()
                library4:Toggle()
            end)

            return library4
        end

        function library3:CreateTextbox(text, callback)
            local library4 = {}
            library4["Text"] = ""

            local Textbox = Instance.new("TextLabel")
            local UICorner = Instance.new("UICorner")
            local Icon = Instance.new("ImageLabel")
            local Title = Instance.new("TextLabel")
            local Textbox_2 = Instance.new("TextBox")
            local UICorner_2 = Instance.new("UICorner")

            Textbox.Name = text.."Textbox"
            Textbox.Parent = Tab
            Textbox.BackgroundColor3 = Color3.fromRGB(40, 43, 86)
            Textbox.BackgroundTransparency = 0.700
            Textbox.Position = UDim2.new(0, 0, 0.326860845, 0)
            Textbox.Size = UDim2.new(0, 375, 0, 50)
            Textbox.Font = Enum.Font.SourceSans
            Textbox.Text = ""
            Textbox.TextColor3 = Color3.fromRGB(0, 0, 0)
            Textbox.TextSize = 14.000

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Textbox

            Icon.Name = "Icon"
            Icon.Parent = Textbox
            Icon.AnchorPoint = Vector2.new(0, 0.5)
            Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon.BackgroundTransparency = 1.000
            Icon.ClipsDescendants = true
            Icon.Position = UDim2.new(0.032333333, 0, 0.5, 0)
            Icon.Size = UDim2.new(0, 25, 0, 24)
            Icon.Image = "rbxassetid://3926305904"
            Icon.ImageRectOffset = Vector2.new(244, 44)
            Icon.ImageRectSize = Vector2.new(36, 36)
            Icon.ScaleType = Enum.ScaleType.Crop
            Icon.SliceScale = 0.500

            Title.Name = "Title"
            Title.Parent = Textbox
            Title.AnchorPoint = Vector2.new(0, 0.5)
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0.141000003, 0, 0.5, 0)
            Title.Size = UDim2.new(0, 101, 0, 21)
            Title.Font = Enum.Font.GothamSemibold
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14.000
            Title.TextXAlignment = Enum.TextXAlignment.Left

            Textbox_2.Name = "Textbox"
            Textbox_2.Parent = Textbox
            Textbox_2.AnchorPoint = Vector2.new(0, 0.5)
            Textbox_2.BackgroundColor3 = Color3.fromRGB(4, 4, 22)
            Textbox_2.BorderSizePixel = 0
            Textbox_2.Position = UDim2.new(0.43233332, 0, 0.5, 0)
            Textbox_2.Size = UDim2.new(0, 201, 0, 20)
            Textbox_2.Font = Enum.Font.Gotham
            Textbox_2.PlaceholderColor3 = Color3.fromRGB(60, 60, 60)
            Textbox_2.PlaceholderText = "Value"
            Textbox_2.Text = ""
            Textbox_2.TextColor3 = Color3.fromRGB(130, 130, 130)
            Textbox_2.TextSize = 14.000
            Textbox_2.TextWrapped = true
            Textbox_2.FocusLost:Connect(function()
                callback(Textbox_2.Text)
                library4["Text"] = Textbox_2.Text
            end)

            UICorner_2.CornerRadius = UDim.new(0, 6)
            UICorner_2.Parent = Textbox_2
        end

        function library3:CreateSlider(text, min, max, callback)
            local library4 = {}
            library4["Value"] = nil
            callback = callback or function() end

            local Slider = Instance.new("TextButton")
            local UICorner_4 = Instance.new("UICorner")
            local Icon_3 = Instance.new("ImageLabel")
            local Title_4 = Instance.new("TextLabel")
            local SliderBar = Instance.new("Frame")
            local UICorner_5 = Instance.new("UICorner")
            local Value = Instance.new("TextLabel")
            local Slider_2 = Instance.new("Frame")
            local UICorner_6 = Instance.new("UICorner")

            Slider.Name = text.."Slider"
            Slider.Parent = Tab
            Slider.BackgroundColor3 = Color3.fromRGB(40, 43, 86)
            Slider.BackgroundTransparency = 0.700
            Slider.Position = UDim2.new(0, 0, 0.336569577, 0)
            Slider.Size = UDim2.new(0, 375, 0, 50)
            Slider.Font = Enum.Font.SourceSans
            Slider.Text = ""
            Slider.TextColor3 = Color3.fromRGB(0, 0, 0)
            Slider.TextSize = 14.000
            Slider.AutoButtonColor = false

            UICorner_4.CornerRadius = UDim.new(0, 6)
            UICorner_4.Parent = Slider

            Icon_3.Name = "Icon"
            Icon_3.Parent = Slider
            Icon_3.AnchorPoint = Vector2.new(0, 0.5)
            Icon_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon_3.BackgroundTransparency = 1.000
            Icon_3.ClipsDescendants = true
            Icon_3.Position = UDim2.new(0.032333333, 0, 0.5, 0)
            Icon_3.Size = UDim2.new(0, 25, 0, 24)
            Icon_3.Image = "rbxassetid://3926305904"
            Icon_3.ImageRectOffset = Vector2.new(4, 124)
            Icon_3.ImageRectSize = Vector2.new(36, 36)
            Icon_3.SliceScale = 0.500

            Title_4.Name = "Title"
            Title_4.Parent = Slider
            Title_4.AnchorPoint = Vector2.new(0, 0.5)
            Title_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_4.BackgroundTransparency = 1.000
            Title_4.Position = UDim2.new(0.141000003, 0, 0.5, 0)
            Title_4.Size = UDim2.new(0, 101, 0, 21)
            Title_4.Font = Enum.Font.GothamSemibold
            Title_4.Text = text
            Title_4.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_4.TextSize = 14.000
            Title_4.TextXAlignment = Enum.TextXAlignment.Left

            SliderBar.Name = "SliderBar"
            SliderBar.Parent = Slider
            SliderBar.AnchorPoint = Vector2.new(0, 0.5)
            SliderBar.BackgroundColor3 = Color3.fromRGB(4, 4, 22)
            SliderBar.BorderSizePixel = 0
            SliderBar.Position = UDim2.new(-0.0666666701, 170, 0.5, 0)
            SliderBar.Size = UDim2.new(0, 219, 0, 15)

            UICorner_5.CornerRadius = UDim.new(0, 6)
            UICorner_5.Parent = SliderBar

            Value.Name = "Value"
            Value.Parent = SliderBar
            Value.AnchorPoint = Vector2.new(0.5, 0.5)
            Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1.000
            Value.Position = UDim2.new(0.5, 0, 0.5, 0)
            Value.Size = UDim2.new(0, 37, 0, 16)
            Value.ZIndex = 2
            Value.Font = Enum.Font.GothamSemibold
            Value.Text = ""
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = 10.000
            Value.TextStrokeTransparency = 0.000
            Value.TextXAlignment = Enum.TextXAlignment.Left

            Slider_2.Name = "Slider"
            Slider_2.Parent = SliderBar
            Slider_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Slider_2.Size = UDim2.new(0, 53, 0, 15)

            UICorner_6.CornerRadius = UDim.new(0, 6)
            UICorner_6.Parent = Slider_2
			
            local value
			local dragging
			local function slide(input)
				local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 0, (SliderBar.AbsoluteSize.Y))
				Slider_2:TweenSize(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
				local value = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
				Value.Text = tostring(value)
                library4["Value"] = value
				callback(value)
			end;
			
			SliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)

			SliderBar.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			SliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slide(input)
				end
			end)

			game:GetService("UserInputService").InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					slide(input)
				end
			end)
            return library4
        end

        function library3:CreateLabel(text)
            local library4 = {}
            local Label = Instance.new("TextLabel")
            local UICorner_7 = Instance.new("UICorner")
            local Icon_4 = Instance.new("ImageLabel")
            local Title_5 = Instance.new("TextLabel")
        
            Label.Name = text.."Label"
            Label.Parent = Tab
            Label.BackgroundColor3 = Color3.fromRGB(40, 43, 86)
            Label.BackgroundTransparency = 0.700
            Label.Position = UDim2.new(0, 0, 0.336569577, 0)
            Label.Size = UDim2.new(0, 375, 0, 50)
            Label.Font = Enum.Font.SourceSans
            Label.Text = ""
            Label.TextColor3 = Color3.fromRGB(0, 0, 0)
            Label.TextSize = 14.000

            UICorner_7.CornerRadius = UDim.new(0, 6)
            UICorner_7.Parent = Label

            Icon_4.Name = "Icon"
            Icon_4.Parent = Label
            Icon_4.AnchorPoint = Vector2.new(0, 0.5)
            Icon_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon_4.BackgroundTransparency = 1.000
            Icon_4.ClipsDescendants = true
            Icon_4.Position = UDim2.new(0.032333333, 0, 0.5, 0)
            Icon_4.Size = UDim2.new(0, 25, 0, 24)
            Icon_4.Image = "rbxassetid://3926305904"
            Icon_4.ImageRectOffset = Vector2.new(584, 4)
            Icon_4.ImageRectSize = Vector2.new(36, 36)
            Icon_4.ScaleType = Enum.ScaleType.Crop
            Icon_4.SliceScale = 0.500

            Title_5.Name = "Title"
            Title_5.Parent = Label
            Title_5.AnchorPoint = Vector2.new(0, 0.5)
            Title_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_5.BackgroundTransparency = 1.000
            Title_5.Position = UDim2.new(0.141000003, 0, 0.5, 0)
            Title_5.Size = UDim2.new(0, 101, 0, 21)
            Title_5.Font = Enum.Font.GothamSemibold
            Title_5.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_5.TextSize = 14.000
            Title_5.TextXAlignment = Enum.TextXAlignment.Left
            Title_5.Text = text

            function library4:Update(textnew) 
                Title_5.Text = textnew
            end
            return library4
        end

        function library3:CreateBind(text, originalBind, callback)
            local library4 = {}
            library4["IsRecording"] = false
            library4["Bind"] = originalBind
            callback = callback or function() end

            local Keybind = Instance.new("TextLabel")
            local UICorner_8 = Instance.new("UICorner")
            local Title_6 = Instance.new("TextLabel")
            local Icon_5 = Instance.new("TextLabel")
            local UICorner_9 = Instance.new("UICorner")
            local Edit = Instance.new("ImageButton")
            local BindText = Instance.new("TextLabel")

            Keybind.Name = text.."Bind"
            Keybind.Parent = Tab
            Keybind.BackgroundColor3 = Color3.fromRGB(40, 43, 86)
            Keybind.BackgroundTransparency = 0.700
            Keybind.Position = UDim2.new(0, 0, 0.336569577, 0)
            Keybind.Size = UDim2.new(0, 375, 0, 50)
            Keybind.Font = Enum.Font.SourceSans
            Keybind.Text = ""
            Keybind.TextColor3 = Color3.fromRGB(0, 0, 0)
            Keybind.TextSize = 14.000

            UICorner_8.CornerRadius = UDim.new(0, 6)
            UICorner_8.Parent = Keybind

            Title_6.Name = "Title"
            Title_6.Parent = Keybind
            Title_6.AnchorPoint = Vector2.new(0, 0.5)
            Title_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_6.BackgroundTransparency = 1.000
            Title_6.Position = UDim2.new(0.141000003, 0, 0.5, 0)
            Title_6.Size = UDim2.new(0, 101, 0, 21)
            Title_6.Font = Enum.Font.GothamSemibold
            Title_6.Text = "Bind"
            Title_6.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_6.TextSize = 14.000
            Title_6.TextXAlignment = Enum.TextXAlignment.Left

            Icon_5.Name = "Icon"
            Icon_5.Parent = Keybind
            Icon_5.AnchorPoint = Vector2.new(0, 0.5)
            Icon_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon_5.Position = UDim2.new(0.0320000015, 0, 0.5, 0)
            Icon_5.Size = UDim2.new(0, 25, 0, 24)
            Icon_5.Font = Enum.Font.GothamBold
            Icon_5.Text = getTextFromKeyCode(library4["Bind"])
            Icon_5.TextColor3 = Color3.fromRGB(0, 0, 0)
            Icon_5.TextSize = 14.000

            UICorner_9.CornerRadius = UDim.new(0, 4)
            UICorner_9.Parent = Icon_5

            Edit.Name = "Edit"
            Edit.Parent = Keybind
            Edit.BackgroundTransparency = 1.000
            Edit.LayoutOrder = 5
            Edit.Position = UDim2.new(0.903674901, 0, 0.248771951, 0)
            Edit.Size = UDim2.new(0, 25, 0, 25)
            Edit.ZIndex = 2
            Edit.Image = "rbxassetid://3926305904"
            Edit.ImageRectOffset = Vector2.new(284, 644)
            Edit.ImageRectSize = Vector2.new(36, 36)

            BindText.Name = "BindText"
            BindText.Parent = Keybind
            BindText.AnchorPoint = Vector2.new(0, 0.5)
            BindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            BindText.BackgroundTransparency = 1.000
            BindText.Position = UDim2.new(0.594333351, 0, 0.5, 0)
            BindText.Size = UDim2.new(0, 93, 0, 21)
            BindText.Font = Enum.Font.GothamSemibold
            BindText.Text = ""
            BindText.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindText.TextSize = 14.000
            BindText.TextXAlignment = Enum.TextXAlignment.Right
            Edit.MouseButton1Click:Connect(function()
                library4["IsBinding"] = true
                BindText.Text = "Press a key..."
            end)

            userInputConnection = game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Backspace then 
                    library4["IsBinding"] = false
                    library4["Bind"] = nil
                    BindText.Text = ""
                    Icon_5.Text = ""
                end
                if not isValidKey(input.KeyCode) then return end
                if library4["IsBinding"] then 
                    library4["Bind"] = input.KeyCode
                    library4["IsBinding"] = false
                    BindText.Text = ""
                    Icon_5.Text = getTextFromKeyCode(library4["Bind"]) or getTextFromKeyCode(originalBind)
                else
                    if input.KeyCode == library4["Bind"] then 
                        callback()
                    end
                end
            end)
            return library4
        end

        function library3:CreateDropdown(text, list, callback)
            local library4 = {}
            library4["Options"] = {}
            library4["Expanded"] = false

            local Dropdown = Instance.new("TextButton")
            local UICorner_10 = Instance.new("UICorner")
            local Title_7 = Instance.new("TextLabel")
            local Icon_6 = Instance.new("ImageLabel")

            Dropdown.Name = text.."Dropdown"
            Dropdown.Parent = Tab
            Dropdown.BackgroundColor3 = Color3.fromRGB(40, 43, 86)
            Dropdown.BackgroundTransparency = 0.700
            Dropdown.Position = UDim2.new(0, 0, 0.158576056, 0)
            Dropdown.Size = UDim2.new(0, 375, 0, 50)
            Dropdown.Font = Enum.Font.SourceSans
            Dropdown.Text = ""
            Dropdown.TextColor3 = Color3.fromRGB(0, 0, 0)
            Dropdown.TextSize = 14.000

            UICorner_10.CornerRadius = UDim.new(0, 6)
            UICorner_10.Parent = Dropdown

            Title_7.Name = "Title"
            Title_7.Parent = Dropdown
            Title_7.AnchorPoint = Vector2.new(0, 0.5)
            Title_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_7.BackgroundTransparency = 1.000
            Title_7.Position = UDim2.new(0.141000003, 0, 0.5, 0)
            Title_7.Size = UDim2.new(0, 263, 0, 21)
            Title_7.Font = Enum.Font.GothamSemibold
            Title_7.Text = "Dropdown"
            Title_7.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_7.TextSize = 14.000
            Title_7.TextXAlignment = Enum.TextXAlignment.Left

            Icon_6.Name = "Icon"
            Icon_6.Parent = Dropdown
            Icon_6.AnchorPoint = Vector2.new(0, 0.5)
            Icon_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon_6.BackgroundTransparency = 1.000
            Icon_6.ClipsDescendants = true
            Icon_6.Position = UDim2.new(0.031, 0 ,0.5, 0)
            Icon_6.Size = UDim2.new(0, 27, 0, 27)
            Icon_6.Image = "rbxassetid://3926305904"
            Icon_6.ImageRectOffset = Vector2.new(484, 204)
            Icon_6.ImageRectSize = Vector2.new(36, 36)

            function library4:CreateOption(text)  
                local Option = Instance.new("TextButton")
                local UICorner_11 = Instance.new("UICorner")
                local Title_8 = Instance.new("TextLabel")
                
                local ending = "Option"
                for i = 1,100 do
                    if i == 1 then i = "" end
                    if not Tab:FindFirstChild(tostring(text).."Option"..tostring(i)) then
                        ending = "Option"..tostring(i)
                        break
                    end
                end
                library4["Options"][tostring(text)..ending] = {
                    ["Value"] = text,
                    ["Instance"] = Option
                }
                library4["Connections"] = {}
                Option.Name = tostring(text)..ending
                Option.Parent = Tab
                Option.BackgroundColor3 = Color3.fromRGB(40, 43, 86)
                Option.BackgroundTransparency = 0.700
                Option.Position = UDim2.new(0, 0, 0.666666687, 0)
                Option.Size = UDim2.new(0, 354, 0, 50)
                Option.Font = Enum.Font.SourceSans
                Option.Text = ""
                Option.TextColor3 = Color3.fromRGB(0, 0, 0)
                Option.TextSize = 14.000
                Option.Visible = false

                UICorner_11.CornerRadius = UDim.new(0, 6)
                UICorner_11.Parent = Option

                Title_8.Name = "Title"
                Title_8.Parent = Option
                Title_8.AnchorPoint = Vector2.new(0, 0.5)
                Title_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Title_8.BackgroundTransparency = 1.000
                Title_8.Position = UDim2.new(0.0441919193, 0, 0.5, 0)
                Title_8.Size = UDim2.new(0, 291, 0, 21)
                Title_8.Font = Enum.Font.GothamSemibold
                Title_8.Text = "• "..tostring(text)
                Title_8.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title_8.TextSize = 14.000
                Title_8.TextXAlignment = Enum.TextXAlignment.Left
                return Option
            end

            function library4:CreateOptions(options)
                for i,v in pairs(options) do 
                    local option = library4:CreateOption(v)
                end
            end
            function library4:RefreshOptions(options)
                options = options or {}
                for i,v in pairs(library4["Options"]) do 
                    v.Instance:Destroy()
                end
                Tab.CanvasSize = UDim2.new(0, Tab.AbsoluteSize.X, 0, UIListLayout_2.AbsoluteContentSize.Y)
                library4["Expanded"] = false
                library4:CreateOptions(options)
            end
            library4:CreateOptions(list)
            Dropdown.MouseButton1Click:Connect(function()
                if library4["Expanded"] then 
                    for i,v in pairs(library4["Options"]) do
                        v.Instance.Visible = false
                    end
                    for i,v in pairs(library4["Connections"]) do
                        v:Disconnect()
                    end
                else
                    for i,v in pairs(library4["Options"]) do 
                        v.Instance.Visible = true
                        library4["Connections"][i] = v.Instance.MouseButton1Click:Connect(function()
                            callback(v.Value)
                            library4["Value"] = v.Value
                            library4["Expanded"] = false
                            Dropdown.Title.Text = text.." - "..tostring(v.Value)
                            for i2, v2 in pairs(library4["Options"]) do 
                                v2.Instance.Visible = false
                            end
                            Tab.CanvasSize = UDim2.new(0, Tab.AbsoluteSize.X, 0, UIListLayout_2.AbsoluteContentSize.Y)
                        end)
                    end
                end
                library4["Expanded"] = not library4["Expanded"]
                Tab.CanvasSize = UDim2.new(0, Tab.AbsoluteSize.X, 0, UIListLayout_2.AbsoluteContentSize.Y)
            end)
            return library4
        end

        function library3:CreateTextList(text, callback)
            local library4 = {}
            library4["List"] = {}
            library4["ListValues"] = {}
            library4["Expanded"] = true

            local Textlist = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")
            local Title = Instance.new("TextLabel")
            local Icon = Instance.new("ImageLabel")
            local Add = Instance.new("ImageButton")

            Textlist.Name = "Textlist"
            Textlist.Parent = Tab
            Textlist.BackgroundColor3 = Color3.fromRGB(40, 43, 86)
            Textlist.BackgroundTransparency = 0.700
            Textlist.Position = UDim2.new(0, 0, 0.158576056, 0)
            Textlist.Size = UDim2.new(0, 375, 0, 50)
            Textlist.Font = Enum.Font.SourceSans
            Textlist.Text = ""
            Textlist.TextColor3 = Color3.fromRGB(0, 0, 0)
            Textlist.TextSize = 14.000

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Textlist

            Title.Name = "Title"
            Title.Parent = Textlist
            Title.AnchorPoint = Vector2.new(0, 0.5)
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0.141000003, 0, 0.5, 0)
            Title.Size = UDim2.new(0, 263, 0, 21)
            Title.Font = Enum.Font.GothamSemibold
            Title.Text = "Textlist"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14.000
            Title.TextXAlignment = Enum.TextXAlignment.Left

            Icon.Name = "Icon"
            Icon.Parent = Textlist
            Icon.AnchorPoint = Vector2.new(0, 0.5)
            Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon.BackgroundTransparency = 1.000
            Icon.ClipsDescendants = true
            Icon.Position = UDim2.new(0.032333333, 0, 0.5, 0)
            Icon.Size = UDim2.new(0, 25, 0, 24)
            Icon.Image = "rbxassetid://3926305904"
            Icon.ImageRectOffset = Vector2.new(44, 204)
            Icon.ImageRectSize = Vector2.new(36, 36)
            Icon.ScaleType = Enum.ScaleType.Crop
            Icon.SliceScale = 0.500

            Add.Name = "Add"
            Add.Parent = Textlist
            Add.AnchorPoint = Vector2.new(0.5, 0.5)
            Add.BackgroundTransparency = 1.000
            Add.LayoutOrder = 3
            Add.Position = UDim2.new(0.934666634, 0, 0.5, 0)
            Add.Size = UDim2.new(0, 25, 0, 25)
            Add.ZIndex = 2
            Add.Image = "rbxassetid://3926307971"
            Add.ImageRectOffset = Vector2.new(324, 364)
            Add.ImageRectSize = Vector2.new(36, 36)

            function library4:CreateTextOption()
                local TextOption = Instance.new("TextLabel")
                local UICorner_2 = Instance.new("UICorner")
                local Textbox6 = Instance.new("TextBox")
                local UICorner_3 = Instance.new("UICorner")
                local Remove = Instance.new("TextButton")

                local ending = "TextOption"
                for i = 1,100 do
                    if i == 1 then i = "" end
                    if not Tab:FindFirstChild(tostring(text).."TextOption"..tostring(i)) then
                        ending = "TextOption"..tostring(i)
                        break
                    end
                end
                library4["List"][text..ending] = TextOption
                TextOption.Name = text..ending
                TextOption.Parent = Tab
                TextOption.BackgroundColor3 = Color3.fromRGB(40, 43, 86)
                TextOption.BackgroundTransparency = 0.700
                TextOption.Position = UDim2.new(0.0506666675, 0, 0.514563084, 0)
                TextOption.Size = UDim2.new(0, 356, 0, 50)
                TextOption.Font = Enum.Font.SourceSans
                TextOption.Text = ""
                TextOption.TextColor3 = Color3.fromRGB(0, 0, 0)
                TextOption.TextSize = 14.000

                UICorner_2.CornerRadius = UDim.new(0, 6)
                UICorner_2.Parent = TextOption

                Textbox6.Name = "Textbox"
                Textbox6.Parent = TextOption
                Textbox6.AnchorPoint = Vector2.new(0.5, 0.5)
                Textbox6.BackgroundColor3 = Color3.fromRGB(4, 4, 22)
                Textbox6.BorderSizePixel = 0
                Textbox6.Position = UDim2.new(0.5, 0, 0.5, 0)
                Textbox6.Size = UDim2.new(0, 288, 0, 20)
                Textbox6.Font = Enum.Font.Gotham
                Textbox6.PlaceholderColor3 = Color3.fromRGB(70, 70, 70)
                Textbox6.PlaceholderText = "Value"
                Textbox6.Text = ""
                Textbox6.TextColor3 = Color3.fromRGB(130, 130, 130)
                Textbox6.TextSize = 14.000
                Textbox6.TextWrapped = true
                Textbox6.FocusLost:Connect(function()
                    local text = Textbox6.Text
                    library4["ListValues"][TextOption.Name] = text
                    callback(library4["ListValues"])
                end)
                Textbox6.Focused:Connect(function()
                    if library4["ListValues"][TextOption.Name] then library4["ListValues"][TextOption.Name] = nil end
                end)

                Remove.Name = "Remove"
                Remove.Parent = TextOption
                Remove.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Remove.BackgroundTransparency = 1.000
                Remove.Position = UDim2.new(0.934339881, 0, 0.339999974, 0)
                Remove.Size = UDim2.new(0, 15, 0, 15)
                Remove.Font = Enum.Font.GothamSemibold
                Remove.Text = "X"
                Remove.TextColor3 = Color3.fromRGB(185, 113, 111)
                Remove.TextSize = 14.000
                Remove.TextStrokeColor3 = Color3.fromRGB(4, 4, 22)
                Remove.MouseButton1Click:Connect(function()
                    if library4["ListValues"][TextOption.Name] then library4["ListValues"][TextOption.Name] = nil end
                    if library4["List"][TextOption.Name] then library4["List"][TextOption.Name] = nil end
                    TextOption:Remove()
                    callback(library4["ListValues"])
                end)

                UICorner_3.CornerRadius = UDim.new(0, 6)
                UICorner_3.Parent = Textbox
            end

            function library4:Expand(bool)
                bool = bool or not library4["Expanded"]
                library4["Expanded"] = bool
                Tab.CanvasSize = UDim2.new(0, Tab.AbsoluteSize.X, 0, UIListLayout_2.AbsoluteContentSize.Y)
                for i,v in pairs(library4["List"]) do 
                    v.Visible = library4["Expanded"]
                end
            end
            Textlist.MouseButton1Click:Connect(function()
                library4:Expand()
            end)
            
            Add.MouseButton1Click:Connect(function()
                Tab.CanvasSize = UDim2.new(0, Tab.AbsoluteSize.X, 0, UIListLayout_2.AbsoluteContentSize.Y)
                library4:CreateTextOption()
                library4:Expand(true)
            end)


            return library4
        end 

        return library3
    end
	
    function library2:CreateSettings()
        local settings = library2:CreateTab("Settings")
        local uninject = settings:CreateButton("RemoveGUI", function() 
            if getgenv().EngoUILib then 
                onSelfDestroy()
                getgenv().EngoUILib:Destroy()
            end
        end)
        return settings
    end
	
    return library2
end

return library
