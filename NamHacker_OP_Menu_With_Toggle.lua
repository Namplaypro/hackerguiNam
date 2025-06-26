-- 👑 by:NamHacker op
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NamHackerGUI"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 2
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "👑 by:NamHacker op"
title.TextColor3 = Color3.new(1,1,0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextScaled = true

function createButton(text, order, callback)
	local btn = Instance.new("TextButton", mainFrame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, 35 + (order * 35))
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextScaled = true
	btn.MouseButton1Click:Connect(callback)
end

-- Fly Setup
local flying = false
local flySpeed = 3

function toggleFly()
	flying = not flying
	if flying then
		local char = LocalPlayer.Character
		local root = char:FindFirstChild("HumanoidRootPart")
		local bv = Instance.new("BodyVelocity", root)
		bv.Name = "FlyVelocity"
		bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		bv.Velocity = Vector3.zero

		RunService:BindToRenderStep("NamFly", Enum.RenderPriority.Camera.Value, function()
			if not flying or not root or not root.Parent then return end
			local camCF = Camera.CFrame
			bv.Velocity = camCF.LookVector * flySpeed
		end)
	else
		RunService:UnbindFromRenderStep("NamFly")
		local vel = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("FlyVelocity")
		if vel then vel:Destroy() end
	end
end

-- Teleport
function teleportBehind()
	local targetName = tostring(game:GetService("StarterGui"):PromptTextInput("Nhập tên người cần tele"))
	local target = Players:FindFirstChild(targetName)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local theirPos = target.Character.HumanoidRootPart.CFrame
		LocalPlayer.Character.HumanoidRootPart.CFrame = theirPos * CFrame.new(0, 0, 0.10)
	end
end

-- Noclip
local noclip = false
function toggleNoclip()
	noclip = not noclip
	RunService.Stepped:Connect(function()
		if noclip and LocalPlayer.Character then
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") and v.CanCollide == true then
					v.CanCollide = false
				end
			end
		end
	end)
end

-- ESP
local espEnabled = false
local espList = {}

function toggleESP()
	espEnabled = not espEnabled
	if espEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
				local billboard = Instance.new("BillboardGui", plr.Character.Head)
				billboard.Name = "NamESP"
				billboard.Size = UDim2.new(0, 100, 0, 30)
				billboard.StudsOffset = Vector3.new(0, 2, 0)
				billboard.AlwaysOnTop = true

				local label = Instance.new("TextLabel", billboard)
				label.Size = UDim2.new(1, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.Text = plr.Name
				label.TextColor3 = Color3.new(1, 0, 0)
				label.TextScaled = true
				table.insert(espList, billboard)
			end
		end
	else
		for _, esp in pairs(espList) do
			if esp and esp.Parent then esp:Destroy() end
		end
		espList = {}
	end
end

-- Anti-Kick & Anti-Ban
local mt = getrawmetatable(game)
setreadonly(mt, false)
local namecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = {...}

	if method == "Kick" then
		warn("⚠️ Blocked Kick attempt.")
		return nil
	end

	if method == "FireServer" and tostring(self):lower():find("ban") then
		warn("⚠️ Blocked Ban attempt.")
		return nil
	end

	return namecall(self, ...)
end)

-- Toggle GUI visibility
local menuOpen = true
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.M then
		menuOpen = not menuOpen
		mainFrame.Visible = menuOpen
	end
end)

-- Toggle menu button
createButton("🔁 Toggle Menu", -1, function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Create buttons
createButton("🔼 Toggle Fly", 0, toggleFly)
createButton("📡 Teleport Behind", 1, teleportBehind)
createButton("🚪 Toggle NoClip", 2, toggleNoclip)
createButton("👁️ Toggle ESP", 3, toggleESP)
createButton("❌ Close Menu (press M to toggle)", 4, function()
	mainFrame.Visible = false
end)
