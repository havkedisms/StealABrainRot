-- LocalScript in StarterGui

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AbzDevMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Dragging function
local function makeDraggable(frame, dragHandle)
	local dragging, dragStart, startPos
	dragHandle = dragHandle or frame
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging=false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
		end
	end)
end

-- LOGIN FRAME
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(0,250,0,150)
loginFrame.Position = UDim2.new(0.5,-125,0.4,0)
loginFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
loginFrame.BorderSizePixel = 2
loginFrame.Parent = screenGui

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1,0,0,40)
loginTitle.BackgroundColor3 = Color3.fromRGB(45,45,45)
loginTitle.Text = "Enter Code"
loginTitle.TextColor3 = Color3.new(1,1,1)
loginTitle.Font = Enum.Font.SourceSansBold
loginTitle.TextSize = 22
loginTitle.Parent = loginFrame

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(0.9,0,0,40)
codeBox.Position = UDim2.new(0.05,0,0,60)
codeBox.PlaceholderText = "Enter Code..."
codeBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
codeBox.TextColor3 = Color3.new(1,1,1)
codeBox.ClearTextOnFocus = false
codeBox.Font = Enum.Font.SourceSans
codeBox.TextSize = 18
codeBox.Parent = loginFrame

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.9,0,0,35)
submitBtn.Position = UDim2.new(0.05,0,0,110)
submitBtn.BackgroundColor3 = Color3.fromRGB(0,120,200)
submitBtn.Text = "Submit"
submitBtn.TextColor3 = Color3.new(1,1,1)
submitBtn.Font = Enum.Font.SourceSansBold
submitBtn.TextSize = 18
submitBtn.Parent = loginFrame

makeDraggable(loginFrame, loginTitle)

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,220,0,200)
mainFrame.Position = UDim2.new(0.5,-110,0.3,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 2
mainFrame.Visible = false
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(45,45,45)
title.Text = "AbzHacks"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 28
title.Parent = mainFrame
makeDraggable(mainFrame, title)

local line = Instance.new("Frame")
line.Size = UDim2.new(1,0,0,2)
line.Position = UDim2.new(0,0,0,40)
line.BackgroundColor3 = Color3.new(1,1,1)
line.Parent = mainFrame

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.9,0,0,40)
espButton.Position = UDim2.new(0.05,0,0,50)
espButton.BackgroundColor3 = Color3.fromRGB(90,0,150)
espButton.Text = "ESP"
espButton.TextColor3 = Color3.new(1,1,1)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 20
espButton.Parent = mainFrame

local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0.9,0,0,40)
jumpButton.Position = UDim2.new(0.05,0,0,100)
jumpButton.BackgroundColor3 = Color3.fromRGB(0,120,200)
jumpButton.Text = "Multi Jump"
jumpButton.TextColor3 = Color3.new(1,1,1)
jumpButton.Font = Enum.Font.SourceSansBold
jumpButton.TextSize = 20
jumpButton.Parent = mainFrame

-- Exit / ON buttons
local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0,25,0,25)
exitBtn.Position = UDim2.new(1,-30,0,5)
exitBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
exitBtn.Text = "X"
exitBtn.TextColor3 = Color3.new(1,1,1)
exitBtn.Font = Enum.Font.SourceSansBold
exitBtn.TextSize = 18
exitBtn.Parent = mainFrame

local onBtn = Instance.new("TextButton")
onBtn.Size = UDim2.new(0,60,0,30)
onBtn.Position = UDim2.new(0,10,0,10)
onBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
onBtn.Text = "ON"
onBtn.TextColor3 = Color3.new(1,1,1)
onBtn.Font = Enum.Font.SourceSansBold
onBtn.TextSize = 18
onBtn.Visible = false
onBtn.Parent = screenGui

exitBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	onBtn.Visible = true
end)
onBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	onBtn.Visible = false
end)

-- LOGIN FUNCTION
local correctCode = "Abz.98ZN"
submitBtn.MouseButton1Click:Connect(function()
	if codeBox.Text == correctCode then
		loginFrame.Visible = false
		mainFrame.Visible = true
	else
		codeBox.Text = ""
		codeBox.PlaceholderText = "❌ Wrong Code"
	end
end)

-- ESP
local espEnabled=false
local espObjects={}
espButton.MouseButton1Click:Connect(function()
	espEnabled=not espEnabled
	if espEnabled then
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr~=player and plr.Character and plr.Character:FindFirstChild("Head") then
				local highlight = Instance.new("Highlight", plr.Character)
				highlight.FillColor = Color3.fromRGB(170,0,255)
				highlight.OutlineColor = Color3.fromRGB(255,255,255)
				local bb = Instance.new("BillboardGui", plr.Character)
				bb.Size = UDim2.new(0,200,0,50)
				bb.Adornee = plr.Character.Head
				bb.AlwaysOnTop = true
				local nameLabel = Instance.new("TextLabel", bb)
				nameLabel.Size = UDim2.new(1,0,1,0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.Text = plr.Name
				nameLabel.TextColor3 = Color3.new(1,1,1)
				nameLabel.Font = Enum.Font.SourceSansBold
				nameLabel.TextSize = 14
				espObjects[plr] = {highlight, nameLabel}
			end
		end
	else
		for _,objs in pairs(espObjects) do
			for _,obj in pairs(objs) do if obj then obj:Destroy() end end
		end
		espObjects = {}
	end
end)

-- Developer Multi Jump
local multiJumpEnabled=false
local jumpCount = 0
local maxJumps = math.huge -- unlimited for developer testing

jumpButton.MouseButton1Click:Connect(function()
	multiJumpEnabled = not multiJumpEnabled
end)

UIS.JumpRequest:Connect(function()
	if multiJumpEnabled then
		local char = player.Character
		local humanoid = char and char:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			jumpCount += 1
		end
	end
end)

player.CharacterAdded:Connect(function(char)
	jumpCount = 0
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Landed then
			jumpCount = 0
		end
	end)
end)
