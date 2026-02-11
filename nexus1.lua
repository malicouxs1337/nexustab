local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // Configuration & Theme // --
local ToggleKey = Enum.KeyCode.RightControl 
local Theme = {
	Background = Color3.fromRGB(15, 15, 15),
	SectionBackground = Color3.fromRGB(22, 22, 22),
	Text = Color3.fromRGB(210, 210, 210),
	TextWhite = Color3.fromRGB(255, 255, 255),
	Accent = Color3.fromRGB(255, 230, 0),
	Button = Color3.fromRGB(28, 28, 28),
	SelectedTab = Color3.fromRGB(35, 35, 35),
	ToggleOn = Color3.fromRGB(0, 255, 0),
	ToggleOff = Color3.fromRGB(255, 0, 0)
}

-- // Cheat Variables // --
local GodMode = false
local AimbotEnabled = false
local ESPEnabled = false
local InfiniteYieldEnabled = false
local FlyEnabled = false
local SpeedEnabled = false
local NoclipEnabled = false
local TargetPlayer = nil
local FlySpeed = 50

-- // Create Main GUI // --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusV_Yellow"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 850, 0, 500)
MainFrame.Position = UDim2.new(0.5, -425, 0.5, -250)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 3)
TopLine.BackgroundColor3 = Theme.Accent
TopLine.BorderSizePixel = 0
TopLine.Parent = MainFrame

-- // Sidebar // --
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 200, 1, -3)
Sidebar.Position = UDim2.new(0, 0, 0, 3)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "Nexus V"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextColor3 = Theme.Accent
Title.Size = UDim2.new(1, -20, 0, 50)
Title.Position = UDim2.new(0, 20, 0, 10)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Sidebar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, -80)
TabContainer.Position = UDim2.new(0, 0, 0, 80)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabContainer

-- // Tab System // --
local ActiveTab = nil
local Tabs = {}

local function CreateTab(text)
	local TabIndex = #Tabs + 1
	local TabBtn = Instance.new("TextButton")
	TabBtn.Size = UDim2.new(1, -10, 0, 38)
	TabBtn.BackgroundTransparency = 1
	TabBtn.Text = ""
	TabBtn.Parent = TabContainer

	local Indicator = Instance.new("Frame")
	Indicator.Size = UDim2.new(0, 2, 0.6, 0)
	Indicator.Position = UDim2.new(0, 5, 0.2, 0)
	Indicator.BackgroundColor3 = Theme.Accent
	Indicator.BackgroundTransparency = 1
	Indicator.BorderSizePixel = 0
	Indicator.Parent = TabBtn

	local Icon = Instance.new("ImageLabel")
	Icon.Size = UDim2.new(0, 18, 0, 18)
	Icon.Position = UDim2.new(0, 20, 0.5, -9)
	Icon.BackgroundTransparency = 1
	Icon.Image = "rbxassetid://3926305904"
	Icon.ImageColor3 = Theme.Accent
	Icon.ImageRectOffset = Vector2.new(964, 204)
	Icon.ImageRectSize = Vector2.new(36, 36)
	Icon.Parent = TabBtn

	local Label = Instance.new("TextLabel")
	Label.Text = text
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 14
	Label.TextColor3 = Theme.Text
	Label.Size = UDim2.new(0, 100, 1, 0)
	Label.Position = UDim2.new(0, 50, 0, 0)
	Label.BackgroundTransparency = 1
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = TabBtn

	Tabs[TabIndex] = {
		Button = TabBtn,
		Label = Label,
		Indicator = Indicator,
		Content = nil,
		Name = text
	}

	TabBtn.MouseButton1Click:Connect(function()
		for i, tab in pairs(Tabs) do
			tab.Button.BackgroundTransparency = 1
			tab.Label.TextColor3 = Theme.Text
			tab.Indicator.BackgroundTransparency = 1
			if tab.Content then tab.Content.Visible = false end
		end
		TabBtn.BackgroundTransparency = 0
		Label.TextColor3 = Theme.TextWhite
		Indicator.BackgroundTransparency = 0
		if Tabs[TabIndex].Content then Tabs[TabIndex].Content.Visible = true end
		ActiveTab = Tabs[TabIndex]
	end)
end

-- Create Tabs
local TabNames = {"Combat", "Self", "Player Trolls", "Server", "ESP", "Misc"}
for _, name in ipairs(TabNames) do
	CreateTab(name)
end

-- // Content Panels // --
local MiddlePanel = Instance.new("ScrollingFrame")
MiddlePanel.Name = "MiddlePanel"
MiddlePanel.Size = UDim2.new(0, 320, 1, -30)
MiddlePanel.Position = UDim2.new(0, 210, 0, 15)
MiddlePanel.BackgroundTransparency = 1
MiddlePanel.BorderSizePixel = 0
MiddlePanel.ScrollBarThickness = 3
MiddlePanel.ScrollBarImageColor3 = Theme.Accent
MiddlePanel.CanvasSize = UDim2.new(0,0,0,0)
MiddlePanel.Visible = false
MiddlePanel.Parent = MainFrame

local RightPanel = Instance.new("ScrollingFrame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0, 300, 1, -30)
RightPanel.Position = UDim2.new(1, -310, 0, 15)
RightPanel.BackgroundTransparency = 1
RightPanel.BorderSizePixel = 0
RightPanel.ScrollBarThickness = 3
RightPanel.ScrollBarImageColor3 = Theme.Accent
RightPanel.CanvasSize = UDim2.new(0,0,0,0)
RightPanel.Visible = false
RightPanel.Parent = MainFrame

local function CreateToggle(text, callback, parent)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.Parent = parent
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.7, 0, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Theme.Text
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 13
	Label.Parent = ToggleFrame
	
	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
	ToggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
	ToggleBtn.BackgroundColor3 = Theme.ToggleOff
	ToggleBtn.Text = "OFF"
	ToggleBtn.Font = Enum.Font.GothamBold
	ToggleBtn.TextSize = 11
	ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToggleBtn.Parent = ToggleFrame
	local ToggleCorner = Instance.new("UICorner")
	ToggleCorner.CornerRadius = UDim.new(0, 10)
	ToggleCorner.Parent = ToggleBtn
	
	ToggleBtn.MouseButton1Click:Connect(function()
		local state = not ToggleBtn.Text == "ON"
		ToggleBtn.Text = state and "ON" or "OFF"
		ToggleBtn.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
		callback(state)
	end)
	
	return ToggleFrame
end

local function CreateButton(text, callback, parent)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0.95, 0, 0, 35)
	Btn.BackgroundColor3 = Theme.Button
	Btn.Text = text
	Btn.Font = Enum.Font.Gotham
	Btn.TextSize = 13
	Btn.TextColor3 = Theme.Text
	Btn.Parent = parent
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 4)
	Corner.Parent = Btn
	
	Btn.MouseEnter:Connect(function() Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end)
	Btn.MouseLeave:Connect(function() Btn.BackgroundColor3 = Theme.Button end)
	Btn.MouseButton1Click:Connect(callback)
end

-- // Tab Contents // --
local function CreateTabContent(tabName)
	local Content = Instance.new("Frame")
	Content.Name = tabName .. "Content"
	Content.Size = UDim2.new(1, 0, 1, 0)
	Content.Position = UDim2.new(0, 0, 0, 0)
	Content.BackgroundTransparency = 1
	Content.Parent = MainFrame
	Content.Visible = false
	
	local MiddleLayout = Instance.new("UIListLayout")
	MiddleLayout.Padding = UDim.new(0, 5)
	MiddleLayout.Parent = MiddlePanel
	MiddleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		MiddlePanel.CanvasSize = UDim2.new(0, 0, 0, MiddleLayout.AbsoluteContentSize.Y + 20)
	end)
	
	local RightLayout = Instance.new("UIListLayout")
	RightLayout.Padding = UDim.new(0, 5)
	RightLayout.Parent = RightPanel
	RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		RightPanel.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 20)
	end)
	
	if tabName == "Combat" then
		-- PVP Aimbot & Combat
		CreateToggle("PVP Aimbot", function(state)
			AimbotEnabled = state
		end, MiddlePanel)
		
		CreateToggle("Kill Aura", function(state)
			-- Kill aura implementation
			if state then
				RunService.Heartbeat:Connect(function()
					if not state then return end
					for _, player in pairs(Players:GetPlayers()) do
						if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
							local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
							if distance < 20 then
								fireclickdetector(player.Character.HumanoidRootPart:FindFirstChildOfClass("ClickDetector"))
							end
						end
					end
				end)
			end
		end, MiddlePanel)
		
		CreateButton("Explode Nearest Player", function()
			local nearest = nil
			local shortest = math.huge
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
					if dist < shortest then
						shortest = dist
						nearest = player
					end
				end
			end
			if nearest and nearest.Character then
				local explosion = Instance.new("Explosion")
				explosion.Position = nearest.Character.HumanoidRootPart.Position
				explosion.Parent = Workspace
			end
		end, RightPanel)
		
		CreateButton("Drop Big Baseplate", function()
			local part = Instance.new("Part")
			part.Size = Vector3.new(1000, 4, 1000)
			part.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, -50, 0)
			part.Anchored = true
			part.BrickColor = BrickColor.new("Really black")
			part.Material = Enum.Material.Neon
			part.Parent = Workspace
		end, RightPanel)
		
	elseif tabName == "Self" then
		-- Self cheats
		CreateToggle("Godmode", function(state)
			GodMode = state
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid.MaxHealth = state and math.huge or 100
				LocalPlayer.Character.Humanoid.Health = state and math.huge or 100
			end
		end, MiddlePanel)
		
		CreateToggle("Fly", function(state)
			FlyEnabled = state
			if state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local bodyVelocity = Instance.new("BodyVelocity")
				bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
				bodyVelocity.Velocity = Vector3.new(0, 0, 0)
				bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
				
				RunService.Heartbeat:Connect(function()
					if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						local cam = Workspace.CurrentCamera
						local vel = bodyVelocity
						if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel.Velocity = vel.Velocity:lerp(cam.CFrame.LookVector * FlySpeed, 0.2) end
						if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel.Velocity = vel.Velocity:lerp(-cam.CFrame.LookVector * FlySpeed, 0.2) end
						if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel.Velocity = vel.Velocity:lerp(-cam.CFrame.RightVector * FlySpeed, 0.2) end
						if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel.Velocity = vel.Velocity:lerp(cam.CFrame.RightVector * FlySpeed, 0.2) end
						if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel.Velocity = vel.Velocity:lerp(Vector3.new(0, FlySpeed, 0), 0.2) end
						if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel.Velocity = vel.Velocity:lerp(Vector3.new(0, -FlySpeed, 0), 0.2) end
					end
				end)
			end
		end, MiddlePanel)
		
		CreateToggle("Speed Hack", function(state)
			SpeedEnabled = state
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid.WalkSpeed = state and 100 or 16
			end
		end, MiddlePanel)
		
		CreateToggle("Noclip", function(state)
			NoclipEnabled = state
			local function noclip()
				if NoclipEnabled and LocalPlayer.Character then
					for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
				end
			end
			if state then
				RunService.Stepped:Connect(noclip)
			end
		end, MiddlePanel)
		
		CreateButton("Teleport to Spawn", function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
			end
		end, RightPanel)
		
	elseif tabName == "Player Trolls" then
		-- Troll features
		CreateButton("FLY all players", function()
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					local humanoid = player.Character:FindFirstChild("Humanoid")
					if humanoid then
						humanoid.PlatformStand = true
					end
				end
			end
		end, MiddlePanel)
		
		CreateButton("Explode ALL Players", function()
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local explosion = Instance.new("Explosion")
					explosion.Position = player.Character.HumanoidRootPart.Position
					explosion.BlastRadius = 50
					explosion.BlastPressure = 500000
					explosion.Parent = Workspace
				end
			end
		end, RightPanel)
		
		CreateButton("Lag Server (Drop Parts)", function()
			for i = 1, 100 do
				local part = Instance.new("Part")
				part.Size = Vector3.new(10, 10, 10)
				part.Position = Vector3.new(math.random(-500, 500), 100, math.random(-500, 500))
				part.Parent = Workspace
			end
		end, RightPanel)
		
		CreateButton("Giant Players", function()
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					for _, part in pairs(player.Character:GetChildren()) do
						if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
							part.Size = part.Size * 3
						end
					end
				end
			end
		end, RightPanel)
		
	elseif tabName == "Server" then
		CreateButton("Rejoin Server", function()
			game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
		end, MiddlePanel)
		
		CreateButton("Server Crash (Spam)", function()
			while wait(0.1) do
				local part = Instance.new("Part")
				part.Parent = Workspace
			end
		end, RightPanel)
		
	elseif tabName == "ESP" then
		CreateToggle("Player ESP", function(state)
			ESPEnabled = state
			if state then
				for _, player in pairs(Players:GetPlayers()) do
					if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
						local highlight = Instance.new("Highlight")
						highlight.FillColor = Color3.fromRGB(255, 0, 0)
						highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
						highlight.Parent = player.Character
					end
				end
			else
				for _, player in pairs(Players:GetPlayers()) do
					if player.Character and player.Character:FindFirstChild("Highlight") then
						player.Character.Highlight:Destroy()
					end
				end
			end
		end, MiddlePanel)
		
	elseif tabName == "Misc" then
		CreateToggle("Infinite Yield", function(state)
			loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
		end, MiddlePanel)
		
		CreateButton("Copy Game Link", function()
			setclipboard("roblox://placeid=" .. game.PlaceId)
		end, RightPanel)
	end
	
	Tabs[#Tabs].Content = Content
end

-- Initialize tab contents
for _, tab in pairs(Tabs) do
	CreateTabContent(tab.Name)
end

-- Activate first tab
if Tabs[1] then
	Tabs[1].Button.MouseButton1Click:Fire()
end

-- // Aimbot Implementation // --
local function GetClosestEnemy()
	local closest, shortest = nil, 1000
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
				if distance < shortest then
					closest = player
					shortest = distance
				end
			end
		end
	end
	return closest
end

RunService.Heartbeat:Connect(function()
	if AimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local target = GetClosestEnemy()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Character.Head.Position)
		end
	end
	
	-- Godmode loop
	if GodMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.Health = math.huge
	end
end)

-- // Character Respawn Handler // --
LocalPlayer.CharacterAdded:Connect(function()
	if GodMode then
		wait(1)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid.MaxHealth = math.huge
			LocalPlayer.Character.Humanoid.Health = math.huge
		end
	end
	if SpeedEnabled then
		wait(1)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid.WalkSpeed = 100
		end
	end
end)

-- // Toggle & Drag // --
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == ToggleKey then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

local dragging, dragInput, dragStart, startPos
local dragConnection
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		
		dragConnection = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				if dragConnection then dragConnection:Disconnect() end
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

print("Nexus V Ultimate Cheats Loaded! Press RightControl to toggle.")
print("Features: PVP Aimbot, Godmode, Fly, Speed, Noclip, Explode Players, Drop Baseparts, ESP, & more!")
