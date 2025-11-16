local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = script.Parent
if not screenGui:IsA("ScreenGui") then
    -- nếu script không nằm trực tiếp trong ScreenGui, tạo 1 cái
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TongHopScriptGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
end

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 380, 0, 160)
frame.Position = UDim2.new(0.5, -190, 0.12, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10) -- gần đen
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Parent = screenGui
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

local uiStroke = Instance.new("UIStroke")
uiStroke.Name = "RainbowStroke"
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.LineJoinMode = Enum.LineJoinMode.Round
uiStroke.Thickness = 4
uiStroke.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -16, 0, 36)
title.Position = UDim2.new(0, 8, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Tổng Hợp Script"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

local btnContainer = Instance.new("Frame")
btnContainer.Name = "ButtonContainer"
btnContainer.Size = UDim2.new(1, -16, 1, -56)
btnContainer.Position = UDim2.new(0, 8, 0, 52)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = frame

local btnCorner = Instance.new("UICorner", btnContainer)
btnCorner.CornerRadius = UDim.new(0, 6)

local function makeButton(name, text, posY)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 44)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(18,18,18)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.AutoButtonColor = true
    btn.Parent = btnContainer

    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(70,70,70)
    stroke.Transparency = 0.25

    return btn
end

local btn1 = makeButton("QuantumOnyxBtn", "Quantum Onyx", 0)
local btn2 = makeButton("ZeesHubBtn", "Zees Hub", 52)

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 1, -20)
statusLabel.AnchorPoint = Vector2.new(0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = frame

local function showStatus(text, sec)
    statusLabel.Text = text
    if sec and sec > 0 then
        spawn(function()
            wait(sec)
            -- clear if unchanged
            if statusLabel.Text == text then
                statusLabel.Text = ""
            end
        end)
    end
end

local function runRemote(url)
    showStatus("Đang tải...", 0)
    local ok, res = pcall(function()
        -- nếu môi trường không cho phép HttpGet sẽ lỗi
        local raw = game:HttpGet(url)
        local f = loadstring(raw)
        if type(f) == "function" then
            return f()
        else
            error("Nội dung tải về không phải 1 function")
        end
    end)
    if ok then
        showStatus("Chạy thành công", 3)
    else
        showStatus("Lỗi: "..tostring(res), 6)
        warn("Lỗi khi chạy remote script:", res)
    end
end

btn1.MouseButton1Click:Connect(function()
    spawn(function()
        runRemote("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua")
    end)
end)

btn2.MouseButton1Click:Connect(function()
    spawn(function()
        runRemote("https://raw.githubusercontent.com/zeesvn/ZeesBloxFruits/refs/heads/main/ZeesHub.lua")
    end)
end)

-- Make window draggable
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService = game:GetService("UserInputService")
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

spawn(function()
    local t = 0
    while true do
        t = tick() % 5 -- cycle every 5s
        -- use HSV to rotate hue smoothly
        local hue = (tick() % 3) / 3 -- 0..1
        uiStroke.Color = Color3.fromHSV(hue, 1, 1)
        wait(0.03)
    end
end)

frame.Position = UDim2.new(0.5, -190, 0, 20)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Transparency = 1
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -190, 0.12, 0)})
tween:Play()
