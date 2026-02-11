local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // Configuration & Theme // --
local Theme = {
	Background = Color3.fromRGB(18, 18, 18),
	SectionBackground = Color3.fromRGB(25, 25, 25),
	Text = Color3.fromRGB(200, 200, 200),
	TextWhite = Color3.fromRGB(255, 255, 255),
	Accent = Color3.fromRGB(0, 255, 128), -- The bright green color
	Button = Color3.fromRGB(30, 30, 30),
	SelectedTab = Color3.fromRGB(40, 40, 40)
}

-- // Create Main GUI // --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RasclatV_UI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 850, 0, 450)
MainFrame.Position = UDim2.new(0.5, -425, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Rounded Corners for Main Frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

-- Top Green Accent Line
local TopLine = Instance.new("Frame")
TopLine.Name = "TopLine"
TopLine.Size = UDim2.new(1, 0, 0, 3)
TopLine.BackgroundColor3 = Theme.Accent
TopLine.BorderSizePixel = 0
TopLine.Parent = MainFrame

-- // 1. Left Sidebar (Navigation) // --
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 200, 1, -3)
Sidebar.Position = UDim2.new(0, 0, 0, 3)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "RasclatV"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Theme.TextWhite
Title.Size = UDim2.new(1, -20, 0, 50)
Title.Position = UDim2.new(0, 20, 0, 10)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Sidebar

local SubTitle = Instance.new("TextLabel")
SubTitle.Text = "Membership (Lifetime)"
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 12
SubTitle.TextColor3 = Color3.fromRGB(100, 100, 100)
SubTitle.Size = UDim2.new(1, -20, 0, 20)
SubTitle.Position = UDim2.new(0, 20, 0, 45)
SubTitle.BackgroundTransparency = 1
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Sidebar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, -80)
TabContainer.Position = UDim2.new(0, 0, 0, 80)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabContainer

-- Function to create Sidebar Tabs
local function CreateTab(text, isActive)
	local TabBtn = Instance.new("TextButton")
	TabBtn.Size = UDim2.new(1, -10, 0, 35)
	TabBtn.BackgroundTransparency = isActive and 0 or 1
	TabBtn.BackgroundColor3 = Theme.SelectedTab
	TabBtn.Text = ""
	TabBtn.Parent = TabContainer

	local TabCorner = Instance.new("UICorner")
	TabCorner.CornerRadius = UDim.new(0, 6)
	TabCorner.Parent = TabBtn

	-- Gear Icon (Using 'o' or an image asset, simulating the green gear)
	local Icon = Instance.new("ImageLabel")
	Icon.Size = UDim2.new(0, 20, 0, 20)
	Icon.Position = UDim2.new(0, 20, 0.5, -10)
	Icon.BackgroundTransparency = 1
	Icon.Image = "rbxassetid://3926305904" -- Generic gear icon
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

-- Create the specific tabs shown in image
local Tabs = {"Myself", "Self Vehicle", "Troll Players", "Troll2 Players", "Troll Vehicles", "Server", "Tools", "Settings", "Triggers"}
for _, name in ipairs(Tabs) do
	CreateTab(name, name == "Troll2 Players") -- Set Troll2 Players as active
end

-- // 2. Middle Panel (Action Buttons) // --
local MiddlePanel = Instance.new("ScrollingFrame")
MiddlePanel.Name = "MiddlePanel"
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

local MiddlePadding = Instance.new("UIPadding")
MiddlePadding.PaddingTop = UDim.new(0, 10)
MiddlePadding.Parent = MiddlePanel

-- Function to create Action Buttons
local function CreateActionButton(text, parent)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0.95, 0, 0, 35)
	Btn.BackgroundColor3 = Theme.Button
	Btn.Text = text
	Btn.Font = Enum.Font.Gotham
	Btn.TextSize = 13
	Btn.TextColor3 = Theme.Text
	Btn.AutoButtonColor = true
	Btn.Parent = parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 4)
	Corner.Parent = Btn
	
	-- Hover effect (simple)
	Btn.MouseEnter:Connect(function()
		Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	end)
	Btn.MouseLeave:Connect(function()
		Btn.BackgroundColor3 = Theme.Button
	end)
	
	-- Click function placeholder
	Btn.MouseButton1Click:Connect(function()
		print("Clicked: " .. text)
	end)
end

-- Add Middle Buttons from image
local MiddleButtons = {
	"Bug player", "Fly 2 player", "Bug Glitch Player I", "Bug Glitch Player II",
	"Bug Player To Undermap (Nearby Entity)", "Bug Player To Sky (Nearby Entity)",
	"Bug Player To Undermap (Spawn)", "Bug Player To Sky (Spawn)",
	"Bug Player V", "Bug Player VI", "Bug Player VII", "New Rage Kill"
}

for _, txt in ipairs(MiddleButtons) do
	CreateActionButton(txt, MiddlePanel)
end
MiddlePanel.CanvasSize = UDim2.new(0, 0, 0, MiddleLayout.AbsoluteContentSize.Y + 20)


-- // 3. Right Panel (Attach Trolls) // --
local RightPanel = Instance.new("ScrollingFrame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0, 280, 1, -20)
RightPanel.Position = UDim2.new(1, -290, 0, 10)
RightPanel.BackgroundTransparency = 1
RightPanel.BorderSizePixel = 0
RightPanel.ScrollBarThickness = 2
RightPanel.ScrollBarImageColor3 = Theme.Accent
RightPanel.Parent = MainFrame

local RightHeader = Instance.new("TextLabel")
RightHeader.Text = "Attach Trolls"
RightHeader.Font = Enum.Font.GothamBold
RightHeader.TextSize = 14
RightHeader.TextColor3 = Theme.TextWhite
RightHeader.Size = UDim2.new(1, 0, 0, 30)
RightHeader.BackgroundTransparency = 1
RightHeader.TextXAlignment = Enum.TextXAlignment.Left
RightHeader.Parent = RightPanel

local RightLayout = Instance.new("UIListLayout")
RightLayout.Padding = UDim.new(0, 8)
RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
RightLayout.Parent = RightPanel

-- Separator Line under "Attach Trolls"
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(1, 0, 0, 1)
Separator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Separator.BorderSizePixel = 0
Separator.LayoutOrder = -1 -- Ensure it stays near top
Separator.Parent = RightPanel

-- Add Right Buttons from image
local RightButtons = {
	"Pumpkin Head", "Pumpkin Head", "Airdance Head", 
	"Give a broom", "Parachute", "Dildo Drops", "Attach Garage to Player"
}

for _, txt in ipairs(RightButtons) do
	CreateActionButton(txt, RightPanel)
end
RightPanel.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 50)


-- // Dragging Functionality // --
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- // Toggle Key (RightControl) // --
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
