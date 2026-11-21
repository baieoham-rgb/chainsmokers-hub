local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local guiParent = (gethui and gethui()) or player:WaitForChild("PlayerGui")

for _, name in ipairs({ "DeltaQuickTest", "DeltaHubV3", "DeltaESP_V3" }) do
    local old = guiParent:FindFirstChild(name)
    if old then old:Destroy() end
end

local cfg = {
    ui = true,
    aim = false,
    esp = false,
    car = false,
    range = 250,
    speed = 120
}

local espFolder = Instance.new("Folder")
espFolder.Name = "DeltaESP_V3"
espFolder.Parent = guiParent

local function validPlr(plr)
    if plr == player then return false end
    local c = plr.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    local head = c and c:FindFirstChild("Head")
    return h and head and h.Health > 0
end

local function myOrigin()
    local c = player.Character
    local r = c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head"))
    return r and r.Position
end

local function clearWall(part)
    local cam = Workspace.CurrentCamera
    if not cam or not part then return false end
    local origin = cam.CFrame.Position
    local dir = part.Position - origin
    local p = RaycastParams.new()
    p.FilterType = Enum.RaycastFilterType.Exclude
    local list = {}
    if player.Character then table.insert(list, player.Character) end
    if part.Parent then table.insert(list, part.Parent) end
    p.FilterDescendantsInstances = list
    return Workspace:Raycast(origin, dir, p) == nil
end

local function bestHead()
    local cam = Workspace.CurrentCamera
    local orig = myOrigin()
    if not cam or not orig then return nil end
    local best, bestScore = nil, math.huge
    local mid = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5)

    for _, plr in ipairs(Players:GetPlayers()) do
        if validPlr(plr) then
            local head = plr.Character:FindFirstChild("Head")
            local d = (head.Position - orig).Magnitude
            if d <= cfg.range and clearWall(head) then
                local sp, onScr = cam:WorldToViewportPoint(head.Position)
                if onScr and sp.Z > 0 then
                    local sd = (Vector2.new(sp.X, sp.Y) - mid).Magnitude
                    if sd <= 240 then
                        local sc = sd + d * 0.1
                        if sc < bestScore then
                            bestScore = sc
                            best = head
                        end
                    end
                end
            end
        end
    end
    return best
end

local function iconOf(n)
    local s = string.lower(n)
    if string.find(s, "gun") or string.find(s, "pistol") or string.find(s, "rifle") or string.find(s, "shotgun") then return "🔫" end
    if string.find(s, "knife") or string.find(s, "sword") or string.find(s, "axe") then return "🗡️" end
    if string.find(s, "med") or string.find(s, "heal") or string.find(s, "food") or string.find(s, "apple") then return "💊" end
    if string.find(s, "key") or string.find(s, "coin") or string.find(s, "cash") then return "🔑" end
    return "🎒"
end

local function itemsText(plr)
    local t, seen = {}, {}
    for _, box in ipairs({ plr.Character, plr:FindFirstChild("Backpack") }) do
        if box then
            for _, obj in ipairs(box:GetChildren()) do
                if obj:IsA("Tool") and not seen[obj.Name] then
                    seen[obj.Name] = true
                    table.insert(t, iconOf(obj.Name))
                end
            end
        end
    end
    return #t > 0 and table.concat(t, " ") or "—"
end

local espCache = {}
local function getTag(plr)
    if espCache[plr] then return espCache[plr] end
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 150, 0, 46)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.Enabled = false
    bb.Parent = espFolder

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    f.BackgroundTransparency = 0.25
    f.Parent = bb

    local l1 = Instance.new("TextLabel")
    l1.Size = UDim2.new(1, -4, 0, 18)
    l1.Position = UDim2.new(0, 2, 0, 2)
    l1.BackgroundTransparency = 1
    l1.TextColor3 = Color3.fromRGB(255, 255, 255)
    l1.TextSize = 11
    l1.Font = Enum.Font.GothamBold
    l1.Parent = f

    local l2 = Instance.new("TextLabel")
    l2.Size = UDim2.new(1, -4, 0, 22)
    l2.Position = UDim2.new(0, 2, 0, 20)
    l2.BackgroundTransparency = 1
    l2.TextColor3 = Color3.fromRGB(0, 230, 170)
    l2.TextSize = 14
    l2.Font = Enum.Font.GothamBold
    l2.Parent = f

    espCache[plr] = { bb = bb, l1 = l1, l2 = l2 }
    return espCache[plr]
end

local function stepESP()
    local orig = myOrigin()
    for plr, tag in pairs(espCache) do
        if not cfg.esp or not orig or not Players:FindFirstChild(plr.Name) or not validPlr(plr) then
            tag.bb.Enabled = false
        end
    end
    if not cfg.esp or not orig then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if validPlr(plr) then
            local head = plr.Character:FindFirstChild("Head")
            local d = (head.Position - orig).Magnitude
            local tag = getTag(plr)
            if d <= cfg.range then
                tag.bb.Adornee = head
                tag.bb.Enabled = true
                tag.l1.Text = plr.DisplayName .. " [" .. math.floor(d) .. "m]"
                tag.l2.Text = itemsText(plr)
            else
                tag.bb.Enabled = false
            end
        end
    end
end

local sg = Instance.new("ScreenGui")
sg.Name = "DeltaHubV3"
sg.ResetOnSpawn = false
sg.Parent = guiParent

local uiBtn = Instance.new("TextButton")
uiBtn.Size = UDim2.new(0, 46, 0, 46)
uiBtn.Position = UDim2.new(0, 12, 0.35, 0)
uiBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 36)
uiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
uiBtn.Text = "UI"
uiBtn.TextSize = 14
uiBtn.Font = Enum.Font.GothamBold
uiBtn.Active = true
uiBtn.Parent = sg

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 250, 0, 235)
panel.Position = UDim2.new(0.5, -125, 0.2, 0)
panel.BackgroundColor3 = Color3.fromRGB(25, 28, 36)
panel.Active = true
panel.Parent = sg

local headBar = Instance.new("TextLabel")
headBar.Size = UDim2.new(1, 0, 0, 30)
headBar.BackgroundColor3 = Color3.fromRGB(38, 42, 54)
headBar.TextColor3 = Color3.fromRGB(255, 255, 255)
headBar.Text = "  DELTA HUB"
headBar.TextSize = 13
headBar.Font = Enum.Font.GothamBold
headBar.TextXAlignment = Enum.TextXAlignment.Left
headBar.Parent = panel

local function mkBtn(y, label, getter, setter)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -16, 0, 30)
    b.Position = UDim2.new(0, 8, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Text = label .. ": OFF"
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = panel
    b.MouseButton1Click:Connect(function()
        local nv = not getter()
        setter(nv)
        b.Text = label .. (nv and ": ON" or ": OFF")
        b.BackgroundColor3 = nv and Color3.fromRGB(0, 160, 115) or Color3.fromRGB(50, 55, 70)
    end)
end

local function mkNum(y, label, def, cb)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.6, 0, 0, 26)
    l.Position = UDim2.new(0, 8, 0, y)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(230, 235, 245)
    l.Text = label
    l.TextSize = 12
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = panel

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.32, 0, 0, 26)
    box.Position = UDim2.new(0.64, 0, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(40, 45, 58)
    box.TextColor3 = Color3.fromRGB(0, 230, 170)
    box.Text = tostring(def)
    box.TextSize = 12
    box.Font = Enum.Font.GothamBold
    box.ClearTextOnFocus = false
    box.Parent = panel

    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        n = n and math.clamp(math.floor(n), 1, 500) or def
        def = n
        box.Text = tostring(n)
        cb(n)
    end)
end

mkBtn(36, "Aimbot (No Wall)", function() return cfg.aim end, function(v) cfg.aim = v end)
mkBtn(70, "ESP+ Icon", function() return cfg.esp end, function(v) cfg.esp = v end)
mkBtn(104, "Car Speed", function() return cfg.car end, function(v) cfg.car = v end)
mkNum(140, "Range (1-500):", cfg.range, function(v) cfg.range = v end)
mkNum(170, "Speed (1-500):", cfg.speed, function(v) cfg.speed = v end)

uiBtn.MouseButton1Click:Connect(function()
    cfg.ui = not cfg.ui
    panel.Visible = cfg.ui
end)

UserInputService.InputBegan:Connect(function(inp, gpe)
    if not gpe and inp.KeyCode == Enum.KeyCode.RightShift then
        cfg.ui = not cfg.ui
        panel.Visible = cfg.ui
    end
end)

RunService.RenderStepped:Connect(function()
    if cfg.aim then
        local h = bestHead()
        local cam = Workspace.CurrentCamera
        if h and cam then
            cam.CFrame = CFrame.lookAt(cam.CFrame.Position, h.Position)
        end
    end
    stepESP()
end)

RunService.Heartbeat:Connect(function(dt)
    if not cfg.car then return end
    local c = player.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    local seat = h and h.SeatPart
    if seat and seat:IsA("VehicleSeat") then
        pcall(function()
            seat.MaxSpeed = cfg.speed
            local root = seat.Parent and (seat.Parent.PrimaryPart or seat)
            if seat.Throttle ~= 0 and root and not root.Anchored then
                local fwd = root.CFrame.LookVector * seat.Throttle
                local vel = root.AssemblyLinearVelocity
                local horiz = Vector3.new(vel.X, 0, vel.Z)
                local goal = Vector3.new(fwd.X * cfg.speed, 0, fwd.Z * cfg.speed)
                local nh = horiz:Lerp(goal, math.clamp(dt * 8, 0, 1))
                root.AssemblyLinearVelocity = Vector3.new(nh.X, vel.Y, nh.Z)
            end
        end)
    end
end)
