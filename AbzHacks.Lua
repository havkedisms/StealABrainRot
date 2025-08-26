-- AbzHacks-style Developer UI (SAFE)
-- Place this LocalScript inside StarterGui

local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- UI appearance settings
local UI_BLUE = Color3.fromRGB(24, 143, 255) -- nice blue
local UI_WHITE = Color3.fromRGB(255, 255, 255)

-- Utility: make a UI object quickly
local function new(className, props)
    local obj = Instance.new(className)
    if props then
        for k,v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

-- Create ScreenGui
local screenGui = new("ScreenGui", {
    Name = "AbzHacksGUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
screenGui.Parent = player:WaitForChild("PlayerGui")

-- MAIN BUTTON (rounded) in top-left corner
local mainButton = new("TextButton", {
    Name = "MainButton",
    Parent = screenGui,
    AnchorPoint = Vector2.new(0, 0),
    Position = UDim2.new(0, 0.02, 0, 10),  -- small margin from top-left
    Size = UDim2.new(0, 150, 0, 40),
    BackgroundColor3 = UI_BLUE,
    Text = "AbzHacks",
    TextColor3 = UI_WHITE,
    Font = Enum.Font.SourceSansBold,
    TextSize = 20,
    AutoButtonColor = true,
})
local mainButtonUICorner = new("UICorner", {Parent = mainButton, CornerRadius = UDim.new(0, 12)})

-- POPUP FRAME (initially hidden)
local popup = new("Frame", {
    Name = "PopupFrame",
    Parent = screenGui,
    AnchorPoint = Vector2.new(0, 0),
    Position = UDim2.new(0, 0.08, 0, 60), -- slightly below main button
    Size = UDim2.new(0, 260, 0, 220),
    BackgroundColor3 = UI_BLUE,
    Visible = false,
    Active = true,
})
new("UICorner", {Parent = popup, CornerRadius = UDim.new(0, 10)})

-- TITLE (AbzHacks)
local title = new("TextLabel", {
    Parent = popup,
    Position = UDim2.new(0, 10, 0, 8),
    Size = UDim2.new(1, -20, 0, 28),
    BackgroundTransparency = 1,
    Text = "AbzHacks",
    TextColor3 = UI_WHITE,
    Font = Enum.Font.SourceSansBold,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- White line under title
local underline = new("Frame", {
    Parent = popup,
    Position = UDim2.new(0, 10, 0, 36),
    Size = UDim2.new(1, -20, 0, 2),
    BackgroundColor3 = UI_WHITE,
})

-- Buttons container start Y
local buttonStartY = 46
local buttonHeight = 40
local buttonSpacing = 8
local buttonWidthMinus = 20

-- Helper to create menu buttons
local function createMenuButton(name, text, y)
    local btn = new("TextButton", {
        Name = name,
        Parent = popup,
        Position = UDim2.new(0, 10, 0, y),
        Size = UDim2.new(1, -20, 0, buttonHeight),
        BackgroundColor3 = Color3.fromRGB(10, 120, 220),
        Text = text,
        TextColor3 = UI_WHITE,
        Font = Enum.Font.SourceSans,
        TextSize = 18,
    })
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 8)})
    return btn
end

local btnInfiniteJump = createMenuButton("InfiniteJumpButton", "Infinite Jump", buttonStartY)
local btnFastSpeed = createMenuButton("FastSpeedButton", "Fast Speed", buttonStartY + (buttonHeight + buttonSpacing))
local btnReset = createMenuButton("ResetButton", "Reset (base lock)", buttonStartY + 2*(buttonHeight + buttonSpacing))

-- "Created by LegoQuality" label
local credit = new("TextLabel", {
    Parent = popup,
    Position = UDim2.new(0, 10, 1, -34),
    Size = UDim2.new(1, -20, 0, 24),
    BackgroundTransparency = 1,
    Text = "created by LegoQuality",
    TextColor3 = UI_WHITE,
    Font = Enum.Font.SourceSansItalic,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Toggle popup when mainButton clicked
mainButton.MouseButton1Click:Connect(function()
    popup.Visible = not popup.Visible
end)

-- Make sure we clean up when player respawns
local currentCharacter = player.Character
local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        humanoid = char:WaitForChild("Humanoid", 5)
    end
    return humanoid
end

-- --- Infinite Jump Implementation (developer mode) ---
local infiniteJumpEnabled = false
local savedJumpPower = nil
local savedUseJumpPower = nil
local jumpBindName = "AbzHacks_InfiniteJump"

local function jumpAction(actionName, inputState, inputObject)
    -- Only trigger on Begin so holding doesn't spam
    if inputState == Enum.UserInputState.Begin then
        local humanoid = getHumanoid()
        if humanoid then
            -- trigger a jump
            humanoid.Jump = true
        end
    end
    -- return Enum.ContextActionResult.Sink to stop further processing? we won't sink to keep normal controls
    return Enum.ContextActionResult.Pass
end

local function setInfiniteJump(enabled)
    infiniteJumpEnabled = enabled
    local humanoid = getHumanoid()
    if enabled then
        if humanoid then
            -- Save original values
            savedJumpPower = humanoid:FindFirstChild("JumpPower") and humanoid.JumpPower or humanoid.JumpPower
            savedUseJumpPower = humanoid.UseJumpPower
            -- Ensure we use JumpPower
            humanoid.UseJumpPower = true
            -- Set a high jump power (safe, developer choice)
            humanoid.JumpPower = 200
        end
        -- Bind action for keyboard & mobile (create mobile button)
        ContextActionService:BindActionAtPriority(jumpBindName, jumpAction, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Space, Enum.UserInputType.Touch)
        -- Also create a ContextActionService mobile button if required
        ContextActionService:SetTitle(jumpBindName, "SuperJump")
        btnInfiniteJump.Text = "Infinite Jump (ON)"
        btnInfiniteJump.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
    else
        -- Unbind and restore
        ContextActionService:UnbindAction(jumpBindName)
        if humanoid then
            -- restore saved values if present
            if savedUseJumpPower ~= nil then
                humanoid.UseJumpPower = savedUseJumpPower
            end
            if savedJumpPower ~= nil then
                -- protect against nil
                humanoid.JumpPower = savedJumpPower
            else
                -- default back to 50 (common default)
                humanoid.JumpPower = 50
            end
        end
        btnInfiniteJump.Text = "Infinite Jump"
        btnInfiniteJump.BackgroundColor3 = Color3.fromRGB(10, 120, 220)
    end
end

-- --- Fast Speed Implementation (developer mode) ---
local fastSpeedEnabled = false
local savedWalkSpeed = nil
local function setFastSpeed(enabled)
    fastSpeedEnabled = enabled
    local humanoid = getHumanoid()
    if enabled then
        if humanoid then
            savedWalkSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = 100 -- developer-chosen high speed
        end
        btnFastSpeed.Text = "Fast Speed (ON)"
        btnFastSpeed.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
    else
        if humanoid and savedWalkSpeed then
            humanoid.WalkSpeed = savedWalkSpeed
        elseif humanoid then
            humanoid.WalkSpeed = 16 -- default
        end
        btnFastSpeed.Text = "Fast Speed"
        btnFastSpeed.BackgroundColor3 = Color3.fromRGB(10, 120, 220)
    end
end

-- --- Reset (respawn) ---
btnReset.MouseButton1Click:Connect(function()
    -- Give feedback
    btnReset.Text = "Respawning..."
    -- Respawn player character safely
    if player and player.Character then
        -- Unbind jump action and restore states to prevent bound actions from persisting badly across load
        if infiniteJumpEnabled then
            setInfiniteJump(false)
        end
        if fastSpeedEnabled then
            setFastSpeed(false)
        end
        -- Reload the character
        player:LoadCharacter()
    end
    wait(0.5)
    btnReset.Text = "Reset (base lock)"
end)

-- Button click handlers
btnInfiniteJump.MouseButton1Click:Connect(function()
    setInfiniteJump(not infiniteJumpEnabled)
end)

btnFastSpeed.MouseButton1Click:Connect(function()
    setFastSpeed(not fastSpeedEnabled)
end)

-- Ensure toggles restore on character respawn
player.CharacterAdded:Connect(function(char)
    -- small delay to allow Humanoid to appear
    wait(0.2)
    local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    -- When a new character spawns, re-apply settings if toggles are still on
    if infiniteJumpEnabled and humanoid then
        -- restore saved flags to this humanoid
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 200
        -- rebind
        ContextActionService:BindActionAtPriority(jumpBindName, jumpAction, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Space, Enum.UserInputType.Touch)
    end
    if fastSpeedEnabled and humanoid then
        savedWalkSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = 100
    end
end)

-- Clean-up if GUI removed / player leaves
player.AncestryChanged:Connect(function()
    if not player:IsDescendantOf(game) then
        -- restore if needed
        if infiniteJumpEnabled then
            ContextActionService:UnbindAction(jumpBindName)
        end
    end
end)

-- Optional: Close popup if user clicks outside (basic)
screenGui.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- if popup visible and click is outside popup and not on mainButton, hide it
        local mousePos = input.Position
        if popup.Visible then
            local guiPoint = Vector2.new(mousePos.X, mousePos.Y)
            local absPos = popup.AbsolutePosition
            local absSize = popup.AbsoluteSize
            local inPopup = guiPoint.X >= absPos.X and guiPoint.X <= (absPos.X + absSize.X)
                       and guiPoint.Y >= absPos.Y and guiPoint.Y <= (absPos.Y + absSize.Y)
            local inMain = guiPoint.X >= mainButton.AbsolutePosition.X and guiPoint.X <= (mainButton.AbsolutePosition.X + mainButton.AbsoluteSize.X)
                       and guiPoint.Y >= mainButton.AbsolutePosition.Y and guiPoint.Y <= (mainButton.AbsolutePosition.Y + mainButton.AbsoluteSize.Y)
            if not inPopup and not inMain then
                popup.Visible = false
            end
        end
    end
end)

-- Friendly initial state
btnInfiniteJump.Text = "Infinite Jump"
btnFastSpeed.Text = "Fast Speed"

-- End of script
