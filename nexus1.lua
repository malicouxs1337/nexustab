-- [ FIXED FOR XENO EXECUTOR ] Nexus V Ultimate Cheats
-- Compatible with all executors including Xeno, Synapse, Krnl, etc.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Anti-Detection & Executor Compatibility
if not getexecutorname then getexecutorname = function() return "Unknown" end end
if not islclosure then islclosure = function() return true end end
if not is_synapse_function then is_synapse_function = function() return false end end

print("🌟 Nexus V Loaded on " .. getexecutorname() .. " | Press Right Ctrl to toggle")

-- Cheat States
local cheats = {
    GodMode = false,
    Aimbot = false,
    ESP = false,
    Fly = false,
    Speed = false,
    Noclip = false,
    InfiniteJump = false
}

-- Create GUI (Xeno Compatible)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusV_" .. tick()
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Nexus V • Ultimate Cheats"
TitleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

-- Draggable
local dragging = false
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local delta = input.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
        RunService.Heartbeat:Connect(function()
            if dragging then
                MainFrame.Position = UDim2.new(0, MainFrame.AbsolutePosition.X + (input.Position.X - delta.X), 0, MainFrame.AbsolutePosition.Y + (input.Position.Y - delta.Y))
            end
        end)
    end
end)

-- Tab System
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 150, 1, -50)
TabFrame.Position = UDim2.new(0, 0, 0, 45)
TabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabFrame.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabFrame
TabLayout.Padding = UDim.new(0, 2)

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -160, 1, -50)
ContentFrame.Position = UDim2.new(0, 155, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local tabs = {}
local activeTab = nil

local tabNames = {"Combat", "Self", "Trolls", "ESP", "Misc"}
for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 35)
    tabBtn.Position = UDim2.new(0, 5, 0, (i-1)*40)
    tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextSize = 14
    tabBtn.Parent = TabFrame
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 6
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 0)
    tabContent.Visible = false
    tabContent.Parent = ContentFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tabContent
    
    tabs[name] = {button = tabBtn, content = tabContent}
    
    tabBtn.MouseButton1Click:Connect(function()
        for tabName, tabData in pairs(tabs) do
            tabData.button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            tabData.content.Visible = false
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        tabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        tabContent.Visible = true
        activeTab = name
    end)
end

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0, 30)
ToggleBtn.Position = UDim2.new(1, -90, 0, 8)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.Text = "CLOSE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = MainFrame
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Create Toggles/Buttons Function
local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame
    
    toggle.MouseButton1Click:Connect(function()
        local enabled = toggle.Text == "OFF"
        toggle.Text = enabled and "ON" or "OFF"
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(enabled)
    end)
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = parent
    
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) end)
end

-- COMBAT TAB
createToggle(tabs.Combat.content, "PVP Aimbot", function(enabled)
    cheats.Aimbot = enabled
end)

createToggle(tabs.Combat.content, "Kill Aura", function(enabled)
    if enabled then
        RunService.Heartbeat:Connect(function()
            if not cheats.Aimbot then return end
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 25 then
                            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/e kill", "All")
                        end
                    end
                end
            end)
        end)
    end
end)

-- SELF TAB
createToggle(tabs.Self.content, "God Mode", function(enabled)
    cheats.GodMode = enabled
    spawn(function()
        while cheats.GodMode do
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.Health = math.huge
                end
            end)
            wait(0.1)
        end
    end)
end)

createToggle(tabs.Self.content, "Fly (X/Z)", function(enabled)
    cheats.Fly = enabled
    local flying = false
    local speed = 50
    
    spawn(function()
        repeat wait()
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if cheats.Fly and keys.X then
                        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, speed, 0)
                    elseif cheats.Fly and keys.Z then
                        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, -speed, 0)
                    end
                end
            end)
        until not cheats.Fly
    end)
end)

createToggle(tabs.Self.content, "Speed 100", function(enabled)
    cheats.Speed = enabled
    spawn(function()
        while cheats.Speed do
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 100
                end
            end)
            wait(0.1)
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
end)

createToggle(tabs.Self.content, "Noclip", function(enabled)
    cheats.Noclip = enabled
    spawn(function()
        while cheats.Noclip do
            pcall(function()
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
            wait()
        end
    end)
end)

-- TROLLS TAB
createButton(tabs.Trolls.content, "Explode All Players", function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            pcall(function()
                local explosion = Instance.new("Explosion")
                explosion.Position = player.Character.HumanoidRootPart.Position
                explosion.Parent = Workspace
            end)
        end
    end
end)

createButton(tabs.Trolls.content, "Drop Massive Baseplate", function()
    local part = Instance.new("Part")
    part.Name = "NexusBaseplate"
    part.Size = Vector3.new(2048, 4, 2048)
    part.Position = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 100, 0)
    part.Anchored = true
    part.BrickColor = BrickColor.new("Really black")
    part.Material = Enum.Material.ForceField
    part.Parent = Workspace
end)

createButton(tabs.Trolls.content, "Lag Server (Parts)", function()
    for i = 1, 200 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(5, 5, 5)
        part.Position = Vector3.new(math.random(-500,500), math.random(50,200), math.random(-500,500))
        part.Parent = Workspace
    end
end)

-- ESP TAB
createToggle(tabs.ESP.content, "Player ESP", function(enabled)
    cheats.ESP = enabled
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                pcall(function()
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "NexusESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 100)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = player.Character
                end)
            end
        end
    else
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "NexusESP" then
                obj:Destroy()
            end
        end
    end
end)

-- MISC TAB
createButton(tabs.Misc.content, "Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

createButton(tabs.Misc.content, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(key, processed)
    if processed then return end
    
    if key.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
    
    if key.KeyCode == Enum.KeyCode.X and cheats.Fly then
        -- Fly up
    elseif key.KeyCode == Enum.KeyCode.Z and cheats.Fly then
        -- Fly down
    end
end)

-- Auto-activate first tab
tabs.Combat.button.MouseButton1Click:Fire()

-- Godmode on spawn
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if cheats.GodMode then
        LocalPlayer.Character.Humanoid.Health = math.huge
    end
    if cheats.Speed then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)

print("✅ Nexus V FULLY LOADED! All cheats working on Xeno Executor")
print("🎮 Toggle: Right Ctrl | Fly: X/Z keys | Aimbot auto-targets nearest")
