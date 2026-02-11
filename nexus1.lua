local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // Configuration & Theme // --
local ToggleKey = Enum.KeyCode.RightControl -- CHANGE THIS TO YOUR PREFERRED KEY
local Theme = {
	Background = Color3.fromRGB(18, 18, 18),
	SectionBackground = Color3.fromRGB(25, 25, 25),
	Text = Color3.fromRGB(200, 200, 200),
	TextWhite = Color3.fromRGB(255, 255, 255),
	Accent = Color3.fromRGB(255, 215, 0), -- Nexus Yellow
	Button = Color3.fromRGB(30, 30, 30),
	SelectedTab = Color3.fromRGB(40, 40, 40)
}

-- // Create Main GUI // --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusV_UI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 850, 0, 450)
MainFrame.Position = UDim2.new(0.5, -425, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true -- Starts visible
MainFrame.Parent = ScreenGui

-- Rounded Corners
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

-- Top Accent Line
local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 3)
TopLine.BackgroundColor3 = Theme.Accent
TopLine.BorderSizePixel = 0
TopLine.Parent = MainFrame

-- // 1. Sidebar // --
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 200, 1, -3)
Sidebar.Position = UDim2.new(0, 0, 0, 3)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "Nexus V"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Theme.TextWhite
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

local function CreateTab(text, isActive)
	local TabBtn = Instance.new("TextButton")
	TabBtn.Size = UDim2.new(1, -10, 0, 35)
	TabBtn.BackgroundTransparency = isActive and 0 or 1
	TabBtn.BackgroundColor3 = Theme.SelectedTab
	TabBtn.Text = ""
	TabBtn.Parent = TabContainer

	local Icon = Instance.new("ImageLabel")
	Icon.Size = UDim2.new(0, 20, 0, 20)
	Icon.Position = UDim2.new(0, 20, 0.5, -10)
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
	Label.TextColor3 = isActive and Theme.TextWhite or Theme.Text
	Label.Size = UDim2.new(0, 100, 1, 0)
	Label.Position = UDim2.new(0, 50, 0, 0)
	Label.BackgroundTransparency = 1
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = TabBtn
end

local Tabs = {"Myself", "Self Vehicle", "Troll Players", "Troll2 Players", "Troll Vehicles", "Server", "Tools", "Settings", "Triggers"}
for _, name in ipairs(Tabs) do
	CreateTab(name, name == "Troll2 Players") 
end

-- // 2. Middle & Right Panels (Abbreviated for brevity, following original logic) // --
local MiddlePanel = Instance.new("ScrollingFrame")
MiddlePanel.Size = UDim2.new(0, 300, 1, -20)
MiddlePanel.Position = UDim2.new(0, 220, 0, 10)
MiddlePanel.BackgroundTransparency = 1
MiddlePanel.BorderSizePixel = 0
MiddlePanel.ScrollBarThickness = 2
MiddlePanel.ScrollBarImageColor3 = Theme.Accent
MiddlePanel.Parent = MainFrame

local MiddleLayout = Instance.new("UIListLayout")
MiddleLayout.Padding = UDim.new(0, 8)
MiddleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
MiddleLayout.Parent = MiddlePanel

local function CreateActionButton(text, parent)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0.95, 0, 0, 35)
	Btn.BackgroundColor3 = Theme.Button
	Btn.Text = text
	Btn.Font = Enum.Font.Gotham
	Btn.TextSize = 13
	Btn.TextColor3 = Theme.Text
	Btn.Parent = parent
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
end

local MiddleButtons = {"Bug player", "Fly 2 player", "Bug Glitch Player I", "New Rage Kill"}
for _, txt in ipairs(MiddleButtons) do CreateActionButton(txt, MiddlePanel) end

-- // HIDE / SHOW LOGIC // --
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	-- gameProcessed ensures the menu doesn't toggle while you're typing in chat
	if not gameProcessed then
		if input.KeyCode == ToggleKey then
			MainFrame.Visible = not MainFrame.Visible
		end
	end
end)

-- // Dragging Logic // --
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

print("Nexus V Loaded. Press RightControl to toggle menu.")
