-- STARS MOD | ULTRA CHEAT MENU 2026
-- Містить: Aimbot, Fly, Noclip, Speed, ESP
-- Відкриття: ПРАВИЙ SHIFT
-- Анімації, сучасний дизайн, довгі слоти

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- ========== НАЛАШТУВАННЯ ==========
local Settings = {
    MenuOpen = false,
    -- AIM
    AimbotEnabled = false,
    SilentAimEnabled = false,
    AimPart = "Head",
    CheckVisible = true,
    TeamCheck = true,
    AimRadius = 200,
    SilentRadius = 300,
    Smoothness = 0.3,
    -- VISUAL
    WallhackEnabled = false,
    ESPColor = Color3.fromRGB(255, 50, 50),
    ESPTransparency = 0.4,
    -- MOVEMENT
    NoclipEnabled = false,
    FlyEnabled = false,
    FlySpeed = 50,
    SpeedEnabled = false,
    SpeedValue = 32,
    -- FLY GUI (сумісність)
    FlyGUIVisible = true,
}

-- ========== ЗМІННІ ==========
local noclipParts = {}
local flyVelocity = nil
local originalWalkSpeed = 16
local flyBodyGyro = nil
local flyBodyVelocity = nil

-- ========== ГОЛОВНЕ МЕНЮ ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StarsCheatMenu2026"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 520)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.BackgroundTransparency = 1

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(60, 60, 80)
frameStroke.Thickness = 1
frameStroke.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28))
})
gradient.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ STARS MOD 2026 ⚡"
title.TextColor3 = Color3.fromRGB(255, 80, 80)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Кнопка закриття
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0, 9)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    Settings.MenuOpen = false
    screenGui.Enabled = false
end)

-- СКРОЛЛ КОНТЕЙНЕР
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -60)
scrollingFrame.Position = UDim2.new(0, 5, 0, 55)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 80)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.Parent = mainFrame

-- ========== ФУНКЦІЇ ДЛЯ СТВОРЕННЯ ЕЛЕМЕНТІВ ==========

local function createSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 35)
    section.BackgroundTransparency = 1
    section.Parent = scrollingFrame
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -20, 0, 2)
    line.Position = UDim2.new(0, 10, 1, -10)
    line.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    line.BorderSizePixel = 0
    line.Parent = section
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
end

local function addToggle(name, flag, defaultColor)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    frame.Parent = scrollingFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, -20, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 70, 0, 38)
    toggleBtn.Position = UDim2.new(1, -85, 0.5, -19)
    toggleBtn.BackgroundColor3 = defaultColor or Color3.fromRGB(0, 180, 0)
    toggleBtn.Text = Settings[flag] and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = toggleBtn
    
    -- Анімація при наведенні
    local function animateButtonIn()
        TweenService:Create(toggleBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Settings[flag] and Color3.fromRGB(0, 220, 0) or Color3.fromRGB(220, 0, 0)
        }):Play()
        TweenService:Create(toggleBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 75, 0, 40)
        }):Play()
    end
    
    local function animateButtonOut()
        TweenService:Create(toggleBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Settings[flag] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        }):Play()
        TweenService:Create(toggleBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 70, 0, 38)
        }):Play()
    end
    
    toggleBtn.MouseEnter:Connect(animateButtonIn)
    toggleBtn.MouseLeave:Connect(animateButtonOut)
    
    toggleBtn.MouseButton1Click:Connect(function()
        Settings[flag] = not Settings[flag]
        toggleBtn.Text = Settings[flag] and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = Settings[flag] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        
        -- Спеціальна обробка
        if flag == "NoclipEnabled" then
            if Settings.NoclipEnabled then
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            table.insert(noclipParts, part)
                        end
                    end
                end
            else
                for _, part in ipairs(noclipParts) do
                    if part and part.Parent then
                        part.CanCollide = true
                    end
                end
                noclipParts = {}
            end
        end
        
        if flag == "FlyEnabled" then
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if Settings.FlyEnabled then
                if humanoid then
                    originalWalkSpeed = humanoid.WalkSpeed
                    humanoid.PlatformStand = true
                    humanoid.AutoRotate = false
                end
            else
                if humanoid then
                    humanoid.PlatformStand = false
                    humanoid.AutoRotate = true
                end
                if flyVelocity then flyVelocity:Destroy() end
                if flyBodyGyro then flyBodyGyro:Destroy() end
                flyVelocity = nil
                flyBodyGyro = nil
            end
        end
        
        if flag == "SpeedEnabled" then
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if humanoid then
                if Settings.SpeedEnabled then
                    humanoid.WalkSpeed = Settings.SpeedValue
                else
                    humanoid.WalkSpeed = originalWalkSpeed
                end
            end
        end
        
        if flag == "WallhackEnabled" then
            updateESP()
        end
    end)
end

local function addSlider(name, flag, minVal, maxVal, isSpeed)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 65)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    frame.Parent = scrollingFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, -20, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 25)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(Settings[flag])
    valueLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(0.95, -30, 0, 22)
    slider.Position = UDim2.new(0, 15, 0, 35)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    slider.Text = ""
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 11)
    sliderCorner.Parent = slider
    
    local sliderFill = Instance.new("Frame")
    local startFillSize = (Settings[flag] - minVal) / (maxVal - minVal)
    sliderFill.Size = UDim2.new(startFillSize, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = slider
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 11)
    sliderFillCorner.Parent = sliderFill
    
    local dragging = false
    slider.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local val = minVal + pos * (maxVal - minVal)
            Settings[flag] = isSpeed and math.floor(val) or math.floor(val)
            valueLabel.Text = tostring(Settings[flag])
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            
            if isSpeed and Settings.SpeedEnabled then
                local char = LocalPlayer.Character
                local humanoid = char and char:FindFirstChild("Humanoid")
                if humanoid then humanoid.WalkSpeed = Settings.SpeedValue end
            end
            if flag == "FlySpeed" and Settings.FlyEnabled then
                updateFlyControls()
            end
        end
    end)
end

local function addDropdown(name, flag, options)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    frame.Parent = scrollingFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, -20, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0, 100, 0, 38)
    dropdownBtn.Position = UDim2.new(1, -115, 0.5, -19)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    dropdownBtn.Text = Settings[flag]
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.TextScaled = true
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = dropdownBtn
    
    local expanded = false
    local dropdownItems = {}
    
    dropdownBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        
        if expanded then
            frame.Size = UDim2.new(1, -20, 0, 55 + (#options * 45))
            
            for i, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(0.95, -30, 0, 38)
                optBtn.Position = UDim2.new(0, 15, 0, 55 + ((i-1) * 45))
                optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                optBtn.TextScaled = true
                optBtn.Font = Enum.Font.Gotham
                optBtn.Parent = frame
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 8)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    Settings[flag] = opt
                    dropdownBtn.Text = opt
                    expanded = false
                    frame.Size = UDim2.new(1, -20, 0, 55)
                    for _, btn in pairs(frame:GetChildren()) do
                        if btn:IsA("TextButton") and btn ~= dropdownBtn then
                            btn:Destroy()
                        end
                    end
                    dropdownItems = {}
                end)
                
                table.insert(dropdownItems, optBtn)
            end
        else
            frame.Size = UDim2.new(1, -20, 0, 55)
            for _, btn in pairs(dropdownItems) do
                btn:Destroy()
            end
            dropdownItems = {}
        end
    end)
end

-- ========== ПОБУДОВА МЕНЮ ==========

createSection("🎯 AIMBOT")
addToggle("Aimbot (автонаведення)", "AimbotEnabled", Color3.fromRGB(0, 150, 0))
addToggle("Silent Aim (патрони в голову)", "SilentAimEnabled", Color3.fromRGB(0, 150, 0))
addToggle("Check Visible (не крізь стіни)", "CheckVisible", Color3.fromRGB(150, 0, 0))
addToggle("Team Check", "TeamCheck", Color3.fromRGB(150, 0, 0))
addDropdown("Частина тіла", "AimPart", {"Head", "HumanoidRootPart", "Torso"})
addSlider("Aimbot Radius", "AimRadius", 50, 500)
addSlider("Silent Radius", "SilentRadius", 50, 500)
addSlider("Smoothness", "Smoothness", 1, 20)

createSection("👁️ VISUAL")
addToggle("Wallhack (ESP)", "WallhackEnabled", Color3.fromRGB(0, 150, 0))

-- Вибір кольору ESP
local colorFrame = Instance.new("Frame")
colorFrame.Size = UDim2.new(1, -20, 0, 45)
colorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
colorFrame.BorderSizePixel = 0
colorFrame.Parent = scrollingFrame

local colorCorner = Instance.new("UICorner")
colorCorner.CornerRadius = UDim.new(0, 12)
colorCorner.Parent = colorFrame

local colorLabel = Instance.new("TextLabel")
colorLabel.Size = UDim2.new(0.4, -20, 1, 0)
colorLabel.Position = UDim2.new(0, 15, 0, 0)
colorLabel.BackgroundTransparency = 1
colorLabel.Text = "ESP Color:"
colorLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
colorLabel.TextScaled = true
colorLabel.Font = Enum.Font.Gotham
colorLabel.TextXAlignment = Enum.TextXAlignment.Left
colorLabel.Parent = colorFrame

local colors = {
    {Name = "Red", Color = Color3.fromRGB(255, 50, 50)},
    {Name = "Green", Color = Color3.fromRGB(50, 255, 50)},
    {Name = "Blue", Color = Color3.fromRGB(50, 50, 255)},
    {Name = "Yellow", Color = Color3.fromRGB(255, 255, 50)},
    {Name = "Purple", Color = Color3.fromRGB(255, 50, 255)},
}

for i, colorInfo in ipairs(colors) do
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0.18, 0, 0, 30)
    colorBtn.Position = UDim2.new(0.45 + (i-1) * 0.11, 0, 0, 8)
    colorBtn.Text = colorInfo.Name
    colorBtn.BackgroundColor3 = colorInfo.Color
    colorBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    colorBtn.Font = Enum.Font.GothamBold
    colorBtn.TextSize = 12
    colorBtn.Parent = colorFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = colorBtn
    
    colorBtn.MouseButton1Click:Connect(function()
        Settings.ESPColor = colorInfo.Color
        updateESP()
    end)
end

createSection("🚀 MOVEMENT")
addToggle("Noclip", "NoclipEnabled", Color3.fromRGB(0, 150, 0))
addToggle("Fly", "FlyEnabled", Color3.fromRGB(0, 150, 0))
addSlider("Fly Speed", "FlySpeed", 20, 200)
addToggle("Speed", "SpeedEnabled", Color3.fromRGB(0, 150, 0))
addSlider("Speed Value", "SpeedValue", 16, 250, true)

-- ========== ФУНКЦІЇ ==========

function updateESP()
    if not Settings.WallhackEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            local char = player.Character
            local esp = char and char:FindFirstChild("StarsESP")
            if esp then esp:Destroy() end
        end
        return
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if not character then continue end
            
            local esp = character:FindFirstChild("StarsESP")
            if not esp then
                esp = Instance.new("Highlight")
                esp.Name = "StarsESP"
                esp.FillTransparency = Settings.ESPTransparency
                esp.OutlineTransparency = 0.2
                esp.FillColor = Settings.ESPColor
                esp.OutlineColor = Color3.fromRGB(255, 255, 255)
                esp.Adornee = character
                esp.Parent = character
            else
                esp.FillColor = Settings.ESPColor
            end
        end
    end
end

function updateFlyControls()
    local char = LocalPlayer.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    if Settings.FlyEnabled and rootPart then
        if not flyVelocity then
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            flyVelocity.Parent = rootPart
        end
        if not flyBodyGyro then
            flyBodyGyro = Instance.new("BodyGyro")
            flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            flyBodyGyro.P = 50000
            flyBodyGyro.Parent = rootPart
        end
    elseif flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
        if flyBodyGyro then flyBodyGyro:Destroy() end
        flyBodyGyro = nil
    end
end

function updateNoclip()
    local char = LocalPlayer.Character
    if not char then return end
    
    if Settings.NoclipEnabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and not table.find(noclipParts, part) then
                part.CanCollide = false
                table.insert(noclipParts, part)
            end
        end
    else
        for _, part in ipairs(noclipParts) do
            if part and part.Parent then
                part.CanCollide = true
            end
        end
        noclipParts = {}
    end
end

function updateSpeed()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChild("Humanoid")
    if humanoid then
        if Settings.SpeedEnabled then
            humanoid.WalkSpeed = Settings.SpeedValue
        elseif humanoid.WalkSpeed == Settings.SpeedValue then
            humanoid.WalkSpeed = originalWalkSpeed
        end
    end
end

-- Функції для Aimbot
local function GetValidEnemies()
    local enemies = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Settings.TeamCheck and LocalPlayer.Team and player.Team == LocalPlayer.Team then
            else
                local character = player.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                if character and humanoid and humanoid.Health > 0 then
                    local aimPart = character:FindFirstChild(Settings.AimPart)
                    if not aimPart then aimPart = character:FindFirstChild("Head") end
                    if aimPart then
                        local isVisible = false
                        if Settings.CheckVisible then
                            local ray = Ray.new(Camera.CFrame.Position, (aimPart.Position - Camera.CFrame.Position).Unit * 1000)
                            local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                            isVisible = hit and (hit:IsDescendantOf(character) or hit == aimPart)
                        else
                            isVisible = true
                        end
                        table.insert(enemies, {Character = character, AimPart = aimPart, Visible = isVisible})
                    end
                end
            end
        end
    end
    return enemies
end

local function GetClosestToCrosshair(radius, checkVisible)
    local enemies = GetValidEnemies()
    local closest = nil
    local shortestDist = radius
    local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    
    for _, enemy in ipairs(enemies) do
        if (not checkVisible) or enemy.Visible then
            local screenPos, onScreen = Camera:WorldToScreenPoint(enemy.AimPart.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = enemy
                end
            end
        end
    end
    return closest
end

-- Silent Aim
if Settings.SilentAimEnabled then
    local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "Raycast" and self == workspace then
            local target = GetClosestToCrosshair(Settings.SilentRadius, Settings.CheckVisible)
            if target and target.AimPart then
                local direction = (target.AimPart.Position - args[1]).Unit
                return oldNamecall(self, args[1], direction * (args[1] - target.AimPart.Position).Magnitude, args[2])
            end
        end
        return oldNamecall(self, ...)
    end)
end

-- Aimbot
RunService.RenderStepped:Connect(function()
    if Settings.AimbotEnabled then
        local target = GetClosestToCrosshair(Settings.AimRadius, Settings.CheckVisible)
        if target and target.AimPart then
            local targetCF = CFrame.new(Camera.CFrame.Position, target.AimPart.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, Settings.Smoothness)
        end
    end
    
    updateESP()
    updateNoclip()
    updateSpeed()
    
    -- Fly логіка
    local char = LocalPlayer.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChild("Humanoid")
    
    if Settings.FlyEnabled and rootPart and humanoid then
        humanoid.PlatformStand = true
        humanoid.AutoRotate = false
        
        if not flyVelocity then
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            flyVelocity.Parent = rootPart
        end
        if not flyBodyGyro then
            flyBodyGyro = Instance.new("BodyGyro")
            flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            flyBodyGyro.P = 50000
            flyBodyGyro.Parent = rootPart
        end
        
        local move = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        
        if move.Magnitude > 0 then
            flyVelocity.Velocity = move.Unit * Settings.FlySpeed
        else
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        flyBodyGyro.CFrame = Camera.CFrame
    elseif humanoid then
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
        if flyVelocity then flyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
        flyVelocity = nil
        flyBodyGyro = nil
    end
end)

-- Оновлення при появі персонажа
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    noclipParts = {}
    updateNoclip()
    updateSpeed()
    flyVelocity = nil
    flyBodyGyro = nil
end)

-- ========== АНІМАЦІЯ ВІДКРИТТЯ МЕНЮ ==========
local menuOpenTween = nil

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Settings.MenuOpen = not Settings.MenuOpen
        if Settings.MenuOpen then
            screenGui.Enabled = true
            mainFrame.BackgroundTransparency = 1
            if menuOpenTween then menuOpenTween:Cancel() end
            menuOpenTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.05
            })
            menuOpenTween:Play()
            
            TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 380, 0, 520)
            }):Play()
        else
            if menuOpenTween then menuOpenTween:Cancel() end
            menuOpenTween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            })
            menuOpenTween:Play()
            task.wait(0.2)
            screenGui.Enabled = false
        end
    end
end)

print("STARS MOD |
