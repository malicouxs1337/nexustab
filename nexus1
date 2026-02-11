local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // Configuration & State \\ --
local Config = {
    GodMode = false,
    Aimbot = false,
    TriggerBot = false,
    AutoFarm = false,
    ESP = false,
    IsFlying = false,
    Noclip = false,
    
    WalkSpeed = 16,
    FlySpeed = 100,
    AimFOV = 200,
    AimSmoothness = 0.1,
    TargetHead = true,
    TeamCheck = false
}

local espElements = {}
local godConnection = nil
local aimbotConnection = nil
local flyConnection = nil
local noclipConnection = nil
local bodyGyro, bodyVel = nil, nil

-- // FOV Circle \\ --
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = Config.AimFOV
fovCircle.Color = Color3.fromRGB(50, 255, 100) -- Green to match theme
fovCircle.Thickness = 2
fovCircle.Filled = false
fovCircle.Transparency = 1

-- // UI Setup (Rayfield) \\ --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. Create Window with RasclatV Naming
local Window = Rayfield:CreateWindow({
    Name = "RasclatV",
    LoadingTitle = "RasclatV Interface",
    LoadingSubtitle = "Roku PVP Edition",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RasclatVConfig", 
        FileName = "RasclatVPVP"
    },
    Discord = { Enabled = false },
    KeySystem = false, 
})

-- 2. Apply RasclatV Theme (Black & Green)
Rayfield.ModifyTheme({
    TextColor = Color3.fromRGB(50, 255, 100), -- Bright Green Text
    
    Background = Color3.fromRGB(15, 15, 15), -- Very Dark Background
    Topbar = Color3.fromRGB(15, 15, 15), 
    Shadow = Color3.fromRGB(0, 0, 0),
    
    NotificationBackground = Color3.fromRGB(20, 20, 20),
    NotificationActionsBackground = Color3.fromRGB(230, 230, 230),
    
    TabBackground = Color3.fromRGB(25, 25, 25),
    TabStroke = Color3.fromRGB(0, 0, 0),
    TabBackgroundSelected = Color3.fromRGB(25, 25, 25),
    TabTextColor = Color3.fromRGB(150, 150, 150),
    SelectedTabTextColor = Color3.fromRGB(50, 255, 100),
    
    ElementBackground = Color3.fromRGB(25, 25, 25),
    ElementBackgroundHover = Color3.fromRGB(35, 35, 35),
    ElementStroke = Color3.fromRGB(0, 0, 0),
    SecondaryElementStroke = Color3.fromRGB(0, 0, 0),
    
    SliderBackground = Color3.fromRGB(50, 50, 50),
    SliderProgress = Color3.fromRGB(50, 255, 100),
    SliderStroke = Color3.fromRGB(0, 0, 0),
    
    ToggleBackground = Color3.fromRGB(30, 30, 30),
    ToggleEnabled = Color3.fromRGB(50, 255, 100),
    ToggleDisabled = Color3.fromRGB(150, 150, 150), 
})

-- // Logic Functions \\ --

-- God Mode
local function setGodMode(enabled)
    Config.GodMode = enabled
    if enabled then
        godConnection = RunService.Stepped:Connect(function()
            if not LocalPlayer.Character or not Config.GodMode then return end
            pcall(function()
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = humanoid.MaxHealth
                end
                for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        end)
    else
        if godConnection then godConnection:Disconnect() godConnection = nil end
    end
end

-- Fly Logic
local function setFlying(enabled)
    Config.IsFlying = enabled
    if enabled then
        local T = LocalPlayer.Character.HumanoidRootPart
        local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        local SPEED = 0
        
        local function fly()
            bodyGyro = Instance.new("BodyGyro", T)
            bodyVel = Instance.new("BodyVelocity", T)
            bodyGyro.P = 9e4
            bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.cframe = T.CFrame
            bodyVel.velocity = Vector3.new(0, 0.1, 0)
            bodyVel.maxForce = Vector3.new(9e9, 9e9, 9e9)
            
            flyConnection = RunService.RenderStepped:Connect(function()
                if not Config.IsFlying or not LocalPlayer.Character then 
                    if flyConnection then flyConnection:Disconnect() end
                    if bodyGyro then bodyGyro:Destroy() end
                    if bodyVel then bodyVel:Destroy() end
                    return 
                end
                
                T.CFrame = CFrame.new(T.Position, T.Position + Camera.CFrame.LookVector)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then CONTROL.F = Config.FlySpeed else CONTROL.F = 0 end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then CONTROL.B = -Config.FlySpeed else CONTROL.B = 0 end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then CONTROL.L = -Config.FlySpeed else CONTROL.L = 0 end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then CONTROL.R = Config.FlySpeed else CONTROL.R = 0 end
                
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    SPEED = 50
                elseif not (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 and SPEED ~= 0 then
                    SPEED = 0
                end
                
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    bodyVel.velocity = ((Camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((Camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - Camera.CFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    bodyVel.velocity = ((Camera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((Camera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + lCONTROL.Q + lCONTROL.E) * 0.2, 0).p) - Camera.CFrame.p)) * SPEED
                else
                    bodyVel.velocity = Vector3.new(0, 0, 0)
                end
                bodyGyro.cframe = Camera.CFrame
            end)
        end
        fly()
    else
        if flyConnection then flyConnection:Disconnect() end
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVel then bodyVel:Destroy() end
    end
end

-- Noclip Logic
local function setNoclip(enabled)
    Config.Noclip = enabled
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if not LocalPlayer.Character then return end
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end

-- Aimbot Logic
local function getClosestTarget()
    local closest, shortest = nil, Config.AimFOV
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local rootPart = player.Character.HumanoidRootPart
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 then continue end
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
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
            local closestTarget = getClosestTarget()
            fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
            
            if closestTarget and Config.Aimbot then
                local targetPos = Config.TargetHead and closestTarget.Parent:FindFirstChild("Head") or closestTarget
                if targetPos then
                    local screenPos, onScreen = Camera:WorldToScreenPoint(targetPos.Position)
                    if onScreen then
                        mousemoverel(
                            (screenPos.X - Mouse.X) * Config.AimSmoothness,
                            (screenPos.Y - Mouse.Y) * Config.AimSmoothness
                        )
                    end
                end
            end
        end)
    else
        if aimbotConnection then aimbotConnection:Disconnect() end
    end
end

-- ESP Logic
local function setESP(enabled)
    Config.ESP = enabled
    if not enabled then
        for _, elements in pairs(espElements) do
            if elements.Tracer then elements.Tracer:Remove() end
            if elements.Box then elements.Box:Remove() end
        end
        espElements = {}
    end
end

-- // Tab Creation & Element Mapping \\ --

-- TAB 1: Myself (Movement & GodMode)
local MyselfTab = Window:CreateTab("Myself", 4483362458)
MyselfTab:CreateSection("Character Status")

MyselfTab:CreateToggle({
    Name = "God Mode (Invincible)",
    CurrentValue = false,
    Callback = setGodMode
})

MyselfTab:CreateSection("Movement")

MyselfTab:CreateToggle({
    Name = "Fly Mode",
    CurrentValue = false,
    Callback = setFlying
})

MyselfTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 500},
    Increment = 1,
    CurrentValue = 100,
    Callback = function(v) Config.FlySpeed = v end
})

MyselfTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = setNoclip
})

MyselfTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v) 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

-- TAB 2: Troll Players (Combat & Aimbot)
local TrollTab = Window:CreateTab("Troll Players", 4483362458)
TrollTab:CreateSection("Aimbot Configuration")

TrollTab:CreateToggle({
    Name = "Enabled Aimbot",
    CurrentValue = false,
    Callback = setAimbot
})

TrollTab:CreateToggle({
    Name = "Target Head",
    CurrentValue = true,
    Callback = function(v) Config.TargetHead = v end
})

TrollTab:CreateSlider({
    Name = "FOV Size",
    Range = {10, 800},
    Increment = 10,
    CurrentValue = 200,
    Callback = function(v) 
        Config.AimFOV = v
        fovCircle.Radius = v 
    end
})

TrollTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.01, 1},
    Increment = 0.01,
    CurrentValue = 0.1,
    Callback = function(v) Config.AimSmoothness = v end
})

TrollTab:CreateSection("Combat Actions")

TrollTab:CreateToggle({
    Name = "Trigger Bot (Auto Shoot)",
    CurrentValue = false,
    Callback = function(v) 
        Config.TriggerBot = v 
        if v then
            Mouse.Button1Down:Connect(function()
                if Config.TriggerBot and getClosestTarget() then
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end)
        end
    end
})

TrollTab:CreateToggle({
    Name = "Kill Aura (AutoFarm)",
    CurrentValue = false,
    Callback = function(v)
        Config.AutoFarm = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not Config.AutoFarm then return end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 25 then
                             -- Generic remote fire attempt, usually requires game specific remote
                            pcall(function()
                                local args = { [1] = player.Character.Humanoid }
                                ReplicatedStorage:FindFirstChild("DamageRemote"):FireServer(unpack(args))
                            end)
                        end
                    end
                end
            end)
        end
    end
})

-- TAB 3: Visuals (ESP)
local ToolsTab = Window:CreateTab("Visuals", 4483362458)
ToolsTab:CreateSection("ESP Settings")

ToolsTab:CreateToggle({
    Name = "Player ESP + Health",
    CurrentValue = false,
    Callback = setESP
})

-- // Main Loop for Visuals \\ --
RunService.RenderStepped:Connect(function()
    if Config.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen and humanoid then
                    if not espElements[player] then 
                        espElements[player] = {
                            Tracer = Drawing.new("Line"), 
                            Box = Drawing.new("Square")
                        }
                    end
                    
                    local tracer = espElements[player].Tracer
                    local box = espElements[player].Box
                    
                    tracer.Visible = true
                    tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    tracer.Color = Color3.fromRGB(50, 255, 100)
                    tracer.Thickness = 1
                    
                    box.Visible = true
                    box.Size = Vector2.new(2000/rootPart.Position.Z, 3000/rootPart.Position.Z) -- Rough box math
                    box.Position = Vector2.new(screenPos.X - box.Size.X/2, screenPos.Y - box.Size.Y/2)
                    box.Color = Color3.fromRGB(50, 255, 100)
                    box.Thickness = 1
                    box.Filled = false
                else
                    if espElements[player] then
                        espElements[player].Tracer.Visible = false
                        espElements[player].Box.Visible = false
                    end
                end
            else
                if espElements[player] then
                    espElements[player].Tracer.Visible = false
                    espElements[player].Box.Visible = false
                end
            end
        end
    end
end)

Rayfield:LoadConfiguration()
Rayfield:Notify({Title = "RasclatV Loaded", Content = "Roku Logic Applied", Duration = 5})
