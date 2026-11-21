local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local function getGuiParent()
    local ok, ui = pcall(function()
        return gethui and gethui()
    end)
    if ok and ui then return ui end
    return player:WaitForChild("PlayerGui")
end

local parentGui = getGuiParent()

if parentGui:FindFirstChild("DeltaStableHub") then
    parentGui.DeltaStableHub:Destroy()
end

local cfg = {
    uiVisible = true,
    aimbot = false,
    esp = false,
    carSpeedOn = false,
    range = 250,
    carSpeed = 120
}

local espFolder = Instance.new("Folder")
espFolder.Name = "DeltaStableESP"
espFolder.Parent = parentGui

local function isValidTarget(plr)
    if plr == player then return false end
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local head = char:FindFirstChild("Head")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return hum and head and hrp and hum.Health > 0
end

local function myPos()
    local c = player.Character
    local r = c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head"))
    return r and r.Position or nil
end

local function canSee(part)
    camera = Workspace.CurrentCamera
    if not camera or not part then return false end
    local origin = camera.CFrame.Position
    local dir = part.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {}
    if player.Character then table.insert(filter, player.Character) end
    if part.Parent then table.insert(filter, part.Parent) end
    params.FilterDescendantsInstances = filter

    local res = Workspace:Raycast(origin, dir, params)
    return res == nil
end

local function getAimHead()
    camera = Workspace.CurrentCamera
    local originPos = myPos()
    if not camera or not originPos then return nil end

    local center = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y * 0.5)
    local bestPart = nil
    local bestScore = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if isValidTarget(plr) then
            local head = plr.Character:FindFirstChild("Head")
            local dist = (head.Position - originPos).Magnitude
            if dist <= cfg.range and canSee(head) then
                local sp, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen and sp.Z > 0 then
                    local sDist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if sDist <= 240 then
                        local score = sDist + dist * 0.1
                        if score < bestScore then
                            bestScore = score
                            bestPart = head
                        end
                    end
                end
            end
        end
    end
    return bestPart
end

local function itemIcon(name)
    local n = string.lower(name)
    if string.find(n, "gun") or string.find(n, "pistol") or string.find(n, "rifle") or string.find(n, "shotgun") or string.find(n, "ak") or string.find(n, "m4") then
        return "🔫"
    elseif string.find(n, "knife") or string.find(n, "sword") or string.find(n, "axe") or string.find(n, "bat") then
        return "🗡️"
    elseif string.find(n, "med") or string.find(n, "heal") or string.find(n, "food") or string.find(n, "apple") or string.find(n, "potion") then
        return "💊"
    elseif string.find(n, "key") or string.find(n, "coin") or string.find(n, "cash") or string.find(n, "gem") then
        return "🔑"
    end
    return "🎒"
end

local function getItems(plr)
    local icons = {}
    local seen = {}
    local containers = { plr.Character, plr:FindFirstChild("Backpack") }
    for _, box in ipairs(containers) do
        if box then
            for _, item in ipairs(box:GetChildren()) do
                if item:IsA("Tool") and not seen[item.Name] then
                    seen[item.Name] = true
                    table.insert(icons, itemIcon(item.Name))
                end
            end
        end
    end
    return (#icons > 0) and table.concat(icons, " ") or "—"
end

local espMap = {}
local function getESP(plr)
    if espMap[plr] then return espMap[plr] end
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 160, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.Enabled = false
    bb.Parent = espFolder

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    bg.BackgroundTransparency = 0.25
    bg.Parent = bb
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)

    local top = Instance.new("TextLabel")
    top.Size = UDim2.new(1, -6, 0, 18)
    top.Position = UDim2.new(0, 3, 0, 2)
    top.BackgroundTransparency = 1
    top.TextColor3 = Color3.fromRGB(255, 255, 255)
    top.TextSize = 11
    top.Font = Enum.Font.GothamBold
    top.Parent = bg

    local bot = Instance.new("TextLabel")
    bot.Size = UDim2.new(1, -6, 0, 24)
    bot.Position = UDim2.new(0, 3, 0, 20)
    bot.BackgroundTransparency = 1
    bot.TextColor3 = Color3.fromRGB(0, 235, 175)
    bot.TextSize = 14
    bot.Font = Enum.Font.GothamBold
    bot.Parent = bg

    espMap[plr] = { gui = bb, top = top, bot = bot }
    return espMap[plr]
end

local function refreshESP()
    local originPos = myPos()
    for plr, obj in pairs(espMap) do
        if not cfg.esp or not originPos or not Players:FindFirstChild(plr.Name) or not isValidTarget(plr) then
            obj.gui.Enabled = false
        end
    end
    if not cfg.esp or not originPos then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if isValidTarget(plr) then
            local head = plr.Character:FindFirstChild("Head")
            local dist = (head.Position - originPos).Magnitude
            local obj = getESP(plr)
            if dist <= cfg.range then
                obj.gui.Adornee = head
                obj.gui.Enabled = true
                obj.top.Text = plr.DisplayName .. " [" .. math.floor(dist) .. "m]"
                obj.bot.Text = getItems(plr)
            else
                obj.gui.Enabled = false
            end
        end
    end
end

-- UI
local sg = Instance.new("ScreenGui")
sg.Name = "DeltaStableHub"
sg.ResetOnSpawn = false
sg.Parent = parentGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 46, 0, 46)
toggleBtn.Position = UDim2.new(0, 14, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 33)
toggleBtn.Text = "⚡"
toggleBtn.TextSize = 20
toggleBtn.Active = true
toggleBtn.Parent = sg
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 265, 0, 265)
main.Position = UDim2.new(0.5, -132, 0.22, 0)
main.BackgroundColor3 = Color3.fromRGB(22, 25, 33)
main.Active = true
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, 0, 0, 34)
bar.BackgroundColor3 = Color3.fromRGB(32, 36, 48)
bar.Parent = main
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DELTA HUB (STABLE)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 12
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = bar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 22)
closeBtn.Position = UDim2.new(1, -30, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = bar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local function addToggle(y, text, getVal, setVal)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 50, 64)
    b.Text = text .. ": OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    b.MouseButton1Click:Connect(function()
        local nv = not getVal()
        setVal(nv)
        b.Text = text .. (nv and ": ON" or ": OFF")
        b.BackgroundColor3 = nv and Color3.fromRGB(0, 165, 120) or Color3.fromRGB(45, 50, 64)
    end)
end

local function addInput(y, label, def, cb)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.6, 0, 0, 28)
    l.Position = UDim2.new(0, 10, 0, y)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = Color3.fromRGB(220, 225, 235)
    l.TextSize = 12
    l.Font = Enum.Font.GothamSemibold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = main

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.32, 0, 0, 28)
    box.Position = UDim2.new(0.65, 0, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(36, 40, 52)
    box.Text = tostring(def)
    box.TextColor3 = Color3.fromRGB(0, 235, 175)
    box.TextSize = 12
    box.Font = Enum.Font.GothamBold
    box.ClearTextOnFocus = false
    box.Parent = main
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        n = n and math.clamp(math.floor(n), 1, 500) or def
        def = n
        box.Text = tostring(n)
        cb(n)
    end)
end

addToggle(42, "Aimbot (No Wall)", function() return cfg.aimbot end, function(v) cfg.aimbot = v end)
addToggle(80, "ESP+ Icon (1-500)", function() return cfg.esp end, function(v) cfg.esp = v end)
addToggle(118, "Car Speed (1-500)", function() return cfg.carSpeedOn end, function(v) cfg.carSpeedOn = v end)
addInput(158, "Range (1-500):", cfg.range, function(v) cfg.range = v end)
addInput(192, "Car Speed (1-500):", cfg.carSpeed, function(v) cfg.carSpeed = v end)

local function setVisible(v)
    cfg.uiVisible = v
    main.Visible = v
end

toggleBtn.MouseButton1Click:Connect(function()
    setVisible(not cfg.uiVisible)
end)

UserInputService.InputBegan:Connect(function(inp, gpe)
    if not gpe and inp.KeyCode == Enum.KeyCode.RightShift then
        setVisible(not cfg.uiVisible)
    end
end)

local function dragify(handle, target)
    local dragging, dragStart, startPos, dragInput
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp
