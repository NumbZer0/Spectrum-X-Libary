-- ========== SPECTRUM UI LIBRARY V1.0 ==========
local SpectrumUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Criar ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpectrumUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Função para criar Window
function SpectrumUI:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    -- Frame principal (mais largo e menos alto para mobile)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame
    
    -- Sombra
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
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 15)
    HeaderCorner.Parent = Header
    
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 15)
    HeaderFix.Position = UDim2.new(0, 0, 1, -15)
    HeaderFix.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Spectrum UI"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(0, 200, 0, 15)
    Subtitle.Position = UDim2.new(0, 15, 1, -18)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = config.Subtitle or ""
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 10
    Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header
    
    -- Botão Minimizar
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
    
    -- Sidebar (Abas no lado esquerdo)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -55)
    Sidebar.Position = UDim2.new(0, 10, 0, 50)
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
    
    -- Container de conteúdo
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -170, 1, -55)
    ContentContainer.Position = UDim2.new(0, 160, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Sistema de minimizar
    local isMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 550, 0, 45)
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
    
    -- Função para criar Tab
    function Window:CreateTab(tabConfig)
        local Tab = {}
        Tab.Elements = {}
        
        -- Frame da Tab
        local TabFrame = Instance.new("Frame")
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        TabFrame.Parent = ContentContainer
        
        local ScrollingFrame = Instance.new("ScrollingFrame")
        ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
        ScrollingFrame.BackgroundTransparency = 1
        ScrollingFrame.BorderSizePixel = 0
        ScrollingFrame.ScrollBarThickness = 4
        ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(25, 25, 112)
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
        
        -- Auto resize ScrollingFrame
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Botão da Tab na Sidebar
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
            TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        table.insert(Window.Tabs, {
            Frame = TabFrame,
            Button = TabButton,
            Label = TabLabel
        })
        
        -- Mostrar primeira tab
        if #Window.Tabs == 1 then
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        -- Função para criar Button
        function Tab:Button(btnConfig)
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
            ButtonFrame.Text = ""
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Parent = ScrollingFrame
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 10)
            ButtonCorner.Parent = ButtonFrame
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
            ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Text = btnConfig.Name or "Button"
            ButtonLabel.Font = Enum.Font.GothamBold
            ButtonLabel.TextSize = 13
            ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Center
            ButtonLabel.Parent = ButtonFrame
            
            ButtonFrame.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 140, 255)}):Play()
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 120, 255)}):Play()
            end)
            
            ButtonFrame.MouseButton1Click:Connect(function()
                if btnConfig.Callback then
                    btnConfig.Callback()
                end
            end)
        end
        
        -- Função para criar Toggle
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
                ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
                Circle.Position = UDim2.new(1, -22, 0.5, -9.5)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                isEnabled = not isEnabled
                
                if isEnabled then
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 112)}):Play()
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
        
        -- Função para criar Input
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
        
        -- Função para criar Dropdown
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
                    OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
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

-- Função para criar Toggle UI Button (botão flutuante)
function SpectrumUI:CreateToggleButton(config)
    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
    ToggleBtn.Image = config.Icon or "rbxassetid://7733954760"
    ToggleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Parent = ScreenGui
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = ToggleBtn
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(255, 255, 255)
    BtnStroke.Thickness = 2
    BtnStroke.Transparency = 0.8
    BtnStroke.Parent = ToggleBtn
    
    ToggleBtn.MouseButton1Click:Connect(function()
        ScreenGui:FindFirstChild("MainFrame").Visible = not ScreenGui:FindFirstChild("MainFrame").Visible
    end)
    
    -- Draggable
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
