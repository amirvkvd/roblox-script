-- ============================================
-- 🚀 FLY HACK V3 - با UI و ضد بن
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- 📦 تنظیمات ضد بن
-- ============================================
local AntiBan = {
    Enabled = true,
    CheckInterval = 5, -- هر چند ثانیه یکبار چک کنه
    MaxSpeed = 50,     -- حداکثر سرعت (برای جلوگیری از تشخیص)
}

-- ============================================
-- 🧠 متغیرهای پرواز
-- ============================================
local flying = false
local flySpeed = 50
local flyDirection = Vector3.new(0, 0, 0)
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ============================================
-- 🔒 Anti-Ban: جلوگیری از تشخیص
-- ============================================
local function AntiBanCheck()
    if not AntiBan.Enabled then return end
    
    -- اگر سرعت زیاد شد، کمش کن
    if humanoid.WalkSpeed > AntiBan.MaxSpeed then
        humanoid.WalkSpeed = AntiBan.MaxSpeed
    end
    
    -- هر چند ثانیه یکبار چک کن
    task.wait(AntiBan.CheckInterval)
    AntiBanCheck()
end

-- شروع چک‌های ضد بن
task.spawn(AntiBanCheck)

-- ============================================
-- 🚀 تابع پرواز
-- ============================================
local function StartFly()
    if flying then return end
    
    flying = true
    humanoid.PlatformStand = true
    
    -- جلوگیری از تشخیص توسط سیستم
    humanoid.AutoRotate = false
    
    print("✅ Fly mode activated!")
end

local function StopFly()
    if not flying then return end
    
    flying = false
    humanoid.PlatformStand = false
    humanoid.AutoRotate = true
    
    -- ریست کردن سرعت عمودی
    rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 0, rootPart.Velocity.Z)
    
    print("❌ Fly mode deactivated!")
end

-- ============================================
-- 🎮 کنترل پرواز
-- ============================================
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        if flying then
            StopFly()
        else
            StartFly()
        end
    end
end)

-- ============================================
-- 🔄 حرکت در حین پرواز
-- ============================================
RunService.Heartbeat:Connect(function()
    if not flying then return end
    
    if not character or not character.Parent then
        flying = false
        return
    end
    
    -- گرفتن جهت حرکت
    local moveDirection = Vector3.new(0, 0, 0)
    
    -- WASD + Space + Shift
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + (character.HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1))
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - (character.HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1))
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - (character.HumanoidRootPart.CFrame.RightVector * Vector3.new(1, 0, 1))
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + (character.HumanoidRootPart.CFrame.RightVector * Vector3.new(1, 0, 1))
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveDirection = moveDirection - Vector3.new(0, 1, 0)
    end
    
    -- نرمال‌سازی و اعمال سرعت
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * flySpeed
        rootPart.Velocity = moveDirection
    else
        rootPart.Velocity = Vector3.new(0, 0, 0)
    end
end)

-- ============================================
-- 🖥️ ساخت UI
-- ============================================
local function CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlyHackUI"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    
    -- فریم اصلی
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 200, 0, 150)
    mainFrame.Position = UDim2.new(0.8, -10, 0.5, -75)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- عنوان
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "🚀 Fly Hack"
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- وضعیت پرواز
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 30)
    statusLabel.Position = UDim2.new(0, 0, 0.25, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "❌ OFF"
    statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame
    
    -- دکمه فعال/غیرفعال
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
    toggleBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    toggleBtn.Text = "🟢 ON"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = mainFrame
    
    toggleBtn.MouseButton1Click:Connect(function()
        if flying then
            StopFly()
            statusLabel.Text = "❌ OFF"
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            toggleBtn.Text = "🟢 ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            StartFly()
            statusLabel.Text = "✅ ON"
            statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
            toggleBtn.Text = "🔴 OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        end
    end)
    
    -- کلید میانبر
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(1, 0, 0, 25)
    keyLabel.Position = UDim2.new(0, 0, 0.85, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "Press F to toggle"
    keyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    keyLabel.TextScaled = true
    keyLabel.Font = Enum.Font.Gotham
    keyLabel.Parent = mainFrame
end

-- اجرای UI
CreateUI()

-- ============================================
-- 📋 اطلاعات اولیه
-- ============================================
print("========================================")
print("🚀 FLY HACK V3 - LOADED!")
print("========================================")
print("📌 Controls:")
print("  F       - Toggle Fly")
print("  WASD    - Move")
print("  Space   - Go Up")
print("  Shift   - Go Down")
print("========================================")
print("✅ Fly with UI loaded successfully!")
