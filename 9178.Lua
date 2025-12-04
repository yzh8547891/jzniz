-- 将此脚本放入：StarterGui > ScreenGui > LocalScript
-- 如果没有ScreenGui，请先创建：StarterGui中右键 -> 插入对象 -> ScreenGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 检查是否在Studio中运行
local isStudio = RunService:IsStudio()

-- 创建UI容器
local screenGui = script.Parent
local mainFrame = Instance.new("Frame")
mainFrame.Name = "EnhancementUI"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.1, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0

-- 圆角
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- 阴影
local shadow = Instance.new("UIStroke")
shadow.Color = Color3.fromRGB(0, 0, 0)
shadow.Thickness = 2
shadow.Transparency = 0.7
shadow.Parent = mainFrame

-- 标题
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "⚡ 游戏增强系统"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
titleLabel.BackgroundTransparency = 0.1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Center

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12, 0, 0)
titleCorner.Parent = titleLabel

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Text = "×"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 24
closeButton.ZIndex = 2
closeButton.Parent = titleLabel

-- 按钮容器
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, -20, 1, -60)
buttonContainer.Position = UDim2.new(0, 10, 0, 50)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

-- 按钮布局
local buttonLayout = Instance.new("UIGridLayout")
buttonLayout.CellSize = UDim2.new(1, 0, 0, 45)
buttonLayout.CellPadding = UDim2.new(0, 0, 0, 10)
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Top
buttonLayout.Parent = buttonContainer

-- 组装UI
titleLabel.Parent = mainFrame
mainFrame.Parent = screenGui

-- 状态存储
local enhancementStates = {
    invincible = false,
    highJump = false,
    speedBoost = false
}

-- 原始属性存储（用于恢复）
local originalProperties = {
    jumpPower = 50,
    walkSpeed = 16,
    maxHealth = 100
}

-- 按钮创建函数
local function createEnhancementButton(text, icon, callback)
    local button = Instance.new("TextButton")
    button.Text = icon .. " " .. text
    button.Size = UDim2.new(1, 0, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(60, 65, 80)
    button.BackgroundTransparency = 0.1
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.AutoButtonColor = true
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(80, 85, 100)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    -- 悬停效果
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(75, 80, 95)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(60, 65, 80)
        }):Play()
    end)
    
    -- 点击效果
    button.MouseButton1Click:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(0.95, 0, 0, 42)
        }):Play()
        
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 0, 45)
        }):Play()
        
        if callback then
            callback()
        end
    end)
    
    return button
end

-- 🛡️ 无敌功能
local function toggleInvincible()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    enhancementStates.invincible = not enhancementStates.invincible
    
    if enhancementStates.invincible then
        -- 开启无敌
        originalProperties.maxHealth = humanoid.MaxHealth
        humanoid.MaxHealth = math.huge
        humanoid.Health = humanoid.MaxHealth
        
        -- 设置无敌视觉效果
        humanoid.BreakJointsOnDeath = false
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        
        print("🛡️ 无敌模式已激活")
        invincibleButton.Text = "🛡️ 无敌: 开"
        invincibleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    else
        -- 关闭无敌
        humanoid.MaxHealth = originalProperties.maxHealth
        humanoid.Health = math.min(humanoid.Health, originalProperties.maxHealth)
        
        -- 恢复视觉设置
        humanoid.BreakJointsOnDeath = true
        
        print("🛡️ 无敌模式已关闭")
        invincibleButton.Text = "🛡️ 无敌: 关"
        invincibleButton.BackgroundColor3 = Color3.fromRGB(60, 65, 80)
    end
end

-- 🦘 跳高功能
local function toggleHighJump()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    enhancementStates.highJump = not enhancementStates.highJump
    
    if enhancementStates.highJump then
        -- 开启跳高
        originalProperties.jumpPower = humanoid.JumpPower
        humanoid.JumpPower = 100
        
        print("🦘 超级跳跃已激活")
        highJumpButton.Text = "🦘 跳高: 开"
        highJumpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    else
        -- 关闭跳高
        humanoid.JumpPower = originalProperties.jumpPower
        
        print("🦘 超级跳跃已关闭")
        highJumpButton.Text = "🦘 跳高: 关"
        highJumpButton.BackgroundColor3 = Color3.fromRGB(60, 65, 80)
    end
end

-- ⚡ 加速功能
local function toggleSpeedBoost()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    enhancementStates.speedBoost = not enhancementStates.speedBoost
    
    if enhancementStates.speedBoost then
        -- 开启加速
        originalProperties.walkSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = 50
        
        print("⚡ 速度提升已激活")
        speedBoostButton.Text = "⚡ 加速: 开"
        speedBoostButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    else
        -- 关闭加速
        humanoid.WalkSpeed = originalProperties.walkSpeed
        
        print("⚡ 速度提升已关闭")
        speedBoostButton.Text = "⚡ 加速: 关"
        speedBoostButton.BackgroundColor3 = Color3.fromRGB(60, 65, 80)
    end
end

-- 创建按钮
local invincibleButton = createEnhancementButton("🛡️ 无敌: 关", "🛡️", toggleInvincible)
local highJumpButton = createEnhancementButton("🦘 跳高: 关", "🦘", toggleHighJump)
local speedBoostButton = createEnhancementButton("⚡ 加速: 关", "⚡", toggleSpeedBoost)

invincibleButton.Parent = buttonContainer
highJumpButton.Parent = buttonContainer
speedBoostButton.Parent = buttonContainer

-- 角色重生时重置状态
player.CharacterAdded:Connect(function(character)
    -- 等待Humanoid加载
    character:WaitForChild("Humanoid")
    
    -- 重置状态
    enhancementStates.invincible = false
    enhancementStates.highJump = false
    enhancementStates.speedBoost = false
    
    -- 更新按钮显示
    invincibleButton.Text = "🛡️ 无敌: 关"
    invincibleButton.BackgroundColor3 = Color3.fromRGB(60, 65, 80)
    
    highJumpButton.Text = "🦘 跳高: 关"
    highJumpButton.BackgroundColor3 = Color3.fromRGB(60, 65, 80)
    
    speedBoostButton.Text = "⚡ 加速: 关"
    speedBoostButton.BackgroundColor3 = Color3.fromRGB(60, 65, 80)
end)

-- 关闭按钮功能
closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.wait(0.3)
    mainFrame.Visible = false
end)

-- 显示/隐藏UI的快捷键（F2键）
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F2 then
        if mainFrame.Visible then
            -- 隐藏UI
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            task.wait(0.3)
            mainFrame.Visible = false
        else
            -- 显示UI
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Visible = true
            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 300, 0, 200)
            }):Play()
        end
    end
end)

-- 拖拽功能
local dragging = false
local dragInput, dragStart, startPos

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleLabel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- 初始化动画
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Visible = true
task.wait(0.5)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 300, 0, 200)
}):Play()

print("✅ 游戏增强UI加载完成！按 F2 键显示/隐藏面板")
print("🎮 功能说明：")
print("  🛡️ 无敌 - 防止角色死亡")
print("  🦘 跳高 - 增强跳跃高度")
print("  ⚡ 加速 - 增加移动速度")

-- 注意：如果不在Studio中，部分功能可能受Roblox安全限制
if not isStudio then
    print("⚠️ 注意：在官方服务器中，某些功能可能受安全限制")
end