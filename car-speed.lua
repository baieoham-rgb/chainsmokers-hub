-- Delta Multi-Feature Script (Car Speed + Aimbot + WallCheck + ESP+ Icon + Head Redirect)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- ลบของเก่าถ้ามีการรันซ้ำ
if playerGui:FindFirstChild("DeltaMultiHubUI") then
    playerGui.DeltaMultiHubUI:Destroy()
end
if playerGui:FindFirstChild("DeltaESPFolder") then
    playerGui.DeltaESPFolder:Destroy()
end
if playerGui:FindFirstChild("DeltaCarSpeedUI") then
    playerGui.DeltaCarSpeedUI:Destroy()
end

-- ตั้งค่าสถานะและพารามิเตอร์
local state = {
    uiVisible = true,
    carSpeedEnabled = false,
    carSpeed = 120,      -- 1 - 500
    aimbotEnabled = false, -- Aimbot + Wall Check
    espEnabled = false,    -- ESP+ Icon มองของในตัว
    espRange = 250,      -- 1 - 500 studs
    silentHead = false   -- กระสุนติดตาม หัว (100% เมื่อเข้าเงื่อนไข)
}

local espFolder = Instance.new("Folder")
espFolder.Name = "DeltaESPFolder"
espFolder.Parent = playerGui

-- ==================== ฟังก์ชันช่วย ====================

local function getCharacter(plr)
    return plr and plr.Character
end

local function getHumanoid(char)
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function isAlive(plr)
    if plr == player then return false end
    local char = getCharacter(plr)
    local hum = getHumanoid(char)
    local head = char and char:FindFirstChild("Head")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    return char and hum and head and hrp and hum.Health > 0
end

local function getDistanceToPlayer(worldPos)
    local myChar = getCharacter(player)
    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Head"))
    if not myRoot then return math.huge end
    return (myRoot.Position - worldPos).Magnitude
end

-- เช็กว่ามีกำแพงขวางระหว่างกล้องกับจุดเป้าหมายหรือไม่ (true = ไม่ติดกำแพง / มองเห็น)
local function isVisibleFromCamera(targetPart)
    if not camera or not targetPart then return false end
    local origin = camera.CFrame.Position
    local direction = targetPart.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    local ignoreList = {}
    if player.Character then
        table.insert(ignoreList, player.Character)
    end
    if targetPart.Parent then
        table.insert(ignoreList, targetPart.Parent)
    end
    params.FilterDescendantsInstances = ignoreList

    local result = Workspace:Raycast(origin, direction, params)
    return result == nil
end

-- หาเป้าหมายที่ดีที่สุดสำหรับ Aimbot & กระสุนติดตามหัว
local function getBestHeadTarget(maxRange)
    if not camera then return nil end
    local bestHead = nil
    local bestScore = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y * 0.5)
    local fovRadius = 220

    for _, plr in ipairs(Players:GetPlayers()) do
        if isAlive(plr) then
            local char = getCharacter(plr)
            local head = char:FindFirstChild("Head")
            local dist = getDistanceToPlayer(head.Position)

            if dist <= maxRange and isVisibleFromCamera(head) then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen and screenPos.Z > 0 then
                    local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if screenDist <= fovRadius then
                        local score = screenDist + (dist * 0.15)
                        if score < bestScore then
                            bestScore = score
                            bestHead = head
                        end
                    end
                end
            end
        end
    end

    return bestHead
end

-- ==================== ฟังก์ชัน Car Speed (1 - 500) ====================

local function getCurrentSeat()
    local char = getCharacter(player)
    local hum = getHumanoid(char)
    if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
        return hum.SeatPart
    end
    return nil
end

local function getCarRoot(seat)
    local model = seat:FindFirstAncestorOfClass("Model")
    if model then
        if model.PrimaryPart then return model.PrimaryPart end
        local largest = seat
        local maxVol = seat.Size.X * seat.Size.Y * seat.Size.Z
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") and not part.Anchored then
                local vol = part.Size.X * part.Size.Y * part.Size.Z
                if vol > maxVol then
                    maxVol = vol
                    largest = part
                end
            end
        end
        return largest
    end
    return seat
end

-- ==================== ฟังก์
