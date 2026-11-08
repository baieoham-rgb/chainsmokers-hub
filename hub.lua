-- Chainsmokers Hub (Safe Micro Version)
task.wait(1) -- หน่วงเวลาให้เกมโหลดเสร็จก่อนรัน

local Players = game:GetService("Players")
local P = Players.LocalPlayer or Players.PlayerAdded:Wait()
local S = game:GetService("RunService")
local Cam = workspace.CurrentCamera

local success, err = pcall(function()
    local G = P:WaitForChild("PlayerGui", 10)
    if not G then return end

    if G:FindFirstChild("CS_Hub") then G.CS_Hub:Destroy() end

    local SG = Instance.new("ScreenGui", G)
    SG.Name = "CS_Hub"
    SG.ResetOnSpawn = false

    local M = Instance.new("Frame", SG)
    M.Size, M.Position, M.BackgroundColor3 = UDim2.new(0, 260, 0, 240), UDim2.new(0.5, -130, 0.5, -120), Color3.fromRGB(20,20,20)
    M.Visible = false
    Instance.new("UICorner", M).CornerRadius = UDim.new(0, 8)

    local T = Instance.new("TextLabel", M)
    T.Size, T.Text, T.TextColor3, T.TextSize, T.BackgroundColor3 = UDim2.new(1,0,0,35), "  CHAINSMOKERS HUB", Color3.new(1,1,1), 14, Color3.fromRGB(30,30,30)
    Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)

    local Btn = Instance.new("TextButton", SG)
    Btn.Size, Btn.Position, Btn.Text, Btn.TextColor3, Btn.BackgroundColor3, Btn.TextSize = UDim2.new(0,45,0,45), UDim2.new(0,20,0.4,0), "CS", Color3.fromRGB(0,170,255), Color3.fromRGB(15,15,15), 18
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", Btn).Color = Color3.fromRGB(0,170,255)

    Btn.MouseButton1Click:Connect(function() M.Visible = not M.Visible end)

    local sp, nc, f, espOn, aimOn = false, false, false, false, false

    local function mk(y, txt, cb)
        local b = Instance.new("TextButton", M)
        b.Size, b.Position, b.Text, b.TextColor3, b.BackgroundColor3, b.TextSize = UDim2.new(1,-20,0,35), UDim2.new(0,10,0,y), txt..": OFF", Color3.new(1,1,1), Color3.fromRGB(45,45,45), 12
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        b.MouseButton1Click:Connect(function()
            local st = cb()
            b.Text = txt..(st and ": ON" or ": OFF")
            b.BackgroundColor3 = st and Color3.fromRGB(0,180,90) or Color3.fromRGB(45,45,45)
        end)
    end

    mk(45, "วิ่งเร็ว (Speed)", function() sp = not sp return sp end)
    mk(85, "ทะลุกำแพง (Noclip)", function() nc = not nc return nc end)
    mk(125, "บิน (Fly)", function() f = not f return f end)
    mk(165, "มองตัวละคร (ESP)", function() espOn = not espOn return espOn end)
    mk(205, "ล็อกเป้า (Aimbot)", function() aimOn = not aimOn return aimOn end)

    S.RenderStepped:Connect(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= P and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local h = plr.Character:FindFirstChild("Highlight")
                if espOn then
                    if not h then
                        h = Instance.new("Highlight", plr.Character)
                        h.FillColor = Color3.fromRGB(255, 0, 0)
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                else
                    if h then h:Destroy() end
                end
            end
        end
    end)

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
        if aimOn then
            local closest, dist = nil, math.huge
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= P and plr.Character and plr.Character:FindFirstChild("Head") then
                    local head = plr.Character.Head
                    local pos, onScreen = Cam:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)).Magnitude
                        if mag < dist then
                            dist = mag
                            closest = head
                        end
                    end
                end
            end
            if closest then
                Cam.CFrame = CFrame.new(Cam.CFrame.Position, closest.Position)
            end
        end
    end)
end)

if not success then
    warn("CS Hub Error: " .. tostring(err))
end
