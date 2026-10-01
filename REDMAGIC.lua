local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = PlayersService.LocalPlayer
local Camera = Workspace.CurrentCamera

local SFX_CLICK_ID = 9116158538
local _sfxHost = Instance.new("ScreenGui")
_sfxHost.Name = "RedmagicSfxHost"
_sfxHost.ResetOnSpawn = false
pcall(function() _sfxHost.Parent = game.CoreGui end)
if not _sfxHost.Parent then pcall(function() _sfxHost.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end
local ClickSfx = Instance.new("Sound")
ClickSfx.SoundId = "rbxassetid://" .. SFX_CLICK_ID
ClickSfx.Volume = 0.7
ClickSfx.Parent = _sfxHost
local function PlayClickSfx()
    pcall(function()
        local c = ClickSfx:Clone()
        c.Parent = _sfxHost
        c:Play()
        task.delay(2, function() if c then c:Destroy() end end)
    end)
end

local loadGui = Instance.new("ScreenGui")
loadGui.Name = "RedmagicLoading"
loadGui.ResetOnSpawn = false
loadGui.IgnoreGuiInset = true
loadGui.DisplayOrder = 999
pcall(function() loadGui.Parent = game.CoreGui end)
if not loadGui.Parent then pcall(function() loadGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end
local loadBg = Instance.new("Frame")
loadBg.Size = UDim2.new(1, 0, 1, 0)
loadBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadBg.BackgroundTransparency = 0.35
loadBg.BorderSizePixel = 0
loadBg.Parent = loadGui
local loadBox = Instance.new("Frame")
loadBox.Size = UDim2.new(0, 320, 0, 140)
loadBox.Position = UDim2.new(0.5, -160, 0.5, -90)
loadBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
loadBox.BackgroundTransparency = 0.1
loadBox.BorderSizePixel = 0
loadBox.Parent = loadGui
local lbc = Instance.new("UICorner"); lbc.CornerRadius = UDim.new(0, 10); lbc.Parent = loadBox
local lbs = Instance.new("UIStroke"); lbs.Color = Color3.fromRGB(200, 0, 0); lbs.Thickness = 1.5; lbs.Transparency = 0.3; lbs.Parent = loadBox
local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0, 50)
loadTitle.Position = UDim2.new(0, 0, 0, 8)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "REDMAGIC"
loadTitle.TextColor3 = Color3.fromRGB(255, 30, 30)
loadTitle.TextSize = 28
loadTitle.Font = Enum.Font.GothamBold
loadTitle.Parent = loadBox
local loadSub = Instance.new("TextLabel")
loadSub.Size = UDim2.new(1, 0, 0, 22)
loadSub.Position = UDim2.new(0, 0, 0, 58)
loadSub.BackgroundTransparency = 1
loadSub.Text = "загрузка..."
loadSub.TextColor3 = Color3.fromRGB(255, 60, 60)
loadSub.TextSize = 14
loadSub.Font = Enum.Font.GothamMedium
loadSub.Parent = loadBox
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 260, 0, 10)
barBg.Position = UDim2.new(0.5, -130, 0, 95)
barBg.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
barBg.BorderSizePixel = 0
barBg.Parent = loadBox
local bbc = Instance.new("UICorner"); bbc.CornerRadius = UDim.new(1, 0); bbc.Parent = barBg
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
local bfc = Instance.new("UICorner"); bfc.CornerRadius = UDim.new(1, 0); bfc.Parent = barFill
local loadSound = Instance.new("Sound")
loadSound.SoundId = "rbxassetid://338224404"
loadSound.Volume = 3
loadSound.Looped = false
loadSound.Parent = loadGui
pcall(function() loadSound:Play() end)
local LOAD_TIME = 13
local loadStartTime = tick()
local loadDone = false
task.spawn(function()
    while not loadDone do
        RunService.Heartbeat:Wait()
        local pct = math.clamp((tick() - loadStartTime) / LOAD_TIME, 0, 1)
        barFill.Size = UDim2.new(pct, 0, 1, 0)
        if pct >= 1 then
            loadDone = true
            pcall(function() loadSound:Stop(); loadSound:Destroy() end)
            pcall(function() loadGui:Destroy() end)
        end
    end
end)
while not loadDone do RunService.Heartbeat:Wait() end

local EspHighlights = {}
local GunHighlights = {}
local EspEnabled = false
local GunEspEnabled = false
local InfJumpEnabled = false
local NoClipEnabled = false
local SilentEnabled = false
local SilentAutoKiller = false
local SilentAutoSheriff = false
local SilentAutoShot = false
local SpeedGlitchEnabled = false
local SpinEnabled = false
local WalkSpeedEnabled = false
local AutoGunPickupEnabled = false
local AutoFarmEnabled = false
local AntiFlingEnabled = false
local KillAllEnabled = false

local spinSpeed = 1
local walkSpeedValue = 16
local bhopMaxSpeed = 80
local bhopGain = 3
local baseWalkSpeed = 16
local AutoGunCooldown = 0
local coins = {}
local lastMoveDir = Vector3.new(0, 0, -1)

local visualState = {
    skyStar = false, skyDark = false, fog = false, beauty = false,
    rain = false, aura = false, tornado = false, tornadoEsp = false,
    lightning = false,
    auraModel = nil, tornadoModel = nil, tornadoEspHL = nil,
    tornadoSound = nil, rainSound = nil, tornadoSpin = 0,
    tornadoLightningConn = nil, tornadoMainConn = nil,
    fogBackup = nil, beautyBackup = nil, skyCurrent = nil,
}

local SKY_DARK_ID = 106377173007538
local SKY_STARRY_ID = 911025794
local RAIN_AUDIO_ID = 1516791621
local AURA_ID = 14676802199
local TORNADO_ID = 3559320372
local TORNADO_SOUND_ID = 88290426489497
local AWP_ID = 148332398
local ICON_ID = 12563966758

local awpOn = false
local awpModel = nil
local FlingOldPos = nil
local FlingFPDH = Workspace.FallenPartsDestroyHeight

local COLOR_NAMES = {"Rainbow","Red","Black","Blue","Green","Yellow","White","Purple"}
local COLOR_LABELS = {
    Rainbow = "Rainbow", Red = "Red", Black = "Black", Blue = "Blue",
    Green = "Green", Yellow = "Yellow", White = "White", Purple = "Purple",
}
local COLOR_VALUES = {
    Rainbow = nil,
    Red = Color3.fromRGB(255, 0, 0),
    Black = Color3.fromRGB(20, 20, 20),
    Blue = Color3.fromRGB(0, 100, 255),
    Green = Color3.fromRGB(0, 255, 0),
    Yellow = Color3.fromRGB(255, 220, 0),
    White = Color3.fromRGB(255, 255, 255),
    Purple = Color3.fromRGB(180, 0, 255),
}

local samuraiOn = false
local samuraiColor = "Rainbow"
local samuraiHat = nil
local samuraiRainbowConn = nil

local outlineOn = false
local outlineColor = "Purple"
local outlineHighlight = nil

local function GetRole(player)
    if not player then return "Innocent" end
    local status = player:FindFirstChild("Status")
    if status then
        local roleObj = status:FindFirstChild("Role")
        if roleObj and roleObj.Value then
            local v = tostring(roleObj.Value)
            if v == "Murderer" then return "Murder" end
            if v == "Sheriff" or v == "Hero" then return "Sheriff" end
        end
    end
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local r = ls:FindFirstChild("Role")
        if r and r.Value then
            local v = tostring(r.Value)
            if v == "Murderer" then return "Murder" end
            if v == "Sheriff" or v == "Hero" then return "Sheriff" end
        end
    end
    local char = player.Character
    local bp = player:FindFirstChild("Backpack")
    local function hasKnife(c)
        if not c then return false end
        return c:FindFirstChild("Knife") or c:FindFirstChild("KnifeVisuals") or
            (c:FindFirstChild("LeftHand") and (c.LeftHand:FindFirstChild("Knife") or c.LeftHand:FindFirstChild("KnifeVisuals"))) or
            (c:FindFirstChild("RightHand") and (c.RightHand:FindFirstChild("Knife") or c.RightHand:FindFirstChild("KnifeVisuals"))) or
            (c:FindFirstChild("Left Arm") and (c["Left Arm"]:FindFirstChild("Knife") or c["Left Arm"]:FindFirstChild("KnifeVisuals"))) or
            (c:FindFirstChild("Right Arm") and (c["Right Arm"]:FindFirstChild("Knife") or c["Right Arm"]:FindFirstChild("KnifeVisuals")))
    end
    local function hasGun(c)
        if not c then return false end
        return c:FindFirstChild("Gun") or c:FindFirstChild("GunVisuals") or
            (c:FindFirstChild("LeftHand") and (c.LeftHand:FindFirstChild("Gun") or c.LeftHand:FindFirstChild("GunVisuals"))) or
            (c:FindFirstChild("RightHand") and (c.RightHand:FindFirstChild("Gun") or c.RightHand:FindFirstChild("GunVisuals"))) or
            (c:FindFirstChild("Left Arm") and (c["Left Arm"]:FindFirstChild("Gun") or c["Left Arm"]:FindFirstChild("GunVisuals"))) or
            (c:FindFirstChild("Right Arm") and (c["Right Arm"]:FindFirstChild("Gun") or c["Right Arm"]:FindFirstChild("GunVisuals")))
    end
    if hasKnife(bp) or hasKnife(char) then return "Murder" end
    if hasGun(bp) or hasGun(char) then return "Sheriff" end
    local wp = Workspace:FindFirstChild(player.Name)
    if wp then
        if hasKnife(wp) then return "Murder" end
        if hasGun(wp) then return "Sheriff" end
    end
    return "Innocent"
end

local function removeSkyV()
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") then pcall(function() obj:Destroy() end) end
    end
    visualState.skyCurrent = nil
end

local function loadSkyV(assetId)
    removeSkyV()
    local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. assetId) end)
    if not ok or not objs then return end
    local foundSky = nil
    local function findSky(obj)
        if foundSky then return end
        if obj:IsA("Sky") then foundSky = obj return end
        for _, child in ipairs(obj:GetChildren()) do findSky(child) end
    end
    for _, obj in ipairs(objs) do findSky(obj) if foundSky then break end end
    if not foundSky then for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end return end
    local cloned = foundSky:Clone()
    cloned.Parent = Lighting
    visualState.skyCurrent = cloned
    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
end

local function ToggleFog()
    visualState.fog = not visualState.fog
    if visualState.fog then
        visualState.fogBackup = {End=Lighting.FogEnd, Start=Lighting.FogStart, Color=Lighting.FogColor}
        Lighting.FogEnd = 80; Lighting.FogStart = 5
        Lighting.FogColor = Color3.fromRGB(120, 120, 130)
    else
        if visualState.fogBackup then
            Lighting.FogEnd = visualState.fogBackup.End
            Lighting.FogStart = visualState.fogBackup.Start
            Lighting.FogColor = visualState.fogBackup.Color
        end
    end
end

local function ToggleBeauty()
    visualState.beauty = not visualState.beauty
    if visualState.beauty then
        visualState.beautyBackup = {
            ClockTime=Lighting.ClockTime, Brightness=Lighting.Brightness,
            Ambient=Lighting.Ambient, OutdoorAmbient=Lighting.OutdoorAmbient,
        }
        Lighting.ClockTime = 0; Lighting.Brightness = 0.5
        Lighting.Ambient = Color3.fromRGB(0,0,0)
        Lighting.OutdoorAmbient = Color3.fromRGB(10,10,25)
        Lighting.GlobalShadows = true
    else
        if visualState.beautyBackup then
            Lighting.ClockTime = visualState.beautyBackup.ClockTime
            Lighting.Brightness = visualState.beautyBackup.Brightness
            Lighting.Ambient = visualState.beautyBackup.Ambient
            Lighting.OutdoorAmbient = visualState.beautyBackup.OutdoorAmbient
        end
    end
end

local function ToggleRain()
    visualState.rain = not visualState.rain
    if visualState.rain then
        local cam = Workspace.CurrentCamera
        if not cam then return end
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. RAIN_AUDIO_ID
        s.Volume = 1; s.Looped = true
        s.RollOffMaxDistance = 100000
        s.Parent = cam
        pcall(function() s:Play() end)
        visualState.rainSound = s
    else
        if visualState.rainSound then
            pcall(function() visualState.rainSound:Stop(); visualState.rainSound:Destroy() end)
            visualState.rainSound = nil
        end
    end
end

local function SpawnAura()
    if visualState.auraModel then pcall(function() visualState.auraModel:Destroy() end) end
    visualState.auraModel = nil
    local char = LocalPlayer.Character
    if not char then return end
    local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. AURA_ID) end)
    if not ok or not objs or not objs[1] then return end
    local aura = objs[1]
    aura.Parent = char
    visualState.auraModel = aura
    for _, c in ipairs(aura:GetDescendants()) do
        if c:IsA("Script") or c:IsA("LocalScript") then pcall(function() c.Disabled = true end) end
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, part in ipairs(aura:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function()
                part.Anchored = false; part.CanCollide = false; part.Massless = true
                part.CFrame = hrp.CFrame
            end)
            local w = Instance.new("WeldConstraint")
            w.Part0 = hrp; w.Part1 = part; w.Parent = part
        end
    end
end

local function ToggleAura()
    visualState.aura = not visualState.aura
    if visualState.aura then SpawnAura()
    else
        if visualState.auraModel then pcall(function() visualState.auraModel:Destroy() end) end
        visualState.auraModel = nil
    end
end

local function SpawnTornado()
    if visualState.tornadoModel then visualState.tornadoModel:Destroy() end
    visualState.tornadoModel = nil
    if visualState.tornadoSound then visualState.tornadoSound:Stop(); visualState.tornadoSound:Destroy(); visualState.tornadoSound = nil end
    if visualState.tornadoMainConn then visualState.tornadoMainConn:Disconnect(); visualState.tornadoMainConn = nil end
    if visualState.tornadoEspHL then visualState.tornadoEspHL:Destroy(); visualState.tornadoEspHL = nil end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. TORNADO_ID) end)
    if not ok or not objs or not objs[1] then return end
    local model = objs[1]
    model.Parent = Workspace
    visualState.tornadoModel = model
    for _, c in ipairs(model:GetDescendants()) do
        if c:IsA("Script") or c:IsA("LocalScript") then pcall(function() c.Disabled = true end) end
    end
    pcall(function() model:ScaleTo(500) end)
    for _, c in ipairs(model:GetDescendants()) do
        if c:IsA("BasePart") then pcall(function() c.Anchored = true; c.CanCollide = false; c.Massless = true end) end
    end
    local extent = model:GetExtentsSize()
    local halfHeight = extent.Y / 2
    local angle = math.random() * math.pi * 2
    local spawnPos = hrp.Position + Vector3.new(math.cos(angle) * 900, 0, math.sin(angle) * 900)
    spawnPos = Vector3.new(spawnPos.X, halfHeight, spawnPos.Z)
    pcall(function()
        model:PivotTo(CFrame.new(spawnPos, Vector3.new(hrp.Position.X, spawnPos.Y, hrp.Position.Z)) * CFrame.Angles(math.rad(180), 0, 0))
    end)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. TORNADO_SOUND_ID
    s.Volume = 10; s.Looped = true
    s.RollOffMaxDistance = 100000
    s.Parent = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart") or model
    pcall(function() s:Play() end)
    visualState.tornadoSound = s
    visualState.tornadoMainConn = RunService.Heartbeat:Connect(function(dt)
        if not visualState.tornado or visualState.tornadoModel ~= model then
            if visualState.tornadoMainConn then visualState.tornadoMainConn:Disconnect() end
            return
        end
        local c = LocalPlayer.Character
        if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart")
        if not h then return end
        local cur = model:GetPivot().Position
        local diff = h.Position - cur
        local dist = diff.Magnitude
        visualState.tornadoSpin = visualState.tornadoSpin - dt * 1.5
        if dist > 5 then
            local newPos = cur + diff.Unit * 70 * dt
            newPos = Vector3.new(newPos.X, halfHeight, newPos.Z)
            model:PivotTo(CFrame.new(newPos, Vector3.new(h.Position.X, newPos.Y, h.Position.Z)) * CFrame.Angles(math.rad(180), visualState.tornadoSpin, 0))
        end
    end)
end

local function ToggleTornado()
    visualState.tornado = not visualState.tornado
    if visualState.tornado then SpawnTornado()
    else
        if visualState.tornadoMainConn then visualState.tornadoMainConn:Disconnect(); visualState.tornadoMainConn = nil end
        if visualState.tornadoModel then visualState.tornadoModel:Destroy(); visualState.tornadoModel = nil end
        if visualState.tornadoSound then visualState.tornadoSound:Stop(); visualState.tornadoSound:Destroy(); visualState.tornadoSound = nil end
        if visualState.tornadoEspHL then visualState.tornadoEspHL:Destroy(); visualState.tornadoEspHL = nil end
    end
end

local function ToggleTornadoEsp()
    visualState.tornadoEsp = not visualState.tornadoEsp
    if visualState.tornadoEsp and visualState.tornadoModel then
        if visualState.tornadoEspHL and visualState.tornadoEspHL.Parent then return end
        local hl = Instance.new("Highlight")
        hl.Adornee = visualState.tornadoModel
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.OutlineColor = Color3.fromRGB(255, 0, 0)
        hl.FillTransparency = 1; hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = visualState.tornadoModel
        visualState.tornadoEspHL = hl
    else
        if visualState.tornadoEspHL then visualState.tornadoEspHL:Destroy(); visualState.tornadoEspHL = nil end
    end
end

local function ToggleLightning()
    visualState.lightning = not visualState.lightning
    if visualState.lightning then
        visualState.tornadoLightningConn = RunService.Heartbeat:Connect(function()
            if not visualState.tornado or not visualState.lightning then return end
            if math.random() < 0.03 then
                Lighting.Brightness = 5
                Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 255)
                task.wait(math.random(5, 15) / 100)
                if visualState.tornado then
                    Lighting.Brightness = 0.2
                    Lighting.OutdoorAmbient = Color3.fromRGB(5, 5, 15)
                end
            end
        end)
    else
        if visualState.tornadoLightningConn then visualState.tornadoLightningConn:Disconnect(); visualState.tornadoLightningConn = nil end
    end
end

local function ToggleSkyStar()
    visualState.skyStar = not visualState.skyStar
    if visualState.skyStar then loadSkyV(SKY_STARRY_ID) else removeSkyV() end
end
local function ToggleSkyDark()
    visualState.skyDark = not visualState.skyDark
    if visualState.skyDark then loadSkyV(SKY_DARK_ID) else removeSkyV() end
end

local function applySamuraiColor(cone)
    if not cone then return end
    if samuraiColor == "Rainbow" then return end
    local col = COLOR_VALUES[samuraiColor]
    if col then
        cone.Color = col
        for _, m in ipairs(cone:GetChildren()) do
            if m:IsA("SpecialMesh") then m.VertexColor = Vector3.new(col.R, col.G, col.B) end
        end
    end
end

local function spawnSamurai()
    local char = LocalPlayer.Character
    if not char then task.wait(0.5); char = LocalPlayer.Character; if not char then return end end
    local head = char:FindFirstChild("Head")
    if not head then task.wait(0.5); head = char:FindFirstChild("Head"); if not head then return end end
    if samuraiHat then pcall(function() samuraiHat:Destroy() end); samuraiHat = nil end
    local hat = Instance.new("Model")
    hat.Name = "SamuraiHatX"
    local cone = Instance.new("Part")
    cone.Size = Vector3.new(1, 1, 1)
    cone.Color = Color3.fromRGB(255, 255, 255)
    cone.Material = Enum.Material.SmoothPlastic
    cone.Transparency = 0.4
    cone.CanCollide = false
    cone.Massless = true
    cone.CastShadow = false
    cone.Anchored = true
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://1033714"
    mesh.Scale = Vector3.new(1.6, 1.2, 1.6)
    mesh.VertexColor = Vector3.new(1, 1, 1)
    mesh.Parent = cone
    cone.Parent = hat
    hat.PrimaryPart = cone
    hat.Parent = char
    samuraiHat = hat
    applySamuraiColor(cone)
    task.spawn(function()
        while samuraiHat == hat do
            local ch = LocalPlayer.Character
            if ch then
                local h = ch:FindFirstChild("Head")
                if h and cone.Parent then
                    cone.CFrame = h.CFrame * CFrame.new(0, 0.9, 0)
                end
            end
            task.wait()
        end
    end)
    if samuraiRainbowConn then pcall(function() samuraiRainbowConn:Disconnect() end) end
    local hue = 0
    samuraiRainbowConn = RunService.Heartbeat:Connect(function(dt)
        if not samuraiHat or not samuraiHat.PrimaryPart then
            if samuraiRainbowConn then pcall(function() samuraiRainbowConn:Disconnect() end) end
            samuraiRainbowConn = nil
            return
        end
        if samuraiColor == "Rainbow" then
            hue = (hue + dt * 0.15) % 1
            local col = Color3.fromHSV(hue, 0.85, 1)
            samuraiHat.PrimaryPart.Color = col
            for _, m in ipairs(samuraiHat.PrimaryPart:GetChildren()) do
                if m:IsA("SpecialMesh") then m.VertexColor = Vector3.new(col.R, col.G, col.B) end
            end
        else
            applySamuraiColor(samuraiHat.PrimaryPart)
        end
    end)
end

local function clearSamurai()
    if samuraiHat then pcall(function() samuraiHat:Destroy() end); samuraiHat = nil end
    if samuraiRainbowConn then pcall(function() samuraiRainbowConn:Disconnect() end); samuraiRainbowConn = nil end
end

local function applyOutlineColor()
    if not outlineHighlight then return end
    if outlineColor == "Rainbow" then return end
    local col = COLOR_VALUES[outlineColor]
    if col then
        outlineHighlight.FillColor = col
        outlineHighlight.OutlineColor = col
    end
end

local function ensureOutline()
    local char = LocalPlayer.Character
    if not char then return end
    if outlineHighlight and outlineHighlight.Parent == char then applyOutlineColor(); return end
    if outlineHighlight then pcall(function() outlineHighlight:Destroy() end) end
    local h = Instance.new("Highlight")
    h.Name = "OutlineX"
    h.Adornee = char
    h.FillTransparency = 1
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = char
    outlineHighlight = h
    applyOutlineColor()
end

local function clearOutline()
    if outlineHighlight then pcall(function() outlineHighlight:Destroy() end); outlineHighlight = nil end
end

RunService.Heartbeat:Connect(function()
    if outlineOn and outlineHighlight and outlineColor == "Rainbow" then
        local col = Color3.fromHSV((tick() * 0.5) % 1, 0.9, 1)
        outlineHighlight.FillColor = col
        outlineHighlight.OutlineColor = col
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if samuraiOn then clearSamurai(); spawnSamurai() end
    if outlineOn then clearOutline(); task.wait(0.2); ensureOutline() end
    if visualState.aura then SpawnAura() end
    if visualState.tornado then SpawnTornado() end
    if awpOn then ClearAwp(); awpModel = BuildAwpModel() end
end)

local function ClearAwp()
    if awpModel then pcall(function() awpModel:Destroy() end) end
    awpModel = nil
end

local function BuildAwpModel()
    local char = LocalPlayer.Character
    if not char then return nil end
    local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
    if not rightHand then return nil end
    local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. AWP_ID) end)
    if not ok or not objs or not objs[1] then return nil end
    local awp = objs[1]
    for _, c in ipairs(awp:GetDescendants()) do
        if c:IsA("Script") or c:IsA("LocalScript") then pcall(function() c.Disabled = true end) end
    end
    if awp:IsA("Model") then
        awp.Parent = char
        local handle = awp.PrimaryPart or awp:FindFirstChild("Handle") or awp:FindFirstChildWhichIsA("BasePart")
        if not handle then awp:Destroy() return nil end
        if not awp.PrimaryPart then awp.PrimaryPart = handle end
        for _, p in ipairs(awp:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Anchored = false; p.CanCollide = false; p.Massless = true
                p.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
            end
        end
        local weldCF = rightHand.CFrame * CFrame.new(0, -0.6, -1.2) * CFrame.Angles(math.rad(-90), 0, 0)
        pcall(function() awp:PivotTo(weldCF) end)
        local motor = Instance.new("Motor6D")
        motor.Name = "RedmagicAwpMotor"
        motor.Part0 = rightHand; motor.Part1 = handle
        motor.C0 = CFrame.new(0, -0.6, -1.2) * CFrame.Angles(math.rad(-90), 0, 0)
        motor.C1 = CFrame.new()
        motor.Parent = rightHand
        for _, p in ipairs(awp:GetDescendants()) do
            if p:IsA("BasePart") and p ~= handle then
                local w = Instance.new("WeldConstraint")
                w.Part0 = handle; w.Part1 = p; w.Parent = p
            end
        end
        return awp
    elseif awp:IsA("BasePart") then
        awp.Parent = char
        awp.Anchored = false; awp.CanCollide = false; awp.Massless = true
        awp.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
        local motor = Instance.new("Motor6D")
        motor.Name = "RedmagicAwpMotor"
        motor.Part0 = rightHand; motor.Part1 = awp
        motor.C0 = CFrame.new(0, -0.6, -1.2) * CFrame.Angles(math.rad(-90), 0, 0)
        motor.C1 = CFrame.new()
        motor.Parent = rightHand
        return awp
    end
    return nil
end

local function ToggleAwp()
    awpOn = not awpOn
    if awpOn then
        ClearAwp()
        awpModel = BuildAwpModel()
    else
        ClearAwp()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedmagicGUI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then pcall(function() ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 170, 0, 55)
ToggleButton.Position = UDim2.new(0.5, -85, 0, 15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "REDMAGIC"
ToggleButton.TextColor3 = Color3.fromRGB(255, 30, 30)
ToggleButton.TextSize = 17
ToggleButton.Font = Enum.Font.GothamMedium
ToggleButton.Parent = ScreenGui
local TogCorner = Instance.new("UICorner"); TogCorner.CornerRadius = UDim.new(1, 0); TogCorner.Parent = ToggleButton
local TogStroke = Instance.new("UIStroke"); TogStroke.Color = Color3.fromRGB(255, 30, 30); TogStroke.Thickness = 1; TogStroke.Transparency = 0.6; TogStroke.Parent = ToggleButton

local btnDragging, btnDragStart, btnStartPos
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true; btnDragStart = input.Position; btnStartPos = ToggleButton.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        ToggleButton.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then btnDragging = false end
end)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 400)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 12); MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke"); MainStroke.Color = Color3.fromRGB(70, 0, 0); MainStroke.Thickness = 1; MainStroke.Transparency = 0.5; MainStroke.Parent = MainFrame

ToggleButton.MouseButton1Click:Connect(function()
    PlayClickSfx()
    MainFrame.Visible = not MainFrame.Visible
end)

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then dragInput = input end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
local SidebarCorner = Instance.new("UICorner"); SidebarCorner.CornerRadius = UDim.new(0, 12); SidebarCorner.Parent = Sidebar

local IconBox = Instance.new("Frame")
IconBox.Size = UDim2.new(1, -16, 0, 62)
IconBox.Position = UDim2.new(0, 8, 0, 8)
IconBox.BackgroundTransparency = 1
IconBox.BorderSizePixel = 0
IconBox.ZIndex = 3
IconBox.ClipsDescendants = true
IconBox.Parent = Sidebar
local IB_corner = Instance.new("UICorner"); IB_corner.CornerRadius = UDim.new(0, 6); IB_corner.Parent = IconBox
local IconImage = Instance.new("ImageLabel")
IconImage.Size = UDim2.new(1, 0, 1, 0)
IconImage.BackgroundTransparency = 1
IconImage.BorderSizePixel = 0
IconImage.Image = "rbxassetid://" .. ICON_ID
IconImage.ScaleType = Enum.ScaleType.Crop
IconImage.ZIndex = 4
IconImage.Parent = IconBox
local II_corner = Instance.new("UICorner"); II_corner.CornerRadius = UDim.new(0, 6); II_corner.Parent = IconImage

local function CreateTabButton(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 30)
    btn.Position = UDim2.new(0, 6, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    btn.BackgroundTransparency = 0.5
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(140, 140, 140)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = Sidebar
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = btn
    local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 10); pad.Parent = btn
    return btn
end

local TabMainBtn = CreateTabButton("MAIN", 78)
local TabCombatBtn = CreateTabButton("COMBAT", 112)
local TabPlayersBtn = CreateTabButton("FLING", 146)
local TabVisualBtn = CreateTabButton("VISUAL", 180)
local TabRadioBtn = CreateTabButton("RADIO", 214)
local TabAiBtn = CreateTabButton("JARVIS", 248)
local TabInfoBtn = CreateTabButton("INFO", 282)

local function CreateContainer()
    local c = Instance.new("ScrollingFrame")
    c.Size = UDim2.new(1, -140, 1, -20)
    c.Position = UDim2.new(0, 140, 0, 10)
    c.BackgroundTransparency = 1
    c.CanvasSize = UDim2.new(0, 0, 4, 0)
    c.ScrollBarThickness = 3
    c.Visible = false
    c.Parent = MainFrame
    return c
end

local ContainerMain = CreateContainer(); ContainerMain.Visible = true
local ContainerCombat = CreateContainer()
local ContainerPlayers = CreateContainer()
local ContainerVisual = CreateContainer()
local ContainerRadio = CreateContainer()
local ContainerInfo = CreateContainer()
local ContainerAi = Instance.new("Frame")
ContainerAi.Size = UDim2.new(1, -140, 1, -20)
ContainerAi.Position = UDim2.new(0, 140, 0, 10)
ContainerAi.BackgroundTransparency = 1
ContainerAi.Visible = false
ContainerAi.Parent = MainFrame

local function SetTab(active, others)
    active.Visible = true
    for _, c in ipairs(others) do c.Visible = false end
end
local function ColorTabs(active)
    for _, t in ipairs({TabMainBtn, TabCombatBtn, TabPlayersBtn, TabVisualBtn, TabRadioBtn, TabAiBtn, TabInfoBtn}) do
        t.TextColor3 = (t == active) and Color3.fromRGB(255,255,255) or Color3.fromRGB(150,150,150)
        t.BackgroundColor3 = (t == active) and Color3.fromRGB(45,0,0) or Color3.fromRGB(25,25,25)
    end
end

TabMainBtn.MouseButton1Click:Connect(function()
    PlayClickSfx()
    SetTab(ContainerMain, {ContainerCombat, ContainerPlayers, ContainerVisual, ContainerRadio, ContainerAi, ContainerInfo}); ColorTabs(TabMainBtn)
end)
TabCombatBtn.MouseButton1Click:Connect(function()
    PlayClickSfx()
    SetTab(ContainerCombat, {ContainerMain, ContainerPlayers, ContainerVisual, ContainerRadio, ContainerAi, ContainerInfo}); ColorTabs(TabCombatBtn)
end)
TabPlayersBtn.MouseButton1Click:Connect(function()
    PlayClickSfx()
    SetTab(ContainerPlayers, {ContainerMain, ContainerCombat, ContainerVisual, ContainerRadio, ContainerAi, ContainerInfo}); ColorTabs(TabPlayersBtn)
end)
TabVisualBtn.MouseButton1Click:Connect(function()
    PlayClickSfx()
    SetTab(ContainerVisual, {ContainerMain, ContainerCombat, ContainerPlayers, ContainerRadio, ContainerAi, ContainerInfo}); ColorTabs(TabVisualBtn)
end)
TabRadioBtn.MouseButton1Click:Connect(function()
    PlayClickSfx()
    SetTab(ContainerRadio, {ContainerMain, ContainerCombat, ContainerPlayers, ContainerVisual, ContainerAi, ContainerInfo}); ColorTabs(TabRadioBtn)
end)
TabAiBtn.MouseButton1Click:Connect(function()
    PlayClickSfx()
    SetTab(ContainerAi, {ContainerMain, ContainerCombat, ContainerPlayers, ContainerVisual, ContainerRadio, ContainerInfo}); ColorTabs(TabAiBtn)
end)
TabInfoBtn.MouseButton1Click:Connect(function()
    PlayClickSfx()
    SetTab(ContainerInfo, {ContainerMain, ContainerCombat, ContainerPlayers, ContainerVisual, ContainerRadio, ContainerAi}); ColorTabs(TabInfoBtn)
end)

local RedmagicHeader = Instance.new("TextLabel")
RedmagicHeader.Size = UDim2.new(1, -20, 0, 44)
RedmagicHeader.Position = UDim2.new(0, 10, 0, 0)
RedmagicHeader.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
RedmagicHeader.BorderSizePixel = 0
RedmagicHeader.Text = "REDMAGIC"
RedmagicHeader.TextColor3 = Color3.fromRGB(255, 40, 40)
RedmagicHeader.TextSize = 20
RedmagicHeader.Font = Enum.Font.GothamBold
RedmagicHeader.Parent = ContainerMain
local RH = Instance.new("UICorner"); RH.CornerRadius = UDim.new(0, 8); RH.Parent = RedmagicHeader
local RHStroke = Instance.new("UIStroke"); RHStroke.Color = Color3.fromRGB(120, 0, 0); RHStroke.Thickness = 1; RHStroke.Transparency = 0.4; RHStroke.Parent = RedmagicHeader

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -40, 0, 200)
infoLabel.Position = UDim2.new(0, 20, 0, 20)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "этот скрипт open source а это значит вы можете взять его функции и добавить в свой скрипт)"
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.TextSize = 16
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = ContainerInfo

local infoLabel2 = Instance.new("TextLabel")
infoLabel2.Size = UDim2.new(1, -40, 0, 200)
infoLabel2.Position = UDim2.new(0, 20, 0, 240)
infoLabel2.BackgroundTransparency = 1
infoLabel2.Text = "в этом скрипте есть недоделаные функции но недоделаные работают хорошо просто их надо улучшить следите за обновлениями"
infoLabel2.TextColor3 = Color3.fromRGB(255, 200, 100)
infoLabel2.TextSize = 15
infoLabel2.Font = Enum.Font.Gotham
infoLabel2.TextWrapped = true
infoLabel2.TextXAlignment = Enum.TextXAlignment.Left
infoLabel2.TextYAlignment = Enum.TextYAlignment.Top
infoLabel2.Parent = ContainerInfo

local function CreateWindowSetting(titleText, rows, callbacks)
    local SettingGui = Instance.new("ScreenGui")
    SettingGui.Name = "Setting_" .. titleText
    SettingGui.ResetOnSpawn = false
    pcall(function() SettingGui.Parent = game.CoreGui end)
    if not SettingGui.Parent then pcall(function() SettingGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end
    local rowH = 34
    local height = 30 + #rows * rowH + 10
    local Window = Instance.new("Frame")
    Window.Size = UDim2.new(0, 260, 0, height)
    Window.Position = UDim2.new(0.5, 200, 0.5, -height/2)
    Window.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    Window.Visible = false
    Window.Parent = SettingGui
    local wCorner = Instance.new("UICorner"); wCorner.CornerRadius = UDim.new(0, 8); wCorner.Parent = Window
    local wStroke = Instance.new("UIStroke"); wStroke.Color = Color3.fromRGB(120, 0, 0); wStroke.Thickness = 1; wStroke.Transparency = 0.4; wStroke.Parent = Window
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 26)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Window
    for i, row in ipairs(rows) do
        local y = 28 + (i - 1) * rowH
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.6, 0, 0, rowH - 4)
        lbl.Position = UDim2.new(0, 10, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.Text = row[1]
        lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.Parent = Window
        if row[3] == "toggle" then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 40, 0, 20)
            btn.Position = UDim2.new(1, -50, 0, y + 4)
            btn.BackgroundColor3 = row[2] and Color3.fromRGB(180,0,0) or Color3.fromRGB(45,45,50)
            btn.Text = ""
            btn.Parent = Window
            local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1, 0); c.Parent = btn
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = row[2] and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Parent = btn
            local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1, 0); kc.Parent = knob
            local state = row[2]
            btn.MouseButton1Click:Connect(function()
                PlayClickSfx()
                state = not state
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = state and Color3.fromRGB(180,0,0) or Color3.fromRGB(45,45,50)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.15), {Position = state and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                if callbacks[i] then callbacks[i](state) end
            end)
        else
            local tb = Instance.new("TextBox")
            tb.Size = UDim2.new(0, 70, 0, 22)
            tb.Position = UDim2.new(1, -80, 0, y + 3)
            tb.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
            tb.Text = tostring(row[2])
            tb.TextColor3 = Color3.fromRGB(255, 255, 255)
            tb.TextSize = 12
            tb.Font = Enum.Font.GothamBold
            tb.Parent = Window
            local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = tb
            tb.FocusLost:Connect(function()
                local v = tonumber(tb.Text)
                if v and callbacks[i] then callbacks[i](v) end
            end)
        end
    end
    return Window
end

local function CreateToggle(parentContainer, name, yPos, defaultSetting, settingCb, toggleCb)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -20, 0, 38)
    Frame.Position = UDim2.new(0, 10, 0, yPos)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    Frame.BorderSizePixel = 0
    Frame.Parent = parentContainer
    local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 8); Corner.Parent = Frame
    local Stroke = Instance.new("UIStroke"); Stroke.Color = Color3.fromRGB(60, 60, 65); Stroke.Thickness = 1; Stroke.Transparency = 0.5; Stroke.Parent = Frame
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.55, 0, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.GothamMedium
    Label.Parent = Frame
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(0, 40, 0, 20)
    Track.Position = UDim2.new(1, -52, 0.5, -10)
    Track.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Track.BorderSizePixel = 0
    Track.ClipsDescendants = false
    Track.Parent = Frame
    local TrackCorner = Instance.new("UICorner"); TrackCorner.CornerRadius = UDim.new(1, 0); TrackCorner.Parent = Track
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    Knob.BorderSizePixel = 0
    Knob.Parent = Track
    local KnobCorner = Instance.new("UICorner"); KnobCorner.CornerRadius = UDim.new(1, 0); KnobCorner.Parent = Knob
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = Frame
    if defaultSetting ~= nil then
        local GearBtn = Instance.new("TextButton")
        GearBtn.Size = UDim2.new(0, 24, 0, 24)
        GearBtn.Position = UDim2.new(1, -84, 0.5, -12)
        GearBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
        GearBtn.Text = "⚙"
        GearBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        GearBtn.TextSize = 13
        GearBtn.Font = Enum.Font.GothamBold
        GearBtn.Parent = Frame
        local gc = Instance.new("UICorner"); gc.CornerRadius = UDim.new(0, 6); gc.Parent = GearBtn
        local settingWindowRef = CreateWindowSetting(name, defaultSetting, settingCb)
        GearBtn.MouseButton1Click:Connect(function()
            PlayClickSfx()
            settingWindowRef.Visible = not settingWindowRef.Visible
        end)
    end
    local state = false
    Btn.MouseButton1Click:Connect(function()
        PlayClickSfx()
        state = not state
        if state then
            TweenService:Create(Track, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            }):Play()
            TweenService:Create(Knob, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 22, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.25), {
                Color = Color3.fromRGB(180, 0, 0),
                Transparency = 0.2
            }):Play()
            TweenService:Create(Knob, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 21, 0.5, -9)
            }):Play()
            task.wait(0.08)
            TweenService:Create(Knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 22, 0.5, -8)
            }):Play()
        else
            TweenService:Create(Track, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            }):Play()
            TweenService:Create(Knob, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            }):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.25), {
                Color = Color3.fromRGB(60, 60, 65),
                Transparency = 0.5
            }):Play()
            TweenService:Create(Knob, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, 3, 0.5, -7)
            }):Play()
            task.wait(0.08)
            TweenService:Create(Knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 2, 0.5, -8)
            }):Play()
        end
        if toggleCb then toggleCb(state) end
    end)
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Frame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 33)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Frame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 24)}):Play()
    end)
end

local function OpenColorPicker(title, currentColorKey, onSelect)
    local picker = Instance.new("Frame")
    picker.Size = UDim2.new(0, 240, 0, 340)
    picker.Position = UDim2.new(0.5, -120, 0.5, -170)
    picker.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    picker.BorderSizePixel = 0
    picker.ZIndex = 30
    picker.Parent = ScreenGui
    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0, 10); pc.Parent = picker
    local ps = Instance.new("UIStroke"); ps.Color = Color3.fromRGB(120, 0, 0); ps.Thickness = 1; ps.Transparency = 0.3; ps.Parent = picker
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 34)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextSize = 15
    t.Font = Enum.Font.GothamBold
    t.ZIndex = 31
    t.Parent = picker
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 28, 0, 28)
    close.Position = UDim2.new(1, -32, 0, 3)
    close.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 120, 120)
    close.TextSize = 14
    close.Font = Enum.Font.GothamBold
    close.BorderSizePixel = 0
    close.ZIndex = 32
    close.Parent = picker
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 6); cc.Parent = close
    close.MouseButton1Click:Connect(function()
        PlayClickSfx()
        picker:Destroy()
    end)
    local y = 42
    for _, key in ipairs(COLOR_NAMES) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -20, 0, 32)
        b.Position = UDim2.new(0, 10, 0, y)
        b.BackgroundColor3 = (key == currentColorKey) and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(45, 45, 50)
        b.Text = COLOR_LABELS[key]
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 13
        b.Font = Enum.Font.GothamMedium
        b.BorderSizePixel = 0
        b.ZIndex = 31
        b.Parent = picker
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = b
        local col = COLOR_VALUES[key]
        if col then
            local strip = Instance.new("Frame")
            strip.Size = UDim2.new(0, 10, 1, 0)
            strip.Position = UDim2.new(1, -14, 0, 0)
            strip.BackgroundColor3 = col
            strip.BorderSizePixel = 0
            strip.ZIndex = 32
            strip.Parent = b
            local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0, 4); sc.Parent = strip
        end
        b.MouseButton1Click:Connect(function()
            PlayClickSfx()
            onSelect(key)
            picker:Destroy()
        end)
        y = y + 36
    end
end

local FLY_MAXSPEED = 50
local flyCtrl = {f=0, b=0, l=0, r=0, up=0, down=0}
local flyLastCtrl = {f=0, b=0, l=0, r=0}
local flySpeedVal = 0
local flyActive = false
local flySpeed = 60

local function GetFlyPart(char)
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    if hum.RigType == Enum.HumanoidRigType.R6 then
        return char:FindFirstChild("Torso")
    else
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    end
end

local function StartFly()
    if flyActive then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local part = GetFlyPart(char)
    if not (char and hum and part) then return end
    flyActive = true
    hum.PlatformStand = true
    for _, v in next, hum:GetPlayingAnimationTracks() do v:AdjustSpeed(0) end
    if char:FindFirstChild("Animate") then char.Animate.Disabled = true end
    local bg = Instance.new("BodyGyro", part)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = part.CFrame
    local bv = Instance.new("BodyVelocity", part)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyCtrl = {f=0, b=0, l=0, r=0, up=0, down=0}
    flyLastCtrl = {f=0, b=0, l=0, r=0}
    flySpeedVal = 0
    task.spawn(function()
        while flyActive and char.Parent and hum.Health > 0 do
            RunService.RenderStepped:Wait()
            local cam = Workspace.CurrentCamera
            if flyCtrl.l + flyCtrl.r ~= 0 or flyCtrl.f + flyCtrl.b ~= 0 then
                flySpeedVal = flySpeedVal + 0.5 + (flySpeedVal / FLY_MAXSPEED)
                if flySpeedVal > flySpeed + FLY_MAXSPEED then flySpeedVal = flySpeed + FLY_MAXSPEED end
            elseif flySpeedVal ~= 0 then
                flySpeedVal = flySpeedVal - 1
                if flySpeedVal < 0 then flySpeedVal = 0 end
            end
            local horiz = Vector3.new(0, 0, 0)
            if (flyCtrl.l + flyCtrl.r) ~= 0 or (flyCtrl.f + flyCtrl.b) ~= 0 then
                horiz = ((cam.CFrame.LookVector * (flyCtrl.f + flyCtrl.b)) +
                    ((cam.CFrame * CFrame.new(flyCtrl.l + flyCtrl.r, 0, 0).p) - cam.CFrame.p)) * flySpeedVal
                flyLastCtrl = {f=flyCtrl.f, b=flyCtrl.b, l=flyCtrl.l, r=flyCtrl.r}
            elseif flySpeedVal ~= 0 then
                horiz = ((cam.CFrame.LookVector * (flyLastCtrl.f + flyLastCtrl.b)) +
                    ((cam.CFrame * CFrame.new(flyLastCtrl.l + flyLastCtrl.r, 0, 0).p) - cam.CFrame.p)) * flySpeedVal
            end
            local vert = Vector3.new(0, flyCtrl.up * flySpeed, 0) - Vector3.new(0, flyCtrl.down * flySpeed, 0)
            bv.Velocity = horiz + vert
            bg.CFrame = cam.CFrame * CFrame.Angles(-math.rad((flyCtrl.f + flyCtrl.b) * 50 * flySpeedVal / FLY_MAXSPEED), 0, 0)
        end
        flyCtrl = {f=0, b=0, l=0, r=0, up=0, down=0}
        flyLastCtrl = {f=0, b=0, l=0, r=0}
        flySpeedVal = 0
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
        local c2 = LocalPlayer.Character
        if c2 then
            local h2 = c2:FindFirstChildOfClass("Humanoid")
            if h2 then h2.PlatformStand = false end
            if c2:FindFirstChild("Animate") then c2.Animate.Disabled = false end
        end
        flyActive = false
    end)
end

local function StopFly() flyActive = false end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe or not flyActive then return end
    if input.KeyCode == Enum.KeyCode.W then flyCtrl.f = 1
    elseif input.KeyCode == Enum.KeyCode.S then flyCtrl.b = -1
    elseif input.KeyCode == Enum.KeyCode.A then flyCtrl.l = -1
    elseif input.KeyCode == Enum.KeyCode.D then flyCtrl.r = 1
    elseif input.KeyCode == Enum.KeyCode.Space then flyCtrl.up = 1
    elseif input.KeyCode == Enum.KeyCode.LeftShift then flyCtrl.down = 1
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if not flyActive then return end
    if input.KeyCode == Enum.KeyCode.W then flyCtrl.f = 0
    elseif input.KeyCode == Enum.KeyCode.S then flyCtrl.b = 0
    elseif input.KeyCode == Enum.KeyCode.A then flyCtrl.l = 0
    elseif input.KeyCode == Enum.KeyCode.D then flyCtrl.r = 0
    elseif input.KeyCode == Enum.KeyCode.Space then flyCtrl.up = 0
    elseif input.KeyCode == Enum.KeyCode.LeftShift then flyCtrl.down = 0
    end
end)

local flyJoystickGui = Instance.new("ScreenGui")
flyJoystickGui.Name = "RedmagicFlyJoystick"
flyJoystickGui.ResetOnSpawn = false
pcall(function() flyJoystickGui.Parent = game.CoreGui end)
if not flyJoystickGui.Parent then pcall(function() flyJoystickGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end

local stickBg = Instance.new("Frame")
stickBg.Size = UDim2.new(0, 140, 0, 140)
stickBg.Position = UDim2.new(0, 20, 0.5, -70)
stickBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
stickBg.BackgroundTransparency = 0.5
stickBg.BorderSizePixel = 0
stickBg.Visible = false
stickBg.Parent = flyJoystickGui
local sbgC = Instance.new("UICorner"); sbgC.CornerRadius = UDim.new(1, 0); sbgC.Parent = stickBg
local sbgStroke = Instance.new("UIStroke"); sbgStroke.Color = Color3.fromRGB(180, 0, 0); sbgStroke.Thickness = 1.5; sbgStroke.Transparency = 0.4; sbgStroke.Parent = stickBg

local stickKnob = Instance.new("Frame")
stickKnob.Size = UDim2.new(0, 50, 0, 50)
stickKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
stickKnob.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
stickKnob.BackgroundTransparency = 0.2
stickKnob.BorderSizePixel = 0
stickKnob.Parent = stickBg
local skC = Instance.new("UICorner"); skC.CornerRadius = UDim.new(1, 0); skC.Parent = stickKnob

local stickBtn = Instance.new("TextButton")
stickBtn.Size = UDim2.new(1, 0, 1, 0)
stickBtn.BackgroundTransparency = 1
stickBtn.Text = ""
stickBtn.Parent = stickBg

local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.new(0, 50, 0, 40)
upBtn.Position = UDim2.new(0, 20, 0.5, -210)
upBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
upBtn.BackgroundTransparency = 0.4
upBtn.Text = "▲"
upBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
upBtn.TextSize = 22
upBtn.Font = Enum.Font.GothamBold
upBtn.Visible = false
upBtn.Parent = flyJoystickGui
local ubC = Instance.new("UICorner"); ubC.CornerRadius = UDim.new(1, 0); ubC.Parent = upBtn

local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0, 50, 0, 40)
downBtn.Position = UDim2.new(0, 20, 0.5, 170)
downBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
downBtn.BackgroundTransparency = 0.4
downBtn.Text = "▼"
downBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
downBtn.TextSize = 22
downBtn.Font = Enum.Font.GothamBold
downBtn.Visible = false
downBtn.Parent = flyJoystickGui
local dbC = Instance.new("UICorner"); dbC.CornerRadius = UDim.new(1, 0); dbC.Parent = downBtn

local origStartFly = StartFly
local origStopFly = StopFly
StartFly = function()
    origStartFly()
    stickBg.Visible = true
    upBtn.Visible = true
    downBtn.Visible = true
end
StopFly = function()
    origStopFly()
    stickBg.Visible = false
    upBtn.Visible = false
    downBtn.Visible = false
    stickKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
end

local stickDragging = false
local stickInput = nil

stickBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        stickDragging = true
        stickInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not stickDragging then return end
    if input ~= stickInput then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local center = stickBg.AbsolutePosition + stickBg.AbsoluteSize / 2
    local delta = Vector2.new(input.Position.X, input.Position.Y) - center
    local mag = math.min(delta.Magnitude, 45)
    if delta.Magnitude > 0 then delta = delta.Unit * mag end
    stickKnob.Position = UDim2.new(0.5, delta.X - 25, 0.5, delta.Y - 25)
    local nx = delta.X / 45
    local ny = -delta.Y / 45
    flyCtrl.l = math.min(0, nx)
    flyCtrl.r = math.max(0, nx)
    flyCtrl.f = math.max(0, ny)
    flyCtrl.b = math.min(0, ny)
end)
UserInputService.InputEnded:Connect(function(input)
    if input == stickInput then
        stickDragging = false
        stickInput = nil
        stickKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
        flyCtrl.l = 0; flyCtrl.r = 0; flyCtrl.f = 0; flyCtrl.b = 0
    end
end)
upBtn.MouseButton1Down:Connect(function() flyCtrl.up = 1 end)
upBtn.MouseButton1Up:Connect(function() flyCtrl.up = 0 end)
upBtn.MouseLeave:Connect(function() flyCtrl.up = 0 end)
downBtn.MouseButton1Down:Connect(function() flyCtrl.down = 1 end)
downBtn.MouseButton1Up:Connect(function() flyCtrl.down = 0 end)
downBtn.MouseLeave:Connect(function() flyCtrl.down = 0 end)

CreateToggle(ContainerMain, "INF JUMP", 50, nil, nil, function(s) InfJumpEnabled = s end)
CreateToggle(ContainerMain, "FLY", 92, {{"flySpeed", 60, "number"}}, {function(v) flySpeed = v end}, function(s)
    if s then StartFly() else StopFly() end
end)
CreateToggle(ContainerMain, "NOCLIP", 134, nil, nil, function(s) NoClipEnabled = s end)

CreateToggle(ContainerCombat, "SLIENT", 10,
    {{"Aimbot Murder", false, "toggle"},{"Aimbot Sheriff", false, "toggle"},{"Auto Shot", false, "toggle"}},
    {
        function(v) SilentAutoKiller = v end,
        function(v) SilentAutoSheriff = v end,
        function(v) SilentAutoShot = v end,
    },
    function(s) SilentEnabled = s end
)
CreateToggle(ContainerCombat, "ESP PLAYERS", 52, nil, nil, function(s) EspEnabled = s end)
CreateToggle(ContainerCombat, "GUN ESP", 94, nil, nil, function(s) GunEspEnabled = s end)
CreateToggle(ContainerCombat, "AUTO GUN PICKUP", 136, nil, nil, function(s) AutoGunPickupEnabled = s end)
CreateToggle(ContainerCombat, "AUTO FARM COINS", 178, nil, nil, function(s) AutoFarmEnabled = s end)
CreateToggle(ContainerCombat, "SPEED GLITCH", 220,
    {{"max speed", 80, "number"},{"gain per jump", 3, "number"}},
    {function(v) bhopMaxSpeed = v end, function(v) bhopGain = v end},
    function(s) SpeedGlitchEnabled = s end
)
CreateToggle(ContainerCombat, "SPIN", 262, {{"speed", 1, "number"}}, {function(v) spinSpeed = v end}, function(s) SpinEnabled = s end)
CreateToggle(ContainerCombat, "WALKSPEED", 304, {{"value", 16, "number"}}, {function(v) walkSpeedValue = v end}, function(s) WalkSpeedEnabled = s end)
CreateToggle(ContainerCombat, "ANTI FLING", 346, nil, nil, function(s) AntiFlingEnabled = s end)
CreateToggle(ContainerCombat, "TP TO MURDER", 388, nil, nil, function(s)
    if s then
        for _, p in pairs(PlayersService:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if GetRole(p) == "Murder" then
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    end
                    break
                end
            end
        end
    end
end)
CreateToggle(ContainerCombat, "TP TO SHERIFF", 430, nil, nil, function(s)
    if s then
        for _, p in pairs(PlayersService:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if GetRole(p) == "Sheriff" then
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    end
                    break
                end
            end
        end
    end
end)
CreateToggle(ContainerCombat, "KILL ALL", 472, nil, nil, function(s) KillAllEnabled = s end)

CreateToggle(ContainerVisual, "SKY STARRY", 10, nil, nil, function(s) ToggleSkyStar() end)
CreateToggle(ContainerVisual, "SKY DARK", 52, nil, nil, function(s) ToggleSkyDark() end)
CreateToggle(ContainerVisual, "FOG", 94, nil, nil, function(s) ToggleFog() end)
CreateToggle(ContainerVisual, "DARK MODE", 136, nil, nil, function(s) ToggleBeauty() end)
CreateToggle(ContainerVisual, "RAIN SOUND", 178, nil, nil, function(s) ToggleRain() end)
CreateToggle(ContainerVisual, "AURA", 220, nil, nil, function(s) ToggleAura() end)
CreateToggle(ContainerVisual, "TORNADO", 262, nil, nil, function(s) ToggleTornado() end)
CreateToggle(ContainerVisual, "TORNADO ESP", 304, nil, nil, function(s) ToggleTornadoEsp() end)
CreateToggle(ContainerVisual, "LIGHTNING", 346, nil, nil, function(s) ToggleLightning() end)
CreateToggle(ContainerVisual, "AWP MODEL GUN", 388, nil, nil, function(s) ToggleAwp() end)
CreateToggle(ContainerVisual, "SAMURAI HAT", 430, nil, nil, function(s)
    samuraiOn = s
    if s then spawnSamurai() else clearSamurai() end
end)
CreateToggle(ContainerVisual, "OUTLINE", 472, nil, nil, function(s)
    outlineOn = s
    if s then ensureOutline() else clearOutline() end
end)

do
    local function attachGear(rowFrame, onClick)
        local gear = Instance.new("TextButton")
        gear.Size = UDim2.new(0, 24, 0, 24)
        gear.Position = UDim2.new(1, -84, 0.5, -12)
        gear.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
        gear.Text = "⚙"
        gear.TextColor3 = Color3.fromRGB(150, 150, 150)
        gear.TextSize = 13
        gear.Font = Enum.Font.GothamBold
        gear.BorderSizePixel = 0
        gear.Parent = rowFrame
        local gc = Instance.new("UICorner"); gc.CornerRadius = UDim.new(0, 6); gc.Parent = gear
        gear.MouseButton1Click:Connect(function()
            PlayClickSfx()
            onClick()
        end)
    end
    for _, ch in ipairs(ContainerVisual:GetChildren()) do
        if ch:IsA("Frame") then
            local lbl = ch:FindFirstChildWhichIsA("TextLabel")
            if lbl and lbl.Text == "SAMURAI HAT" then
                attachGear(ch, function()
                    OpenColorPicker("SAMURAI COLOR", samuraiColor, function(k)
                        samuraiColor = k
                        if samuraiHat and samuraiHat.PrimaryPart then applySamuraiColor(samuraiHat.PrimaryPart) end
                    end)
                end)
            elseif lbl and lbl.Text == "OUTLINE" then
                attachGear(ch, function()
                    OpenColorPicker("OUTLINE COLOR", outlineColor, function(k)
                        outlineColor = k
                        applyOutlineColor()
                    end)
                end)
            end
        end
    end
end

ColorTabs(TabMainBtn)

local radioHeader = Instance.new("TextLabel")
radioHeader.Size = UDim2.new(1, -20, 0, 44)
radioHeader.Position = UDim2.new(0, 10, 0, 0)
radioHeader.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
radioHeader.BorderSizePixel = 0
radioHeader.Text = "RADIO"
radioHeader.TextColor3 = Color3.fromRGB(255, 40, 40)
radioHeader.TextSize = 20
radioHeader.Font = Enum.Font.GothamBold
radioHeader.Parent = ContainerRadio
local radH = Instance.new("UICorner"); radH.CornerRadius = UDim.new(0, 8); radH.Parent = radioHeader

local radioSound = Instance.new("Sound")
radioSound.Name = "RedmagicRadioSound"
radioSound.Volume = 1
radioSound.Looped = true
radioSound.Parent = ScreenGui

local radioIdLabel = Instance.new("TextLabel")
radioIdLabel.Size = UDim2.new(1, -20, 0, 24)
radioIdLabel.Position = UDim2.new(0, 10, 0, 58)
radioIdLabel.BackgroundTransparency = 1
radioIdLabel.Text = "вставь ID песни:"
radioIdLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
radioIdLabel.TextSize = 13
radioIdLabel.TextXAlignment = Enum.TextXAlignment.Left
radioIdLabel.Font = Enum.Font.GothamMedium
radioIdLabel.Parent = ContainerRadio

local radioIdBox = Instance.new("TextBox")
radioIdBox.Size = UDim2.new(1, -20, 0, 36)
radioIdBox.Position = UDim2.new(0, 10, 0, 86)
radioIdBox.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
radioIdBox.BorderSizePixel = 0
radioIdBox.Text = ""
radioIdBox.PlaceholderText = "например 1837879082"
radioIdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
radioIdBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
radioIdBox.TextSize = 14
radioIdBox.Font = Enum.Font.Gotham
radioIdBox.ClearTextOnFocus = false
radioIdBox.Parent = ContainerRadio
local ridC = Instance.new("UICorner"); ridC.CornerRadius = UDim.new(0, 6); ridC.Parent = radioIdBox

local radioPlayBtn = Instance.new("TextButton")
radioPlayBtn.Size = UDim2.new(0.5, -15, 0, 34)
radioPlayBtn.Position = UDim2.new(0, 10, 0, 130)
radioPlayBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
radioPlayBtn.Text = "PLAY"
radioPlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
radioPlayBtn.TextSize = 14
radioPlayBtn.Font = Enum.Font.GothamBold
radioPlayBtn.Parent = ContainerRadio
local rpbC = Instance.new("UICorner"); rpbC.CornerRadius = UDim.new(0, 6); rpbC.Parent = radioPlayBtn

local radioStopBtn = Instance.new("TextButton")
radioStopBtn.Size = UDim2.new(0.5, -15, 0, 34)
radioStopBtn.Position = UDim2.new(0.5, 5, 0, 130)
radioStopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
radioStopBtn.Text = "STOP"
radioStopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
radioStopBtn.TextSize = 14
radioStopBtn.Font = Enum.Font.GothamBold
radioStopBtn.Parent = ContainerRadio
local rsbC = Instance.new("UICorner"); rsbC.CornerRadius = UDim.new(0, 6); rsbC.Parent = radioStopBtn

local radioVolLabel = Instance.new("TextLabel")
radioVolLabel.Size = UDim2.new(1, -20, 0, 22)
radioVolLabel.Position = UDim2.new(0, 10, 0, 178)
radioVolLabel.BackgroundTransparency = 1
radioVolLabel.Text = "громкость: 100%"
radioVolLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
radioVolLabel.TextSize = 13
radioVolLabel.TextXAlignment = Enum.TextXAlignment.Left
radioVolLabel.Font = Enum.Font.GothamMedium
radioVolLabel.Parent = ContainerRadio

local radioVolBarBg = Instance.new("Frame")
radioVolBarBg.Size = UDim2.new(1, -20, 0, 12)
radioVolBarBg.Position = UDim2.new(0, 10, 0, 204)
radioVolBarBg.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
radioVolBarBg.BorderSizePixel = 0
radioVolBarBg.Parent = ContainerRadio
local rvbbC = Instance.new("UICorner"); rvbbC.CornerRadius = UDim.new(1, 0); rvbbC.Parent = radioVolBarBg

local radioVolFill = Instance.new("Frame")
radioVolFill.Size = UDim2.new(1, 0, 1, 0)
radioVolFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
radioVolFill.BorderSizePixel = 0
radioVolFill.Parent = radioVolBarBg
local rvbfC = Instance.new("UICorner"); rvbfC.CornerRadius = UDim.new(1, 0); rvbfC.Parent = radioVolFill

local radioVolKnob = Instance.new("Frame")
radioVolKnob.Size = UDim2.new(0, 18, 0, 18)
radioVolKnob.Position = UDim2.new(1, -9, 0.5, -9)
radioVolKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
radioVolKnob.BorderSizePixel = 0
radioVolKnob.Parent = radioVolBarBg
local rvkC = Instance.new("UICorner"); rvkC.CornerRadius = UDim.new(1, 0); rvkC.Parent = radioVolKnob

local radioVolDrag = Instance.new("TextButton")
radioVolDrag.Size = UDim2.new(1, 0, 3, 0)
radioVolDrag.Position = UDim2.new(0, 0, -1, 0)
radioVolDrag.BackgroundTransparency = 1
radioVolDrag.Text = ""
radioVolDrag.Parent = radioVolBarBg

local RADIO_MAX_VOL = 10
local radioVolPct = 1.0

local function ApplyRadioVolume()
    local v = math.clamp(radioVolPct, 0, 1) * RADIO_MAX_VOL
    radioSound.Volume = v
    radioVolFill.Size = UDim2.new(math.clamp(radioVolPct, 0, 1), 0, 1, 0)
    radioVolKnob.Position = UDim2.new(math.clamp(radioVolPct, 0, 1), -9, 0.5, -9)
    radioVolLabel.Text = "громкость: " .. math.floor(radioVolPct * 100 + 0.5) .. "%"
end
ApplyRadioVolume()

local radioVolDragging = false
local function UpdateRadioVolFromInput(input)
    local rel = (input.Position.X - radioVolBarBg.AbsolutePosition.X) / math.max(radioVolBarBg.AbsoluteSize.X, 1)
    radioVolPct = math.clamp(rel, 0, 1)
    ApplyRadioVolume()
end

radioVolDrag.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        radioVolDragging = true
        UpdateRadioVolFromInput(input)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not radioVolDragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        UpdateRadioVolFromInput(input)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        radioVolDragging = false
    end
end)

radioPlayBtn.MouseButton1Click:Connect(function()
    PlayClickSfx()
    local id = tostring(radioIdBox.Text):gsub("%D", "")
    if id == "" then return end
    radioSound:Stop()
    radioSound.SoundId = "rbxassetid://" .. id
    task.wait(0.1)
    radioSound:Play()
end)

radioStopBtn.MouseButton1Click:Connect(function()
    PlayClickSfx()
    pcall(function() radioSound:Stop() end)
end)

local PlayersListContainer = Instance.new("ScrollingFrame")
PlayersListContainer.Size = UDim2.new(1, -20, 1, -20)
PlayersListContainer.Position = UDim2.new(0, 10, 0, 10)
PlayersListContainer.BackgroundTransparency = 1
PlayersListContainer.CanvasSize = UDim2.new(0, 0, 2, 0)
PlayersListContainer.ScrollBarThickness = 3
PlayersListContainer.Parent = ContainerPlayers

local playerFrames = {}

local function BuildPlayerList()
    for _, child in pairs(PlayersListContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    playerFrames = {}
    local yOffset = 0
    for _, player in pairs(PlayersService:GetPlayers()) do
        if player ~= LocalPlayer then
            local pFrame = Instance.new("Frame")
            pFrame.Size = UDim2.new(1, 0, 0, 32)
            pFrame.Position = UDim2.new(0, 0, 0, yOffset)
            pFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            pFrame.Parent = PlayersListContainer
            local pfCorner = Instance.new("UICorner"); pfCorner.CornerRadius = UDim.new(0, 5); pfCorner.Parent = pFrame
            local nameBtn = Instance.new("TextButton")
            nameBtn.Size = UDim2.new(1, -10, 1, 0)
            nameBtn.Position = UDim2.new(0, 8, 0, 0)
            nameBtn.BackgroundTransparency = 1
            nameBtn.Text = player.Name
            nameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameBtn.TextSize = 13
            nameBtn.TextXAlignment = Enum.TextXAlignment.Left
            nameBtn.Font = Enum.Font.GothamBold
            nameBtn.Parent = pFrame
            nameBtn.MouseButton1Click:Connect(function()
                PlayClickSfx()
                if player.Character then
                    task.spawn(function() SkidFling(player) end)
                end
            end)
            playerFrames[player] = {btn = nameBtn, frame = pFrame}
            yOffset = yOffset + 38
        end
    end
    PlayersListContainer.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        for player, data in pairs(playerFrames) do
            if player.Parent and player.Character then
                local role = GetRole(player)
                local color = (role == "Murder" and Color3.fromRGB(255, 50, 50))
                    or (role == "Sheriff" and Color3.fromRGB(50, 120, 255))
                    or (role == "Innocent" and Color3.fromRGB(80, 220, 80))
                    or Color3.fromRGB(200, 200, 200)
                data.btn.Text = player.Name .. " [" .. role .. "]"
                data.btn.TextColor3 = color
            end
        end
    end
end)

PlayersService.PlayerAdded:Connect(BuildPlayerList)
PlayersService.PlayerRemoving:Connect(function() task.wait(0.1); BuildPlayerList() end)

function SkidFling(TargetPlayer)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    if not (Character and Humanoid and RootPart) then return end
    local TCharacter = TargetPlayer.Character
    if not TCharacter then return end
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    if RootPart.AssemblyLinearVelocity.Magnitude < 50 then
        FlingOldPos = RootPart.CFrame
    end
    if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end
    local function FPos(BasePart, Pos, Ang)
        if not RootPart or not RootPart.Parent then return end
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
        RootPart.AssemblyLinearVelocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RootPart.AssemblyAngularVelocity = Vector3.new(9e8, 9e8, 9e8)
    end
    local function SFBasePart(BasePart)
        local TimeToWait = 2
        local Time = tick()
        local Angle = 0
        repeat
            if RootPart and THumanoid then
                if BasePart.AssemblyLinearVelocity.Magnitude < 50 then
                    Angle = Angle + 100
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                else
                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0,0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.AssemblyLinearVelocity.Magnitude / 1.25), CFrame.Angles(math.rad(90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.AssemblyLinearVelocity.Magnitude / 1.25), CFrame.Angles(0,0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.AssemblyLinearVelocity.Magnitude / 1.25), CFrame.Angles(math.rad(90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0,0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90),0,0)); task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0,0,0)); task.wait()
                end
            else break end
        until BasePart.AssemblyLinearVelocity.Magnitude > 500
            or BasePart.Parent ~= TargetPlayer.Character
            or TargetPlayer.Parent ~= PlayersService
            or TargetPlayer.Character ~= TCharacter
            or (THumanoid and THumanoid.Sit)
            or (Humanoid and Humanoid.Health <= 0)
            or tick() > Time + TimeToWait
    end
    Workspace.FallenPartsDestroyHeight = 0/0
    local BV = Instance.new("BodyVelocity")
    BV.Name = "RedmagicVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    if TRootPart and THead then
        if (TRootPart.CFrame.Position - THead.CFrame.Position).Magnitude > 5 then
            SFBasePart(THead)
        else
            SFBasePart(TRootPart)
        end
    elseif TRootPart then
        SFBasePart(TRootPart)
    elseif THead then
        SFBasePart(THead)
    end
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    Camera.CameraSubject = Humanoid
    if FlingOldPos then
        repeat
            RootPart.CFrame = FlingOldPos * CFrame.new(0, 0.5, 0)
            Character:SetPrimaryPartCFrame(FlingOldPos * CFrame.new(0, 0.5, 0))
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            for _, x in pairs(Character:GetChildren()) do
                if x:IsA("BasePart") then
                    x.AssemblyLinearVelocity = Vector3.new()
                    x.AssemblyAngularVelocity = Vector3.new()
                end
            end
            task.wait()
        until (RootPart.Position - FlingOldPos.Position).Magnitude < 25
    end
    Workspace.FallenPartsDestroyHeight = FlingFPDH
end

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local character = LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.MoveDirection.Magnitude > 0.05 then
        lastMoveDir = hum.MoveDirection
    end
end)

task.spawn(function()
    while true do
        task.wait()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            if not SpeedGlitchEnabled then
                if hum.WalkSpeed ~= baseWalkSpeed and not WalkSpeedEnabled then
                    hum.WalkSpeed = baseWalkSpeed
                end
            else
                if hum.WalkSpeed < bhopMaxSpeed then
                    if hum.Jump then
                        hum.WalkSpeed = math.min(hum.WalkSpeed + bhopGain, bhopMaxSpeed)
                        task.wait(0.4)
                    elseif hum.MoveDirection.Magnitude > 0 then
                        task.wait(0.15)
                        if not hum.Jump then
                            for i = hum.WalkSpeed, baseWalkSpeed, -2 do
                                hum.WalkSpeed = i
                                task.wait()
                            end
                        end
                    end
                end
                if hum.MoveDirection.Magnitude <= 0 and not hum.Jump then
                    for i = hum.WalkSpeed, baseWalkSpeed, -2 do
                        hum.WalkSpeed = i
                        task.wait()
                    end
                end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if NoClipEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if not AntiFlingEnabled then return end
    for _, p in pairs(PlayersService:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            for _, part in pairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
    local myChar = LocalPlayer.Character
    if myChar then
        local hrp = myChar:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.AssemblyLinearVelocity.Magnitude > 150 then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if KillAllEnabled then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                for _, p in pairs(PlayersService:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not SpinEnabled then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed * 30), 0)
end)

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and WalkSpeedEnabled and not SpeedGlitchEnabled then
        hum.WalkSpeed = walkSpeedValue
    end
end)

local function ApplyPlayerEsp(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local existing = EspHighlights[player]
    if existing and existing.Parent and existing.Adornee == char then
        local role = GetRole(player)
        local color = role == "Murder" and Color3.fromRGB(255,0,0)
            or role == "Sheriff" and Color3.fromRGB(0,100,255)
            or Color3.fromRGB(0,255,0)
        existing.FillColor = color
        existing.OutlineColor = color
        return
    end
    if existing and existing.Parent then existing:Destroy() end
    EspHighlights[player] = nil
    local role = GetRole(player)
    local color = role == "Murder" and Color3.fromRGB(255,0,0)
        or role == "Sheriff" and Color3.fromRGB(0,100,255)
        or Color3.fromRGB(0,255,0)
    local h = Instance.new("Highlight")
    h.Name = "RedmagicESP"
    h.Adornee = char
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.6
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = char
    EspHighlights[player] = h
end

local function ApplyGunEsp()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "Gun" or obj.Name == "Knife" then
            if not GunHighlights[obj] or not GunHighlights[obj].Parent then
                local color = obj.Name == "Gun" and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 150, 0)
                local h = Instance.new("Highlight")
                h.Adornee = obj
                h.FillColor = color
                h.OutlineColor = color
                h.FillTransparency = 0.5
                h.Parent = obj
                GunHighlights[obj] = h
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if EspEnabled then
        for _, p in pairs(PlayersService:GetPlayers()) do ApplyPlayerEsp(p) end
    else
        for plr, h in pairs(EspHighlights) do if h and h.Parent then h:Destroy() end end
        EspHighlights = {}
    end
    if GunEspEnabled then ApplyGunEsp()
    else
        for obj, h in pairs(GunHighlights) do if h and h.Parent then h:Destroy() end end
        GunHighlights = {}
    end
end)

local function HookCharEsp(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.3)
        if EspEnabled then ApplyPlayerEsp(p) end
    end)
end
for _, p in pairs(PlayersService:GetPlayers()) do HookCharEsp(p) end
PlayersService.PlayerAdded:Connect(HookCharEsp)

local shootOffset = 2.8

local function GetGunTool()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if char then local g = char:FindFirstChild("Gun"); if g then return g end end
    if bp then local g = bp:FindFirstChild("Gun"); if g then return g end end
    return nil
end

local function FindMurderer()
    for _, p in pairs(PlayersService:GetPlayers()) do
        if p ~= LocalPlayer and GetRole(p) == "Murder" then return p end
    end
    return nil
end

local function GetPredictedPosition(targetPlayer)
    local char = targetPlayer.Character
    if not char then return Vector3.new(0, 0, 0) end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return Vector3.new(0, 0, 0) end
    local velocity = hrp.AssemblyLinearVelocity
    local moveDir = hum.MoveDirection
    local predictedPosition = hrp.Position + ((velocity * Vector3.new(0.75, 0.5, 0.75)) * (shootOffset / 15)) + moveDir * shootOffset
    return Vector3.new(
        predictedPosition.X,
        math.clamp(predictedPosition.Y, hrp.Position.Y - 2, hrp.Position.Y + 2),
        predictedPosition.Z
    )
end

local lastFire = 0
RunService.RenderStepped:Connect(function()
    if not SilentEnabled then return end
    local gun = GetGunTool()
    if not gun then return end
    local target = nil
    if SilentAutoShot or SilentAutoKiller then
        target = FindMurderer()
    end
    if not target and SilentAutoSheriff then
        for _, p in pairs(PlayersService:GetPlayers()) do
            if p ~= LocalPlayer and GetRole(p) == "Sheriff" then target = p break end
        end
    end
    if not target or not target.Character then return end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    local dir = (hrp.Position - myHrp.Position).Unit * 50
    local hit = Workspace:Raycast(myHrp.Position, dir, rayParams)
    if hit and not hit.Instance:IsDescendantOf(target.Character) then return end
    if tick() - lastFire < 0.1 then return end
    lastFire = tick()
    local rightHand = LocalPlayer.Character:FindFirstChild("RightHand") or LocalPlayer.Character:FindFirstChild("Right Arm")
    if not rightHand then return end
    local predictedPosition = GetPredictedPosition(target)
    local shootRemote = gun:FindFirstChild("Shoot")
    if shootRemote then
        local args = {
            CFrame.new(rightHand.Position),
            CFrame.new(predictedPosition)
        }
        pcall(function()
            shootRemote:FireServer(table.unpack(args))
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    if not AutoGunPickupEnabled then return end
    if GetRole(LocalPlayer) == "Sheriff" then return end
    if tick() - AutoGunCooldown < 1 then return end
    AutoGunCooldown = tick()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local hrp = myChar.HumanoidRootPart
    local gd = Workspace:FindFirstChild("GunDrop", true) or Workspace:FindFirstChild("Gun", true)
    if gd then
        local old = hrp.CFrame
        local target = gd:IsA("Model") and (gd:FindFirstChild("Handle") or gd:FindFirstChildWhichIsA("BasePart")) or gd
        if target and target:IsA("BasePart") then
            hrp.CFrame = target.CFrame * CFrame.new(0, 1, 0)
            task.wait(0.2)
            hrp.CFrame = old
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoFarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local folder = Workspace:FindFirstChild("Normal") or Workspace
            local closest, dist = nil, math.huge
            for _, o in pairs(folder:GetDescendants()) do
                if o:IsA("BasePart") and o.Parent and not coins[o] and
                   (o.Name:sub(1,4) == "Coin" or o.Name == "GoldCoin" or o.Name == "CandyCane" or o:GetAttribute("Coin")) then
                    local d = (hrp.Position - o.Position).Magnitude
                    if d < dist then closest, dist = o, d end
                end
            end
            if closest then
                coins[closest] = true
                task.delay(5, function() coins[closest] = nil end)
                local tw = TweenService:Create(hrp, TweenInfo.new(dist / 22, Enum.EasingStyle.Linear), {CFrame = closest.CFrame})
                tw:Play()
                tw.Completed:Wait()
            end
        end
    end
end)

local ChatScroll = Instance.new("ScrollingFrame")
ChatScroll.Size = UDim2.new(1, -20, 1, -70)
ChatScroll.Position = UDim2.new(0, 10, 0, 10)
ChatScroll.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
ChatScroll.BackgroundTransparency = 0.3
ChatScroll.BorderSizePixel = 0
ChatScroll.ScrollBarThickness = 3
ChatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ChatScroll.Parent = ContainerAi
local ChatScrollCorner = Instance.new("UICorner"); ChatScrollCorner.CornerRadius = UDim.new(0, 6); ChatScrollCorner.Parent = ChatScroll

local ChatLayout = Instance.new("UIListLayout")
ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatLayout.Padding = UDim.new(0, 6)
ChatLayout.Parent = ChatScroll

local ChatPad = Instance.new("UIPadding")
ChatPad.PaddingTop = UDim.new(0, 8)
ChatPad.PaddingLeft = UDim.new(0, 8)
ChatPad.PaddingRight = UDim.new(0, 8)
ChatPad.Parent = ChatScroll

local function AddMessage(who, text, color)
    local bubble = Instance.new("Frame")
    bubble.Size = UDim2.new(1, -10, 0, 0)
    bubble.AutomaticSize = Enum.AutomaticSize.Y
    bubble.BackgroundTransparency = 1
    bubble.Parent = ChatScroll
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.BackgroundColor3 = color or Color3.fromRGB(30, 30, 30)
    lbl.BackgroundTransparency = 0.2
    lbl.Text = who .. ": " .. text
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.Parent = bubble
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = lbl
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = lbl
    task.wait()
    ChatScroll.CanvasPosition = Vector2.new(0, ChatScroll.AbsoluteCanvasSize.Y)
    return lbl
end

AddMessage("JARVIS", "Привет, я JARVIS. Пиши свой запрос, отвечу.", Color3.fromRGB(40, 20, 20))

local InputBar = Instance.new("Frame")
InputBar.Size = UDim2.new(1, -20, 0, 44)
InputBar.Position = UDim2.new(0, 10, 1, -54)
InputBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InputBar.BackgroundTransparency = 0.15
InputBar.BorderSizePixel = 0
InputBar.Parent = ContainerAi
local InputBarCorner = Instance.new("UICorner"); InputBarCorner.CornerRadius = UDim.new(1, 0); InputBarCorner.Parent = InputBar

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -60, 1, -8)
InputBox.Position = UDim2.new(0, 12, 0, 4)
InputBox.BackgroundTransparency = 1
InputBox.Text = ""
InputBox.PlaceholderText = "Напиши JARVIS..."
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
InputBox.TextSize = 14
InputBox.Font = Enum.Font.Gotham
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.ClearTextOnFocus = false
InputBox.Parent = InputBar

local SendBtn = Instance.new("TextButton")
SendBtn.Size = UDim2.new(0, 40, 0, 36)
SendBtn.Position = UDim2.new(1, -46, 0.5, -18)
SendBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
SendBtn.Text = ">"
SendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SendBtn.TextSize = 18
SendBtn.Font = Enum.Font.GothamBold
SendBtn.Parent = InputBar
local SendCorner = Instance.new("UICorner"); SendCorner.CornerRadius = UDim.new(1, 0); SendCorner.Parent = SendBtn

local function SendToJarvis(prompt)
    if prompt == "" then return end
    AddMessage("ТЫ", prompt, Color3.fromRGB(25, 35, 25))
    local thinkingLabel = AddMessage("JARVIS", "подожди нейросеть думает...", Color3.fromRGB(80, 0, 0))
    thinkingLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
    local url = "https://text.pollinations.ai/" .. HttpService:UrlEncode(prompt) .. "?system=" .. HttpService:UrlEncode("Ты JARVIS, кратко отвечай на русском.")
    task.spawn(function()
        local ok, res = pcall(function() return game:HttpGet(url) end)
        thinkingLabel.Parent:Destroy()
        if ok and res and #res > 0 then
            AddMessage("JARVIS", res, Color3.fromRGB(40, 20, 20))
        else
            AddMessage("JARVIS", "ошибка соединения.", Color3.fromRGB(60, 20, 20))
        end
    end)
end

SendBtn.MouseButton1Click:Connect(function()
    PlayClickSfx()
    local txt = InputBox.Text
    InputBox.Text = ""
    SendToJarvis(txt)
end)

InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local txt = InputBox.Text
        InputBox.Text = ""
        SendToJarvis(txt)
    end
end)

BuildPlayerList()