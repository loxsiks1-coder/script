-- STARS MOD | ADVANCED AIMBOT + ESP
-- Функції: Silent Aim, Aimbot (з перевіркою на стіни), Wallhack, радіус наводки, меню.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- ========== НАЛАШТУВАННЯ (ЗМІНЮЙ ПІД СЕБЕ) ==========
local Settings = {
    Enabled = true,            -- Ввімкнення/вимкнення всього моду (клавіша "Insert")
    -- Налаштування Aimbot
    AimbotEnabled = true,      -- Ввімкнути Aimbot
    SilentAimEnabled = true,   -- Ввімкнути Silent Aim
    AimPart = "Head",          -- Куди цілитися ("Head", "HumanoidRootPart", "Torso")
    CheckVisible = true,       -- Перевіряти чи видно ціль (не стріляти крізь стіни)
    TeamCheck = true,          -- Не наводитися на тиммейтів
    -- Радіус наводки (два режими)
    AimRadius = 200,           -- Радіус для звичайного Aimbot (пікселі)
    SilentRadius = 300,        -- Радіус для Silent Aim (пікселі)
    -- Налаштування ESP (Wallhack)
    WallhackEnabled = true,    -- Ввімкнути Wallhack
    ESPColor = Color3.fromRGB(255, 0, 0), -- Колір ворогів
    ESPTransparency = 0.5,     -- Прозорість підсвітки
    -- Додаткове
    ShowMenu = true,           -- Показувати меню на екрані
}

-- ========== СТВОРЕННЯ GUI МЕНЮ ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StarsCheatMenu"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 320)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Visible = Settings.ShowMenu

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "STARS MOD | AIMBOT + ESP"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Перемикачі
local function addToggle(text, flag, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Text = text .. ": ON"
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Settings[flag] = not Settings[flag]
        btn.Text = text .. ": " .. (Settings[flag] and "ON" or "OFF")
        if flag == "ShowMenu" then
            mainFrame.Visible = Settings.ShowMenu
        end
    end)
    return btn
end

-- Слайдер для радіусу
local function addSlider(text, flag, minVal, maxVal, yPos)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = mainFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text .. ": " .. tostring(Settings[flag])
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, 0, 0, 20)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    slider.Text = ""
    slider.Parent = frame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((Settings[flag] - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = slider
    
    local dragging = false
    slider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - slider.AbsolutePosition.X
            local newVal = math.clamp(pos / slider.AbsoluteSize.X, 0, 1)
            local val = math.floor(minVal + newVal * (maxVal - minVal))
            Settings[flag] = val
            label.Text = text .. ": " .. tostring(val)
            sliderFill.Size = UDim2.new(newVal, 0, 1, 0)
        end
    end)
end

-- Додаємо елементи меню
addToggle("Aimbot (автонаведення)", "AimbotEnabled", 40)
addToggle("Silent Aim (патрони в голову)", "SilentAimEnabled", 80)
addToggle("Check Visible (не крізь стіни)", "CheckVisible", 120)
addToggle("Wallhack (ESP)", "WallhackEnabled", 160)
addToggle("Team Check", "TeamCheck", 200)
addToggle("Показати меню", "ShowMenu", 240)
addSlider("Aimbot радіус", "AimRadius", 50, 500, 280)

-- ========== ОСНОВНА ЛОГІКА ЧИТА ==========
local function GetValidEnemies()
    local enemies = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Settings.TeamCheck and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                -- пропускаємо союзників
            else
                local character = player.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                if character and humanoid and humanoid.Health > 0 then
                    local aimPart = character:FindFirstChild(Settings.AimPart)
                    if aimPart then
                        local isVisible = false
                        if Settings.CheckVisible then
                            local ray = Ray.new(Camera.CFrame.Position, (aimPart.Position - Camera.CFrame.Position).Unit * 1000)
                            local hit, pos = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                            isVisible = hit and (hit:IsDescendantOf(character) or hit == aimPart)
                        else
                            isVisible = true
                        end
                        table.insert(enemies, {
                            Player = player,
                            Character = character,
                            AimPart = aimPart,
                            Visible = isVisible
                        })
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

-- ESP (Wallhack)
if Settings.WallhackEnabled then
    local function addESP(player)
        local character = player.Character
        if not character then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "StarsESP"
        highlight.FillTransparency = Settings.ESPTransparency
        highlight.OutlineTransparency = 0.2
        highlight.FillColor = Settings.ESPColor
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Adornee = character
        highlight.Parent = character
        
        player.CharacterAdded:Connect(function(newChar)
            task.wait(0.5)
            addESP(player)
        end)
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            addESP(player)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function()
                task.wait(0.5)
                addESP(player)
            end)
        end
    end)
end

-- Silent Aim (перехоплення пострілів)
if Settings.SilentAimEnabled then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "Raycast" and self == workspace and Settings.Enabled then
            local target = GetClosestToCrosshair(Settings.SilentRadius, Settings.CheckVisible)
            if target and target.AimPart then
                local direction = (target.AimPart.Position - args[1]).Unit
                local newRaycastParams = args[2] or RaycastParams.new()
                newRaycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                return oldNamecall(self, args[1], direction * (args[1] - target.AimPart.Position).Magnitude, newRaycastParams)
            end
        end
        return oldNamecall(self, ...)
    end)
end

-- Aimbot (автонаведення прицілу)
if Settings.AimbotEnabled then
    RunService.RenderStepped:Connect(function()
        if Settings.Enabled and Settings.AimbotEnabled then
            local target = GetClosestToCrosshair(Settings.AimRadius, Settings.CheckVisible)
            if target and target.AimPart then
                local targetCF = CFrame.new(Camera.CFrame.Position, target.AimPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCF, 0.3)
            end
        end
    end)
end

-- Глобальне ввімкнення/вимкнення по клавіші Insert
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        Settings.Enabled = not Settings.Enabled
        mainFrame.Visible = Settings.Enabled and Settings.ShowMenu
        LocalPlayer:WaitForChild("PlayerGui"):SetCore("SendNotification", {
            Title = "STARS MOD",
            Text = Settings.Enabled and "🟢 Чит: УВІМКНЕНО" or "🔴 Чит: ВИМКНЕНО",
            Duration = 2
        })
    end
end)

print("✅ STARS MOD | Advanced Aimbot + ESP Loaded")