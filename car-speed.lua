-- Delta Car Speed Controller (1 - 500) + UI Toggle
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ลบ UI เก่าถ้ามีการรันซ้ำ
if playerGui:FindFirstChild("DeltaCarSpeedUI") then
    playerGui.DeltaCarSpeedUI:Destroy()
end

-- ตั้งค่าเริ่มต้น
local enabled = false
local targetSpeed = 120 -- ช่วง 1 - 500
local uiVisible = true

-- ฟังก์ชันหา VehicleSeat ที่ผู้เล่นนั่งอยู่
local function getCurrentSeat()
    local char = player.Character
    if not char then return nil end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
        return humanoid.SeatPart
    end

    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Weld") or obj:IsA("Motor6D") then
            if obj.Part1 and obj.Part1:IsA("VehicleSeat") then
                return obj.Part1
            end
        end
    end
    return nil
end

-- ฟังก์ชันหาชิ้นส่วนหลักของรถ
local function getCarRoot(seat)
    local model = seat:FindFirstAncestorOfClass("Model")
    if model then
        if model.PrimaryPart then
            return model.PrimaryPart
        end
        local largestPart = seat
        local maxVolume = seat.Size.X * seat.Size.Y * seat.Size.Z
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") and not part.Anchored then
                local vol = part.Size.X * part.Size.Y * part.Size.Z
                if vol > maxVolume then
                    maxVolume = vol
                    largestPart = part
                end
            end
        end
        return largestPart
    end
    return seat
end

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaCarSpeedUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ปุ่มลอยสำหรับเปิด/ปิด UI (ใช้ได้ทั้งคอมและมือถือ)
local openToggleBtn = Instance.new("TextButton")
openToggleBtn.Name = "OpenToggleBtn"
openToggleBtn.Size = UDim2.new(0, 48, 0, 48)
openToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
openToggleBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
openToggleBtn.Text = "🚗"
openToggleBtn.TextSize = 22
openToggleBtn.Active = true
openToggleBtn.Parent = screenGui
Instance.new("UICorner", openToggleBtn).CornerRadius = UDim.new(0, 12)

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(0, 200, 150)
openStroke.Thickness = 1.5
openStroke.Parent = openToggleBtn

-- หน้าต่างหลัก (Main UI Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 245, 0, 175)
mainFrame.Position = UDim2.new(0.5, -122, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 200, 150)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

-- แถบด้านบน (สำหรับลากย้าย)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -75, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "DELTA CAR SPEED"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- ปุ่มซ่อน UI บนแถบหัวข้อ (-)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 24)
minBtn.Position = UDim2.new(1, -60, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 62)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 16
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = topBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- ปุ่มลบสคริปต์ (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 24)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- พื้นที่เนื้อหา
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -24, 1, -48)
contentFrame.Position = UDim2.new(0, 12, 0, 42)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ปุ่มเปิด/ปิดความเร็ว (Speed Toggle)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 55, 65)
toggleBtn.Text = "STATUS: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 15
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = contentFrame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

-- ช่องกรอกความเร็ว (1 - 500)
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.58, 0, 0, 22)
speedLabel.Position = UDim2.new(0, 0, 0, 48)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed (1 - 500):"
speedLabel.TextColor3 = Color3.fromRGB(200, 205, 220)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = contentFrame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.4, 0, 0, 28)
speedBox.Position = UDim2.new(0.6, 0, 0, 45)
speedBox.BackgroundColor3 = Color3.fromRGB(36, 40, 50)
speedBox.Text = tostring(targetSpeed)
speedBox.TextColor3 = Color3.fromRGB(0, 230, 170)
speedBox.TextSize = 14
speedBox.Font = Enum.Font.GothamBold
speedBox.ClearTextOnFocus = false
speedBox.Parent = contentFrame
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)

local boxStroke = Instance.new("UIStroke")
boxStroke.Color = Color3.fromRGB(70, 78, 95)
boxStroke.Thickness = 1
boxStroke.Parent = speedBox

-- สถานะรถปัจจุบัน
local statusInfo = Instance.new("TextLabel")
statusInfo.Size = UDim2.new(1, 0, 0, 26)
statusInfo.Position = UDim2.new(0, 0, 0, 82)
statusInfo.BackgroundTransparency = 1
statusInfo.Text = "Vehicle: Waiting..."
statusInfo.TextColor3 = Color3.fromRGB(160, 168, 185)
statusInfo.TextSize = 12
statusInfo.Font = Enum.Font.Gotham
statusInfo.TextXAlignment = Enum.TextXAlignment.Left
statusInfo.Parent = contentFrame

-- ฟังก์ชันสลับการ แสดง/ซ่อน UI
local function setUIVisibility(visible)
    uiVisible = visible
    mainFrame.Visible = visible
end

openToggleBtn.MouseButton1Click:Connect(function()
    setUIVisibility(not uiVisible)
end)

minBtn.MouseButton1Click:Connect(function()
    setUIVisibility(false)
end)

-- กดปุ่ม RightShift บนคีย์บอร์ดเพื่อ ซ่อน/แสดง UI
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        setUIVisibility(not uiVisible)
    end
end)

-- ระบบลากย้ายหน้าต่าง (รองรับทั้ง Touch และ Mouse)
local function setupDrag(frame, targetMove)
    local dragging, dragStart, startPos, dragInput
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetMove.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            targetMove.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

setupDrag(topBar, mainFrame)
setupDrag(openToggleBtn, openToggleBtn) -- ลากย้ายปุ่มลอย 🚗 ได้ด้วย

-- อัปเดตการแสดงผลปุ่มเปิด/ปิดความเร็ว
local function updateToggleVisual()
    if enabled then
        toggleBtn.Text = "STATUS: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 175, 125)
    else
        toggleBtn.Text = "STATUS: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 55, 65)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    updateToggleVisual()
end)

-- จำกัดค่าความเร็ว 1 - 500
speedBox.FocusLost:Connect(function()
    local num = tonumber(speedBox.Text)
    if not num then
        num = targetSpeed
    else
        num = math.clamp(math.floor(num), 1, 500)
    end
    targetSpeed = num
    speedBox.Text = tostring(targetSpeed)
end)

-- ปิดสคริปต์และคืนค่า
local heartbeatConn
closeBtn.MouseButton1Click:Connect(function()
    enabled = false
    if heartbeatConn then
        heartbeatConn:Disconnect()
    end
    screenGui:Destroy()
end)

-- ลูปทำงานหลัก: ปรับความเร็วรถ
heartbeatConn = RunService.Heartbeat:Connect(function(dt)
    local seat = getCurrentSeat()
    if not seat then
        statusInfo.Text = "Vehicle: Not seated"
        statusInfo.TextColor3 = Color3.fromRGB(160, 168, 185)
        return
    end

    statusInfo.Text = "Vehicle: " .. seat.Parent.Name .. " | Speed: " .. tostring(targetSpeed)
    statusInfo.TextColor3 = enabled and Color3.fromRGB(0, 230, 170) or Color3.fromRGB(220, 225, 235)

    if not enabled then
        return
    end

    pcall(function()
        seat.MaxSpeed = targetSpeed

        local root = getCarRoot(seat)
        local throttle = seat.Throttle

        if throttle ~= 0 and root and not root.Anchored then
            local forwardDir = root.CFrame.LookVector * throttle
            local currentVel = root.AssemblyLinearVelocity
            local horizontalVel = Vector3.new(currentVel.X, 0, currentVel.Z)
            local desiredVel = forwardDir * targetSpeed

            local blendedHoriz = horizontalVel:Lerp(
                Vector3.new(desiredVel.X, 0, desiredVel.Z),
                math.clamp(dt * 8, 0, 1)
            )
            root.AssemblyLinearVelocity = Vector3.new(blendedHoriz.X, currentVel.Y, blendedHoriz.Z)
        end
    end)
end)
