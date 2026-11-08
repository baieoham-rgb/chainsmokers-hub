-- Chainsmokers Hub - Touch Input Fixed Version
task.wait(0.5)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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

-- ปุ่มเปิด-ปิดเมนู (ใส่ ZIndex สูงสุดเพื่อให้กดทับทุกอย่างบนมือถือได้)
local MainBtn = Instance.new("TextButton")
MainBtn.Name = "CS_Toggle"
MainBtn.Size = UDim2.new(0, 45, 0, 45)
MainBtn.Position = UDim2.new(0, 20, 0.4, 0)
MainBtn.Text = "CS"
MainBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
MainBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainBtn.TextSize = 18
MainBtn.ZIndex = 999
MainBtn.Parent = ScreenGui
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(1, 0)
local stroke1 = Instance.new("UIStroke", MainBtn)
stroke1.Color = Color3.fromRGB(0, 170, 255)

-- หน้าต่างหลักของ Hub
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
MainFrame.Visible = false
MainFrame.ZIndex = 100
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(0, 170, 255)
mainStroke.Transparency = 0.5
mainStroke.Thickness = 1.5

local bgGradient = Instance.new("UIGradient", MainFrame)
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 24, 33)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 17))
})
bgGradient.Rotation = 45

-- ใช้ระบบ Touch / Click เด้งเปิดปิดชัวร์ๆ บนมือถือ
MainBtn.Activated:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 101
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "Chainsmokers Hub"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.ZIndex = 101
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 16, 0, 16)
CloseBtn.Position = UDim2.new(1, -24, 0.5, -8)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
CloseBtn.TextSize = 10
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
CloseBtn.ZIndex = 101
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.Activated:Connect(function()
    MainFrame.Visible = false
end)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 16, 0, 16)
MinimizeBtn.Position = UDim2.new(1, -46, 0.5, -8)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
MinimizeBtn.TextSize = 12
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 185, 45)
MinimizeBtn.ZIndex = 101
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0)

MinimizeBtn.Activated:Connect(function()
    MainFrame.Visible = false
end)

-- แถบเมนูด้านข้าง (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 100, 1, -40)
Sidebar.Position = UDim2.new(0, 6, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
Sidebar.ZIndex = 101
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.SortOrder = Enum.SortOrder.LayoutOrder
SideList.Padding = UDim.new(0, 6)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local SidePadding = Instance.new("UIPadding", Sidebar)
SidePadding.PaddingTop = UDim.new(0, 8)

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -120, 1, -40)
ContentContainer.Position = UDim2.new(0, 112, 0, 35)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 101
ContentContainer.Parent = MainFrame

local tabs = {}

local function createTab(name)
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabFrame.ScrollBarThickness = 4
    tabFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    tabFrame.Visible = false
    tabFrame.ZIndex = 101
    tabFrame.Parent = ContentContainer
    
    local list = Instance.new("UIListLayout", tabFrame)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    
    tabs[name] = tabFrame
    return tabFrame
end

local mainTab = createTab("Main")
local combatTab = createTab("Combat")
local espTab = createTab("ESP")
mainTab.Visible = true

local activeTabBtn = nil

local function createTabBtn(order, name, targetTab)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 28)
    btn.LayoutOrder = order
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.BackgroundColor3 = Color3.fromRGB(28, 33, 45)
    btn.TextSize = 11
    btn.Font = Enum.Font.SourceSansBold
    btn.ZIndex = 102
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    if order == 1 then
        activeTabBtn = btn
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    btn.Activated:Connect(function()
        for _, tab in pairs(tabs) do
            tab.Visible = false
        end
        if activeTabBtn then
            activeTabBtn.BackgroundColor3 = Color3.fromRGB(28, 33, 45)
            activeTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        targetTab.Visible = true
        activeTabBtn = btn
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

createTabBtn(1, "Main", mainTab)
createTabBtn(2, "Combat", combatTab)
createTabBtn(3, "ESP", espTab)

local function createToggle(parent, order, text, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 36)
    card.LayoutOrder = order
    card.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
    card.ZIndex = 102
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.ZIndex = 102
    lbl.Parent = card
    
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 34, 0, 18)
    switchBg.Position = UDim2.new(1, -40, 0.5, -9)
    switchBg.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    switchBg.ZIndex = 102
    switchBg.Parent = card
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new(0, 2, 0.5, -7)
    dot.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    dot.ZIndex = 103
    dot.Parent = switchBg
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 103
    btn.Parent = card
    
    local state = false
    btn.Activated:Connect(function()
        state = callback()
        if state then
            switchBg.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            dot.Position = UDim2.new(1, -16, 0.5, -7)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            switchBg.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
            dot.Position = UDim2.new(0, 2, 0.5, -7)
            dot.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        end
    end)
end

local speedOn, noclipOn, flyOn, aimbotOn, aimAssistOn, espOn, distOn, boxOn = false, false, false, false, false, false, false, false

createToggle(mainTab, 1, "วิ่งเร็ว (Speed)", function() speedOn = not speedOn return speedOn end)
createToggle(mainTab, 2, "ทะลุกำแพง (Noclip)", function() noclipOn = not noclipOn return noclipOn end)
createToggle(mainTab, 3, "บิน (Fly)", function() flyOn = not flyOn return flyOn end)

createToggle(combatTab, 1, "ล็อกเป้า (Aimbot)", function() aimbotOn = not aimbotOn return aimbotOn end)
createToggle(combatTab, 2, "ช่วยเล็ง (Aim Assist)", function() aimAssistOn = not aimAssistOn return aimAssistOn end)

createToggle(espTab, 1, "มองตัวละคร (ESP)", function() espOn = not espOn return espOn end)
createToggle(espTab, 2, "ระยะตัวละคร (Distance)", function() distOn = not distOn return distOn end)
createToggle(espTab, 3, "กล่อง ESP (Box)", function() boxOn = not boxOn return boxOn end)

local function getClosestPlayer()
    local target = nil
    local shortestDist = 150
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos, onScreen = Cam:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        target = hrp
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if aimbotOn then
        local targetHRP = getClosestPlayer()
        if targetHRP then
            Cam.CFrame = CFrame.new(Cam.CFrame.Position, targetHRP.Position)
        end
    elseif aimAssistOn then
        local targetHRP = getClosestPlayer()
        if targetHRP then
            local goalCFrame = CFrame.new(Cam.CFrame.Position, targetHRP.Position)
            Cam.CFrame = Cam.CFrame:Lerp(goalCFrame, 0.2)
        end
    end

    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
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
