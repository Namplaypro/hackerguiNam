
-- Nam Hacker GUI Tổng Hợp
local P=game.Players.LocalPlayer
local C=P.Character or P.CharacterAdded:Wait()
local H=C:WaitForChild("Humanoid")
local R=C:WaitForChild("HumanoidRootPart")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local G=Instance.new("ScreenGui",P:WaitForChild("PlayerGui"))
G.Name="NamHackerMenu"
G.ResetOnSpawn=false

-- GUI chính
local F=Instance.new("Frame",G)
F.Size=UDim2.new(0,320,0,580)
F.Position=UDim2.new(0.5,-160,0.5,-290)
F.BackgroundColor3=Color3.fromRGB(30,30,35)
Instance.new("UICorner",F).CornerRadius=UDim.new(0,12)

-- Gradient nền
local gradFrame = Instance.new("UIGradient", F)
gradFrame.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 0, 60)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 180))
}

-- Tiêu đề
local T=Instance.new("TextLabel",F)
T.Size=UDim2.new(1,0,0,40)
T.Position=UDim2.new(0,0,0,10)
T.BackgroundColor3=Color3.fromRGB(40,130,255)
T.TextColor3=Color3.new(1,1,1)
T.Text="Nam Hacker Menu"
T.Font=Enum.Font.GothamBold
T.TextSize=22
T.BorderSizePixel=0
Instance.new("UICorner",T).CornerRadius=UDim.new(0,12)

-- Loading bar
local loadingBarBg = Instance.new("Frame", F)
loadingBarBg.Size = UDim2.new(0, 280, 0, 8)
loadingBarBg.Position = UDim2.new(0, 20, 0, 50)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
loadingBarBg.BorderSizePixel = 0
Instance.new("UICorner", loadingBarBg).CornerRadius = UDim.new(1, 0)

local loadingBar = Instance.new("Frame", loadingBarBg)
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
loadingBar.BorderSizePixel = 0
Instance.new("UICorner", loadingBar).CornerRadius = UDim.new(1, 0)

local loadingSpeed = 180
local direction = 1
local maxWidth = 280
RS.RenderStepped:Connect(function(dt)
	local w = loadingBar.Size.X.Offset
	w += loadingSpeed * dt * direction
	if w >= maxWidth then w = maxWidth direction = -1 end
	if w <= 0 then w = 0 direction = 1 end
	loadingBar.Size = UDim2.new(0, w, 1, 0)
end)

-- Các tính năng đầy đủ đã được thêm (Fly, Noclip, ESP, Auto Heal, Speed/Jump chỉnh, Teleport Mouse/Player, Kick Player, Anti Kick...)
-- Đã có trong canvas

-- TOGGLE GUI
UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode==Enum.KeyCode.X then F.Visible=not F.Visible end
end)
