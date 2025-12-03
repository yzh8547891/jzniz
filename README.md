-- 将此脚本放入 StarterGui > ScreenGui > LocalScript
-- 如果没有ScreenGui，请先创建：StarterGui中右键 -> 插入对象 -> ScreenGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local gui = script.Parent

-- 创建主框架
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- 圆角
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- 阴影边框
local shadow = Instance.new("UIStroke")
shadow.Color = Color3.fromRGB(0, 0, 0)
shadow.Thickness = 2
shadow.Transparency = 0.7
shadow.Parent = mainFrame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12, 0, 0)
titleCorner.Parent = titleBar

-- 标题文字
local titleText = Instance.new("TextLabel")
titleText.Text = "🎮 游戏控制面板"
titleText.Size = UDim2.new(1, -20, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Text = "×"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 24
closeButton.Parent = titleBar

-- 内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- 自动布局
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = contentFrame

-- 组装
titleBar.Parent = mainFrame
mainFrame.Parent = gui

-- 创建按钮的函数
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(1, 0, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    button.BackgroundTransparency = 0.1
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.AutoButtonColor = true
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(100, 100, 150)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    -- 鼠标悬停效果
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        }):Play()
    end)
    
    -- 点击效果
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(0.95, 0, 0, 42)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 0, 45)
        }):Play()
        if callback then callback() end
    end)
    
    return button
end

-- 定义按钮功能
local buttons = {
    {"🚀 超级跳跃", function()
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = 100
                print("超级跳跃已激活")
            end
        end
    end},
    
    {"⚡ 快速移动", function()
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 32
                print("快速移动已激活")
            end
        end
    end},
    
    {"🛡️ 无敌模式", function()
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 1000
                humanoid.Health = 1000
                print("无敌模式已激活")
            end
        end
    end},
    
    {"💰 收集资源", function()
        print("资源收集功能已点击")
        -- 这里可以添加你的收集逻辑
    end},
    
    {"🔧 设置", function()
        print("设置功能已点击")
    end}
}

-- 添加所有按钮
for _, buttonData in ipairs(buttons) do
    local button = createButton(buttonData[1], buttonData[2])
    button.Parent = contentFrame
end

-- 拖拽功能
local dragging = false
local dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
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

titleBar.InputChanged:Connect(function(input)
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

-- 关闭按钮功能
closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.wait(0.3)
    mainFrame.Visible = false
end)

-- 快捷键：F9显示/隐藏
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F9 then
        if mainFrame.Visible then
            -- 隐藏
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            task.wait(0.3)
            mainFrame.Visible = false
        else
            -- 显示
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Visible = true
            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 300, 0, 400)
            }):Play()
        end
    end
end)

-- 初始动画
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Visible = true
task.wait(0.5)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 300, 0, 400)
}):Play()

print("✅ UI系统加载完成！按 F9 键显示/隐藏控制面板")# jzniz