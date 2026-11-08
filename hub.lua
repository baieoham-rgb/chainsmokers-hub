-- Chainsmokers Hub (Ultimate Stable Version)
task.wait(0.5)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Cam = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    LocalPlayer = Players.PlayerAdded:Wait()
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
if not PlayerGui then return end

if PlayerGui:FindFirstChild("CS_Hub") then
    PlayerGui.CS_Hub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CS_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ปุ่มเปิด/ปิดเมนูหลัก (วงกลม CS)
local MainBtn = Instance.new("TextButton")
MainBtn.Name = "ToggleBtn"
MainBtn.Size = UDim2.new(0, 45, 0, 45)
MainBtn.Position = UDim2.new(0, 20, 0.4, 0)
MainBtn.Text = "CS"
MainBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
MainBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainBtn.TextSize = 18
MainBtn.Parent = ScreenGui

local corner1 = Instance.new("UICorner", MainBtn)
corner1.CornerRadius = UDim.new(1, 0)

local stroke1 = Instance.new("UIStroke", MainBtn)
stroke1.Color = Color3.fromRGB(0, 170, 255)

-- หน้าต่างหลัก (กรอบนอก)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 210)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -105)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

MainBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- หัวข้อ
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "  CHAINSMOKERS HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 13
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Parent = MainFrame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

-- พื้นที่เลื่อนได้ (ScrollingFrame)
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -38)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 34)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- สถานะฟังก์ชัน
local speedOn, noclipOn, flyOn, espOn, distOn, boxOn = false, false, false, false, false, false

local function createButton(order, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.LayoutOrder = order
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextSize = 11
    btn.Parent = ScrollingFrame
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        local state = callback()
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(45, 45, 45)
    end)
end

createButton(1, "วิ่งเร็ว (Speed)", function() speedOn = not speedOn return speedOn end)
createButton(2, "ทะลุกำแพง (Noclip)", function() noclipOn = not noclipOn return noclipOn end)
createButton(3, "บิน (Fly)", function() flyOn = not flyOn return flyOn end)
createButton(4, "มองตัวละคร (ESP)", function() espOn = not espOn return espOn end)
createButton(5, "ระยะตัวละคร (Distance)", function() distOn = not distOn return distOn end)
createButton(6, "กล่อง ESP (Box)", function() boxOn = not boxOn return boxOn end)

-- ESP, Distance & Box Loop
RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                -- Highlight ESP
                local highlight = char:FindFirstChild("CS_Highlight")
                if espOn then
                    if not highlight then
                        highlight = Instance.new("Highlight", char)
                        highlight.Name = "CS_Highlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                else
                    if highlight then highlight:Destroy() end
                end

                -- Distance Tag
                local distanceTag = char:FindFirstChild("CS_DistanceTag")
                if distOn and myHRP then
                    if not distanceTag then
                        local bb = Instance.new("BillboardGui", char)
                        bb.Name = "CS_DistanceTag"
                        bb.Size = UDim2.new(0, 100, 0, 40)
                        bb.StudsOffset = Vector3.new(0, 3.5, 0)
                        bb.AlwaysOnTop = true
                        
                        local txt = Instance.new("TextLabel", bb)
                        txt.Name = "Text"
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                        txt.TextStrokeTransparency = 0
                        txt.TextSize = 13
                    else
                        local dist = math.floor((hrp.Position - myHRP.Position).Magnitude)
                        local txt = distanceTag:FindFirstChild("Text")
                        if txt then
                            txt.Text = "[" .. dist .. "m]"
                        end
                    end
                else
                    if distanceTag then distanceTag:Destroy() end
                end

                -- Box ESP
                local boxTag = char:FindFirstChild("CS_BoxTag")
                if boxOn then
                    if not boxTag then
                        local bb = Instance.new("BillboardGui", char)
                        bb.Name = "CS_BoxTag"
                        bb.Size = UDim2.new(4, 0, 5, 0)
                        bb.StudsOffset = Vector3.new(0, 0.5, 0)
                        bb.AlwaysOnTop = true
                        
                        local frm = Instance.new("Frame", bb)
                        frm.Size = UDim2.new(1, 0, 1, 0)
                        frm.BackgroundTransparency = 1
                        
                        local stroke = Instance.new("UIStroke", frm)
                        stroke.Color = Color3.fromRGB(0, 255, 255)
                        stroke.Thickness = 1.5
                    end
                else
                    if boxTag then boxTag:Destroy() end
                end
            end
        end
    end
end)

-- Movement Loop (Speed, Noclip, Fly)
RunService.RenderStepped:Connect(function()
    local c = LocalPlayer.Character
    if not c then return end
    
    local humanoid = c:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedOn and 50 or 16
    end
    
    if noclipOn then
        for _, v in ipairs(c:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
    
    if flyOn then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 1, 0)
            hrp.CFrame = hrp.CFrame + (Cam.CFrame.LookVector * 1.2)
        end
    end
end)
