local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local Config = require(script.Parent.Config)
local Utils = require(script.Parent.Utils)
local AnimationHandler = require(script.Parent.AnimationHandler)
local StatusManager = require(script.Parent.StatusManager)

local HealthUIController = {}

function HealthUIController.new()
    local self = {}
    local player = Players.LocalPlayer
    local animator = AnimationHandler.new()
    local statusManager = StatusManager.new()
    local isDragging = false
    local dragStart = nil
    local startPos = nil

    -- Create main UI container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HealthUI"
    screenGui.ResetOnSpawn = false

    -- Create toggle button
    local toggleButton = Instance.new("ImageButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 40, 0, 40)
    toggleButton.Position = UDim2.new(0, 20, 0, 20)
    toggleButton.BackgroundTransparency = 0.5
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Image = "rbxassetid://6031075931" -- Heart icon
    toggleButton.Parent = screenGui

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleButton

    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, Config.BAR_WIDTH + 20, 0, 120)
    mainFrame.Position = UDim2.new(0, 70, 0, 20)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Visible = true
    mainFrame.Parent = screenGui
    
    -- Create player info
    local playerInfo = Instance.new("Frame")
    playerInfo.Name = "PlayerInfo"
    playerInfo.Size = UDim2.new(1, 0, 0, 30)
    playerInfo.BackgroundTransparency = 1
    playerInfo.Parent = mainFrame
    
    local playerName = Instance.new("TextLabel")
    playerName.Name = "PlayerName"
    playerName.Size = UDim2.new(1, -80, 0, 20)
    playerName.Position = UDim2.new(0, 80, 0, 0)
    playerName.BackgroundTransparency = 1
    playerName.Font = Enum.Font.GothamBold
    playerName.TextSize = 14
    playerName.TextColor3 = Color3.new(1, 1, 1)
    playerName.TextXAlignment = Enum.TextXAlignment.Left
    playerName.Parent = playerInfo
    
    -- Create health bar container
    local barContainer = Instance.new("Frame")
    barContainer.Name = "BarContainer"
    barContainer.Size = UDim2.new(0, Config.BAR_WIDTH, 0, Config.BAR_HEIGHT)
    barContainer.Position = UDim2.new(0, 0, 0, 40)
    barContainer.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    barContainer.BorderSizePixel = 2
    barContainer.BorderColor3 = Config.OUTLINE_COLOR
    barContainer.Parent = mainFrame
    
    local cornerRadius = Instance.new("UICorner")
    cornerRadius.CornerRadius = Config.CORNER_RADIUS
    cornerRadius.Parent = barContainer
    
    -- Create health bar
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Config.HEALTH_COLORS[3]
    healthBar.BorderSizePixel = 0
    healthBar.Parent = barContainer
    
    local healthCorner = Instance.new("UICorner")
    healthCorner.CornerRadius = Config.CORNER_RADIUS
    healthCorner.Parent = healthBar
    
    -- Create status text
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, 0, 0, 20)
    statusText.Position = UDim2.new(0, 0, 0, 70)
    statusText.BackgroundTransparency = 1
    statusText.Font = Enum.Font.GothamBold
    statusText.TextSize = 16
    statusText.TextColor3 = Config.HEALTH_COLORS[3]
    statusText.Parent = mainFrame
    
    -- Create avatar image
    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(0, 70, 0, 70)
    avatarImage.Position = UDim2.new(0, 0, 0, 0)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Image = Players:GetUserThumbnailAsync(
        player.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size70x70
    )
    avatarImage.Parent = playerInfo
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatarImage
    

    local function beginDrag(frame, input)
        isDragging = true
        dragStart = input.Position
        startPos = frame.Position

        local dragConnection
        local dragEndConnection

        dragConnection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or
               input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)

        dragEndConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
                dragConnection:Disconnect()
                dragEndConnection:Disconnect()
            end
        end)
    end

    -- Add dragging to toggle button
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            beginDrag(toggleButton, input)
        end
    end)

    -- Add dragging to main frame
    local dragHandle = Instance.new("TextButton")
    dragHandle.Name = "DragHandle"
    dragHandle.Size = UDim2.new(1, 0, 0, 20)
    dragHandle.Position = UDim2.new(0, 0, 0, 0)
    dragHandle.BackgroundTransparency = 1
    dragHandle.Text = ""
    dragHandle.Parent = mainFrame

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            beginDrag(mainFrame, input)
        end
    end)

    -- Toggle functionality
    toggleButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        animator.tweenTransparency(toggleButton, mainFrame.Visible and 0.5 or 1)
    end)

    -- Update functions
    local function updateHealth(health)
        local percentage = health / Config.MAX_HEALTH
        local targetSize = Utils.calculateHealthBarSize(health, Config.MAX_HEALTH, Config.BAR_WIDTH)
        local status = Utils.getHealthStatus(health, Config.MAX_HEALTH)
        
        animator.tweenHealthBar(healthBar, targetSize)
        animator.tweenColor(healthBar, Config.HEALTH_COLORS[status])
        statusManager.updateStatus(statusText, health, Config.MAX_HEALTH)
        
        if status == 1 then -- Critical health
            animator.pulseAnimation(statusText)
        end
    end
    
    -- Connect to player's health changes
    player.Character.Humanoid.HealthChanged:Connect(updateHealth)
    
    -- Update player info
    statusManager.updatePlayerInfo(playerName, player)
    
    -- Initial update
    updateHealth(player.Character.Humanoid.Health)
    
    screenGui.Parent = player.PlayerGui
    return self
end

return HealthUIController
