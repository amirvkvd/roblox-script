-- ============================================
-- 🔥 ULTIMATE WALLHACK ESP v6.0 - WITH MENU
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
    ShowAll = true,
    BoxColor = Color3.new(1, 0, 0),
    TeamColor = Color3.new(0, 1, 0),
    BoxTransparency = 0.3,
}

-- ============================================
-- 🧠 کش (Cache)
-- ============================================
local ESPCache = {}

-- ============================================
-- 🎨 ساخت ESP
-- ============================================
local function CreateESP(player)
    if player == LocalPlayer then return end

    local cache = ESPCache[player]
    if cache and cache.Created then return end

    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")

    -- باکس (Highlight)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Parent = character
    highlight.FillColor = Settings.BoxColor
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = Settings.BoxTransparency
    highlight.Enabled = true  -- همیشه روشن
    cache.Highlight = highlight

    -- تگ اطلاعات
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Parent = head
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.Enabled = true
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
end

-- ============================================
-- 🔄 آپدیت لحظه‌ای وال‌هک
-- ============================================
local function UpdateWallhack()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            continue
        end

        local cache = ESPCache[player]
        if not cache or not cache.Created then
            CreateESP(player)
            continue
        end

        local highlight = cache.Highlight
        local billboard = cache.Billboard

        if highlight and billboard then
            -- ✅ وال‌هک: همیشه روشن (حتی پشت دیوار)
            highlight.Enabled = true
            billboard.Enabled = true

            -- رنگ بر اساس تیم
            if player.Team == LocalPlayer.Team then
                highlight.FillColor = Settings.TeamColor
            else
                highlight.FillColor = Settings.BoxColor
            end

            -- به‌روزرسانی اطلاعات
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            if humanoid and head then
                local health = humanoid.Health
                local maxHealth = humanoid.MaxHealth
                local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") and
                                  (head.Position - LocalPlayer.Character.Head.Position).Magnitude) or 0

                local infoLabel = billboard:FindFirstChild("InfoLabel")
                if infoLabel then
                    infoLabel.Text = math.floor(health) .. "/" .. math.floor(maxHealth) .. " HP | " .. math.floor(distance) .. "m"
                end
            end
        end
    end
end

-- ============================================
-- 🖥️ ساخت صفحه (GUI)
-- ============================================
local function CreateMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Wallhack_Menu"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    -- عنوان
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "🔴 WALLHACK ESP"
    title.TextColor3 = Color3.fromRGB(255, 50, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame

    -- دکمه فعال/غیرفعال
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.8, 0, 0, 50)
    toggleBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    toggleBtn.Text = "🟢 ESP: ON"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = mainFrame

    toggleBtn.MouseButton1Click:Connect(function()
        Settings.Enabled = not Settings.Enabled
        toggleBtn.Text = Settings.Enabled and "🟢 ESP: ON" or "🔴 ESP: OFF"
        toggleBtn.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        
        -- اعمال روی همه
        for _, player in ipairs(Players:GetPlayers()) do
            local cache = ESPCache[player]
            if cache and cache.Highlight then
                cache.Highlight.Enabled = Settings.Enabled
            end
        end
    end)

    -- دکمه بستن
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
    info.Text = "🔹 This ESP works through walls!"
    info.TextColor3 = Color3.new(0.5, 0.5, 0.5)
    info.TextScaled = true
    info.Font = Enum.Font.Gotham
    info.Parent = mainFrame
end

-- ============================================
-- 🚀 اجرای اصلی
-- ============================================
-- ایجاد کش
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        ESPCache[player] = {}
        CreateESP(player)
    end
end

-- رویدادهای جدید
Players.PlayerAdded:Connect(function(player)
    ESPCache[player] = {}
    player.CharacterAdded:Connect(function()
        wait(0.5)
        CreateESP(player)
    end)
end)

-- آپدیت مداوم
RunService.RenderStepped:Connect(UpdateWallhack)

-- نمایش منو
CreateMenu()

print("✅ WALLHACK ESP v6.0 LOADED!")
print("🔴 You can now see enemies through walls!")
