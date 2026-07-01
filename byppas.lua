-- ============================================
-- 🔥 ULTIMATE PURCHASE BYPASS SYSTEM v3.0
-- ============================================
-- 🎯 فقط برای استفاده در سرورهای خصوصی
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ============================================
-- 📦 تنظیمات اصلی
-- ============================================
local Settings = {
    DebugMode = true,        -- نمایش پیام‌های دیباگ
    AutoBypass = false,      -- بای‌پس خودکار هنگام باز شدن پنجره خرید
    AutoCollect = true,      -- جمع‌آوری خودکار آیتم‌ها پس از خرید
    NotifyOnPurchase = true, -- نمایش اعلان پس از خرید موفق
    LogPurchases = true,     -- ذخیره تاریخچه خریدها
}

-- ============================================
-- 🛒 لیست آیتم‌ها (با اطلاعات کامل)
-- ============================================
local ItemDatabase = {
    -- آیتم‌های ویژه
    [1001] = {
        name = "Sword of Power",
        price = 1000,
        type = "Tool",
        rarity = "Legendary",
        stats = {damage = 50, speed = 1.2}
    },
    [1002] = {
        name = "Shield of Defense",
        price = 800,
        type = "Gear",
        rarity = "Epic",
        stats = {defense = 40, health = 50}
    },
    [1003] = {
        name = "Speed Boots",
        price = 500,
        type = "Accessory",
        rarity = "Rare",
        stats = {speed = 30}
    },
    -- آیتم‌های معمولی
    [2001] = {
        name = "Health Potion",
        price = 100,
        type = "Consumable",
        rarity = "Common",
        stats = {heal = 20}
    },
    [2002] = {
        name = "Mana Potion",
        price = 100,
        type = "Consumable",
        rarity = "Common",
        stats = {mana = 20}
    },
    -- آیتم‌های ویژه رویداد
    [3001] = {
        name = "Event Trophy",
        price = 0, -- رایگان
        type = "Collectible",
        rarity = "Event",
        stats = {}
    },
}

-- ============================================
-- 📜 تاریخچه خریدها
-- ============================================
local PurchaseHistory = {}
local PurchaseLog = {
    totalItems = 0,
    totalValue = 0,
    purchases = {}
}

-- ============================================
-- 🔍 پیدا کردن رویدادهای خرید
-- ============================================
local function FindPurchaseEvents()
    local events = {}
    
    -- جستجو در ReplicatedStorage
    for _, child in ipairs(ReplicatedStorage:GetChildren()) do
        if child:IsA("RemoteEvent") and (
            string.lower(child.Name):find("purchase") or
            string.lower(child.Name):find("buy") or
            string.lower(child.Name):find("shop") or
            string.lower(child.Name):find("store")
        ) then
            table.insert(events, child)
            if Settings.DebugMode then
                print("🔍 پیدا شد: " .. child.Name)
            end
        end
    end
    
    -- جستجو در Workspace (اگر فروشگاه در نقشه باشد)
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("RemoteEvent") and (
            string.lower(child.Name):find("purchase") or
            string.lower(child.Name):find("buy")
        ) then
            table.insert(events, child)
            if Settings.DebugMode then
                print("🔍 پیدا شد (Workspace): " .. child.Name)
            end
        end
    end
    
    return events
end

-- ============================================
-- 💰 بای‌پس اصلی خرید
-- ============================================
local function BypassPurchase(itemId, quantity)
    quantity = quantity or 1
    
    if Settings.DebugMode then
        print("🔄 تلاش برای بای‌پس خرید آیتم " .. tostring(itemId) .. " (" .. quantity .. " عدد)")
    end
    
    -- بررسی وجود آیتم در دیتابیس
    local itemData = ItemDatabase[itemId]
    if not itemData then
        warn("❌ آیتم با شناسه " .. tostring(itemId) .. " در دیتابیس وجود ندارد!")
        return false
    end
    
    -- پیدا کردن رویدادهای خرید
    local events = FindPurchaseEvents()
    
    if #events == 0 then
        warn("❌ هیچ رویداد خریدی پیدا نشد!")
        return false
    end
    
    -- ارسال درخواست به همه رویدادهای پیدا شده
    local success = false
    for _, event in ipairs(events) do
        local fireSuccess, err = pcall(function()
            event:FireServer(itemId, quantity)
            success = true
        end)
        
        if not fireSuccess then
            if Settings.DebugMode then
                warn("⚠️ خطا در ارسال به " .. event.Name .. ": " .. tostring(err))
            end
        end
    end
    
    if success then
        -- ثبت خرید
        if Settings.LogPurchases then
            table.insert(PurchaseHistory, {
                itemId = itemId,
                itemName = itemData.name,
                quantity = quantity,
                timestamp = os.time(),
                price = itemData.price * quantity
            })
            
            PurchaseLog.totalItems = PurchaseLog.totalItems + quantity
            PurchaseLog.totalValue = PurchaseLog.totalValue + (itemData.price * quantity)
        end
        
        -- نمایش اعلان
        if Settings.NotifyOnPurchase then
            print("✅ خرید موفق: " .. quantity .. "x " .. itemData.name)
        end
        
        -- جمع‌آوری خودکار آیتم
        if Settings.AutoCollect then
            -- اینجا کد جمع‌آوری آیتم رو اضافه کن
        end
        
        return true
    else
        warn("❌ بای‌پس خرید ناموفق بود!")
        return false
    end
end

-- ============================================
-- 🎮 بای‌پس خرید با شناسه نام
-- ============================================
local function BypassPurchaseByName(itemName, quantity)
    quantity = quantity or 1
    
    for id, data in pairs(ItemDatabase) do
        if string.lower(data.name) == string.lower(itemName) then
            return BypassPurchase(id, quantity)
        end
    end
    
    warn("❌ آیتم با نام '" .. itemName .. "' پیدا نشد!")
    return false
end

-- ============================================
-- 🛒 خرید همه آیتم‌ها
-- ============================================
local function BypassAllItems()
    local count = 0
    for id, data in pairs(ItemDatabase) do
        if data.price > 0 then -- فقط آیتم‌های غیررایگان
            if BypassPurchase(id, 1) then
                count = count + 1
            end
            task.wait(0.1) -- جلوگیری از اسپم
        end
    end
    print("✅ " .. count .. " آیتم خریداری شد!")
    return count
end

-- ============================================
-- 📊 نمایش تاریخچه خرید
-- ============================================
local function ShowPurchaseHistory()
    print("\n📜 تاریخچه خریدها:")
    print("═══════════════════════════════════════")
    print("مجموع آیتم‌ها: " .. PurchaseLog.totalItems)
    print("مجموع ارزش: " .. PurchaseLog.totalValue .. " روباکس")
    print("───────────────────────────────────────")
    
    for i, purchase in ipairs(PurchaseHistory) do
        local date = os.date("%Y-%m-%d %H:%M:%S", purchase.timestamp)
        print(i .. ". " .. purchase.quantity .. "x " .. purchase.itemName .. " (" .. date .. ")")
    end
    print("═══════════════════════════════════════\n")
end

-- ============================================
-- 🖥️ ساخت منوی GUI ساده
-- ============================================
local function CreateGUI()
    -- اگر بازیکن GUI ندارد، یک ScreenGui بساز
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PurchaseBypassGUI"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- فریم اصلی
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- تیتر
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "🔥 Purchase Bypass v3.0"
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- اسکرول‌کننده لیست آیتم‌ها
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -20, 1, -120)
    scrollingFrame.Position = UDim2.new(0, 10, 0, 50)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #ItemDatabase * 40)
    scrollingFrame.ScrollBarThickness = 8
    scrollingFrame.Parent = mainFrame
    
    -- ایجاد دکمه برای هر آیتم
    local yPos = 0
    for id, data in pairs(ItemDatabase) do
        local itemButton = Instance.new("TextButton")
        itemButton.Size = UDim2.new(1, 0, 0, 30)
        itemButton.Position = UDim2.new(0, 0, 0, yPos)
        itemButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        itemButton.Text = data.name .. " (" .. data.price .. "R$)"
        itemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemButton.TextScaled = true
        itemButton.Font = Enum.Font.Gotham
        itemButton.Parent = scrollingFrame
        
        -- رویداد کلیک
        itemButton.MouseButton1Click:Connect(function()
            BypassPurchase(id, 1)
        end)
        
        yPos = yPos + 35
    end
    
    -- دکمه خرید همه
    local buyAllButton = Instance.new("TextButton")
    buyAllButton.Size = UDim2.new(0.4, -5, 0, 30)
    buyAllButton.Position = UDim2.new(0.05, 0, 1, -35)
    buyAllButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    buyAllButton.Text = "🔥 خرید همه"
    buyAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyAllButton.TextScaled = true
    buyAllButton.Font = Enum.Font.GothamBold
    buyAllButton.Parent = mainFrame
    
    buyAllButton.MouseButton1Click:Connect(BypassAllItems)
    
    -- دکمه تاریخچه
    local historyButton = Instance.new("TextButton")
    historyButton.Size = UDim2.new(0.4, -5, 0, 30)
    historyButton.Position = UDim2.new(0.55, 0, 1, -35)
    historyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    historyButton.Text = "📜 تاریخچه"
    historyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    historyButton.TextScaled = true
    historyButton.Font = Enum.Font.GothamBold
    historyButton.Parent = mainFrame
    
    historyButton.MouseButton1Click:Connect(ShowPurchaseHistory)
    
    print("✅ GUI ساخته شد!")
end

-- ============================================
-- ⌨️ کنترل‌های صفحه کلید
-- ============================================
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        BypassPurchase(1001, 1) -- خرید آیتم ویژه
    elseif input.KeyCode == Enum.KeyCode.F2 then
        BypassAllItems() -- خرید همه
    elseif input.KeyCode == Enum.KeyCode.F3 then
        ShowPurchaseHistory() -- نمایش تاریخچه
    elseif input.KeyCode == Enum.KeyCode.F4 then
        if LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("PurchaseBypassGUI") then
            LocalPlayer.PlayerGui.PurchaseBypassGUI:Destroy()
        else
            CreateGUI()
        end
    end
end)

-- ============================================
-- 🚀 Auto-Bypass (اختیاری)
-- ============================================
if Settings.AutoBypass then
    -- این تابع هر ۵ ثانیه یکبار بررسی می‌کند که آیا پنجره خرید باز شده است
    task.spawn(function()
        while true do
            task.wait(5)
            -- اینجا می‌تونی کد تشخیص پنجره خرید رو اضافه کنی
            if Settings.DebugMode then
                print("🔍 Auto-Bypass در حال اجرا...")
            end
        end
    end)
end

-- ============================================
-- 📦 اجرای اولیه
-- ============================================
print("═══════════════════════════════════════")
print("🔥 ULTIMATE PURCHASE BYPASS v3.0")
print("📦 بارگذاری شد!")
print("───────────────────────────────────────")
print("📋 " .. #ItemDatabase .. " آیتم در دیتابیس")
print("🔄 " .. #FindPurchaseEvents() .. " رویداد خرید پیدا شد")
print("───────────────────────────────────────")
print("⌨️ کلیدها:")
print("  F1 - خرید آیتم ویژه")
print("  F2 - خرید همه آیتم‌ها")
print("  F3 - نمایش تاریخچه")
print("  F4 - نمایش/مخفی کردن GUI")
print("═══════════════════════════════════════")

-- ساخت GUI
CreateGUI()

-- ============================================
-- 🎉 پایان اسکریپت
-- ============================================
print("✅ اسکریپت با موفقیت اجرا شد!")
