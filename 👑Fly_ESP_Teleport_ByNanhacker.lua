
--[[
🔰 SCRIPT CHỨC NĂNG:
✅ Fly bằng phím
✅ ESP tên người chơi
✅ Auto Teleport ra sau người chơi
✅ Teleport đến người chơi bằng cách gõ tên
✅ GUI bật/tắt bằng phím
✅ Hiển thị chữ "By: 👑ByNanhacker" trong GUI
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- Biến
local flying = false
local flySpeed = 50
local espEnabled = false
local autoTeleport = false
local targetName = "TênNgườiChơi"
local guiKey = Enum.KeyCode.RightControl
local guiVisible = true
local espTable = {}

-- GUI
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "HackGUI"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 250, 0, 230)
frame.Position = UDim2.new(0, 10, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0

-- Label Tác Giả
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 0, 20)
label.Position = UDim2.new(0, 0, 0, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 0)
label.Text = "By: 👑ByNanhacker"
label.Font = Enum.Font.GothamBold
label.TextSize = 16

-- Nút: Fly
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(1, 0, 0, 30)
flyBtn.Position = UDim2.new(0, 0, 0, 25)
flyBtn.Text = "Toggle Fly"
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
end)

-- Nút: ESP
local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(1, 0, 0, 30)
espBtn.Position = UDim2.new(0, 0, 0, 60)
espBtn.Text = "Toggle ESP"
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
end)

-- Nút: Auto Teleport
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(1, 0, 0, 30)
tpBtn.Position = UDim2.new(0, 0, 0, 95)
tpBtn.Text = "Toggle Auto TP"
tpBtn.MouseButton1Click:Connect(function()
    autoTeleport = not autoTeleport
end)

-- Gõ tên người chơi
local inputBox = Instance.new("TextBox", frame)
inputBox.Size = UDim2.new(1, 0, 0, 30)
inputBox.Position = UDim2.new(0, 0, 0, 130)
inputBox.PlaceholderText = "Tên người chơi..."

-- Nút: Teleport
local goBtn = Instance.new("TextButton", frame)
goBtn.Size = UDim2.new(1, 0, 0, 30)
goBtn.Position = UDim2.new(0, 0, 0, 165)
goBtn.Text = "Teleport đến người chơi"
goBtn.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(inputBox.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        hrp.CFrame = target.Character.HumanoidRootPart.CFrame + target.Character.HumanoidRootPart.CFrame.LookVector * -2
    end
end)

-- Toggle GUI bằng phím
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == guiKey then
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end
end)

-- Fly system
RunService.RenderStepped:Connect(function()
    if flying and char and hrp then
        local moveVec = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += Camera.CFrame.RightVector end
        hrp.Velocity = moveVec.Unit * flySpeed
    end
end)

-- ESP system
RunService.RenderStepped:Connect(function()
    for i, v in pairs(espTable) do
        if v.Label and v.Player and v.Player.Character and v.Player.Character:FindFirstChild("Head") then
            local headPos, onScreen = Camera:WorldToViewportPoint(v.Player.Character.Head.Position)
            v.Label.Visible = onScreen and espEnabled
            v.Label.Position = UDim2.new(0, headPos.X, 0, headPos.Y)
            v.Label.Text = v.Player.Name
        end
    end
end)

-- Tạo ESP cho người chơi khác
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= lp then
        local label = Instance.new("TextLabel", sg)
        label.Size = UDim2.new(0, 100, 0, 20)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 0, 0)
        label.TextStrokeTransparency = 0.5
        label.TextSize = 14
        label.Visible = false
        table.insert(espTable, {Player = plr, Label = label})
    end
end

Players.PlayerAdded:Connect(function(plr)
    local label = Instance.new("TextLabel", sg)
    label.Size = UDim2.new(0, 100, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 0, 0)
    label.TextStrokeTransparency = 0.5
    label.TextSize = 14
    label.Visible = false
    table.insert(espTable, {Player = plr, Label = label})
end)

-- Auto TP system
RunService.RenderStepped:Connect(function()
    if autoTeleport then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Name:lower():find(targetName:lower()) then
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local tHRP = plr.Character.HumanoidRootPart
                    hrp.CFrame = tHRP.CFrame + tHRP.CFrame.LookVector * -0.2
                end
            end
        end
    end
end)
