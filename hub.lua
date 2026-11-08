-- Chainsmokers Hub (Direct Run Version)
task.wait(0.5)

local Players = game:GetService("Players")
local P = Players.LocalPlayer or Players.PlayerAdded:Wait()
local S = game:GetService("RunService")
local Cam = workspace.CurrentCamera

local G = P:WaitForChild("PlayerGui")
if G:FindFirstChild("CS_Hub") then 
    G.CS_Hub:Destroy() 
end

local SG = Instance.new("ScreenGui", G)
SG.Name = "CS_Hub"
SG.ResetOnSpawn = false

-- ปุ่มเปิด/ปิดเมนูหลัก (วงกลม CS)
local Btn = Instance.new("TextButton", SG)
Btn.Size = UDim2.new(0, 45, 0, 45)
Btn.Position = UDim2.new(0, 20, 0.4, 0)
Btn.Text = "CS"
Btn.TextColor3 = Color3.fromRGB(0,170,255)
Btn.BackgroundColor3 = Color3.fromRGB(15,15,15)
Btn.TextSize = 18
Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", Btn)
stroke.Color = Color3.fromRGB(0,170,255)

-- หน้าต่างหลัก (กรอบนอก)
local M = Instance.new("Frame", SG)
M.Size = UDim2.new(0, 260, 0, 190)
M.Position = UDim2.new(0.5, -130, 0.5, -95)
M.BackgroundColor3 = Color3.fromRGB(20,20,20)
M.Visible = false
Instance.new("UICorner", M).CornerRadius = UDim.new(0, 8)

Btn.MouseButton1Click:Connect(function() 
    M.Visible = not M.Visible 
end)

-- หัวข้อ
local T = Instance.new("TextLabel", M)
T.Size = UDim2.new(1, 0, 0, 30)
T.Text = "  CHAINSMOKERS HUB"
T.TextColor3 = Color3.new(1,1,1)
T.TextSize = 13
T.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)

-- พื้นที่เลื่อนได้ (ScrollingFrame)
local SF = Instance.new("ScrollingFrame", M)
SF.Size = UDim2.new(1, -10, 1, -38)
SF.Position = UDim2.new(0, 5, 0, 34)
SF.BackgroundTransparency = 1
SF.CanvasSize = UDim2.new(0, 0, 0, 220)
SF.ScrollBarThickness = 5
SF.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

local UIList = Instance.new("UIListLayout", SF)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local sp, nc, f, espOn, distOn = false, false, false, false, false

local function mk(order, txt, cb)
    local b = Instance.new("TextButton", SF)
    b.Size = UDim2.new(1, -10, 0, 32)
    b.LayoutOrder = order
    b.Text = txt..": OFF"
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(function()
        local st = cb()
        b.Text = txt..(st and ": ON" or ": OFF")
        b.BackgroundColor3 = st and Color3.fromRGB(0,180,90) or Color3.fromRGB(45,45,45)
    end)
end

mk(1, "วิ่งเร็ว (Speed)", function() sp = not sp return sp end)
mk(2, "ทะลุกำแพง (Noclip)", function() nc = not nc return nc end)
mk(3, "บิน (Fly)", function() f = not f return f end)
mk(4, "มองตัวละคร (ESP)", function() espOn = not espOn return espOn end)
mk(5, "ระยะตัวละคร (Distance)", function() distOn = not distOn return distOn end)

-- ESP & Distance Loop
S.RenderStepped:Connect(function()
    local myChar = P.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= P and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local h = plr.Character:FindFirstChild("Highlight")
            local bg = plr.Character:FindFirstChild("CS_DistanceTag")
            
            if espOn then
                if not h then
                    h = Instance.new("Highlight", plr.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            else
                if h then h:Destroy() end
            end

            if distOn then
                if not bg and hrp then
                    local bb = Instance.new("BillboardGui", plr.Character)
                    bb.Name = "CS_DistanceTag"
                    bb.Size = UDim2.new(0, 100, 0, 40)
                    bb.StudsOffset = Vector3.new(0, 3, 0)
                    bb.AlwaysOnTop = true
                    
                    local txtLabel = Instance.new("TextLabel", bb)
                    txtLabel.Size = UDim2.new(1, 0, 1, 0)
                    txtLabel.BackgroundTransparency = 1
                    txtLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    txtLabel.TextStrokeTransparency = 0
                    txtLabel.TextSize = 13
                end
                
                if bg and myHRP then
                    local dist = math.floor((hrp.Position - myHRP.Position).Magnitude)
                    local lbl = bg:FindFirstChildOfClass("TextLabel")
                    if lbl then
                        lbl.Text = "[" .. dist .. "m]"
                    end
                end
            else
                if bg then bg:Destroy() end
            end
        end
    end
end)

-- Movement Loop
S.RenderStepped:Connect(function()
    local c = P.Character
    if not c then return end
    if c:FindFirstChild("Humanoid") then
        c.Humanoid.WalkSpeed = sp and 50 or 16
    end
    if nc then
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
        end
    end
    if f and c:FindFirstChild("HumanoidRootPart") then
        local hrp = c.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, 1, 0)
        hrp.CFrame = hrp.CFrame + (Cam.CFrame.LookVector * 1.2)
    end
end)
