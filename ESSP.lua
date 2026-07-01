-- ============================================
-- 🔥 WALLHACK ESP - مشاهده دشمنان از پشت دیوار
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- ============================================
-- 📦 تنظیمات (همه چیز روشن)
-- ============================================
local Settings = {
    Enabled = true,
    BoxColor = Color3.new(1, 0, 0),      -- قرمز
    TeamColor = Color3.new(0, 1, 0),      -- سبز
    BoxTransparency = 0.3,
    VisibleCheck = false,                 -- ❌ غیرفعال (دیدن از پشت دیوار)
    ShowAll = true,                       -- ✅ نمایش همه
}

-- ============================================
-- 🎨 ساخت ESP
-- ============================================
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    -- باکس (Highlight) - این اصلی‌ترین بخش وال‌هک است
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Parent = player.Character or player.CharacterAdded:Wait()
    highlight.FillColor = Settings.BoxColor
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = Settings.BoxTransparency
    highlight.Enabled = Settings.Enabled
    cache.Highlight = highlight
    
    -- تگ اطلاعات (همیشه بالا)
    local head = character:WaitForChild("Head")
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Parent = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true  -- ✅ همیشه بالای همه چیز
    billboard.Enabled = Settings.Enabled
    cache.Billboard = billboard
    
    -- اسم
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Parent = billboard
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    
    -- اطلاعات (سلامتی/فاصله)
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoLabel"
    infoLabel.Parent = billboard
    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "100 HP"
    infoLabel.TextColor3 = Color3.new(0, 1, 0)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.Gotham
end

-- ============================================
-- 🔄 آپدیت مداوم (بدون تشخیص دیوار)
-- ============================================
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local highlight = player.Character:FindFirstChild("ESP_Highlight")
            local billboard = player.Character.Head:FindFirstChild("ESP_Billboard")
            
            if highlight and billboard then
                -- همیشه روشن (حتی پشت دیوار)
                highlight.Enabled = true
                billboard.Enabled = true
                
                -- رنگ بر اساس تیم
                if player.Team == LocalPlayer.Team then
                    highlight.FillColor = Color3.new(0, 1, 0)  -- سبز
                else
                    highlight.FillColor = Color3.new(1, 0, 0)  -- قرمز
                end
                
                -- به‌روزرسانی اطلاعات
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    local health = humanoid.Health
                    local maxHealth = humanoid.MaxHealth
                    local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") and 
                                      (player.Character.Head.Position - LocalPlayer.Character.Head.Position).Magnitude) or 0
                    
                    local infoLabel = billboard:FindFirstChild("InfoLabel")
                    if infoLabel then
                        infoLabel.Text = math.floor(health) .. "/" .. math.floor(maxHealth) .. " HP  |  " .. math.floor(distance) .. "m"
                    end
                end
            end
        end
    end
end)

-- ============================================
-- 🚀 اجرا برای همه بازیکن‌ها
-- ============================================
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(0.5)
        CreateESP(player)
    end)
end)

print("✅ WALLHACK ESP ACTIVATED!")
print("👀 You can now see enemies through walls!")
