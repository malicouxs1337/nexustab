local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
	Accent = Color3.fromRGB(255, 230, 0), -- VIBRANT YELLOW
	Button = Color3.fromRGB(28, 28, 28),
	SelectedTab = Color3.fromRGB(35, 35, 35)
}

-- // Create Main GUI // --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusV_Yellow"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 850, 0, 450)
MainFrame.Position = UDim2.new(0.5, -425, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

-- Top Yellow Accent Line
local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 3)
TopLine.BackgroundColor3 = Theme.Accent
TopLine.BorderSizePixel = 0
TopLine.Parent = MainFrame

-- // 1. Sidebar // --
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 200, 1, -3)
Sidebar.Position = UDim2.new(0, 0, 0, 3)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "Nexus V"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextColor3 = Theme.Accent -- Changed Title to Yellow
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
	TabBtn.Size = UDim2.new(1, -10, 0, 38)
	TabBtn.BackgroundTransparency = isActive and 0 or 1
	TabBtn.BackgroundColor3 = Theme.SelectedTab
	TabBtn.Text = ""
	TabBtn.Parent = TabContainer

	-- Selection Indicator (The vertical yellow line next to active tab)
	if isActive then
		local Indicator = Instance.new("Frame")
		Indicator.Size = UDim2.new(0, 2, 0.6, 0)
		Indicator.Position = UDim2.new(0, 5, 0.2, 0)
		Indicator.BackgroundColor3 = Theme.Accent
		Indicator.BorderSizePixel = 0
		Indicator.Parent = TabBtn
	end

	local Icon = Instance.new("ImageLabel")
	Icon.Size = UDim2.new(0, 18, 0, 18)
	Icon.Position = UDim2.new(0, 20, 0.5, -9)
	Icon.BackgroundTransparency = 1
	Icon.Image = "rbxassetid://3926305904" 
	Icon.ImageColor3 = Theme.Accent -- YELLOW ICON
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

-- // 2. Scroll Panels (Middle and Right) // --
local function CreatePanel(pos, size, name)
	local Panel = Instance.new("ScrollingFrame")
	Panel.Name = name
	Panel.Size = size
	Panel.Position = pos
	Panel.BackgroundTransparency = 1
	Panel.BorderSizePixel = 0
	Panel.ScrollBarThickness = 3
	Panel.ScrollBarImageColor3 = Theme.Accent -- YELLOW SCROLLBAR
	Panel.CanvasSize = UDim2.new(0,0,0,0)
	Panel.Parent = MainFrame
	
	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0, 8)
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Layout.Parent = Panel
	
	-- Auto Canvas Resize
	Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Panel.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
	end)
	
	return Panel
end

local MiddlePanel = CreatePanel(UDim2.new(0, 220, 0, 15), UDim2.new(0, 300, 1, -30), "Actions")
local RightPanel = CreatePanel(UDim2.new(1, -310, 0, 15), UDim2.new(0, 280, 1, -30), "Trolls")

local function CreateButton(text, parent)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0.95, 0, 0, 35)
	Btn.BackgroundColor3 = Theme.Button
	Btn.Text = text
	Btn.Font = Enum.Font.Gotham
	Btn.TextSize = 13
	Btn.TextColor3 = Theme.Text
	Btn.Parent = parent
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
	
	Btn.MouseEnter:Connect(function() Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end)
	Btn.MouseLeave:Connect(function() Btn.BackgroundColor3 = Theme.Button end)
end

-- Sample Buttons
local M_Btns = {"Bug player", "Fly 2 player", "Bug Glitch Player I", "Bug Glitch Player II", "New Rage Kill"}
for _, t in ipairs(M_Btns) do CreateButton(t, MiddlePanel) end

local R_Btns = {"Pumpkin Head", "Airdance Head", "Give a broom", "Parachute"}
for _, t in ipairs(R_Btns) do CreateButton(t, RightPanel) end

-- // 3. Keybind & Draggable Logic // --
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == ToggleKey then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

-- Draggable Logic
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true; dragStart = input.Position; startPos = MainFrame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

print("Nexus V (Yellow) Loaded. Press RightControl to toggle.")
