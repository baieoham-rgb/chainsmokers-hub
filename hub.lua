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
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8
