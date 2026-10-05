local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = PlayersService.LocalPlayer
local Camera = Workspace.CurrentCamera

local sfxHost = Instance.new("ScreenGui")
sfxHost.Name = "RedmagicSfxHost"
sfxHost.ResetOnSpawn = false
pcall(function() sfxHost.Parent = game.CoreGui end)
if not sfxHost.Parent then sfxHost.Parent = LocalPlayer:WaitForChild("PlayerGui") end
local ClickSfx = Instance.new("Sound")
ClickSfx.SoundId = "rbxassetid://9116158538"
ClickSfx.Volume = 0.7
ClickSfx.Parent = sfxHost
local function PlayClickSfx()
    pcall(function()
        local c = ClickSfx:Clone()
        c.Parent = sfxHost
        c:Play()
        task.delay(2, function() if c then c:Destroy() end end)
    end)
end

do
    local loadGui = Instance.new("ScreenGui")
    loadGui.Name = "RedmagicLoading"
    loadGui.ResetOnSpawn = false
    loadGui.IgnoreGuiInset = true
    loadGui.DisplayOrder = 9999
    pcall(function() loadGui.Parent = game.CoreGui end)
    if not loadGui.Parent then loadGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
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
    loadBox.BorderSizePixel = 0
    loadBox.Parent = loadGui
    local lbc = Instance.new("UICorner")
    lbc.CornerRadius = UDim.new(0, 10)
    lbc.Parent = loadBox
    local lbs = Instance.new("UIStroke")
    lbs.Color = Color3.fromRGB(200, 0, 0)
    lbs.Thickness = 1.5
    lbs.Transparency = 0.3
    lbs.Parent = loadBox
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 50)
    t.Position = UDim2.new(0, 0, 0, 8)
    t.BackgroundTransparency = 1
    t.Text = "REDMAGIC"
    t.TextColor3 = Color3.fromRGB(255, 30, 30)
    t.TextSize = 28
    t.Font = Enum.Font.GothamBold
    t.Parent = loadBox
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 22)
    sub.Position = UDim2.new(0, 0, 0, 58)
    sub.BackgroundTransparency = 1
    sub.Text = "загрузка..."
    sub.TextColor3 = Color3.fromRGB(255, 60, 60)
    sub.TextSize = 14
    sub.Font = Enum.Font.GothamMedium
    sub.Parent = loadBox
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0, 260, 0, 10)
    barBg.Position = UDim2.new(0.5, -130, 0, 95)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    barBg.BorderSizePixel = 0
    barBg.Parent = loadBox
    local bbc = Instance.new("UICorner")
    bbc.CornerRadius = UDim.new(1, 0)
    bbc.Parent = barBg
    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg
    local bfc = Instance.new("UICorner")
    bfc.CornerRadius = UDim.new(1, 0)
    bfc.Parent = barFill
    pcall(function()
        local snd = Instance.new("Sound")
        snd.SoundId = "rbxassetid://338224404"
        snd.Volume = 3
        snd.Looped = false
        snd.Parent = loadGui
        snd:Play()
    end)
    local startTime = tick()
    while true do
        local pct = math.clamp((tick() - startTime) / 8, 0, 1)
        barFill.Size = UDim2.new(pct, 0, 1, 0)
        if pct >= 1 then break end
        RunService.Heartbeat:Wait()
    end
    pcall(function() loadGui:Destroy() end)
end

local EspEnabled = false
local InfJumpEnabled = false
local NoClipEnabled = false
local AimbotEnabled = false
local AimbotMurder = false
local AimbotSheriff = false
local AutoShotEnabled = false
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
local AutoShotCooldown = 0
local AUTO_SHOT_INTERVAL = 0.35
local coins = {}
local lastMoveDir = Vector3.new(0, 0, -1)

local flyActive = false
local flySpeed = 60
local flyCtrl = {f=0,b=0,l=0,r=0,up=0,down=0}
local flyLastCtrl = {f=0,b=0,l=0,r=0}
local flySpeedVal = 0
local FLY_MAXSPEED = 50

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

local SpawnPosition = nil
local SPAWN_RADIUS = 150
do
    task.spawn(function()
        while true do
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and not SpawnPosition then
                    SpawnPosition = hrp.Position
                end
            end
            task.wait(1)
        end
    end)
end
local function IsOnSpawn(player)
    if not SpawnPosition then return false end
    if not player or not player.Character then return true end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    return (hrp.Position - SpawnPosition).Magnitude < SPAWN_RADIUS
end

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

local roleCache = {}
local murdererName, sheriffName, heroName

local function readRoleFromRemote()
    local remote = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
    if not remote then return nil end
    local ok, roles = pcall(function() return remote:InvokeServer() end)
    if not ok or type(roles) ~= "table" then return nil end
    return roles
end

local function HoldsGun(p)
    if not p then return false end
    local char = p.Character
    local bp = p:FindFirstChild("Backpack")
    local function scan(c)
        if not c then return false end
        if c:FindFirstChild("Gun") or c:FindFirstChild("GunVisuals") then return true end
        local rh = c:FindFirstChild("RightHand") or c:FindFirstChild("Right Arm")
        if rh and (rh:FindFirstChild("Gun") or rh:FindFirstChild("GunVisuals")) then return true end
        if c:IsA("Tool") and (c.Name:lower():find("gun") or c.Name:lower():find("pistol")) then return true end
        return false
    end
    return scan(char) or scan(bp)
end

local function HoldsKnife(p)
    if not p then return false end
    local char = p.Character
    local bp = p:FindFirstChild("Backpack")
    local function scan(c)
        if not c then return false end
        if c:FindFirstChild("Knife") or c:FindFirstChild("KnifeVisuals") then return true end
        local rh = c:FindFirstChild("RightHand") or c:FindFirstChild("Right Arm")
        if rh and (rh:FindFirstChild("Knife") or rh:FindFirstChild("KnifeVisuals")) then return true end
        if c:IsA("Tool") and (c.Name:lower():find("knife") or c.Name:lower():find("dagger")) then return true end
        return false
    end
    return scan(char) or scan(bp)
end

local function readRoleFromStatus(p)
    if not p then return "Innocent" end
    local st = p:FindFirstChild("Status")
    if st then
        local r = st:FindFirstChild("Role")
        if r and r.Value then
            local v = tostring(r.Value)
            if v == "Murderer" then return "Murderer" end
            if v == "Sheriff" then return "Sheriff" end
            if v == "Hero" then return "Hero" end
        end
    end
    local ls = p:FindFirstChild("leaderstats")
    if ls then
        local r = ls:FindFirstChild("Role")
        if r and r.Value then
            local v = tostring(r.Value)
            if v == "Murderer" then return "Murderer" end
            if v == "Sheriff" then return "Sheriff" end
            if v == "Hero" then return "Hero" end
        end
    end
    if HoldsKnife(p) then return "Murderer" end
    if HoldsGun(p) then
        local c = roleCache[p.Name]
        if c and c.Role == "Hero" then return "Hero" end
        return "Sheriff"
    end
    return "Innocent"
end

local function IsPhysicallyAlive(p)
    if not p then return false end
    local char = p.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.Health > 0
end

local function RefreshRoles()
    local newCache = {}
    local remoteData = readRoleFromRemote()
    if remoteData then
        for name, data in pairs(remoteData) do
            if type(data) == "table" then
                local role = data.Role or "Innocent"
                local plr = PlayersService:FindFirstChild(name)
                local physicallyDead = plr and not IsPhysicallyAlive(plr)
                local killed = data.Killed == true or data.Dead == true or physicallyDead
                newCache[name] = { Role = role, Killed = killed, Dead = killed }
            end
        end
    end
    for _, p in pairs(PlayersService:GetPlayers()) do
        if p ~= LocalPlayer then
            if not newCache[p.Name] then
                local role = readRoleFromStatus(p)
                local alive = IsPhysicallyAlive(p)
                newCache[p.Name] = { Role = role, Killed = not alive, Dead = not alive }
            end
            local c = newCache[p.Name]
            if c and not (c.Killed or c.Dead) then
                if HoldsKnife(p) then
                    c.Role = "Murderer"
                elseif HoldsGun(p) and c.Role ~= "Hero" and c.Role ~= "Sheriff" then
                    c.Role = "Sheriff"
                end
            end
        end
    end
    local mName, sName, hName
    for name, c in pairs(newCache) do
        if not (c.Killed or c.Dead) then
            if c.Role == "Murderer" then mName = name
            elseif c.Role == "Sheriff" then sName = name
            elseif c.Role == "Hero" then hName = name end
        end
    end
    roleCache = newCache
    murdererName, sheriffName, heroName = mName, sName, hName
end

local function GetRole(p)
    if not p then return "Innocent" end
    if not IsPhysicallyAlive(p) then return "Innocent" end
    local c = roleCache[p.Name]
    if c then
        if c.Killed or c.Dead then return "Innocent" end
        if c.Role == "Murderer" then return "Murder" end
        if c.Role == "Sheriff" then return "Sheriff" end
        if c.Role == "Hero" then return "Hero" end
    end
    local r = readRoleFromStatus(p)
    if r == "Murderer" then return "Murder" end
    if r == "Sheriff" then return "Sheriff" end
    if r == "Hero" then return "Hero" end
    return "Innocent"
end

local function roleColor(role)
    if role == "Murder" then return Color3.fromRGB(255, 50, 50) end
    if role == "Sheriff" then return Color3.fromRGB(50, 120, 255) end
    if role == "Hero" then return Color3.fromRGB(255, 250, 0) end
    return Color3.fromRGB(80, 220, 80)
end

local function AskESP_Murderer()
    for _, p in pairs(PlayersService:GetPlayers()) do
        if p ~= LocalPlayer and GetRole(p) == "Murder" then return p end
    end
    return nil
end

local function AskESP_Sheriff()
    for _, p in pairs(PlayersService:GetPlayers()) do
        if p ~= LocalPlayer and GetRole(p) == "Sheriff" then
            local c = roleCache[p.Name]
            if c then
                if not (c.Killed or c.Dead) then return p end
            elseif IsPhysicallyAlive(p) then
                return p
            end
        end
    end
    return nil
end

local function IsSheriffDead()
    if not sheriffName then return true end
    local c = roleCache[sheriffName]
    if not c then return true end
    return (c.Killed or c.Dead)
end

local function IsLocalPlayerAlive()
    return IsPhysicallyAlive(LocalPlayer)
end

local EspHighlights = {}
local function CreateHighlight()
    for _, v in pairs(PlayersService:GetChildren()) do
        if v ~= LocalPlayer and v.Character and not v.Character:FindFirstChild("RedmagicESP") then
            local h = Instance.new("Highlight")
            h.Name = "RedmagicESP"
            h.Adornee = v.Character
            h.FillTransparency = 0.6
            h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = v.Character
            EspHighlights[v] = h
        end
    end
end

local function UpdateHighlights()
    for _, v in pairs(PlayersService:GetChildren()) do
        if v ~= LocalPlayer and v.Character then
            local hl = v.Character:FindFirstChild("RedmagicESP")
            if hl then
                local role = GetRole(v)
                local color = roleColor(role)
                hl.FillColor = color
                hl.OutlineColor = color
            end
        end
    end
end

local function ClearHighlights()
    for _, v in pairs(PlayersService:GetChildren()) do
        if v ~= LocalPlayer and v.Character then
            local hl = v.Character:FindFirstChild("RedmagicESP")
            if hl then hl:Destroy() end
        end
    end
    EspHighlights = {}
end

local function ToggleSkyStar()
    visualState.skyStar = not visualState.skyStar
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") then pcall(function() obj:Destroy() end) end
    end
    if visualState.skyStar then
        pcall(function()
            local objs = game:GetObjects("rbxassetid://" .. SKY_STARRY_ID)
            local sky
            local function findSky(o)
                if sky then return end
                if o:IsA("Sky") then sky = o return end
                for _, c in ipairs(o:GetChildren()) do findSky(c) end
            end
            for _, o in ipairs(objs) do findSky(o) if sky then break end end
            if sky then sky:Clone().Parent = Lighting end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end)
    end
end

local function ToggleSkyDark()
    visualState.skyDark = not visualState.skyDark
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") then pcall(function() obj:Destroy() end) end
    end
    if visualState.skyDark then
        pcall(function()
            local objs = game:GetObjects("rbxassetid://" .. SKY_DARK_ID)
            local sky
            local function findSky(o)
                if sky then return end
                if o:IsA("Sky") then sky = o return end
                for _, c in ipairs(o:GetChildren()) do findSky(c) end
            end
            for _, o in ipairs(objs) do findSky(o) if sky then break end end
            if sky then sky:Clone().Parent = Lighting end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end)
    end
end

local function ToggleFog()
    visualState.fog = not visualState.fog
    if visualState.fog then
        visualState.fogBackup = {End=Lighting.FogEnd, Start=Lighting.FogStart, Color=Lighting.FogColor}
        Lighting.FogEnd = 80
        Lighting.FogStart = 5
        Lighting.FogColor = Color3.fromRGB(120, 120, 130)
    elseif visualState.fogBackup then
        Lighting.FogEnd = visualState.fogBackup.End
        Lighting.FogStart = visualState.fogBackup.Start
        Lighting.FogColor = visualState.fogBackup.Color
    end
end

local function ToggleBeauty()
    visualState.beauty = not visualState.beauty
    if visualState.beauty then
        visualState.beautyBackup = {
            ClockTime=Lighting.ClockTime, Brightness=Lighting.Brightness,
            Ambient=Lighting.Ambient, OutdoorAmbient=Lighting.OutdoorAmbient,
        }
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.5
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(10, 10, 25)
        Lighting.GlobalShadows = true
    elseif visualState.beautyBackup then
        Lighting.ClockTime = visualState.beautyBackup.ClockTime
        Lighting.Brightness = visualState.beautyBackup.Brightness
        Lighting.Ambient = visualState.beautyBackup.Ambient
        Lighting.OutdoorAmbient = visualState.beautyBackup.OutdoorAmbient
    end
end

local function ToggleRain()
    visualState.rain = not visualState.rain
    if visualState.rain then
        local cam = Workspace.CurrentCamera
        if cam then
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://" .. RAIN_AUDIO_ID
            s.Volume = 1
            s.Looped = true
            s.RollOffMaxDistance = 100000
            s.Parent = cam
            pcall(function() s:Play() end)
            visualState.rainSound = s
        end
    elseif visualState.rainSound then
        pcall(function() visualState.rainSound:Stop(); visualState.rainSound:Destroy() end)
        visualState.rainSound = nil
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
                part.Anchored = false
                part.CanCollide = false
                part.Massless = true
                part.CFrame = hrp.CFrame
            end)
            local w = Instance.new("WeldConstraint")
            w.Part0 = hrp
            w.Part1 = part
            w.Parent = part
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
    s.Volume = 10
    s.Looped = true
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
        hl.FillTransparency = 1
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = visualState.tornadoModel
        visualState.tornadoEspHL = hl
    elseif visualState.tornadoEspHL then
        visualState.tornadoEspHL:Destroy()
        visualState.tornadoEspHL = nil
    end
end

local function ToggleLightning()
    visualState.lightning = not visualState.lightning
    if visualState.lightning then
        visualState.tornadoLightningConn = RunService.Heartbeat:Connect(function()
            if not visualState.lightning then return end
            if math.random() < 0.03 then
                Lighting.Brightness = 5
                Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 255)
                task.wait(math.random(5, 15) / 100)
                Lighting.Brightness = 0.2
                Lighting.OutdoorAmbient = Color3.fromRGB(5, 5, 15)
            end
        end)
    elseif visualState.tornadoLightningConn then
        visualState.tornadoLightningConn:Disconnect()
        visualState.tornadoLightningConn = nil
    end
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
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
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
                p.Anchored = false
                p.CanCollide = false
                p.Massless = true
                p.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
            end
        end
        local weldCF = rightHand.CFrame * CFrame.new(0, -0.6, -1.2) * CFrame.Angles(math.rad(-90), 0, 0)
        pcall(function() awp:PivotTo(weldCF) end)
        local motor = Instance.new("Motor6D")
        motor.Name = "RedmagicAwpMotor"
        motor.Part0 = rightHand
        motor.Part1 = handle
        motor.C0 = CFrame.new(0, -0.6, -1.2) * CFrame.Angles(math.rad(-90), 0, 0)
        motor.C1 = CFrame.new()
        motor.Parent = rightHand
        for _, p in ipairs(awp:GetDescendants()) do
            if p:IsA("BasePart") and p ~= handle then
                local w = Instance.new("WeldConstraint")
                w.Part0 = handle
                w.Part1 = p
                w.Parent = p
            end
        end
        return awp
    elseif awp:IsA("BasePart") then
        awp.Parent = char
        awp.Anchored = false
        awp.CanCollide = false
        awp.Massless = true
        awp.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
        local motor = Instance.new("Motor6D")
        motor.Name = "RedmagicAwpMotor"
        motor.Part0 = rightHand
        motor.Part1 = awp
        motor.C0 = CFrame.new(0, -0.6, -1.2) * CFrame.Angles(math.rad(-90), 0, 0)
        motor.C1 = CFrame.new()
        motor.Parent = rightHand
        return awp
    end
    return nil
end

local function ToggleAwp()
    awpOn = not awpOn
    if awpOn then ClearAwp(); awpModel = BuildAwpModel() else ClearAwp() end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedmagicGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 900
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 170, 0, 55)
ToggleButton.Position = UDim2.new(0.5, -85, 0, 15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.BackgroundTransparency = 0.35
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "REDMAGIC"
ToggleButton.TextColor3 = Color3.fromRGB(255, 30, 30)
ToggleButton.TextSize = 17
ToggleButton.Font = Enum.Font.GothamMedium
ToggleButton.ZIndex = 50
ToggleButton.Parent = ScreenGui
local TogCorner = Instance.new("UICorner")
TogCorner.CornerRadius = UDim.new(1, 0)
TogCorner.Parent = ToggleButton
local TogStroke = Instance.new("UIStroke")
TogStroke.Color = Color3.fromRGB(255, 30, 30)
TogStroke.Thickness = 1
TogStroke.Transparency = 0.6
TogStroke.Parent = ToggleButton

local btnDragging, btnDragStart, btnStartPos
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true
        btnDragStart = input.Position
        btnStartPos = ToggleButton.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        ToggleButton.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = false
    end
end)

local WIN_W, WIN_H = 620, 340
local SIDEBAR_W = 120
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, WIN_W, 0, WIN_H)
MainFrame.Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BackgroundTransparency = 0.35
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.ZIndex = 5
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 0, 0)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

local HeaderGui = Instance.new("ScreenGui")
HeaderGui.Name = "RedmagicHeader"
HeaderGui.ResetOnSpawn = false
HeaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
HeaderGui.IgnoreGuiInset = true
HeaderGui.DisplayOrder = 901
pcall(function() HeaderGui.Parent = game.CoreGui end)
if not HeaderGui.Parent then HeaderGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local HeaderBar = Instance.new("Frame")
HeaderBar.Size = UDim2.new(0, WIN_W, 0, 40)
HeaderBar.Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2 - 48)
HeaderBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
HeaderBar.BackgroundTransparency = 0.3
HeaderBar.BorderSizePixel = 0
HeaderBar.Visible = false
HeaderBar.Parent = HeaderGui
local HeaderBarCorner = Instance.new("UICorner")
HeaderBarCorner.CornerRadius = UDim.new(0, 12)
HeaderBarCorner.Parent = HeaderBar
local HeaderBarStroke = Instance.new("UIStroke")
HeaderBarStroke.Color = Color3.fromRGB(200, 20, 20)
HeaderBarStroke.Thickness = 1.3
HeaderBarStroke.Transparency = 0.2
HeaderBarStroke.Parent = HeaderBar

local HeaderAvatar = Instance.new("ImageLabel")
HeaderAvatar.Size = UDim2.new(0, 20, 0, 20)
HeaderAvatar.Position = UDim2.new(0, 14, 0.5, -10)
HeaderAvatar.BackgroundTransparency = 1
HeaderAvatar.Image = "rbxassetid://" .. ICON_ID
HeaderAvatar.ScaleType = Enum.ScaleType.Crop
HeaderAvatar.Parent = HeaderBar
local HeaderAvatarCorner = Instance.new("UICorner")
HeaderAvatarCorner.CornerRadius = UDim.new(0, 4)
HeaderAvatarCorner.Parent = HeaderAvatar

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(0, 200, 1, 0)
HeaderTitle.Position = UDim2.new(0, 40, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "REDMAGIC"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 30, 30)
HeaderTitle.TextSize = 20
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = HeaderBar

local function MakeHeaderPill(text, xOff, width)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, width, 0, 26)
    b.Position = UDim2.new(1, xOff, 0.5, -13)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 66)
    b.BackgroundTransparency = 0.25
    b.Text = text
    b.TextColor3 = Color3.fromRGB(235, 235, 235)
    b.TextSize = 12
    b.Font = Enum.Font.GothamMedium
    b.BorderSizePixel = 0
    b.Parent = HeaderBar
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = b
    return b
end

local PillGeneral = MakeHeaderPill("General", -190, 84)
local PillUis = MakeHeaderPill("UIS", -96, 58)

local HeaderCloseBtn = Instance.new("TextButton")
HeaderCloseBtn.Size = UDim2.new(0, 26, 0, 26)
HeaderCloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
HeaderCloseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 66)
HeaderCloseBtn.BackgroundTransparency = 0.25
HeaderCloseBtn.Text = "x"
HeaderCloseBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
HeaderCloseBtn.TextSize = 14
HeaderCloseBtn.Font = Enum.Font.GothamBold
HeaderCloseBtn.BorderSizePixel = 0
HeaderCloseBtn.Parent = HeaderBar
local HCcorner = Instance.new("UICorner")
HCcorner.CornerRadius = UDim.new(1, 0)
HCcorner.Parent = HeaderCloseBtn
HeaderCloseBtn.MouseButton1Click:Connect(function()
    PlayClickSfx()
    MainFrame.Visible = false
    HeaderBar.Visible = false
end)

ToggleButton.MouseButton1Click:Connect(function()
    PlayClickSfx()
    MainFrame.Visible = not MainFrame.Visible
    HeaderBar.Visible = MainFrame.Visible
    if MainFrame.Visible then
        HeaderBar.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset,
                                        MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - 48)
    end
end)

local dragging, dragStart, startPos
local function beginDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end
MainFrame.InputBegan:Connect(beginDrag)
HeaderBar.InputBegan:Connect(beginDrag)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        HeaderBar.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset,
                                        MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - 48)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Sidebar.BackgroundTransparency = 0.35
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

local IconBox = Instance.new("Frame")
IconBox.Size = UDim2.new(1, -16, 0, 62)
IconBox.Position = UDim2.new(0, 8, 0, 8)
IconBox.BackgroundTransparency = 1
IconBox.BorderSizePixel = 0
IconBox.ZIndex = 3
IconBox.ClipsDescendants = true
IconBox.Parent = Sidebar
local IB_corner = Instance.new("UICorner")
IB_corner.CornerRadius = UDim.new(0, 6)
IB_corner.Parent = IconBox
local IconImage = Instance.new("ImageLabel")
IconImage.Size = UDim2.new(1, 0, 1, 0)
IconImage.BackgroundTransparency = 1
IconImage.BorderSizePixel = 0
IconImage.Image = "rbxassetid://" .. ICON_ID
IconImage.ScaleType = Enum.ScaleType.Crop
IconImage.ZIndex = 4
IconImage.Parent = IconBox
local II_corner = Instance.new("UICorner")
II_corner.CornerRadius = UDim.new(0, 6)
II_corner.Parent = IconImage

local function CreateTabButton(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 30)
    btn.Position = UDim2.new(0, 6, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    btn.BackgroundTransparency = 0.55
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(140, 140, 140)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = Sidebar
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.Parent = btn
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

local ContainerMain = CreateContainer()
ContainerMain.Visible = true
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

local allTabs = {TabMainBtn, TabCombatBtn, TabPlayersBtn, TabVisualBtn, TabRadioBtn, TabAiBtn, TabInfoBtn}
local allContainers = {ContainerMain, ContainerCombat, ContainerPlayers, ContainerVisual, ContainerRadio, ContainerAi, ContainerInfo}

local function ColorTabs(active)
    for _, t in ipairs(allTabs) do
        t.TextColor3 = (t == active) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        t.BackgroundColor3 = (t == active) and Color3.fromRGB(45, 0, 0) or Color3.fromRGB(25, 25, 25)
    end
end

local function ShowTab(idx)
    for i, c in ipairs(allContainers) do c.Visible = (i == idx) end
    ColorTabs(allTabs[idx])
end

TabMainBtn.MouseButton1Click:Connect(function() PlayClickSfx(); ShowTab(1) end)
TabCombatBtn.MouseButton1Click:Connect(function() PlayClickSfx(); ShowTab(2) end)
TabPlayersBtn.MouseButton1Click:Connect(function() PlayClickSfx(); ShowTab(3) end)
TabVisualBtn.MouseButton1Click:Connect(function() PlayClickSfx(); ShowTab(4) end)
TabRadioBtn.MouseButton1Click:Connect(function() PlayClickSfx(); ShowTab(5) end)
TabAiBtn.MouseButton1Click:Connect(function() PlayClickSfx(); ShowTab(6) end)
TabInfoBtn.MouseButton1Click:Connect(function() PlayClickSfx(); ShowTab(7) end)
PillGeneral.MouseButton1Click:Connect(function() PlayClickSfx(); ShowTab(1) end)
PillUis.MouseButton1Click:Connect(function() PlayClickSfx(); ShowTab(4) end)

local function CreateWindowSetting(titleText, rows, callbacks)
    local SettingGui = Instance.new("ScreenGui")
    SettingGui.Name = "Setting_" .. titleText
    SettingGui.ResetOnSpawn = false
    SettingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SettingGui.IgnoreGuiInset = true
    SettingGui.DisplayOrder = 950
    pcall(function() SettingGui.Parent = game.CoreGui end)
    if not SettingGui.Parent then SettingGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    local rowH = 34
    local height = 30 + #rows * rowH + 10
    local Window = Instance.new("Frame")
    Window.Size = UDim2.new(0, 260, 0, height)
    Window.Position = UDim2.new(0.5, 200, 0.5, -height / 2)
    Window.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    Window.BackgroundTransparency = 0.35
    Window.Visible = false
    Window.Parent = SettingGui
    local wCorner = Instance.new("UICorner")
    wCorner.CornerRadius = UDim.new(0, 8)
    wCorner.Parent = Window
    local wStroke = Instance.new("UIStroke")
    wStroke.Color = Color3.fromRGB(120, 0, 0)
    wStroke.Thickness = 1
    wStroke.Transparency = 0.3
    wStroke.Parent = Window
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 26)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Window
    local dg, ds, sp
    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dg = true; ds = input.Position; sp = Window.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dg and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - ds
            Window.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dg = false end
    end)
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
            btn.BackgroundColor3 = row[2] and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(45, 45, 50)
            btn.Text = ""
            btn.Parent = Window
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = btn
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = row[2] and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Parent = btn
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob
            local state = row[2]
            btn.MouseButton1Click:Connect(function()
                PlayClickSfx()
                state = not state
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = state and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(45, 45, 50)}):Play()
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
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 4)
            c.Parent = tb
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
    Frame.BackgroundTransparency = 0.35
    Frame.BorderSizePixel = 0
    Frame.Parent = parentContainer
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(60, 60, 65)
    Stroke.Thickness = 1
    Stroke.Transparency = 0.4
    Stroke.Parent = Frame
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
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    Knob.BorderSizePixel = 0
    Knob.Parent = Track
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob
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
        local gc = Instance.new("UICorner")
        gc.CornerRadius = UDim.new(0, 6)
        gc.Parent = GearBtn
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
            TweenService:Create(Track, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(180, 0, 0)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 22, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.25), {Color = Color3.fromRGB(180, 0, 0), Transparency = 0.2}):Play()
        else
            TweenService:Create(Track, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.25), {Color = Color3.fromRGB(60, 60, 65), Transparency = 0.4}):Play()
        end
        if toggleCb then toggleCb(state) end
    end)
    return state
end

local function OpenColorPicker(title, currentColorKey, onSelect)
    local picker = Instance.new("Frame")
    picker.Size = UDim2.new(0, 240, 0, 340)
    picker.Position = UDim2.new(0.5, -120, 0.5, -170)
    picker.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    picker.BackgroundTransparency = 0.25
    picker.BorderSizePixel = 0
    picker.ZIndex = 30
    picker.Parent = ScreenGui
    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(0, 10)
    pc.Parent = picker
    local ps = Instance.new("UIStroke")
    ps.Color = Color3.fromRGB(120, 0, 0)
    ps.Thickness = 1
    ps.Transparency = 0.3
    ps.Parent = picker
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 34)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextSize = 15
    t.Font = Enum.Font.GothamBold
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
    close.Parent = picker
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 6)
    cc.Parent = close
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
        b.BackgroundTransparency = 0.15
        b.Text = COLOR_LABELS[key]
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 13
        b.Font = Enum.Font.GothamMedium
        b.BorderSizePixel = 0
        b.Parent = picker
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 6)
        bc.Parent = b
        local col = COLOR_VALUES[key]
        if col then
            local strip = Instance.new("Frame")
            strip.Size = UDim2.new(0, 10, 1, 0)
            strip.Position = UDim2.new(1, -14, 0, 0)
            strip.BackgroundColor3 = col
            strip.BorderSizePixel = 0
            strip.Parent = b
            local sc = Instance.new("UICorner")
            sc.CornerRadius = UDim.new(0, 4)
            sc.Parent = strip
        end
        b.MouseButton1Click:Connect(function()
            PlayClickSfx()
            onSelect(key)
            picker:Destroy()
        end)
        y = y + 36
    end
end

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
    elseif input.KeyCode == Enum.KeyCode.LeftShift then flyCtrl.down = 1 end
end)

UserInputService.InputEnded:Connect(function(input)
    if not flyActive then return end
    if input.KeyCode == Enum.KeyCode.W then flyCtrl.f = 0
    elseif input.KeyCode == Enum.KeyCode.S then flyCtrl.b = 0
    elseif input.KeyCode == Enum.KeyCode.A then flyCtrl.l = 0
    elseif input.KeyCode == Enum.KeyCode.D then flyCtrl.r = 0
    elseif input.KeyCode == Enum.KeyCode.Space then flyCtrl.up = 0
    elseif input.KeyCode == Enum.KeyCode.LeftShift then flyCtrl.down = 0 end
end)

CreateToggle(ContainerMain, "INF JUMP", 50, nil, nil, function(s) InfJumpEnabled = s end)
CreateToggle(ContainerMain, "FLY", 92, {{"flySpeed", 60, "number"}}, {function(v) flySpeed = v end}, function(s)
    if s then StartFly() else StopFly() end
end)
CreateToggle(ContainerMain, "NOCLIP", 134, nil, nil, function(s) NoClipEnabled = s end)

CreateToggle(ContainerCombat, "AIMBOT", 10,
    {{"Aimbot Murder", false, "toggle"}, {"Aimbot Sheriff", false, "toggle"}},
    {function(v) AimbotMurder = v end, function(v) AimbotSheriff = v end},
    function(s) AimbotEnabled = s end
)
CreateToggle(ContainerCombat, "AUTO SHOT", 52, nil, nil, function(s) AutoShotEnabled = s end)
CreateToggle(ContainerCombat, "ESP PLAYERS", 94, nil, nil, function(s) EspEnabled = s end)
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
CreateToggle(ContainerCombat, "KILL ALL", 388, nil, nil, function(s) KillAllEnabled = s end)

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
        gear.BackgroundTransparency = 0.2
        gear.Text = "⚙"
        gear.TextColor3 = Color3.fromRGB(150, 150, 150)
        gear.TextSize = 13
        gear.Font = Enum.Font.GothamBold
        gear.BorderSizePixel = 0
        gear.Parent = rowFrame
        local gc = Instance.new("UICorner")
        gc.CornerRadius = UDim.new(0, 6)
        gc.Parent = gear
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

local radioHeader = Instance.new("TextLabel")
radioHeader.Size = UDim2.new(1, -20, 0, 44)
radioHeader.Position = UDim2.new(0, 10, 0, 0)
radioHeader.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
radioHeader.BackgroundTransparency = 0.3
radioHeader.BorderSizePixel = 0
radioHeader.Text = "RADIO"
radioHeader.TextColor3 = Color3.fromRGB(255, 40, 40)
radioHeader.TextSize = 20
radioHeader.Font = Enum.Font.GothamBold
radioHeader.Parent = ContainerRadio
local radH = Instance.new("UICorner")
radH.CornerRadius = UDim.new(0, 8)
radH.Parent = radioHeader

local radioSound = Instance.new("Sound")
radioSound.Volume = 1
radioSound.Looped = true
radioSound.Parent = ScreenGui

local radioIdBox = Instance.new("TextBox")
radioIdBox.Size = UDim2.new(1, -20, 0, 36)
radioIdBox.Position = UDim2.new(0, 10, 0, 76)
radioIdBox.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
radioIdBox.BackgroundTransparency = 0.25
radioIdBox.BorderSizePixel = 0
radioIdBox.PlaceholderText = "например 1837879082"
radioIdBox.Text = ""
radioIdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
radioIdBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
radioIdBox.TextSize = 14
radioIdBox.Font = Enum.Font.Gotham
radioIdBox.ClearTextOnFocus = false
radioIdBox.Parent = ContainerRadio
local ridC = Instance.new("UICorner")
ridC.CornerRadius = UDim.new(0, 6)
ridC.Parent = radioIdBox

local radioPlayBtn = Instance.new("TextButton")
radioPlayBtn.Size = UDim2.new(0.5, -15, 0, 34)
radioPlayBtn.Position = UDim2.new(0, 10, 0, 120)
radioPlayBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
radioPlayBtn.BackgroundTransparency = 0.2
radioPlayBtn.Text = "PLAY"
radioPlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
radioPlayBtn.TextSize = 14
radioPlayBtn.Font = Enum.Font.GothamBold
radioPlayBtn.Parent = ContainerRadio
local rpbC = Instance.new("UICorner")
rpbC.CornerRadius = UDim.new(0, 6)
rpbC.Parent = radioPlayBtn

local radioStopBtn = Instance.new("TextButton")
radioStopBtn.Size = UDim2.new(0.5, -15, 0, 34)
radioStopBtn.Position = UDim2.new(0.5, 5, 0, 120)
radioStopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
radioStopBtn.BackgroundTransparency = 0.25
radioStopBtn.Text = "STOP"
radioStopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
radioStopBtn.TextSize = 14
radioStopBtn.Font = Enum.Font.GothamBold
radioStopBtn.Parent = ContainerRadio
local rsbC = Instance.new("UICorner")
rsbC.CornerRadius = UDim.new(0, 6)
rsbC.Parent = radioStopBtn

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
    local seenSheriff = false
    local ordered = {}
    for _, p in pairs(PlayersService:GetPlayers()) do table.insert(ordered, p) end
    table.sort(ordered, function(a, b) return a.UserId < b.UserId end)
    for _, player in ipairs(ordered) do
        if player ~= LocalPlayer then
            local role = GetRole(player)
            if role == "Sheriff" then
                if seenSheriff then role = "Innocent" end
                if role == "Sheriff" then seenSheriff = true end
            end
            local pFrame = Instance.new("Frame")
            pFrame.Size = UDim2.new(1, 0, 0, 32)
            pFrame.Position = UDim2.new(0, 0, 0, yOffset)
            pFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            pFrame.BackgroundTransparency = 0.35
            pFrame.Parent = PlayersListContainer
            local pfCorner = Instance.new("UICorner")
            pfCorner.CornerRadius = UDim.new(0, 5)
            pfCorner.Parent = pFrame
            local nameBtn = Instance.new("TextButton")
            nameBtn.Size = UDim2.new(1, -10, 1, 0)
            nameBtn.Position = UDim2.new(0, 8, 0, 0)
            nameBtn.BackgroundTransparency = 1
            nameBtn.Text = player.Name .. " [" .. role .. "]"
            nameBtn.TextColor3 = roleColor(role)
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
            playerFrames[player] = {btn = nameBtn, frame = pFrame, role = role}
            yOffset = yOffset + 38
        end
    end
    PlayersListContainer.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

local ChatScroll = Instance.new("ScrollingFrame")
ChatScroll.Size = UDim2.new(1, -20, 1, -70)
ChatScroll.Position = UDim2.new(0, 10, 0, 10)
ChatScroll.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
ChatScroll.BackgroundTransparency = 0.35
ChatScroll.BorderSizePixel = 0
ChatScroll.ScrollBarThickness = 3
ChatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ChatScroll.Parent = ContainerAi
local ChatScrollCorner = Instance.new("UICorner")
ChatScrollCorner.CornerRadius = UDim.new(0, 6)
ChatScrollCorner.Parent = ChatScroll

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
    lbl.BackgroundTransparency = 0.25
    lbl.Text = who .. ": " .. text
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.Parent = bubble
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = lbl
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = lbl
    task.wait()
    ChatScroll.CanvasPosition = Vector2.new(0, ChatScroll.AbsoluteCanvasSize.Y)
    return lbl
end

AddMessage("JARVIS", "Привет, я JARVIS. Пиши свой запрос, отвечу.", Color3.fromRGB(40, 20, 20))

local InputBar = Instance.new("Frame")
InputBar.Size = UDim2.new(1, -20, 0, 44)
InputBar.Position = UDim2.new(0, 10, 1, -54)
InputBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InputBar.BackgroundTransparency = 0.35
InputBar.BorderSizePixel = 0
InputBar.Parent = ContainerAi
local InputBarCorner = Instance.new("UICorner")
InputBarCorner.CornerRadius = UDim.new(1, 0)
InputBarCorner.Parent = InputBar

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
SendBtn.BackgroundTransparency = 0.2
SendBtn.Text = ">"
SendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SendBtn.TextSize = 18
SendBtn.Font = Enum.Font.GothamBold
SendBtn.Parent = InputBar
local SendCorner = Instance.new("UICorner")
SendCorner.CornerRadius = UDim.new(1, 0)
SendCorner.Parent = SendBtn

local JARVIS_SYSTEM = "Ты JARVIS, ассистент. Отвечай кратко, по делу, на русском."

local function JarvisRequest(prompt)
    local ok, reply = pcall(function()
        local url = "https://text.pollinations.ai/" .. HttpService:UrlEncode(prompt)
            .. "?system=" .. HttpService:UrlEncode(JARVIS_SYSTEM) .. "&model=openai"
        return game:HttpGet(url)
    end)
    if ok and reply and #reply > 0 then return reply end
    return nil
end

local function SendToJarvis(prompt)
    if prompt == "" then return end
    AddMessage("ТЫ", prompt, Color3.fromRGB(25, 35, 25))
    local thinking = AddMessage("JARVIS", "думаю...", Color3.fromRGB(80, 0, 0))
    thinking.TextColor3 = Color3.fromRGB(255, 40, 40)
    task.spawn(function()
        local reply = JarvisRequest(prompt)
        if thinking.Parent then thinking.Parent:Destroy() end
        if reply and #reply > 0 then
            AddMessage("JARVIS", reply, Color3.fromRGB(40, 20, 20))
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

local function EquipKnife()
    local char = LocalPlayer.Character
    if not char then return nil end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Tool") and (c.Name == "Knife" or c.Name:lower():find("knife")) then return c end
    end
    if bp then
        for _, c in ipairs(bp:GetChildren()) do
            if c:IsA("Tool") and (c.Name == "Knife" or c.Name:lower():find("knife")) then
                pcall(function() hum:EquipTool(c) end)
                return c
            end
        end
    end
    return nil
end

local function GetGunTool()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Tool") and (c.Name:lower():find("gun") or c.Name:lower():find("pistol") or c.Name == "Gun") then return c end
    end
    local rh = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
    if rh then
        local g = rh:FindFirstChild("Gun") or rh:FindFirstChild("GunVisuals")
        if g then return g end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, c in ipairs(bp:GetChildren()) do
            if c:IsA("Tool") and (c.Name:lower():find("gun") or c.Name:lower():find("pistol") or c.Name == "Gun") then return c end
        end
    end
    return nil
end

local function FindShootRemote(gun)
    if not gun then return nil end
    local function findIn(obj)
        if not obj then return nil end
        for _, c in ipairs(obj:GetChildren()) do
            if (c:IsA("RemoteEvent") or c:IsA("RemoteFunction")) then
                local n = c.Name:lower()
                if n:find("shoot") or n:find("fire") or n:find("hit") or n == "attack" then return c end
            end
        end
        return nil
    end
    return findIn(gun) or findIn(gun.Parent) or findIn(LocalPlayer.Character) or findIn(LocalPlayer:FindFirstChild("Backpack"))
end

local function GetPredictedPosition(targetPlayer)
    local char = targetPlayer.Character
    if not char then return Vector3.new(0, 0, 0) end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return Vector3.new(0, 0, 0) end
    local velocity = hrp.AssemblyLinearVelocity
    local moveDir = hum.MoveDirection
    local predictedPosition = hrp.Position + ((velocity * Vector3.new(0.75, 0.5, 0.75)) * (0.3 / 15)) + moveDir * 0.3
    return Vector3.new(predictedPosition.X, math.clamp(predictedPosition.Y, hrp.Position.Y - 2, hrp.Position.Y + 2), predictedPosition.Z)
end

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local character = LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
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
                local knife = EquipKnife()
                local myHrp = myChar.HumanoidRootPart
                for _, p in pairs(PlayersService:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not IsOnSpawn(p) then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            myHrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                            task.wait(0.35)
                            if knife then
                                local atk = knife:FindFirstChild("Attack") or knife:FindFirstChild("Hit")
                                if atk and atk:IsA("RemoteEvent") then pcall(function() atk:FireServer() end) end
                            end
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

task.spawn(function()
    while true do
        RunService.RenderStepped:Wait()
        RefreshRoles()
        if EspEnabled then
            CreateHighlight()
            UpdateHighlights()
        else
            ClearHighlights()
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end
    local target = nil
    if AimbotMurder then target = AskESP_Murderer() end
    if not target and AimbotSheriff then target = AskESP_Sheriff() end
    if not target or not target.Character then return end
    local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not tHrp then return end
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local myPos = cam.CFrame.Position
    if (tHrp.Position - myPos).Magnitude > 1000 then return end
    local limited = CFrame.new(myPos, Vector3.new(tHrp.Position.X, myPos.Y, tHrp.Position.Z))
    cam.CFrame = cam.CFrame:Lerp(limited, 0.25)
end)

RunService.RenderStepped:Connect(function()
    if not AutoShotEnabled then return end
    if tick() - AutoShotCooldown < AUTO_SHOT_INTERVAL then return end
    local gun = GetGunTool()
    if not gun then return end
    local target = nil
    if AimbotMurder then target = AskESP_Murderer() end
    if not target and AimbotSheriff then target = AskESP_Sheriff() end
    if not target or not target.Character then return end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    AutoShotCooldown = tick()
    local rightHand = LocalPlayer.Character:FindFirstChild("RightHand") or LocalPlayer.Character:FindFirstChild("Right Arm")
    if not rightHand then return end
    local predictedPosition = GetPredictedPosition(target)
    local shootRemote = FindShootRemote(gun)
    if shootRemote and shootRemote:IsA("RemoteEvent") then
        pcall(function() shootRemote:FireServer(CFrame.new(rightHand.Position), CFrame.new(predictedPosition)) end)
    end
end)

RunService.Heartbeat:Connect(function()
    if not AutoGunPickupEnabled then return end
    if GetRole(LocalPlayer) == "Sheriff" then return end
    if not IsLocalPlayerAlive() then return end
    if not IsSheriffDead() then return end
    if tick() - AutoGunCooldown < 1 then return end
    AutoGunCooldown = tick()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local hrp = myChar.HumanoidRootPart
    local gd = Workspace:FindFirstChild("GunDrop", true)
             or Workspace:FindFirstChild("Gun", true)
             or Workspace:FindFirstChild("DroppedGun", true)
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
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0)); task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0)); task.wait()
                else
                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0)); task.wait()
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
    local prevFPDH = Workspace.FallenPartsDestroyHeight
    Workspace.FallenPartsDestroyHeight = 0 / 0
    local BV = Instance.new("BodyVelocity")
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    if TRootPart and THead then
        if (TRootPart.CFrame.Position - THead.CFrame.Position).Magnitude > 5 then SFBasePart(THead) else SFBasePart(TRootPart) end
    elseif TRootPart then SFBasePart(TRootPart)
    elseif THead then SFBasePart(THead) end
    BV:Destroy()
    Camera.CameraSubject = Humanoid
    if FlingOldPos then
        repeat
            if RootPart and RootPart.Parent then
                RootPart.CFrame = FlingOldPos * CFrame.new(0, 0.5, 0)
                Character:SetPrimaryPartCFrame(FlingOldPos * CFrame.new(0, 0.5, 0))
                Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                for _, x in pairs(Character:GetChildren()) do
                    if x:IsA("BasePart") then
                        x.AssemblyLinearVelocity = Vector3.new()
                        x.AssemblyAngularVelocity = Vector3.new()
                    end
                end
            end
            task.wait()
        until not RootPart or not RootPart.Parent or (RootPart.Position - FlingOldPos.Position).Magnitude < 25
    end
    Workspace.FallenPartsDestroyHeight = prevFPDH
end

task.spawn(function()
    while true do
        RefreshRoles()
        pcall(BuildPlayerList)
        task.wait(2)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if samuraiOn then clearSamurai(); spawnSamurai() end
    if outlineOn then clearOutline(); task.wait(0.2); ensureOutline() end
    if visualState.aura then SpawnAura() end
    if visualState.tornado then ToggleTornado(); ToggleTornado() end
    if awpOn then ClearAwp(); awpModel = BuildAwpModel() end
    SpawnPosition = nil
end)

RefreshRoles()
ShowTab(1)