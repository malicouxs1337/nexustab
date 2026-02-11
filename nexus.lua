local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Variables
local guiOpen = false
local godmode = false
local fly = false
local speed = false
local noclip = false
local aimbot = false

-- Create GUI (SIMPLE VERSION)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusV"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Title.Text = "NEXUS V - YELLOW THEME"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Buttons
local function createButton(yPos, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 40)
	btn.Position = UDim2.new(0.05, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Parent = MainFrame
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn
	
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Toggles
local function createToggle(yPos, text, varName)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.9, 0, 0, 35)
	frame.Position = UDim2.new(0.05, 0, 0, yPos)
	frame.BackgroundTransparency = 1
	frame.Parent = MainFrame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 40, 0, 25)
	toggle.Position = UDim2.new(1, -45, 0.5, -12.5)
	toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	toggle.Text = "OFF"
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 12
	toggle.Parent = frame
	
	local togCorner = Instance.new("UICorner")
	togCorner.CornerRadius = UDim.new(0, 12)
	togCorner.Parent = toggle
	
	local function toggleFunc()
		if _G[varName] then
			_G[varName] = false
			toggle.Text = "OFF"
			toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		else
			_G[varName] = true
			toggle.Text = "ON"
			toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		end
	end
	
	toggle.MouseButton1Click:Connect(toggleFunc)
end

-- Create UI Elements
createToggle(65, "Godmode", "godmode")
createToggle(110, "Fly (WASD)", "fly")
createToggle(155, "Speed 100", "speed")
createToggle(200, "Noclip", "noclip")
createToggle(245, "Aimbot", "aimbot")

createButton(300, "💥 EXPLODE NEAREST", function()
	local closest, dist = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local d = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
			if d < dist then dist, closest = d, player end
		end
	end
	if closest then
		local exp = Instance.new("Explosion")
		exp.Position = closest.Character.HumanoidRootPart.Position
		exp.Parent = Workspace
	end
end)

-- Toggle GUI
UserInputService.InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.RightControl then
		guiOpen = not guiOpen
		MainFrame.Visible = guiOpen
	end
end)

-- Features
RunService.Heartbeat:Connect(function()
	-- Godmode
	if _G.godmode and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
		localPlayer.Character.Humanoid.MaxHealth = math.huge
		localPlayer.Character.Humanoid.Health = math.huge
	end
	
	-- Speed
	if _G.speed and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
		localPlayer.Character.Humanoid.WalkSpeed = 100
	end
	
	-- Aimbot
	if _G.aimbot and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local closest = nil
		local shortest = 150
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
				local dist = (localPlayer.Character.HumanoidRootPart.Position - player.Character.Head.Position).Magnitude
				if dist < shortest then
					closest = player
					shortest = dist
				end
			end
		end
		if closest then
			Workspace.CurrentCamera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position, closest.Character.Head.Position)
		end
	end
end)

RunService.Stepped:Connect(function()
	-- Noclip
	if _G.noclip and localPlayer.Character then
		for _, part in pairs(localPlayer.Character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
	
	-- Fly
	if _G.fly and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local root = localPlayer.Character.HumanoidRootPart
		if not root:FindFirstChild("FlyBodyVelocity") then
			local bv = Instance.new("BodyVelocity")
			bv.Name = "FlyBodyVelocity"
			bv.MaxForce = Vector3.new(4000, 4000, 4000)
			bv.Velocity = Vector3.new(0, 0, 0)
			bv.Parent = root
		end
		
		local move = Vector3.new()
		local cam = Workspace.CurrentCamera
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 50, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 50, 0) end
		
		root.FlyBodyVelocity.Velocity = move
	end
end)

-- Respawn handler
localPlayer.CharacterAdded:Connect(function()
	if _G.godmode then
		task.wait(1)
		if localPlayer.Character:FindFirstChild("Humanoid") then
			localPlayer.Character.Humanoid.MaxHealth = math.huge
			localPlayer.Character.Humanoid.Health = math.huge
		end
	end
end)

print("🟡 NEXUS V LOADED! Press RIGHT CTRL")
print("✅ GUI will appear INSTANTLY!")
