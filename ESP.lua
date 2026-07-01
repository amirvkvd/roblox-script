-- ============================================
-- 🔥 ULTIMATE ESP v5.0 - MOBILE EDITION
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- ============================================
-- 📦 تنظیمات
-- ============================================
local Settings = {
    Enabled = true,
    BoxColor = Color3.new(1, 0, 0),
    TeamColor = Color3.new(0, 1, 0),
    BoxTransparency = 0.3,
}

-- ============================================
-- 🧠 کش (Cache) برای جلوگیری از قطعی
-- ============================================
local ESPCache = {}
local function GetCachedESP(player)
    if not ESPCache[player] then
        ESPCache[player] = {}
    end
    return ESPCache[player]
end

-- ============================================
-- 🎨 ساخت ESP برای یک بازیکن
-- ============================================
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local cache = GetCachedESP(player)
    if cache.Created then return end
    
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- باکس (Highlight)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Parent = character
    highlight.FillColor = Settings.BoxColor
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = Settings.BoxTransparency
    highlight.Enabled = Settings.Enabled
    cache.Highlight = highlight
    
    -- تگ اطلاعات (Billboard)
    local head = character:WaitForChild("Head")
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Parent = head
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.Enabled = Settings.Enabled
    cache.Billboard = billboard
    
    -- اسم
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Parent = billboard
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    
    -- سلامتی/فاصله
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoLabel"
    infoLabel.Parent = billboard
    infoLabel.Position = UDim2.new(0, 0, 0.4, 0)
    infoLabel.Size = UDim2.new(1, 0, 0.3, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "100 HP"
    infoLabel.TextColor3 = Color3.new(0, 1, 0)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.Gotham
    
    cache.Created = true
    cache.Player = player
end

-- ============================================
-- 🔄 آپدیت اطلاعات (پایدار)
-- ============================================
local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            continue
        end
        
        local cache = GetCachedESP(player)
        
        if not cache.Created then
            CreateESP(player)
            continue
        end
        
        if not player.Character or not player.Character.Parent then
            cache.Created = false
            CreateESP(player)
            continue
        end
        
        local highlight = cache.Highlight
        local billboard = cache.Billboard
        
        if highlight and billboard then
            highlight.Enabled = Settings.Enabled
            billboard.Enabled = Settings.Enabled
            
            if player.Team == LocalPlayer.Team then
                highlight.FillColor = Settings.TeamColor
            else
                highlight.FillColor = Settings.BoxColor
            end
            
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            
            if humanoid and head then
                local health = humanoid.Health
                local maxHealth = humanoid.MaxHealth
                local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") and 
                                  (head.Position - LocalPlayer.Character.Head.Position).Magnitude) or 0
                
                local infoLabel = billboard:FindFirstChild("InfoLabel")
                if infoLabel then
                    infoLabel.Text = math.floor(health) .. "/" .. math.floor(maxHealth) .. " HP  |  " .. math.floor(distance) .. "m"
                    
                    if health / maxHealth > 0.5 then
                        infoLabel.TextColor3 = Color3.new(0, 1, 0)
                    elseif health / maxHealth > 0.2 then
                        infoLabel.TextColor3 = Color3.new(1, 1, 0)
                    else
                        infoLabel.TextColor3 = Color3.new(1, 0, 0)
                    end
                end
            end
        end
    end
end

-- ============================================
-- 🖥️ ساخت صفحه (GUI) - مخصوص گوشی
-- ============================================
local function CreateMenu()
    -- صفحه اصلی
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ESP_Menu"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- فریم اصلی
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- عنوان
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "🔥 ESP CONTROL"
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- دکمه فعال/غیرفعال
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.8, 0, 0, 50)
    toggleBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    toggleBtn.Text = "🟢 ESP: ON"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = mainFrame
    
    toggleBtn.MouseButton1Click:Connect(function()
        Settings.Enabled = not Settings.Enabled
        toggleBtn.Text = Settings.Enabled and "🟢 ESP: ON" or "🔴 ESP: OFF"
        toggleBtn.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    end)
    
    -- دکمه بستن صفحه
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0.6, 0, 0, 50)
    closeBtn.Position = UDim2.new(0.2, 0, 0.65, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    closeBtn.Text = "❌ Close Menu"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = mainFrame
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- اطلاعات
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0, 30)
    info.Position = UDim2.new(0, 0, 0.88, 0)
    info.BackgroundTransparency = 1
    info.Text = "🔹 Tap Close to hide"
    info.TextColor3 = Color3.new(0.5, 0.5, 0.5)
    info.TextScaled = true
    info.Font = Enum.Font.Gotham
    info.Parent = mainFrame
end

-- ============================================
-- 🚀 اجرای اصلی
-- ============================================
-- اجرای اولیه
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- اتصال به رویدادهای جدید
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(0.5)
        CreateESP(player)
    end)
end)

-- آپدیت مداوم (پایدار)
RunService.RenderStepped:Connect(UpdateESP)

-- نمایش صفحه بلافاصله
CreateMenu()

print("✅ ULTIMATE ESP v5.0 LOADED!")
print("📱 Mobile Edition - Ready!")
