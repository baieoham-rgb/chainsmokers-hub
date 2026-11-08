-- Chainsmokers Hub - Direct Run Full Version
if game:GetService("CoreGui"):FindFirstChild("CS_Hub") then
    game:GetService("CoreGui").CS_Hub:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Cam = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CS_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainBtn = Instance.new("TextButton", ScreenGui)
MainBtn.Size = UDim2.new(0, 48, 0, 48)
MainBtn.Position = UDim2.new(0, 20, 0.4, 0)
MainBtn.Text = "CS"
MainBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
MainBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainBtn.TextSize = 18
MainBtn.ZIndex = 9999
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(1, 0)
local stroke1 = Instance.new("UIStroke", MainBtn)
stroke1.Color = Color3.fromRGB(0, 170, 255)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
MainFrame.Visible = false
MainFrame.ZIndex = 1000
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(0, 170, 255)
mainStroke.Thickness = 1.5

local dragging, dragStart, startPos = false, nil, nil
MainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainBtn.Position
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if conn then conn:Disconnect() end
                if (input.Position - dragStart).Magnitude < 5 then
                    MainFrame.Visible = not MainFrame.Visible
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        MainBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 1001

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "Chainsmokers Hub"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.ZIndex = 1001

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -10)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
CloseBtn.TextSize = 10
CloseBtn.ZIndex = 1001
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.Activated:Connect(function() MainFrame.Visible = false end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 100, 1, -45)
Sidebar.Position = UDim2.new(0, 6, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
Sidebar.ZIndex = 1001
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.SortOrder = Enum.SortOrder.LayoutOrder
SideList.Padding = UDim.new(0, 6)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 8)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -120, 1, -45)
ContentContainer.Position = UDim2.new(0, 112, 0, 38)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 1001

local tabs = {}
local function createTab(name)
    local tabFrame = Instance.new("ScrollingFrame", ContentContainer)
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabFrame.ScrollBarThickness = 3
    tabFrame.Visible = false
    tabFrame.ZIndex = 1001
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
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, -12, 0, 28)
    btn.LayoutOrder = order
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.BackgroundColor3 = Color3.fromRGB(28, 33, 45)
    btn.TextSize = 11
    btn.Font = Enum.Font.SourceSansBold
    btn.ZIndex = 1002
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    if order == 1 then
        activeTabBtn = btn
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    btn.Activated:Connect(function()
        for _, tab in pairs(tabs) do tab.Visible = false end
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
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, -6, 0, 34)
    card.LayoutOrder = order
    card.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
    card.ZIndex = 1002
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -45, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.ZIndex = 1002
    
    local switchBg = Instance.new("Frame", card)
    switchBg.Size = UDim2.new(0, 32, 0, 16)
    switchBg.Position = UDim2.new(1, -38, 0.5, -8)
    switchBg.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    switchBg.ZIndex = 1002
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", switchBg)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 2, 0.5, -6)
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
        state = callback()
        if state then
            switchBg.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            dot.Position = UDim2.new(1, -14, 0.5, -6)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            switchBg.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
            dot.Position = UDim2.new(0, 2, 0.5, -6)
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
    local target, shortestDist = nil, 150
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos, onScreen = Cam:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)).Magnitude
                    if dist < shortestDist then shortestDist = dist; target = hrp end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if aimbotOn then
        local t = getClosestPlayer()
        if t then Cam.CFrame = CFrame.new(Cam.CFrame.Position, t.Position) end
    elseif aimAssistOn then
        local t = getClosestPlayer()
        if t then Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, t.Position), 0.2) end
    end

    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local hl = char:FindFirstChild("CS_Highlight")
                if espOn then
                    if not hl then
                        hl = Instance.new("Highlight", char)
                        hl.Name = "CS_Highlight"
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                    end
                else if hl then hl:Destroy() end end

                local dt = char:FindFirstChild("CS_DistanceTag")
                if distOn and myHRP then
                    if not dt then
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
                        txt.TextSize = 12
                    else
                        local d = math.floor((hrp.Position - myHRP.Position).Magnitude)
                        local txt = dt:FindFirstChild("Text")
                        if txt then txt.Text = "[" .. d .. "m]" end
                    end
                else if dt then dt:Destroy() end end

                local bt = char:FindFirstChild("CS_BoxTag")
                if boxOn then
                    if not bt then
                        local bb = Instance.new("BillboardGui", char)
                        bb.Name = "CS_BoxTag"
                        bb.Size = UDim2.new(4, 0, 5, 0)
                        bb.StudsOffset = Vector3.new(0, 0.5, 0)
                        bb.AlwaysOnTop = true
                        local frm = Instance.new("Frame", bb)
                        frm.Size = UDim2.new(1, 0, 1, 0)
                        frm.BackgroundTransparency = 1
                        local st = Instance.new("UIStroke", frm)
                        st.Color = Color3.fromRGB(0, 255, 255)
                    end
                else if bt then bt:Destroy() end end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local c = LocalPlayer.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = speedOn and 50 or 16 end
    if noclipOn then
        for _, v in ipairs(c:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
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
