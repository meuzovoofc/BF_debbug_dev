--[[ 
    📦 Blox Fruits - Dev Debug Tool
    🔧 Autor: Bruno Ferreira (Dev Team)
    🎯 Objetivo: Ferramenta simples de debug para testes de frutas, XP, dinheiro e teleporte
]]

-- // CONFIGURAÇÕES
local ENABLED = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- // Checa permissão
for _, id in ipairs(DEV_USER_IDS) do
	if player.UserId == id then
		ENABLED = true
		break
	end
end

if not ENABLED then
	warn("Debug Tool desativado para este usuário.")
	return
end

print("✅ Debug Tool ativada para", player.Name)


-- // FUNÇÕES DE DEBUG -------------------------------------------------
local function giveMoney(amount)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats and leaderstats:FindFirstChild("Money") then
		leaderstats.Money.Value += amount
		print("[DEBUG] +", amount, "Beli")
	end
end

local function setXP(amount)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats and leaderstats:FindFirstChild("XP") then
		leaderstats.XP.Value = amount
		print("[DEBUG] XP setado para:", amount)
	end
end

local function giveFruit(fruitName)
	local fruitFolder = ReplicatedStorage:FindFirstChild("Fruits")
	if fruitFolder and fruitFolder:FindFirstChild(fruitName) then
		local fruit = fruitFolder[fruitName]:Clone()
		fruit.Parent = player.Backpack
		print("[DEBUG] Fruta adicionada:", fruitName)
	else
		warn("[DEBUG] Fruta não encontrada:", fruitName)
	end
end

local function teleportTo(pos)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
		print("[DEBUG] Teleportado para:", pos)
	end
end

local function toggleInvincible()
	local char = player.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.NameDisplayDistance = 0
		char.Humanoid.MaxHealth = math.huge
		char.Humanoid.Health = math.huge
		print("[DEBUG] Invencibilidade ativada")
	end
end


-- // GUI DE DEBUG ----------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DebugGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Size = UDim2.new(0, 250, 0, 320)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = Frame
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 18
	btn.Text = text
	btn.BorderSizePixel = 0
	btn.MouseButton1Click:Connect(callback)
	return btn
end


-- // BOTÕES DE DEBUG -------------------------------------------------
createButton("💰 +1.000.000 Beli", function()
	giveMoney(1000000)
end)

createButton("⭐ Setar XP = 99999", function()
	setXP(99999)
end)

createButton("🍎 Dar Fruta: Flame", function()
	giveFruit("Flame")
end)

createButton("⚡ Invencibilidade", function()
	toggleInvincible()
end)

createButton("🌴 Teleportar (Marine Start)", function()
	teleportTo(Vector3.new(-2600, 80, 2000))
end)

createButton("🏝️ Teleportar (Jungle)", function()
	teleportTo(Vector3.new(-1420, 100, 300))
end)

createButton("❌ Fechar Painel", function()
	ScreenGui.Enabled = false
end)


-- // TECLA DE ATALHO -------------------------------------------------
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.F2 then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)

print("💻 Debug GUI carregada! Pressione [F2] para mostrar/ocultar.")
