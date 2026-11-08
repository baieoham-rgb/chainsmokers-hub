-- Chainsmokers Hub - Debug Version
print("=== [CS Hub] เริ่มต้นโหลดสคริปต์ ===")

local Success, Err = pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    if not LocalPlayer then
        print("[CS Hub] กำลังรอ LocalPlayer...")
        LocalPlayer = Players.PlayerAdded:Wait()
    end
    print("[CS Hub] พบ LocalPlayer แล้ว: " .. LocalPlayer.Name)

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if not PlayerGui then
        warn("[CS Hub] Error: ไม่พบ PlayerGui!")
        return
    end
    print("[CS Hub] พบ PlayerGui แล้ว")

    if PlayerGui:FindFirstChild("CS_Hub") then
        PlayerGui.CS_Hub:Destroy()
        print("[CS Hub] ลบ UI เก่าทิ้งเรียบร้อย")
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CS_Hub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui
    print("[CS Hub] สร้าง ScreenGui สำเร็จ!")

    -- ปุ่มเปิด-ปิดทดสอบ
    local MainBtn = Instance.new("TextButton")
    MainBtn.Name = "CS_Toggle"
    MainBtn.Size = UDim2.new(0, 50, 0, 50)
    MainBtn.Position = UDim2.new(0, 20, 0.4, 0)
    MainBtn.Text = "CS"
    MainBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
    MainBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainBtn.TextSize = 18
    MainBtn.Parent = ScreenGui
    Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(1, 0)
    print("[CS Hub] สร้างปุ่ม CS สำเร็จแล้ว!")
end)

if not Success then
    warn("[CS Hub] เกิดข้อผิดพลาดร้ายแรง: " .. tostring(Err))
else
    print("=== [CS Hub] โหลด UI พื้นฐานเสร็จสมบูรณ์! ===")
end
