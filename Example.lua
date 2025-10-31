-- ========== SPECTRUM UI LIBRARY V1.8 ==========
local SpectrumUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function makeHeaderDraggable(header, frame)
    local dragging = false
    local mousePos, framePos

    local function getInputPosition(input)
        return input.UserInputType == Enum.UserInputType.Touch and input.Position or UserInputService:GetMouseLocation()
    end

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = getInputPosition(input)
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = getInputPosition(input) - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

local function applyTransparency(parent, transparency)
    for _, obj in ipairs(parent:GetDescendants()) do
        if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("ScrollingFrame") then
            obj.BackgroundTransparency = transparency
        end
        if obj:IsA("ImageLabel") and obj.Name == "LogoImg" then
            obj.BackgroundTransparency = 1
            obj.ImageTransparency = 0.25
        end
        if obj:IsA("ImageButton") and obj.Name == "ToggleBtn" then
            obj.BackgroundTransparency = transparency
        end
    end
end

function SpectrumUI:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil

    local transparency = typeof(config.Transparency) == "number" and math.clamp(config.Transparency, 0, 0.8) or 0.3

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SpectrumUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Visible = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(128,0,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
    }
    MainGradient.Rotation = 90
    MainGradient.Parent = MainFrame

    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxasset://textures/ui/Chat/9-slice-shadow.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.3
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 15)
    HeaderCorner.Parent = Header

    local HeaderGradient = Instance.new("UIGradient")
    HeaderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(128,0,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
    }
    HeaderGradient.Rotation = 90
    HeaderGradient.Parent = Header

    -- Logo atrás do título/subtítulo (se fornecido)
    if config.LogoId then
        local LogoImg = Instance.new("ImageLabel")
        LogoImg.Name = "LogoImg"
        LogoImg.Size = UDim2.new(0, 38, 0, 38)
        LogoImg.Position = UDim2.new(0, 10, 0.5, -19)
        LogoImg.BackgroundTransparency = 1
        LogoImg.Image = tostring(config.LogoId)
        LogoImg.ImageTransparency = 0.25
        LogoImg.ZIndex = 1
        LogoImg.Parent = Header
    end

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 0, 24)
    Title.Position = UDim2.new(0, 60, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Spectrum UI"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -80, 0, 15)
    Subtitle.Position = UDim2.new(0, 60, 0, 32)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = config.Subtitle or ""
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 10
    Subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.ZIndex = 2
    Subtitle.Parent = Header

    -- Drag pelo header no mobile e PC!
    makeHeaderDraggable(Header, MainFrame)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
    MinimizeButton.Position = UDim2.new(1, -45, 0.5, -17.5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    MinimizeButton.Text = "−"
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 20
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Parent = Header

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeButton

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -75)
    Sidebar.Position = UDim2.new(0, 10, 0, 70)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 8)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = Sidebar

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = Sidebar

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -170, 1, -75)
    ContentContainer.Position = UDim2.new(0, 160, 0, 70)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- PRETO IGUAL SIDEBAR!
    ContentContainer.Parent = MainFrame

    local isMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized

        if isMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 550, 0, 60)
            }):Play()
            Sidebar.Visible = false
            ContentContainer.Visible = false
            MinimizeButton.Text = "+"
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 550, 0, 350)
            }):Play()
            task.wait(0.1)
            Sidebar.Visible = true
            ContentContainer.Visible = true
            MinimizeButton.Text = "−"
        end
    end)

    applyTransparency(MainFrame, transparency)

    function Window:CreateTab(tabConfig)
        local Tab = {}
        Tab.Elements = {}

        local TabFrame = Instance.new("Frame")
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- PRETO
        TabFrame.Parent = ContentContainer

        local ScrollingFrame = Instance.new("ScrollingFrame")
        ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
        ScrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        ScrollingFrame.BorderSizePixel = 0
        ScrollingFrame.ScrollBarThickness = 4
        ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 0)
        ScrollingFrame.Parent = TabFrame

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = ScrollingFrame

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.Parent = ScrollingFrame

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = Sidebar

        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8)
        TabButtonCorner.Parent = TabButton

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -10, 1, 0)
        TabLabel.Position = UDim2.new(0, 10, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabConfig.Name or "Tab"
        TabLabel.Font = Enum.Font.GothamBold
        TabLabel.TextSize = 13
        TabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Frame.Visible = false
                tab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                tab.Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            end

            TabFrame.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        table.insert(Window.Tabs, {
            Frame = TabFrame,
            Button = TabButton,
            Label = TabLabel
        })

        if #Window.Tabs == 1 then
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        function Tab:Button(btnConfig)
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
            ButtonFrame.Text = ""
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Parent = ScrollingFrame

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 10)
            ButtonCorner.Parent = ButtonFrame

            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Size = UDim2.new(1, -44, 1, 0)
            ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Text = btnConfig.Name or "Button"
            ButtonLabel.Font = Enum.Font.GothamBold
            ButtonLabel.TextSize = 15
            ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Center
            ButtonLabel.Parent = ButtonFrame

            local ClickIcon = Instance.new("ImageLabel")
            ClickIcon.Size = UDim2.new(0, 26, 0, 26)
            ClickIcon.Position = UDim2.new(1, -32, 0.5, -13)
            ClickIcon.BackgroundTransparency = 1
            ClickIcon.Image = btnConfig.ClickIconId or "rbxassetid://10366495969"
            ClickIcon.Parent = ButtonFrame

            ButtonFrame.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(160, 10, 10)}):Play()
            end)

            ButtonFrame.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(128, 0, 0)}):Play()
            end)

            ButtonFrame.MouseButton1Click:Connect(function()
                if btnConfig.Callback then
                    btnConfig.Callback()
                end
            end)
        end

        function Tab:Notice(noticeConfig)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 60)
            frame.BackgroundColor3 = noticeConfig.Color or Color3.fromRGB(255, 230, 180)
            frame.BorderSizePixel = 0
            frame.Parent = ScrollingFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = frame

            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0, 34, 0, 34)
            icon.Position = UDim2.new(0, 10, 0, 13)
            icon.BackgroundTransparency = 1
            icon.Image = "rbxassetid://4871684504"
            icon.Parent = frame

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -60, 0, 24)
            title.Position = UDim2.new(0, 54, 0, 8)
            title.BackgroundTransparency = 1
            title.Text = noticeConfig.Title or "Aviso"
            title.Font = Enum.Font.GothamBold
            title.TextSize = 15
            title.TextColor3 = Color3.fromRGB(255,255,255)
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame

            if noticeConfig.Subtitle then
                local subtitle = Instance.new("TextLabel")
                subtitle.Size = UDim2.new(1, -60, 0, 18)
                subtitle.Position = UDim2.new(0, 54, 0, 32)
                subtitle.BackgroundTransparency = 1
                subtitle.Text = noticeConfig.Subtitle
                subtitle.Font = Enum.Font.Gotham
                subtitle.TextSize = 12
                subtitle.TextColor3 = Color3.fromRGB(255,255,255)
                subtitle.TextXAlignment = Enum.TextXAlignment.Left
                subtitle.TextWrapped = true
                subtitle.Parent = frame
            end
        end

        function Tab:Toggle(toggleConfig)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 70)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = ScrollingFrame

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 10)
            ToggleCorner.Parent = ToggleFrame

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -65, 0, 20)
            ToggleLabel.Position = UDim2.new(0, 12, 0, 10)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleConfig.Name or "Toggle"
            ToggleLabel.Font = Enum.Font.GothamBold
            ToggleLabel.TextSize = 13
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame

            local ToggleDesc = Instance.new("TextLabel")
            ToggleDesc.Size = UDim2.new(1, -65, 0, 30)
            ToggleDesc.Position = UDim2.new(0, 12, 0, 32)
            ToggleDesc.BackgroundTransparency = 1
            ToggleDesc.Text = toggleConfig.Description or ""
            ToggleDesc.Font = Enum.Font.Gotham
            ToggleDesc.TextSize = 11
            ToggleDesc.TextColor3 = Color3.fromRGB(160, 160, 160)
            ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
            ToggleDesc.TextWrapped = true
            ToggleDesc.Parent = ToggleFrame

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 25)
            ToggleButton.Position = UDim2.new(1, -55, 0, 10)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame

            local ToggleBtnCorner = Instance.new("UICorner")
            ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
            ToggleBtnCorner.Parent = ToggleButton

            local Circle = Instance.new("Frame")
            Circle.Name = "Circle"
            Circle.Size = UDim2.new(0, 19, 0, 19)
            Circle.Position = UDim2.new(0, 3, 0.5, -9.5)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.BorderSizePixel = 0
            Circle.Parent = ToggleButton

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle

            local isEnabled = toggleConfig.Default or false

            if isEnabled then
                ToggleButton.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
                Circle.Position = UDim2.new(1, -22, 0.5, -9.5)
            end

            ToggleButton.MouseButton1Click:Connect(function()
                isEnabled = not isEnabled

                if isEnabled then
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(128, 0, 0)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -9.5)}):Play()
                else
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9.5)}):Play()
                end

                if toggleConfig.Callback then
                    toggleConfig.Callback(isEnabled)
                end
            end)
        end

        function Tab:Input(inputConfig)
            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, 0, 0, 70)
            InputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            InputFrame.BorderSizePixel = 0
            InputFrame.Parent = ScrollingFrame

            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 10)
            InputCorner.Parent = InputFrame

            local InputLabel = Instance.new("TextLabel")
            InputLabel.Size = UDim2.new(1, -20, 0, 20)
            InputLabel.Position = UDim2.new(0, 12, 0, 8)
            InputLabel.BackgroundTransparency = 1
            InputLabel.Text = inputConfig.Name or "Input"
            InputLabel.Font = Enum.Font.GothamBold
            InputLabel.TextSize = 13
            InputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = InputFrame

            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(1, -24, 0, 30)
            InputBox.Position = UDim2.new(0, 12, 0, 32)
            InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            InputBox.BorderSizePixel = 0
            InputBox.Text = inputConfig.Default or ""
            InputBox.PlaceholderText = inputConfig.Placeholder or "Enter text..."
            InputBox.Font = Enum.Font.Gotham
            InputBox.TextSize = 12
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            InputBox.BackgroundTransparency = 0
            InputBox.Parent = InputFrame

            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 8)
            InputBoxCorner.Parent = InputBox

            InputBox.FocusLost:Connect(function()
                if inputConfig.Callback then
                    inputConfig.Callback(InputBox.Text)
                end
            end)
        end

        function Tab:Dropdown(dropConfig)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 45)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = ScrollingFrame

            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 10)
            DropCorner.Parent = DropdownFrame

            local DropButton = Instance.new("TextButton")
            DropButton.Size = UDim2.new(1, -24, 0, 35)
            DropButton.Position = UDim2.new(0, 12, 0, 5)
            DropButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            DropButton.Text = ""
            DropButton.Parent = DropdownFrame

            local DropBtnCorner = Instance.new("UICorner")
            DropBtnCorner.CornerRadius = UDim.new(0, 8)
            DropBtnCorner.Parent = DropButton

            local DropLabel = Instance.new("TextLabel")
            DropLabel.Size = UDim2.new(1, -40, 1, 0)
            DropLabel.Position = UDim2.new(0, 12, 0, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.Text = dropConfig.Default or dropConfig.Name or "Select..."
            DropLabel.Font = Enum.Font.GothamBold
            DropLabel.TextSize = 12
            DropLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropLabel.Parent = DropButton

            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 20, 1, 0)
            Arrow.Position = UDim2.new(1, -25, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 10
            Arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
            Arrow.Parent = DropButton

            local OptionsList = Instance.new("Frame")
            OptionsList.Size = UDim2.new(1, -24, 0, 0)
            OptionsList.Position = UDim2.new(0, 12, 0, 45)
            OptionsList.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            OptionsList.BorderSizePixel = 0
            OptionsList.Visible = false
            OptionsList.ClipsDescendants = true
            OptionsList.Parent = DropdownFrame

            local OptionsCorner = Instance.new("UICorner")
            OptionsCorner.CornerRadius = UDim.new(0, 8)
            OptionsCorner.Parent = OptionsList

            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Parent = OptionsList

            local isOpen = false

            DropButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen

                if isOpen then
                    local targetSize = #(dropConfig.Options or {}) * 30
                    OptionsList.Visible = true
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 45 + targetSize + 5)}):Play()
                    TweenService:Create(OptionsList, TweenInfo.new(0.2), {Size = UDim2.new(1, -24, 0, targetSize)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                else
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                    TweenService:Create(OptionsList, TweenInfo.new(0.2), {Size = UDim2.new(1, -24, 0, 0)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    task.wait(0.2)
                    OptionsList.Visible = false
                end
            end)

            for _, option in pairs(dropConfig.Options or {}) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                OptionButton.Text = option
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextSize = 11
                OptionButton.TextColor3 = Color3.fromRGB(220, 220, 220)
                OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                OptionButton.Parent = OptionsList

                local OptionPadding = Instance.new("UIPadding")
                OptionPadding.PaddingLeft = UDim.new(0, 12)
                OptionPadding.Parent = OptionButton

                OptionButton.MouseEnter:Connect(function()
                    OptionButton.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
                end)

                OptionButton.MouseLeave:Connect(function()
                    OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                end)

                OptionButton.MouseButton1Click:Connect(function()
                    DropLabel.Text = option
                    isOpen = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                    TweenService:Create(OptionsList, TweenInfo.new(0.2), {Size = UDim2.new(1, -24, 0, 0)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    task.wait(0.2)
                    OptionsList.Visible = false

                    if dropConfig.Callback then
                        dropConfig.Callback(option)
                    end
                end)
            end
        end

        return Tab
    end

    return Window
end

function SpectrumUI:CreateToggleButton(config)
    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
    ToggleBtn.BackgroundTransparency = typeof(config.Transparency) == "number" and math.clamp(config.Transparency, 0, 0.8) or 0.3
    ToggleBtn.Image = config.Icon or "rbxassetid://7733954760"
    ToggleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Parent = game:GetService("CoreGui")

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = ToggleBtn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(255, 255, 255)
    BtnStroke.Thickness = 2
    BtnStroke.Transparency = 0.8
    BtnStroke.Parent = ToggleBtn

    ToggleBtn.MouseButton1Click:Connect(function()
        local MainFrame = game:GetService("CoreGui"):FindFirstChild("SpectrumUI"):FindFirstChild("MainFrame")
        if MainFrame then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local dragging = false
    local dragInput, mousePos, framePos

    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = ToggleBtn.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    ToggleBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            ToggleBtn.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)

    return ToggleBtn
end

return SpectrumUI
