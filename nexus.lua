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
local playerGui = localPlayer:WaitForChild("PlayerGui")

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
local FlyEnabled = false
local SpeedEnabled = false
local NoclipEnabled = false
local FlySpeed = 50
local Connections = {}

-- // Create Main GUI // --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusV_Yellow"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 850, 0, 500)
MainFrame.Position = UDim2.new(0.5, -425, 0.5, -250)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 3)
TopLine.BackgroundColor3 = Theme.Accent
TopLine.BorderSizePixel = 0
TopLine.ZIndex = 10
TopLine.Parent = MainFrame

-- // Sidebar // --
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 200, 1, -3)
Sidebar.Position = UDim2.new(0, 0, 0, 3)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BackgroundTransparency = 0.1
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 6)
SidebarCorner.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Text = "Nexus V"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Theme.Accent
Title.Size = UDim2.new(1, -20, 0, 60)
Title.Position = UDim2.new(0, 20, 0, 15)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 10
Title.Parent = Sidebar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, -90)
TabContainer.Position = UDim2.new(0, 0, 0, 85)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 8)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = TabContainer

-- // Content Areas // --
local MiddlePanel = Instance.new("ScrollingFrame")
MiddlePanel.Name = "MiddlePanel"
MiddlePanel.Size = UDim2.new(0, 320, 1, -30)
MiddlePanel.Position = UDim2.new(0, 210, 0, 15)
MiddlePanel.BackgroundColor3 = Theme.SectionBackground
MiddlePanel.BorderSizePixel = 0
MiddlePanel.ScrollBarThickness = 4
MiddlePanel.ScrollBarImageColor3 = Theme.Accent
MiddlePanel.CanvasSize = UDim2.new(0,0,0,0)
MiddlePanel.ScrollBarImageTransparency = 0.5
MiddlePanel.Visible = false
MiddlePanel.Parent = MainFrame

local MiddleCorner = Instance.new("UICorner")
MiddleCorner.CornerRadius = UDim.new(0, 6)
MiddleCorner.Parent = MiddlePanel

local MiddleLayout = Instance.new("UIListLayout")
MiddleLayout.Padding = UDim.new(0, 10)
MiddleLayout.SortOrder = Enum.SortOrder.LayoutOrder
MiddleLayout.Parent = MiddlePanel

local RightPanel = Instance.new("ScrollingFrame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0, 300, 1, -30)
RightPanel.Position = UDim2.new(1, -310, 0, 15)
RightPanel.BackgroundColor3 = Theme.SectionBackground
RightPanel.BorderSizePixel = 0
RightPanel.ScrollBarThickness = 4
RightPanel.ScrollBarImageColor3 = Theme.Accent
RightPanel.CanvasSize = UDim2.new(0,0,0,0)
RightPanel.ScrollBarImageTransparency = 0.5
RightPanel.Visible = false
RightPanel.Parent = MainFrame

local RightCorner = Instance.new("UICorner")
RightCorner.CornerRadius = UDim.new(0, 6)
RightCorner.Parent = RightPanel

local RightLayout = Instance.new("UIListLayout")
RightLayout.Padding = UDim.new(0, 10)
RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
RightLayout.Parent = RightPanel

-- // Tab System // --
local ActiveTab = nil
local Tabs = {}

local function UpdateCanvasSize()
	MiddlePanel.CanvasSize = UDim2.new(0, 0, 0, MiddleLayout.AbsoluteContentSize.Y + 30)
	RightPanel.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 30)
end

local function CreateTab(text, layoutOrder)
	local TabBtn = Instance.new("TextButton")
	TabBtn.Size = UDim2.new(1, -20, 0, 50)
	TabBtn.BackgroundTransparency = 1
	TabBtn.Text = ""
	TabBtn.LayoutOrder = layoutOrder
	TabBtn.Parent = TabContainer

	local Indicator = Instance.new("Frame")
	Indicator.Size = UDim2.new(0, 4, 0.75, 0)
	Indicator.Position = UDim2.new(0, 8, 0.125, 0)
	Indicator.BackgroundColor3 = Theme.Accent
	Indicator.BackgroundTransparency = 1
	Indicator.BorderSizePixel = 0
	Indicator.Parent = TabBtn

	local Icon = Instance.new("ImageLabel")
	Icon.Size = UDim2.new(0, 24, 0, 24)
	Icon.Position = UDim2.new(0, 18, 0.5, -12)
	Icon.BackgroundTransparency = 1
	Icon.Image = "rbxassetid://3926305904"
	Icon.ImageColor3 = Theme.Accent
	Icon.ImageRectOffset = Vector2.new(964, 204)
	Icon.ImageRectSize = Vector2.new(36, 36)
	Icon.Parent = TabBtn

	local Label = Instance.new("TextLabel")
	Label.Text = text
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 15
	Label.TextColor3 = Theme.Text
	Label.Size = UDim2.new(1, -55, 1, 0)
	Label.Position = UDim2.new(0, 50, 0, 0)
	Label.BackgroundTransparency = 1
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextYAlignment = Enum.TextYAlignment.Center
	Label.Parent = TabBtn

	local tabData = {
		Button = TabBtn,
		Label = Label,
		Indicator = Indicator,
		MiddleContent = {},
		RightContent = {}
	}
	
	Tabs[#Tabs + 1] = tabData
	
	TabBtn.MouseButton1Click:Connect(function()
		-- Reset all tabs
		for _, tab in pairs(Tabs) do
			tab.Button.BackgroundTransparency = 1
			tab.Label.TextColor3 = Theme.Text
			tab.Indicator.BackgroundTransparency = 1
		end
		
		-- Activate current tab
		TabBtn.BackgroundTransparency = 0.7
		TabBtn.BackgroundColor3 = Theme.SelectedTab
		Label.TextColor3 = Theme.TextWhite
		Indicator.BackgroundTransparency = 0
		ActiveTab = tabData
		
		-- Clear panels
		MiddlePanel.Visible = false
		RightPanel.Visible = false
		
		-- Clear previous content
		for _, content in pairs(tabData.MiddleContent) do
			if content and content.Parent then content:Destroy() end
		end
		for _, content in pairs(tabData.RightContent) do
			if content and content.Parent then content:Destroy() end
		end
		tabData.MiddleContent = {}
		tabData.RightContent = {}
		
		-- Create new content
		CreateTabContent(text)
		
		-- Show panels
		MiddlePanel.Visible = true
		RightPanel.Visible = true
		
		task.wait()
		UpdateCanvasSize()
	end)
end

-- // UI Components // --
local function CreateToggle(text, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, -20, 0, 45)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.LayoutOrder = #ActiveTab.MiddleContent + 1
	ToggleFrame.Parent = MiddlePanel
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.72, 0, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Text = "  " .. text
	Label.TextColor3 = Theme.TextWhite
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Font = Enum.Font.GothamSemibold
	Label.TextSize = 15
	Label.TextYAlignment = Enum.TextYAlignment.Center
	Label.Parent = ToggleFrame
	
	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Size = UDim2.new(0, 55, 0, 28)
	ToggleBtn.Position = UDim2.new(1, -60, 0.5, -14)
	ToggleBtn.BackgroundColor3 = Theme.ToggleOff
	ToggleBtn.Text = "OFF"
	ToggleBtn.Font = Enum.Font.GothamBold
	ToggleBtn.TextSize = 13
	ToggleBtn.TextColor3 = Color3.new(1,1,1)
	ToggleBtn.Parent = ToggleFrame
	
	local ToggleCorner = Instance.new("UICorner")
	ToggleCorner.CornerRadius = UDim.new(0, 14)
	ToggleCorner.Parent = ToggleBtn
	
	local ToggleStroke = Instance.new("UIStroke")
	ToggleStroke.Color = Theme.Accent
	ToggleStroke.Thickness = 1.2
	ToggleStroke.Parent = ToggleBtn
	
	ToggleBtn.MouseButton1Click:Connect(function()
		local state = ToggleBtn.Text == "OFF"
		ToggleBtn.Text = state and "ON" or "OFF"
		ToggleBtn.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
		callback(state)
	end)
	
	ActiveTab.MiddleContent[#ActiveTab.MiddleContent + 1] = ToggleFrame
	return ToggleFrame
end

local function CreateButton(text, callback, panel)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -20, 0, 50)
	Btn.BackgroundColor3 = Theme.Button
	Btn.Text = text
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextSize = 15
	Btn.TextColor3 = Theme.TextWhite
	Btn.TextYAlignment = Enum.TextYAlignment.Center
	Btn.Parent = panel
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Btn
	
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Theme.Accent
	Stroke.Thickness = 1.5
	Stroke.Parent = Btn
	
	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(55, 55, 55),
			Rotation = 0.5
		}):Play()
	end)
	
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {
			BackgroundColor3 = Theme.Button,
			Rotation = 0
		}):Play()
	end)
	
	Btn.MouseButton1Click:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -25, 0, 48)}):Play()
		task.wait(0.1)
		TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 50)}):Play()
		callback()
	end)
	
	if panel == MiddlePanel then
		ActiveTab.MiddleContent[#ActiveTab.MiddleContent + 1] = Btn
	else
		ActiveTab.RightContent[#ActiveTab.RightContent + 1] = Btn
	end
end

-- // Tab Content Creator // --
function CreateTabContent(tabName)
	if tabName == "Combat" then
		CreateToggle("PVP Aimbot", function(state) AimbotEnabled = state end)
		CreateToggle("Kill Aura", function(state)
			if Connections.KillAura then Connections.KillAura:Disconnect() end
			if state then
				Connections.KillAura = RunService.Heartbeat:Connect(function()
					if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
						for _, player in pairs(Players:GetPlayers()) do
							if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
								local distance = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
								if distance < 25 then
									fireclickdetector(player.Character.HumanoidRootPart:FindFirstChildOfClass("ClickDetector"))
								end
							end
						end
					end
				end)
			end
		end)
		CreateButton("💥 Explode Nearest", function()
			local nearest, shortest = nil, math.huge
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local dist = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
					if dist < shortest then shortest, nearest = dist, player end
				end
			end
			if nearest and nearest.Character then
				local explosion = Instance.new("Explosion")
				explosion.Position = nearest.Character.HumanoidRootPart.Position
				explosion.Parent = Workspace
			end
		end, RightPanel)
		
	elseif tabName == "Self" then
		CreateToggle("Godmode", function(state) GodMode = state end)
		CreateToggle("Fly (WASD)", function(state) FlyEnabled = state end)
		CreateToggle("Speed 100", function(state) SpeedEnabled = state end)
		CreateToggle("Noclip", function(state) NoclipEnabled = state end)
		CreateButton("🔄 Respawn", function()
			if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
				localPlayer.Character.Humanoid.Health = 0
			end
		end, RightPanel)
		
	elseif tabName == "Player Trolls" then
		CreateButton("✈️ FLY All Players", function()
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
					player.Character.Humanoid.PlatformStand = true
				end
			end
		end)
		CreateButton("💣 Explode ALL", function()
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local explosion = Instance.new("Explosion")
					explosion.Position = player.Character.HumanoidRootPart.Position
					explosion.Parent = Workspace
				end
			end
		end, RightPanel)
		CreateButton("🐌 Lag Server", function()
			for i = 1, 75 do
				local part = Instance.new("Part")
				part.Size = Vector3.new(4, 4, 4)
				part.Position = Vector3.new(math.random(-200,200), math.random(50,200), math.random(-200,200))
				part.Anchored = true
				part.Parent = Workspace
			end
		end, RightPanel)
		
	elseif tabName == "Server" then
		CreateButton("🔄 Rejoin", function()
			game:GetService("TeleportService"):Teleport(game.PlaceId, localPlayer)
		end)
		CreateButton("💥 Crash", function()
			while task.wait() do
				local part = Instance.new("Part")
				part.Parent = Workspace
			end
		end, RightPanel)
		
	elseif tabName == "ESP" then
		CreateToggle("Player ESP", function(state)
			ESPEnabled = state
			if state then
				for _, player in pairs(Players:GetPlayers()) do
					if player ~= localPlayer and player.Character then
						local highlight = Instance.new("Highlight")
						highlight.FillColor = Color3.fromRGB(255, 0, 0)
						highlight.OutlineColor = Theme.Accent
						highlight.FillTransparency = 0.4
						highlight.Parent = player.Character
					end
				end
			else
				for _, player in pairs(Players:GetPlayers()) do
					if player.Character then
						local highlight = player.Character:FindFirstChildOfClass("Highlight")
						if highlight then highlight:Destroy() end
					end
				end
			end
		end)
		
	elseif tabName == "Misc" then
		CreateButton("📦 Infinite Yield", function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
		end)
		CreateButton("🔗 Copy Link", function()
			setclipboard("roblox://placeid=" .. game.PlaceId)
		end, RightPanel)
	end
end

-- Create all tabs
local TabNames = {"Combat", "Self", "Player Trolls", "Server", "ESP", "Misc"}
for i, name in ipairs(TabNames) do
	CreateTab(name, i)
end

-- // Main Feature Loops // --
Connections.Aimbot = RunService.Heartbeat:Connect(function()
	if AimbotEnabled and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local closest, shortest = nil, 120
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
				if dist < shortest then closest, shortest = player, dist end
			end
		end
		if closest and closest.Character and closest.Character:FindFirstChild("Head") then
			camera.CFrame = CFrame.lookAt(camera.CFrame.Position, closest.Character.Head.Position)
		end
	end
end)

Connections.Godmode = RunService.Heartbeat:Connect(function()
	if GodMode and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
		localPlayer.Character.Humanoid.MaxHealth = math.huge
		localPlayer.Character.Humanoid.Health = math.huge
	end
end)

Connections.Fly = RunService.Heartbeat:Connect(function()
	if FlyEnabled and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local root = localPlayer.Character.HumanoidRootPart
		if not root:FindFirstChild("FlyVelocity") then
			local bv = Instance.new("BodyVelocity")
			bv.Name = "FlyVelocity"
			bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			bv.Velocity = Vector3.new()
			bv.Parent = root
		end
		local bv = root:FindFirstChild("FlyVelocity")
		local moveVector = Vector3.new()
		local cam = camera
		
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector + Vector3.new(0, -1, 0) end
		
		bv.Velocity = moveVector.Unit * FlySpeed
	end
end)

Connections.Speed = RunService.Heartbeat:Connect(function()
	if SpeedEnabled and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
		localPlayer.Character.Humanoid.WalkSpeed = 120
	end
end)

Connections.Noclip = RunService.Stepped:Connect(function()
	if NoclipEnabled and localPlayer.Character then
		for _, part in pairs(localPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end
end)

-- // Character Respawn Handler // --
localPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	if GodMode and localPlayer.Character:FindFirstChild("Humanoid") then
		localPlayer.Character.Humanoid.MaxHealth = math.huge
		localPlayer.Character.Humanoid.Health = math.huge
	end
	if SpeedEnabled and localPlayer.Character:FindFirstChild("Humanoid") then
		localPlayer.Character.Humanoid.WalkSpeed = 120
	end
end)

-- // Toggle GUI // --
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == ToggleKey then
		MainFrame.Visible = not MainFrame.Visible
		if MainFrame.Visible then
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 850, 0, 500)}):Play()
		end
	end
end)

-- // Window Dragging // --
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Target == MainFrame then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- // Initialize // --
MiddleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)
RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)

-- Activate first tab
if Tabs[1] then
	Tabs[1].Button.MouseButton1Click:Fire()
end

print("🟡 Nexus V Ultimate Loaded!")
print("🎮 Press RIGHT CONTROL to toggle GUI")
print("✅ Features: Aimbot, Godmode, Fly, ESP, Trolls, Server Crash & more!")
