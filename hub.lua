-- Chainsmokers Hub (Casserus UI Style)
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

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CS_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ปุ่มวงกลมเปิด/ปิดเมนูหลัก (CS Button)
local MainBtn = Instance.new("TextButton")
MainBtn.Name = "CS_Toggle"
MainBtn.Size = UDim2.new(0, 45, 0, 45)
MainBtn.Position = UDim2.new(0, 20, 0.4, 0)
MainBtn.Text = "CS"
MainBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
MainBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainBtn.TextSize = 18
MainBtn.Parent = ScreenGui
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(1, 0)
local stroke1 = Instance.new("UIStroke", MainBtn)
stroke1.Color = Color3.fromRGB(0, 170, 255)

-- Main Frame (Casserus Style)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

MainBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Title = Instance.new("Text
