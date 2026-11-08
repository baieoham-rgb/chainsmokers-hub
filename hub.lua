-- Chainsmokers Hub (Micro Version + Scrollable Menu)
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

    -- หน้าต่างหลัก (กรอบนอก)
    local M = Instance.new("Frame", SG)
    M.Size, M.Position, M.BackgroundColor3 = UDim2.new(0, 260, 0, 190), UDim2.new(0.5, -130, 0.5, -95), Color3.fromRGB(20,20,20)
    M.Visible = false
    Instance.new("UICorner", M).CornerRadius = UDim.new(0, 8)

    -- หัวข้อ (ตรึงไว้ด้านบนสุด)
    local T = Instance.new("TextLabel", M)
    T.Size, T.Text, T.TextColor3, T.TextSize, T.BackgroundColor3 = UDim2.new(1,0,0,30), "  CHAINSMOKERS HUB", Color3.new(1,1,1), 13, Color3.fromRGB(30,30,30)
    Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)

    -- ปุ่มเปิด/ปิดเมนูหลัก (วงกลม CS)
    local Btn = Instance.new("TextButton", SG)
    Btn.Size, Btn.Position, Btn.Text, Btn.TextColor3, Btn.BackgroundColor3, Btn.TextSize = UDim2.new(0,45,0,45), UDim2.new(0,20,0.4,0), "CS", Color3.fromRGB(0,170,255), Color3.fromRGB(15,15,15), 18
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", Btn).Color = Color3.fromRGB(0,170,255)

    Btn.MouseButton1Click:Connect(function() M.Visible = not M.Visible end)

    -- พื้นที่เลื่อนได้ (ScrollingFrame) สำหรับใส่ปุ่มฟังก์ชันต่างๆ
    local SF = Instance.new("ScrollingFrame", M)
    SF.Size = UDim2.new(1, -10, 1, -38)
    SF.Position = UDim2.new(0, 5, 0, 34)
    SF.BackgroundTransparency = 1
    SF.CanvasSize = UDim2.new(0, 0, 0, 0)
    SF.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SF.ScrollBarThickness = 5
    SF.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

    -- จัดเรียงปุ่มอัตโนมัติใน ScrollingFrame
    local UIList = Instance.new("UIListLayout", SF)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 6)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local sp, nc, f, espOn, distOn = false, false, false, false, false

    local function mk(order, txt, cb)
        local b = Instance.new("TextButton", SF)
        b.Size, b.LayoutOrder, b.Text, b.TextColor3, b.BackgroundColor3, b.TextSize = UDim2.new(1, -10, 0, 32), order, txt..": OFF", Color3.new(1,1,1), Color3.fromRGB(45,45,45), 11
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        b.MouseButton1Click:Connect(function()
            local st = cb()
            b.Text = txt..(st and ": ON" or ": OFF")
            b.BackgroundColor3 = st and Color3.fromRGB(0,180,90) or Color3.fromRGB(45,45,45)
