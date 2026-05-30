local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local Settings = {
    Enabled = true,
    AimbotEnabled = true,
    SilentAimEnabled = true,
    NoRecoilEnabled = true,
    AimPart = "Head",
    CheckVisible = false,
    TeamCheck = true,
    AimRadius = 200,
    SilentRadius = 300,
    NoRecoilValue = 0.2,
    WallhackEnabled = true,
    ESPColor = Color3.fromRGB(255, 50, 50),
    ESPTransparency = 0.4,
    ShowMenu = true,
}

local circleGui = Instance.new("ScreenGui")
circleGui.Name = "AimCircle"
circleGui.Parent = CoreGui
circleGui.ResetOnSpawn = false

local circle = Instance.new("Frame")
circle.Size = UDim2.new(0, 12, 0, 12)
circle.Position = UDim2.new(0.5, -6, 0.5, -6)
circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
circle.BackgroundTransparency = 0.3
circle.BorderSizePixel = 0
circle.Parent = circleGui

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = circle

local circleStroke = Instance.new("UIStroke")
circleStroke.Color = Color3.fromRGB(255, 50, 50)
circleStroke.Thickness = 2
circleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
circleStroke.Parent = circle

local function pulseCircle()
    if not Settings.Enabled then return end
    TweenService:Create(circle, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 16, 0, 16)
    }):Play()
    TweenService:Create(circle, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 12, 0, 12)
    }):Play()
end

local function checkAllFunctions()
    return {
        Aimbot = Settings.AimbotEnabled and Settings.Enabled,
        SilentAim = Settings.SilentAimEnabled and Settings.Enabled,
        NoRecoil = Settings.NoRecoilEnabled,
        Wallhack = Settings.WallhackEnabled,
        VisibleCheck = not Settings.CheckVisible
    }
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StarsCheatMenu2026"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 420)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Visible = Settings.ShowMenu

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

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "⚡ STARS MOD 2026 ⚡"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.1, 0, 0, 45)
toggleBtn.Text = Settings.Enabled and "🟢 ЧИТ: УВІМКНЕНО" or "🔴 ЧИТ: ВИМКНЕНО"
toggleBtn.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

toggleBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    toggleBtn.Text = Settings.Enabled and "🟢 ЧИТ: УВІМКНЕНО" or "🔴 ЧИТ: ВИМКНЕНО"
    toggleBtn.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    if Settings.Enabled then pulseCircle() end
end)

local function addToggle(text, flag, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text .. ": " .. (Settings[flag] and "ON" or "OFF")
    btn.BackgroundColor3 = Settings[flag] and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(60, 60, 80)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Settings[flag] = not Settings[flag]
        btn.Text = text .. ": " .. (Settings[flag] and "ON" or "OFF")
        btn.BackgroundColor3 = Settings[flag] and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(60, 60, 80)
        if flag == "ShowMenu" then
            mainFrame.Visible = Settings.ShowMenu
        end
    end)
    return btn
end

local function addSlider(text, flag, minVal, maxVal, yPos)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 45)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = mainFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text .. ": " .. string.format("%.1f", Settings[flag])
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = frame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, 0, 0, 20)
    slider.Position = UDim2.new(0, 0, 0, 22)
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
            Settings[flag] = flag == "NoRecoilValue" and val or math.floor(val)
            label.Text = text .. ": " .. (flag == "NoRecoilValue" and string.format("%.2f", val) or tostring(Settings[flag]))
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        end
    end)
end

addToggle("Aimbot", "AimbotEnabled", 90)
addToggle("Silent Aim", "SilentAimEnabled", 125)
addToggle("No Recoil", "NoRecoilEnabled", 160)
addToggle("Стрільба крізь стіни", "CheckVisible", 195)
addToggle("Wallhack (ESP)", "WallhackEnabled", 230)
addToggle("Team Check", "TeamCheck", 265)
addToggle("Показати меню", "ShowMenu", 300)
addSlider("No Recoil сила", "NoRecoilValue", 0, 1, 335)
addSlider("Aimbot радіус", "AimRadius", 50, 500, 380)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F9 then
        local status = checkAllFunctions()
        local msg = "=== STARS MOD STATUS ===\n"
        msg = msg .. "Aimbot: " .. (status.Aimbot and "✅" or "❌") .. "\n"
        msg = msg .. "Silent Aim: " .. (status.SilentAim and "✅" or "❌") .. "\n"
        msg = msg .. "No Recoil: " .. (status.NoRecoil and "✅" or "❌") .. "\n"
        msg = msg .. "Wallhack: " .. (status.Wallhack and "✅" or "❌") .. "\n"
        msg = msg .. "Ignore Walls: " .. (status.VisibleCheck and "✅" or "❌") .. "\n"
        warn(msg)
        StarterGui:SetCore("SendNotification", {Title = "STARS MOD", Text = "Статус перевірено. Відкрий консоль (F9)", Duration = 3})
    end
end)

if Settings.NoRecoilEnabled then
    local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Fire" and self:IsA("Tool") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local args = {...}
            if args[1] and args[1] == Enum.UserInputType.MouseButton1 then
                local recoil = Settings.NoRecoilValue
                local cameraCF = Camera.CFrame
                Camera.CFrame = cameraCF * CFrame.Angles(recoil * 0.1, 0, 0)
                task.wait(0.05)
                Camera.CFrame = cameraCF
            end
        end
        return oldNamecall(self, ...)
    end)
end

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
                        table.insert(enemies, {Player = player, Character = character, AimPart = aimPart, Visible = isVisible})
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
        player.CharacterAdded:Connect(function() task.wait(0.5) addESP(player) end)
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then addESP(player) end
    end
    Players.PlayerAdded:Connect(function(player) if player ~= LocalPlayer then player.CharacterAdded:Connect(function() task.wait(0.5) addESP(player) end) end end)
end

if Settings.SilentAimEnabled then
    local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "Raycast" and self == workspace and Settings.Enabled then
            local target = GetClosestToCrosshair(Settings.SilentRadius, Settings.CheckVisible)
            if target and target.AimPart then
                local direction = (target.AimPart.Position - args[1]).Unit
                return oldNamecall(self, args[1], direction * (args[1] - target.AimPart.Position).Magnitude, args[2])
            end
        end
        return oldNamecall(self, ...)
    end)
end

if Settings.AimbotEnabled then
    RunService.RenderStepped:Connect(function()
        if Settings.Enabled and Settings.AimbotEnabled then
            local target = GetClosestToCrosshair(Settings.AimRadius, Settings.CheckVisible)
            if target and target.AimPart then
                local targetCF = CFrame.new(Camera.CFrame.Position, target.AimPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCF, 0.3)
                pulseCircle()
            end
        end
    end)
end

pulseCircle()

print("STARS MOD 2026 | ULTRA AIMBOT + ESP Loaded")
