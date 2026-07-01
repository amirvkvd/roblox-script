-- ============================================
-- 🔥 SUPER ESP v3.0 - MOBILE EDITION
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- ============================================
-- 📦 تنظیمات ESP
-- ============================================
local Settings = {
    BoxESP = true,          -- باکس دور بازیکن
    LineESP = true,         -- خط از پایین بازیکن به پایین صفحه
    NameESP = true,         -- نمایش اسم
    HealthESP = true,       -- نمایش نوار سلامتی
    DistanceESP = true,     -- نمایش فاصله
    TeamCheck = true,       -- تشخیص هم‌تیمی
    VisibleCheck = true,    -- تشخیص دید (پشت دیوار)
    BoxColor = Color3.new(1, 0, 0),  -- قرمز برای دشمن
    TeamColor = Color3.new(0, 1, 0), -- سبز برای هم‌تیمی
}

-- ============================================
-- 🎨 توابع رسم (با GUI)
-- ============================================
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    -- باکس دور بازیکن
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Parent = player.Character or player.CharacterAdded:Wait()
    highlight.FillColor = Settings.BoxColor
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.3
    
    -- خط از پایین بازیکن
    local line = Instance.new("Part")
    line.Name = "ESP_Line"
    line.Parent = player.Character
    line.Size = Vector3.new(0.1, 50, 0.1)
    line.Anchored = true
    line.CanCollide = false
    line.Material = Enum.Material.Neon
    line.BrickColor = BrickColor.Red()
    
    -- تگ اسم و اطلاعات
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Parent = player.Character:WaitForChild("Head")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = player.Character.Head
    billboard.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Parent = billboard
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Parent = billboard
    healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100 HP"
    healthLabel.TextColor3 = Color3.new(0, 1, 0)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.Gotham
end

-- ============================================
-- 🚀 اجرای ESP برای همه بازیکن‌ها
-- ============================================
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        CreateESP(player)
    end)
end)

-- ============================================
-- 🔄 آپدیت خودکار (رنگ‌ها و فاصله)
-- ============================================
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local highlight = player.Character:FindFirstChild("ESP_Highlight")
            local billboard = player.Character.Head:FindFirstChild("ESP_Billboard")
            local line = player.Character:FindFirstChild("ESP_Line")
            
            if highlight and billboard and line then
                -- محاسبه فاصله
                local distance = (LocalPlayer.Character.Head.Position - player.Character.Head.Position).Magnitude
                
                -- آپدیت رنگ بر اساس هم‌تیمی
                if Settings.TeamCheck and player.Team == LocalPlayer.Team then
                    highlight.FillColor = Settings.TeamColor
                else
                    highlight.FillColor = Settings.BoxColor
                end
                
                -- آپدیت فاصله
                if Settings.DistanceESP then
                    local healthLabel = billboard:FindFirstChild("HealthLabel")
                    if healthLabel then
                        healthLabel.Text = math.floor(distance) .. "m"
                    end
                end
                
                -- آپدیت سلامتی
                if Settings.HealthESP and player.Character:FindFirstChild("Humanoid") then
                    local healthLabel = billboard:FindFirstChild("HealthLabel")
                    if healthLabel then
                        local health = player.Character.Humanoid.Health
                        local maxHealth = player.Character.Humanoid.MaxHealth
                        healthLabel.Text = math.floor(health) .. "/" .. math.floor(maxHealth) .. " HP"
                        
                        -- تغییر رنگ سلامتی
                        if health / maxHealth > 0.5 then
                            healthLabel.TextColor3 = Color3.new(0, 1, 0)
                        elseif health / maxHealth > 0.2 then
                            healthLabel.TextColor3 = Color3.new(1, 1, 0)
                        else
                            healthLabel.TextColor3 = Color3.new(1, 0, 0)
                        end
                    end
                end
                
                -- آپدیت خط
                local rootPos = player.Character.HumanoidRootPart.Position
                line.Position = Vector3.new(rootPos.X, rootPos.Y - 25, rootPos.Z)
            end
        end
    end
end)

print("✅ ESP Activated!")
