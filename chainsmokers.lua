-- Chainsmokers Hub - Clean & Stable Version
task.wait(0.5)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Cam = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
if not PlayerGui then return end

if PlayerGui:FindFirstChild("CS_Hub") then
    PlayerGui.CS_Hub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CS_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ปุ่มเปิด-ปิดเมนูหลัก
local MainBtn = Instance.new("TextButton")
MainBtn.Name = "CS_Toggle"
MainBtn.Size = UDim2.new(0, 48, 0, 48)
MainBtn.Position = UDim2.new(0, 20, 0.4, 0)
MainBtn.Text = "CS"
MainBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
MainBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainBtn.TextSize = 18
MainBtn.ZIndex = 9999
MainBtn.Parent = ScreenGui
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(1, 0)
local stroke1 = Instance.new("UIStroke", MainBtn)
stroke1.Color = Color3.fromRGB(0, 170, 255)

-- หน้าต่างหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 200)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
MainFrame.Visible = false
MainFrame.ZIndex = 1000
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(0, 170, 255)
mainStroke.Thickness = 1.5

-- หัวข้อหน้าต่าง
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "Chainsmokers Hub"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.ZIndex = 1001

-- ปุ่มปิดหน้าต่าง (X)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -30, 0, 8)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
CloseBtn.TextSize = 12
CloseBtn.ZIndex = 1001
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.Activated:Connect(function()
    MainFrame.Visible = false
end)

-- กดปุ่มเปิด-ปิดเมนู
MainBtn.Activated:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- คอนเทนเนอร์ใส่ปุ่มฟังก์ชัน
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.ScrollBarThickness = 4
Container.ZIndex = 1001

local UIList = Instance.new("UIListLayout", Container)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

-- ฟังก์ชันสร้างปุ่มสวิตช์ฟีเจอร์
local speedOn, noclipOn, espOn = false, false, false

local function addToggle(text, callback)
    local card = Instance.new("Frame", Container)
    card.Size = UDim2.new(1, 0, 0, 36)
    card.BackgroundColor3 = Color3.fromRGB(26, 32, 44)
    card.ZIndex = 1002
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.ZIndex = 1002
    
    local switchBg = Instance.new("Frame", card)
    switchBg.Size = UDim2.new(0, 34, 0, 18)
    switchBg.Position = UDim2.new(1, -42, 0.5, -9)
    switchBg.BackgroundColor3 = Color3.fromRGB(45, 52, 64)
    switchBg.ZIndex = 1002
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", switchBg)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new(0, 2, 0.5, -7)
    dot.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    dot.ZIndex = 1003
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 1004
    
    local state = false
    btn.Activated:Connect(function()
        state = not state
        callback(state)
        if state then
            switchBg.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            dot.Position = UDim2.new(1, -16, 0.5, -7)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            switchBg.BackgroundColor3 = Color3.fromRGB(45, 52, 64)
            dot.Position = UDim2.new(0, 2, 0.5, -7)
            dot.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        end
    end)
end

addToggle("วิ่งเร็ว (Speed)", function(state) speedOn = state end)
addToggle("ทะลุกำแพง (Noclip)", function(state) noclipOn = state end)
addToggle("มองตัวละคร (ESP)", function(state) espOn = state end)

-- ลูปการทำงานฟังก์ชันในเกม
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
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
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
        end
    end
end)
