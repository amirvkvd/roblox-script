-- ESP Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function CreateESP(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(character)
        wait(1)
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.3
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    CreateESP(player)
end

Players.PlayerAdded:Connect(CreateESP)
print("✅ ESP Loaded!")
