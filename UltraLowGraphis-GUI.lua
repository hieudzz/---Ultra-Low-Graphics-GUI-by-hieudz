-- Ultra Low Graphics GUI by HieuDz
-- Bấm phím K để mở/tắt menu

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Hàm tối ưu từng phần
local function removeTextures()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Texture") or v:IsA("Decal") then
            v:Destroy()
        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Color = Color3.fromRGB(163, 162, 165)
        end
    end
end

local function removeParticles()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            v.Enabled = false
        elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Shimmer") or v:IsA("Highlight") then
            v:Destroy()
        end
    end
end

local function optimizeLighting()
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
            v:Destroy()
        end
    end
end

local function optimizeTerrain()
    if Terrain then
        Terrain.WaterTransparency = 1
        Terrain.WaterWaveSize = 0
        Terrain.WaterReflectance = 0
        Terrain.MaterialColors = Enum.MaterialColors.Plain
    end
end

local function stopAnimations()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") then
            for _, anim in ipairs(v:GetPlayingAnimationTracks()) do
                anim:Stop()
            end
        elseif v:IsA("Animation") or v:IsA("AnimationTrack") then
            v:Destroy()
        end
    end
end

local function stopSounds()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Sound") then
            v:Stop()
        end
    end
end

-- Chế độ
local function normalMode()
    removeTextures()
    removeParticles()
    optimizeLighting()
    optimizeTerrain()
end

local function extremeMode()
    normalMode()
    stopAnimations()
    stopSounds()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Color = Color3.fromRGB(0, 0, 0)
        end
    end
end

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = true

local function createButton(text, y, func)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.MouseButton1Click:Connect(func)
end

createButton("Normal Mode", 5, normalMode)
createButton("Extreme Mode", 50, extremeMode)
createButton("Custom (Remove Textures)", 95, removeTextures)

-- Toggle GUI
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.K and not gameProcessed then
        Frame.Visible = not Frame.Visible
    end
end)
