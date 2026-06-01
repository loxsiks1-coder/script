-- STARS MOD | MODERN CHEAT MENU 2026
-- Відкриття: ПРАВИЙ SHIFT
-- Вкладки: AIM, VISUAL, MOVEMENT, SETTINGS

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
    -- AIM
    AimbotEnabled = false,
    SilentAimEnabled = false,
    AimPart = "Head",
    CheckVisible = true,
    TeamCheck = true,
    AimRadius = 200,
    SilentRadius = 300,
    -- VISUAL
    WallhackEnabled = false,
    ESPColor = Color3.fromRGB(255, 50, 50),
    ESPTransparency = 0.4,
    -- MOVEMENT
    NoclipEnabled = false,
    FlyEnabled = false,
    SpeedEnabled = false,
    SpeedValue = 50,
    -- SETTINGS
    MenuOpen = false,
}

-- ========== ЗМІННІ ДЛЯ РУХУ ==========
local noclipParts = {}
local flyVelocity = nil
local originalWalkSpeed = 16

-- ========== СТВОРЕННЯ МЕНЮ ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StarsCheatMenu"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(60, 60, 80)
frameStroke.Thickness = 1
frameStroke.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 35))
})
gradient.Parent = mainFrame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "⚡ STARS MOD 2026 ⚡"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Вкладки
local tabs = {"AIM", "VISUAL", "MOVEMENT", "SETTINGS"}
local activeTab = "AIM"
local tabButtons = {}
local contentFrames = {}

local function createTabButton(tabName, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.22, 0, 0, 35)
    btn.Position = UDim2.new(0.02 + (yPos * 0.25), 0, 0, 50)
    btn.Text = tabName
    btn.BackgroundColor3 = tabName == activeTab and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(40, 40, 55)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        activeTab = tabName
        for _, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        for _, frame in pairs(contentFrames) do
            frame.Visible = false
        end
        contentFrames[tabName].Visible = true
    end)
    
    return btn
end

-- Створюємо контейнери для кожної вкладки
local function createContentFrame(tabName)
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(0.95, 0, 0, 340)
    frame.Position = UDim2.new(0.025, 0, 0, 95)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.CanvasSize = UDim2.new(0, 0, 0, 400)
    frame.ScrollBarThickness = 4
    frame.Parent = mainFrame
    frame.Visible = tabName == activeTab
    contentFrames[tabName] = frame
    return frame
end

-- Перемикач (toggle)
local function addToggle(parent, text, flag, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.Position = UDim2.new(0.025, 0, 0, yPos)
    btn.Text = text .. ": " .. (Settings[flag] and "ON" or "OFF")
    btn.BackgroundColor3 = Settings[flag] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(50, 50, 70)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Settings[flag] = not Settings[flag]
        btn.Text = text .. ": " .. (Settings[flag] and "ON" or "OFF")
        btn.BackgroundColor3 = Settings[flag] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(50, 50, 70)
        
        -- Спеціальна обробка для Noclip
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
        
        -- Спеціальна обробка для Fly
        if flag == "FlyEnabled" then
            if Settings.FlyEnabled then
                local char = LocalPlayer.Character
                local humanoid = char and char:FindFirstChild("Humanoid")
                if humanoid then
                    originalWalkSpeed = humanoid.WalkSpeed
                    humanoid.PlatformStand = true
                    flyVelocity = Instance.new("BodyVelocity")
                    flyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    flyVelocity.Parent = char and char:FindFirstChild("HumanoidRootPart")
                end
            else
                local char = LocalPlayer.Character
                local humanoid = char and char:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                    if flyVelocity then flyVelocity:Destroy() end
                    flyVelocity = nil
                end
            end
        end
        
        -- Спеціальна обробка для Speed
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
    end)
    return btn
end

-- Слайдер для радіусу та швидкості
local function addSlider(parent, text, flag, minVal, maxVal, yPos, isSpeed)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 50)
    frame.Position = UDim2.new(0.025, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text .. ": " .. tostring(Settings[flag])
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = frame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, 0, 0, 20)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    slider.Text = ""
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = slider
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((Settings[flag] - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = slider
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 10)
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
            label.Text = text .. ": " .. tostring(Settings[flag])
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            
            if isSpeed and Settings.SpeedEnabled then
                local char = LocalPlayer.Character
                local humanoid = char and char:FindFirstChild("Humanoid")
                if humanoid then humanoid.WalkSpeed = Settings.SpeedValue end
            end
        end
    end)
end

-- Вкладки
for i, tab in ipairs(tabs) do
    table.insert(tabButtons, createTabButton(tab, i-1))
end

-- ВКЛАДКА AIM
local aimFrame = createContentFrame("AIM")
addToggle(aimFrame, "Aimbot", "AimbotEnabled", 10)
addToggle(aimFrame, "Silent Aim", "SilentAimEnabled", 50)
addToggle(aimFrame, "Check Visible (стіни)", "CheckVisible", 90)
addToggle(aimFrame, "Team Check", "TeamCheck", 130)
addSlider(aimFrame, "Aimbot Radius", "AimRadius", 50, 500, 170)
addSlider(aimFrame, "Silent Radius", "SilentRadius", 50, 500, 230)

-- ВКЛАДКА VISUAL
local visualFrame = createContentFrame("VISUAL")
addToggle(visualFrame, "Wallhack (ESP)", "WallhackEnabled", 10)
-- Колір ESP (прості кнопки)
local colorText = Instance.new("TextLabel")
colorText.Size = UDim2.new(0.95, 0, 0, 20)
colorText.Position = UDim2.new(0.025, 0, 0, 55)
colorText.Text = "ESP Color:"
colorText.TextColor3 = Color3.fromRGB(200, 200, 200)
colorText.BackgroundTransparency = 1
colorText.Font = Enum.Font.Gotham
colorText.TextSize = 12
colorText.Parent = visualFrame

local colors = {
    {Name = "Red", Color = Color3.fromRGB(255, 50, 50)},
    {Name = "Green", Color = Color3.fromRGB(50, 255, 50)},
    {Name = "Blue", Color = Color3.fromRGB(50, 50, 255)},
    {Name = "Yellow", Color = Color3.fromRGB(255, 255, 50)},
    {Name = "Purple", Color = Color3.fromRGB(255, 50, 255)},
}

for i, colorInfo in ipairs(colors) do
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0.18, 0, 0, 25)
    colorBtn.Position = UDim2.new(0.025 + (i-1) * 0.19, 0, 0, 80)
    colorBtn.Text = colorInfo.Name
    colorBtn.BackgroundColor3 = colorInfo.Color
    colorBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    colorBtn.Font = Enum.Font.GothamBold
    colorBtn.TextSize = 11
    colorBtn.Parent = visualFrame
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 4)
    colorCorner.Parent = colorBtn
    
    colorBtn.MouseButton1Click:Connect(function()
        Settings.ESPColor = colorInfo.Color
        -- Оновлюємо ESP
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                local esp = char and char:FindFirstChild("StarsESP")
                if esp then esp.FillColor = Settings.ESPColor end
            end
        end
    end)
end

-- ВКЛАДКА MOVEMENT
local movementFrame = createContentFrame("MOVEMENT")
addToggle(movementFrame, "Noclip", "NoclipEnabled", 10)
addToggle(movementFrame, "Fly", "FlyEnabled", 50)
addToggle(movementFrame, "Speed", "SpeedEnabled", 90)
addSlider(movementFrame, "Speed Value", "SpeedValue", 20, 200, 130, true)

-- ВКЛАДКА SETTINGS
local settingsFrame = createContentFrame("SETTINGS")
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.8, 0, 0, 40)
closeBtn.Position = UDim2.new(0.1, 0, 0, 20)
closeBtn.Text = "CLOSE MENU (RIGHT SHIFT)"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = settingsFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    Settings.MenuOpen = false
    screenGui.Enabled = false
end)

-- ========== ВІДКРИТТЯ МЕНЮ ПО ПРАВОМУ SHIFT ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Settings.MenuOpen = not Settings.MenuOpen
        screenGui.Enabled = Settings.MenuOpen
    end
end)

-- ========== ОСНОВНІ ФУНКЦІЇ ==========

-- Функція для ESP (Wallhack)
local function updateESP()
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

-- Функція для Noclip
local function updateNoclip()
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

-- Функція для Fly
local function updateFly()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChild("Humanoid")
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    if Settings.FlyEnabled and humanoid and rootPart then
        humanoid.PlatformStand = true
        if not flyVelocity or flyVelocity.Parent ~= rootPart then
            if flyVelocity then flyVelocity:Destroy() end
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            flyVelocity.Parent = rootPart
        end
        
        local move = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        
        flyVelocity.Velocity = move.Unit * 50
    elseif humanoid then
        humanoid.PlatformStand = false
        if flyVelocity then flyVelocity:Destroy() end
        flyVelocity = nil
    end
end

-- Функція для Speed
local function updateSpeed()
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

-- Функція для отримання ворогів
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
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, 0.3)
        end
    end
    
    updateESP()
    updateNoclip()
    updateFly()
    updateSpeed()
end)

-- Оновлення Noclip при зміні персонажа
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    noclipParts = {}
    updateNoclip()
    updateFly()
    updateSpeed()
end)

print("STARS MOD | Modern Cheat Menu Loaded. Press RIGHT SHIFT to open")
