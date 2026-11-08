-- Chainsmokers Hub (Micro Version + ESP + Distance - Fixed UI)
task.wait(1)

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
    M.Size, M.Position, M.BackgroundColor3 = UDim2.new(0, 260, 0, 195), UDim2.new(0.5, -130, 0.5, -97), Color3.fromRGB(20,20,20)
    M.Visible = false
    Instance.new("UICorner", M).CornerRadius = UDim.new(0, 8)

    local T = Instance.new("TextLabel", M)
    T.Size, T.Text, T.TextColor3, T.TextSize, T.BackgroundColor3 = UDim2.new(1,0,0,30), "  CHAINSMOKERS HUB", Color3.new(1,1,1), 13, Color3.fromRGB(30,30,30)
    Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)

    local Btn = Instance.new("TextButton", SG)
    Btn.Size, Btn.Position, Btn.Text, Btn.TextColor3, Btn.BackgroundColor3, Btn.TextSize = UDim2.new(0,45,0,45), UDim2.new(0,20,0.4,0), "CS", Color3.fromRGB(0,170,255), Color3.fromRGB(15,15,15), 18
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", Btn).Color = Color3.fromRGB(0,170,255)

    Btn.MouseButton1Click:Connect(function() M.Visible = not M.Visible end)

    local sp, nc, f, espOn = false, false, false, false

    local function mk(y, txt, cb)
        local b = Instance.new("TextButton", M)
        b.Size, b.Position, b.Text, b.TextColor3, b.BackgroundColor3, b.TextSize = UDim2.new(1,-20,0,32), UDim2.new(0,10,0,
