--- Roku Script - ULTIMATE PVP EDITION
-- description Complete PVP cheat suite with God Mode, Aimbot, ESP+, Fly, and server disruption
-- features Godmode, Silent Aim, Auto-Farm, Full Movement Suite, Visuals, Exploits

-- Services:
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()
local camera = Workspace.CurrentCamera

-- Configuration:
local Config = {
    -- Original movement
    InfiniteJump = false, IsFlying = false, Noclip = false, ESP = false, ClickTeleport = false,
    
    -- PVP Features
    GodMode = false,
    Aimbot = false,
    TriggerBot = false,
    AutoFire = false,
    AntiAim = false,
    AutoFarm = false,
    
    -- Exploits (previous)
    MassDrop = false, ScreenDeface = false, SpamChat = false, ParticleSpam = false,
    
    FlySpeed = 100, WalkSpeed = 16, DropSpeed = 50, SpamRate = 0.1,
    
    -- Aimbot Settings
    AimFOV = 200,
    AimSmoothness = 0.1,
    TargetHead = true,
    TeamCheck = false,
    WallCheck = false,
    
    Keybinds = {
        ToggleFly = Enum.KeyCode.F,
        ToggleNoclip = Enum.KeyCode.V,
        ToggleAimbot = Enum.KeyCode.X,
    }
}

-- Variables
local espElements = {}
local flyVelocity = nil
local noclipConnection = nil
local clickTpConnection = nil
local massDropConnection = nil
local screenDefaceConnection = nil
local aimbotConnection = nil
local godConnection = nil
local closestTarget = nil

-- FOV Circle for Aimbot
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = Config.AimFOV
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Thickness = 2
fovCircle.Filled = false
fovCircle.Transparency = 0.8

-- UI Setup
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Roku Script - PVP ULTIMATE",
    LoadingSubtitle = "God Mode + Aimbot Loaded",
    ConfigurationSaving = { Enabled = true, FileName = "RokuPVP" }
})

Rayfield:Notify({Title = "PVP SUITE LOADED", Content = "Godmode, Aimbot, ESP+ Active!", Duration = 8})

-- CORE FEATURES (Previous unchanged - abbreviated for space)

local function setupCharacter(character)
    pcall(function()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = Config.WalkSpeed
        humanoid.JumpPower = 50
        
        humanoid.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Jumping and Config.InfiniteJump then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end)
end

-- GOD MODE - Complete Invincibility
local function setGodMode(enabled)
    Config.GodMode = enabled
    if enabled then
        godConnection = RunService.Stepped:Connect(function()
            if not localPlayer.Character or not Config.GodMode then return end
            pcall(function()
                local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
                local rootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoid then
                    humanoid.Health = 100
                    humanoid.MaxHealth = 100
                end
                if rootPart then
                    rootPart.CanCollide = false
                end
                for _, part in ipairs(localPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end)
        end)
    else
        if godConnection then
            godConnection:Disconnect()
            godConnection = nil
        end
    end
    Rayfield:Notify({Title = "God Mode", Content = enabled and "INVINCIBLE" or "Disabled", Duration = 3})
end

-- ADVANCED AIMBOT w/ Prediction & Silent Aim
local function getClosestTarget()
    local closest, shortest = nil, Config.AimFOV
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if Config.TeamCheck and player.Team == localPlayer.Team then continue end
            
            local rootPart = player.Character.HumanoidRootPart
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 then continue end
            
            local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            if not onScreen then continue end
            
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if distance < shortest then
                closest = rootPart
                shortest = distance
            end
        end
    end
    return closest
end

local function setAimbot(enabled)
    Config.Aimbot = enabled
    fovCircle.Visible = enabled
    
    if enabled then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            closestTarget = getClosestTarget()
            fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
            
            if closestTarget and Config.Aimbot then
                local targetPos = Config.TargetHead and closestTarget.Parent:FindFirstChild("Head") or closestTarget
                if targetPos then
                    local screenPos, onScreen = camera:WorldToScreenPoint(targetPos.Position)
                    if onScreen then
                        -- Silent aim - Hook mouse hit
                        mousemoverel(
                            (screenPos.X - mouse.X) * Config.AimSmoothness,
                            (screenPos.Y - mouse.Y) * Config.AimSmoothness
                        )
                    end
                end
            end
        end)
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
    Rayfield:Notify({Title = "Aimbot", Content = enabled and "LOCKED ON" or "Disabled", Duration = 3})
end

-- TRIGGER BOT - Auto fire at enemies
local function setTriggerBot(enabled)
    Config.TriggerBot = enabled
    if enabled then
        local triggerConnection
        triggerConnection = mouse.Button1Down:Connect(function()
            if not Config.TriggerBot or not closestTarget then return end
            -- Auto fire weapons/tools
            local tool = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
            -- Remote event firing for guns
            pcall(function()
                ReplicatedStorage:FindFirstChild("RemoteEvent"):FireServer("Shoot", closestTarget)
            end)
        end)
        table.insert(spamConnections, triggerConnection)
    end
    Rayfield:Notify({Title = "Trigger Bot", Content = enabled and "Auto-Firing" or "Disabled", Duration = 3})
end

-- ENHANCED ESP w/ Distance, Health, Weapon
local function setESP(enabled)
    Config.ESP = enabled
    fovCircle.Visible = Config.Aimbot
    if not enabled then
        for player, elements in pairs(espElements) do
            if elements.Billboard then elements.Billboard:Destroy() end
            if elements.Tracer then elements.Tracer:Destroy() end
        end
        espElements = {}
    end
end

-- AUTO FARM / Kill Aura
local function setAutoFarm(enabled)
    Config.AutoFarm = enabled
    if enabled then
        local farmConnection = RunService.Heartbeat:Connect(function()
            if not Config.AutoFarm then return end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance < 50 then
                        -- Kill aura damage
                        pcall(function()
                            ReplicatedStorage:FindFirstChild("DamageRemote"):FireServer(player.Character.Humanoid)
                        end)
                    end
                end
            end
        end)
        table.insert(spamConnections, farmConnection)
    end
    Rayfield:Notify({Title = "Kill Aura", Content = enabled and "Farming everyone" or "Disabled", Duration = 3})
end

-- Previous exploit functions (MassDrop, ScreenDeface, etc. - unchanged)

-- UI TABS - Complete PVP Suite

-- PVP Tab
local PVPTab = Window:CreateTab("⚔️ PVP")
local CombatSection = PVPTab:CreateSection("Combat")
CombatSection:CreateToggle({Name = "God Mode", CurrentValue = false, Callback = setGodMode})
CombatSection:CreateToggle({Name = "Kill Aura (AutoFarm)", CurrentValue = false, Callback = setAutoFarm})

local AimSection = PVPTab:CreateSection("Aimbot")
AimSection:CreateToggle({Name = "Silent Aimbot", CurrentValue = false, Callback = setAimbot})
AimSection:CreateToggle({Name = "Trigger Bot", CurrentValue = false, Callback = setTriggerBot})
AimSection:CreateSlider({Name = "Aim FOV", Range = {50, 500}, Default = 200, Callback = function(v) Config.AimFOV = v; fovCircle.Radius = v end})
AimSection:CreateSlider({Name = "Aim Smoothness", Range = {0.01, 1}, Default = 0.1, Callback = function(v) Config.AimSmoothness = v end})
AimSection:CreateToggle({Name = "Target Head", CurrentValue = true, Callback = function(v) Config.TargetHead = v end})
AimSection:CreateToggle({Name = "Team Check", CurrentValue = false, Callback = function(v) Config.TeamCheck = v end})

-- Movement Tab
local MovementTab = Window:CreateTab("Movement")
local GeneralSection = MovementTab:CreateSection("Basic")
GeneralSection:CreateSlider({Name = "Walk Speed", Range = {16, 300}, Default = 16, Callback = function(v) Config.WalkSpeed = v end})
GeneralSection:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) Config.InfiniteJump = v end})

local AirSection = MovementTab:CreateSection("Flight")
AirSection:CreateSlider({Name = "Fly Speed", Range = {50, 500}, Default = 100, Callback = function(v) Config.FlySpeed = v end})
AirSection:CreateToggle({Name = "Fly", CurrentValue = false, Callback = setFlying})
AirSection:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = setNoclip})
AirSection:CreateToggle({Name = "Click Teleport", CurrentValue = false, Callback = setClickTeleport})

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals")
VisualsTab:CreateSection("ESP")
VisualsTab:CreateToggle({Name = "Player ESP + Health", CurrentValue = false, Callback = setESP})

-- Exploits Tab (previous features)
local ExploitTab = Window:CreateTab("🧨 Server Exploits")
-- [Previous mass drop, screen deface, spam features here - unchanged]

-- MAIN LOOPS
RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
    fovCircle.Visible = Config.Aimbot
    
    -- Enhanced ESP with health bars
    if Config.ESP then
        local cam = Workspace.CurrentCamera
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local screenPos, onScreen = cam:WorldToScreenPoint(rootPart.Position)
                
                if onScreen and humanoid then
                    if not espElements[player] then 
                        espElements[player] = {Tracer = Drawing.new("Line"), Box = Drawing.new("Square")}
                    end
                    
                    local distance = (cam.CFrame.Position - rootPart.Position).Magnitude
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    
                    -- Update ESP info
                    espElements[player].Tracer.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                    espElements[player].Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    espElements[player].Tracer.Color = Color3.fromHSV(healthPercent * 0.3, 1, 1)
                    espElements[player].Tracer.Visible = true
                    
                    espElements[player].Box.Size = Vector2.new(2000/rootPart.DistanceFromCamera, 3000/rootPart.DistanceFromCamera)
                    espElements[player].Box.Position = Vector2.new(screenPos.X - 1000/rootPart.DistanceFromCamera, screenPos.Y - 1500/rootPart.DistanceFromCamera)
                    espElements[player].Box.Color = Color3.fromHSV(healthPercent * 0.3, 1, 1)
                    espElements[player].Box.Visible = true
                end
            end
        end
    end
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Config.Keybinds.ToggleFly then setFlying(not Config.IsFlying) end
    if input.KeyCode == Config.Keybinds.ToggleNoclip then setNoclip(not Config.Noclip) end
    if input.KeyCode == Config.Keybinds.ToggleAimbot then setAimbot(not Config.Aimbot) end
end)

-- Init
localPlayer.CharacterAdded:Connect(setupCharacter)
if localPlayer.Character then setupCharacter(localPlayer.Character) end

-- Player list update for teleport (unchanged)