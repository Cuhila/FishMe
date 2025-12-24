local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local spamEnabled = false
local spamLoop = nil
local isUIVisible = true
local spamCount = 0

local fishPresets = {
    {name = "Black Maja", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(50, 50, 50)},
    {name = "El Maja", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(255, 215, 0)},
    {name = "Queen Grand Maja", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(255, 50, 255)},
    {name = "Queen Kraken", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(138, 43, 226)},
    {name = "Kraken", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(75, 0, 130)},
    {name = "Mega Hunt", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(255, 140, 0)},
    {name = "Flame Megalodon", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(255, 69, 0)},
    {name = "Naga", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(0, 255, 127)},
    {name = "Shark Bone", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(220, 220, 220)},
    {name = "King Crab", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(255, 0, 0)},
    {name = "KingJally Strong", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(0, 191, 255)},
    {name = "King Jelly", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(255, 105, 180)},
    {name = "Sapu Sapu Goib", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(139, 69, 19)},
    {name = "Abyssal Ness", rarity = "Secret", weight = 566.0, color = Color3.fromRGB(25, 25, 112)},
}

local selectedPreset = 1

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SynceFishMe"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local existingUI = game:GetService("CoreGui"):FindFirstChild("SynceFishUI")
if existingUI then
    existingUI:Destroy()
end

ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 200)
MainFrame.Position = UDim2.new(0.5, -210, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.Position = UDim2.new(0.5, -20, 0.5, -20)
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxasset://textures/ui/Glow.png"
Glow.ImageColor3 = Color3.fromRGB(255, 50, 255)
Glow.ImageTransparency = 0.6
Glow.ZIndex = 0
Glow.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 120, 0, 25)
Title.Position = UDim2.new(0, 10, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "Synce Fish Me"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local Counter = Instance.new("TextLabel")
Counter.Name = "Counter"
Counter.Size = UDim2.new(0, 60, 0, 25)
Counter.Position = UDim2.new(0, 140, 0, 8)
Counter.BackgroundTransparency = 1
Counter.Text = "0"
Counter.TextColor3 = Color3.fromRGB(255, 100, 255)
Counter.TextSize = 16
Counter.Font = Enum.Font.GothamBold
Counter.TextXAlignment = Enum.TextXAlignment.Left
Counter.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 26, 0, 22)
ToggleButton.Position = UDim2.new(1, -36, 0, 8)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "👁️"
ToggleButton.TextSize = 12
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, 250, 0, 155)
LeftPanel.Position = UDim2.new(0, 10, 0, 38)
LeftPanel.BackgroundTransparency = 1
LeftPanel.Parent = MainFrame

local SelectionFrame = Instance.new("Frame")
SelectionFrame.Name = "SelectionFrame"
SelectionFrame.Size = UDim2.new(1, 0, 0, 50)
SelectionFrame.Position = UDim2.new(0, 0, 0, 0)
SelectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SelectionFrame.BorderSizePixel = 0
SelectionFrame.Parent = LeftPanel

local SelectionCorner = Instance.new("UICorner")
SelectionCorner.CornerRadius = UDim.new(0, 8)
SelectionCorner.Parent = SelectionFrame

local SelectedFish = Instance.new("TextLabel")
SelectedFish.Name = "SelectedFish"
SelectedFish.Size = UDim2.new(1, -20, 0, 22)
SelectedFish.Position = UDim2.new(0, 10, 0, 8)
SelectedFish.BackgroundTransparency = 1
SelectedFish.Text = "Black Maja"
SelectedFish.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedFish.TextSize = 14
SelectedFish.Font = Enum.Font.GothamBold
SelectedFish.TextXAlignment = Enum.TextXAlignment.Left
SelectedFish.Parent = SelectionFrame

local FishInfo = Instance.new("TextLabel")
FishInfo.Name = "FishInfo"
FishInfo.Size = UDim2.new(1, -20, 0, 16)
FishInfo.Position = UDim2.new(0, 10, 0, 28)
FishInfo.BackgroundTransparency = 1
FishInfo.Text = "Secret • 566.0kg"
FishInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
FishInfo.TextSize = 11
FishInfo.Font = Enum.Font.GothamMedium
FishInfo.TextXAlignment = Enum.TextXAlignment.Left
FishInfo.Parent = SelectionFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, 0, 0, 95)
ScrollFrame.Position = UDim2.new(0, 0, 0, 60)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 255)
ScrollFrame.ScrollBarImageTransparency = 0.5
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = LeftPanel

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Size = UDim2.new(1, 0, 0, 0)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = ScrollFrame

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellSize = UDim2.new(0, 75, 0, 28)
UIGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.Parent = ButtonContainer

for i, preset in ipairs(fishPresets) do
    local FishButton = Instance.new("TextButton")
    FishButton.Name = "Fish"..i
    FishButton.Size = UDim2.new(0, 75, 0, 28)
    FishButton.BackgroundColor3 = i == 1 and preset.color or Color3.fromRGB(40, 40, 45)
    FishButton.BorderSizePixel = 0
    FishButton.Text = preset.name:match("(%w+)$")
    FishButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FishButton.TextSize = 9
    FishButton.Font = Enum.Font.GothamBold
    FishButton.AutoButtonColor = false
    FishButton.LayoutOrder = i
    FishButton.Parent = ButtonContainer
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = FishButton
    
    FishButton.MouseButton1Click:Connect(function()
        selectedPreset = i
        SelectedFish.Text = preset.name
        FishInfo.Text = preset.rarity .. " • " .. preset.weight .. "kg"
        
        Glow.ImageColor3 = preset.color
        
        for _, btn in pairs(ButtonContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                }):Play()
            end
        end
        
        TweenService:Create(FishButton, TweenInfo.new(0.2), {
            BackgroundColor3 = preset.color
        }):Play()
    end)
end

task.spawn(function()
    task.wait(0.1)
    ButtonContainer.Size = UDim2.new(1, 0, 0, UIGridLayout.AbsoluteContentSize.Y)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + 10)
end)

local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0, 145, 0, 155)
RightPanel.Position = UDim2.new(1, -155, 0, 38)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

local SpamButton = Instance.new("TextButton")
SpamButton.Name = "SpamButton"
SpamButton.Size = UDim2.new(1, 0, 0, 65)
SpamButton.Position = UDim2.new(0, 0, 0, 0)
SpamButton.BackgroundColor3 = Color3.fromRGB(255, 50, 255)
SpamButton.BorderSizePixel = 0
SpamButton.Text = ""
SpamButton.AutoButtonColor = false
SpamButton.Parent = RightPanel

local SpamCorner = Instance.new("UICorner")
SpamCorner.CornerRadius = UDim.new(0, 8)
SpamCorner.Parent = SpamButton

local SpamLabel = Instance.new("TextLabel")
SpamLabel.Name = "SpamLabel"
SpamLabel.Size = UDim2.new(1, 0, 1, 0)
SpamLabel.BackgroundTransparency = 1
SpamLabel.Text = "START SPAM"
SpamLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpamLabel.TextSize = 16
SpamLabel.Font = Enum.Font.GothamBold
SpamLabel.Parent = SpamButton

local CatchButton = Instance.new("TextButton")
CatchButton.Name = "CatchButton"
CatchButton.Size = UDim2.new(1, 0, 0, 55)
CatchButton.Position = UDim2.new(0, 0, 0, 75)
CatchButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
CatchButton.BorderSizePixel = 0
CatchButton.Text = "CATCH ONCE"
CatchButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CatchButton.TextSize = 13
CatchButton.Font = Enum.Font.GothamBold
CatchButton.AutoButtonColor = false
CatchButton.Parent = RightPanel

local CatchCorner = Instance.new("UICorner")
CatchCorner.CornerRadius = UDim.new(0, 8)
CatchCorner.Parent = CatchButton

local ResetButton = Instance.new("TextButton")
ResetButton.Name = "ResetButton"
ResetButton.Size = UDim2.new(1, 0, 0, 15)
ResetButton.Position = UDim2.new(0, 0, 0, 140)
ResetButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
ResetButton.BorderSizePixel = 0
ResetButton.Text = "Reset Counter"
ResetButton.TextColor3 = Color3.fromRGB(150, 150, 150)
ResetButton.TextSize = 9
ResetButton.Font = Enum.Font.GothamMedium
ResetButton.AutoButtonColor = false
ResetButton.Parent = RightPanel

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 4)
ResetCorner.Parent = ResetButton

local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, 45, 0, 45)
FloatingButton.Position = UDim2.new(0.85, 0, 0.15, 0)
FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloatingButton.BackgroundTransparency = 0.3
FloatingButton.BorderSizePixel = 0
FloatingButton.Text = "🐟"
FloatingButton.TextSize = 22
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.AutoButtonColor = false
FloatingButton.Visible = false
FloatingButton.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingButton

local FloatingGlow = Instance.new("ImageLabel")
FloatingGlow.Name = "FloatingGlow"
FloatingGlow.Size = UDim2.new(1, 16, 1, 16)
FloatingGlow.Position = UDim2.new(0.5, -8, 0.5, -8)
FloatingGlow.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingGlow.BackgroundTransparency = 1
FloatingGlow.Image = "rbxasset://textures/ui/Glow.png"
FloatingGlow.ImageColor3 = Color3.fromRGB(100, 100, 100)
FloatingGlow.ImageTransparency = 0.7
FloatingGlow.ZIndex = 0
FloatingGlow.Parent = FloatingButton

local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local floatingDragging = false
local floatingDragInput, floatingDragStart, floatingStartPos

local function updateFloating(input)
    local delta = input.Position - floatingDragStart
    FloatingButton.Position = UDim2.new(floatingStartPos.X.Scale, floatingStartPos.X.Offset + delta.X, floatingStartPos.Y.Scale, floatingStartPos.Y.Offset + delta.Y)
end

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatingDragging = true
        floatingDragStart = input.Position
        floatingStartPos = FloatingButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                floatingDragging = false
            end
        end)
    end
end)

FloatingButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        floatingDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == floatingDragInput and floatingDragging then
        updateFloating(input)
    end
end)

local function toggleUI()
    isUIVisible = not isUIVisible
    
    if isUIVisible then
        FloatingButton.Visible = false
        MainFrame.Visible = true
        MainFrame.Position = UDim2.new(0.5, -210, 0.5, -100)
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        
        for _, child in pairs(MainFrame:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                child.TextTransparency = 1
            elseif child:IsA("Frame") then
                child.BackgroundTransparency = 1
            elseif child:IsA("ImageLabel") and child.Name ~= "Glow" then
                child.ImageTransparency = 1
            end
        end
        MainFrame.BackgroundTransparency = 1
        
        local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 420, 0, 200)
        }):Play()
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            BackgroundTransparency = 0
        }):Play()
        
        for _, child in pairs(MainFrame:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
                    TextTransparency = 0
                }):Play()
            elseif child:IsA("Frame") and child.Name ~= "MainFrame" then
                TweenService:Create(child, TweenInfo.new(0.3), {
                    BackgroundTransparency = 0
                }):Play()
            elseif child:IsA("ImageLabel") and child.Name ~= "Glow" then
                TweenService:Create(child, TweenInfo.new(0.3), {
                    ImageTransparency = 0
                }):Play()
            end
        end
        
        SelectionFrame.BackgroundTransparency = 0
        
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {
            BackgroundTransparency = 1
        }):Play()
        
        for _, child in pairs(MainFrame:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.25), {
                    TextTransparency = 1
                }):Play()
            elseif child:IsA("Frame") then
                TweenService:Create(child, TweenInfo.new(0.25), {
                    BackgroundTransparency = 1
                }):Play()
            elseif child:IsA("ImageLabel") and child.Name ~= "Glow" then
                TweenService:Create(child, TweenInfo.new(0.25), {
                    ImageTransparency = 1
                }):Play()
            end
        end
        
        TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        task.wait(0.3)
        MainFrame.Visible = false
        FloatingButton.Visible = true
    end
end

local function catchFish()
    local preset = fishPresets[selectedPreset]
    
    pcall(function()
        local args = {
            hookPosition = Vector3.new(2074.549560546875, 450.6968688964844, 179.74554443359375),
            name = preset.name,
            rarity = preset.rarity,
            weight = preset.weight
        }
        
        local YahikoGiver = ReplicatedStorage:WaitForChild("FishingYahiko"):WaitForChild("YahikoGiver")
        YahikoGiver:FireServer(args)
        
        spamCount = spamCount + 1
        Counter.Text = tostring(spamCount)
    end)
end

local function toggleSpam()
    spamEnabled = not spamEnabled
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if spamEnabled then
        SpamLabel.Text = "STOP SPAM"
        TweenService:Create(SpamButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
        
        FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        FloatingButton.BackgroundTransparency = 0.2
        FloatingGlow.ImageColor3 = Color3.fromRGB(0, 255, 0)
        FloatingGlow.ImageTransparency = 0.5
        
        spamLoop = task.spawn(function()
            while spamEnabled do
                catchFish()
                task.wait(0.05)
            end
        end)
    else
        SpamLabel.Text = "START SPAM"
        TweenService:Create(SpamButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 50, 255)}):Play()
        
        FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        FloatingButton.BackgroundTransparency = 0.3
        FloatingGlow.ImageColor3 = Color3.fromRGB(100, 100, 100)
        FloatingGlow.ImageTransparency = 0.7
        
        if spamLoop then
            task.cancel(spamLoop)
            spamLoop = nil
        end
    end
end

SpamButton.MouseButton1Click:Connect(toggleSpam)
CatchButton.MouseButton1Click:Connect(catchFish)
FloatingButton.MouseButton1Click:Connect(toggleUI)
ToggleButton.MouseButton1Click:Connect(toggleUI)

ResetButton.MouseButton1Click:Connect(function()
    spamCount = 0
    Counter.Text = "0"
    TweenService:Create(ResetButton, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(255, 50, 255)
    }):Play()
    task.wait(0.1)
    TweenService:Create(ResetButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    }):Play()
end)

CatchButton.MouseEnter:Connect(function()
    TweenService:Create(CatchButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    }):Play()
end)

CatchButton.MouseLeave:Connect(function()
    TweenService:Create(CatchButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    }):Play()
end)

ToggleButton.MouseEnter:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    }):Play()
end)

ToggleButton.MouseLeave:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    }):Play()
end)

ResetButton.MouseEnter:Connect(function()
    TweenService:Create(ResetButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    }):Play()
end)

ResetButton.MouseLeave:Connect(function()
    TweenService:Create(ResetButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    }):Play()
end)