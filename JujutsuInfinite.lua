repeat wait() until game:IsLoaded()

repeat wait() until 
    game.Workspace:FindFirstChild("Objects") and
    game.Workspace.Objects:FindFirstChild("Characters") and
    game.Workspace.Objects.Characters:FindFirstChild(game.Players.LocalPlayer.Name) and
    game.Players.LocalPlayer:FindFirstChild("ReplicatedData") and
    game:GetService("ReplicatedStorage")

    if game:GetService("CoreGui"):FindFirstChild("ScreenGui") then
        game:GetService("CoreGui").ScreenGui:Destroy()
    end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local bb = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
    bb:CaptureController()
    bb:ClickButton2(Vector2.new())
end)

local Window = Fluent:CreateWindow({
    Title = "UniverseHub | 1.75 ",
    SubTitle = "by Leo 🤓",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Main = Window:AddTab({ Title = "Farm Options", Icon = "settings" }),
    
}

local Options = Fluent.Options

local Farm = Tabs.Main:AddSection("Auto Farm Quests (FINALLY HERE)")

local Slider = Tabs.Main:AddSlider("Slider", {
    Title = "Loop Delay (Seconds)",
    Description = "+TIME = +SAFE",
    Default = 15,
    Min = 1,
    Max = 120,
    Rounding = 1,
    Callback = function(Value)
        getgenv().WaitTime = Value
    end
})

getgenv().WaitTime = 15

local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Auto Quest (RISKY!!!)", Default = false})

Toggle:OnChanged(function()
    if Toggle.Value then
        getgenv().AutoFarm1 = true
        local processing = false

        game:GetService("RunService").Heartbeat:Connect(function()
            if getgenv().AutoFarm1 and not processing then
                processing = true

                local localPlayer = game.Players.LocalPlayer
                local ohTable1 = {
                    ["type"] = "Kill",
                    ["set"] = "Yuki Fortress Set",
                    ["rewards"] = {
                        ["essence"] = 40,
                        ["chestMeter"] = 79,
                        ["exp"] = 8850000,
                        ["cash"] = 51000
                    },
                    ["rewardsText"] = "8.85 Mi EXP | Universe Hub",
                    ["difficulty"] = 3,
                    ["title"] = "Defeat",
                    ["level"] = 430,
                    ["grade"] = localPlayer.ReplicatedData.grade.Value,
                    ["subtitle"] = "a Curse User"
                }

                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.Server.Data.TakeQuest:InvokeServer(ohTable1)
                end)

                task.wait(1)

                local questData = localPlayer:FindFirstChild("ReplicatedTempData") and localPlayer.ReplicatedTempData:FindFirstChild("quest")
                if not questData then
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.Server.Data.TakeQuest:InvokeServer(ohTable1)
                    end)
                end

                local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                local questMarker = localPlayer.PlayerGui:WaitForChild("QuestMarker")
                local adornee = questMarker.Adornee

                if adornee and adornee:IsA("BasePart") then
                    humanoidRootPart.CFrame = adornee.CFrame
                end

                task.wait(getgenv().WaitTime)
                processing = false
            end
        end)
    else
        getgenv().AutoFarm1 = false
    end
end)

local Farm = Tabs.Main:AddSection("New Things")


local Toggle = Tabs.Main:AddToggle("GodModeToggle", {Title = "God Mode", Default = false})
local originalCooldown = nil

Toggle:OnChanged(function()
    local skillName = "Infinity: Mugen"
    local skill = game:GetService("ReplicatedStorage").Skills:FindFirstChild(skillName)

    if skill then
        if Toggle.Value then
            originalCooldown = skill.Cooldown.Value
            skill.Cooldown.Value = 0
            getgenv().GodMode = true
            while getgenv().GodMode do
                local selectedSkill = game:GetService("ReplicatedStorage").Skills:FindFirstChild(skillName)
                if selectedSkill then
                    game:GetService("ReplicatedStorage").Remotes.Server.Combat.Skill:FireServer(skillName)
                end
                wait(1)
            end
        else
            if originalCooldown then
                skill.Cooldown.Value = originalCooldown
            end
            getgenv().GodMode = false
        end
    end
end)

local Toggle = Tabs.Main:AddToggle("LootToggle", {Title = "Auto Collect Chest", Default = false})

local function activateChest()
    local chest = workspace:FindFirstChild("Objects") and workspace.Objects:FindFirstChild("Drops") and workspace.Objects.Drops:FindFirstChild("Chest")
    
    if chest then
        for i, v in pairs(chest:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                fireproximityprompt(v, 1, true)
            end
        end
        return true
    end
    return false
end

local function checkLootAndChest()
    local player = game:GetService("Players").LocalPlayer
    local loot = player.PlayerGui:FindFirstChild("Loot")
    
    if loot and loot.Enabled then
        local button = player.PlayerGui.Loot.Frame.Flip
        game:GetService("GuiService").SelectedObject = button
        game:GetService("GuiService").SelectedObject = button
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    else
        activateChest()
    end
end

Toggle:OnChanged(function()
    getgenv().loot = Toggle.Value
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().loot then
        checkLootAndChest()
    end
end)


local Toggle = Tabs.Main:AddToggle("InstantPromoteToggle", {Title = "Auto Promote", Default = false })

Toggle:OnChanged(function()
    if Toggle.Value then
        getgenv().instantPromote = true
        task.spawn(function()
            while getgenv().instantPromote do
                task.wait(0.1)
                local ohString1 = "Clan Head Jujutsu High"
                local ohString2 = "Promote"
                
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.Server.Dialogue.GetResponse:InvokeServer(ohString1, ohString2)
                end)
            end
        end)
    else
        getgenv().instantPromote = false
    end
end)

local HitStackSection = Tabs.Main:AddSection("Hit Stack")

getgenv().stackm1 = false

local hitStack = 150
local cooldownTime = 0.1

local function calcularDistancia(cframe1, cframe2)
    return (cframe1.Position - cframe2.Position).magnitude
end


local HitStackSlider = Tabs.Main:AddSlider("HitStackSlider", {
    Title = "Hit Stack",
    Description = "Hit ammount",
    Default = hitStack,
    Min = 10,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        hitStack = Value
    end
})

local CooldownSlider = Tabs.Main:AddSlider("CooldownSlider", {
    Title = "Cooldown",
    Description = "Stack Cooldown",
    Default = cooldownTime,
    Min = 0.1,
    Max = 2,
    Rounding = 1,
    Callback = function(Value)
        cooldownTime = Value
    end
})

local Toggle = Tabs.Main:AddToggle("StackM1", { Title = "Stack M1", Default = false })


Toggle:OnChanged(function()
    getgenv().stackm1 = Toggle.Value

    if getgenv().stackm1 then
        task.spawn(function()
            local localPlayer = game.Players.LocalPlayer
            local jogador = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if not jogador then
                return
            end

            while getgenv().stackm1 do
                local npcsDentroDoAlcance = {}

                for _, mob in ipairs(workspace.Objects.Mobs:GetChildren()) do
                    local humanoidRootPart = mob:FindFirstChild("HumanoidRootPart")
                    local humanoid = mob:FindFirstChild("Humanoid")

                    if humanoidRootPart and humanoid and calcularDistancia(jogador.CFrame, humanoidRootPart.CFrame) < 100 then
                        table.insert(npcsDentroDoAlcance, humanoid)
                    end
                end

                if #npcsDentroDoAlcance == 0 then
                    wait(0.5)
                else
                    local args = { [1] = 5, [2] = npcsDentroDoAlcance }
                    local combatRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Combat"):WaitForChild("M1")
                    
                    combatRemote:FireServer(unpack(args))
                    wait(0.2)

                    for _ = 1, hitStack do
                        combatRemote:FireServer(unpack(args))
                    end
                    wait(cooldownTime)
                end
            end

        end)
    end
end)


local KillAura = Tabs.Main:AddSection("Instant Kill Mobs")

getgenv().InstaKill = true

local Toggle = Tabs.Main:AddToggle("InstaKillMobs", {
    Title = "Instant Kill Mobs",
    Default = false
})

Toggle:OnChanged(function()
    getgenv().InstaKill = Toggle.Value
    if getgenv().InstaKill then
    else
    end
end)
pcall(function ()
    game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().InstaKill then
        local localPlayer = game.Players.LocalPlayer
        local jogador = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

        if jogador then
            local distanciaLimite = 100

            for _, mob in pairs(workspace.Objects.Mobs:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") then
                    local distancia = (mob.HumanoidRootPart.Position - jogador.Position).magnitude
                    if distancia < distanciaLimite then
                        local humanoide = mob:FindFirstChild("Humanoid")
                        if humanoide then
                            humanoide.Health = 0
                        end
                    end
                end
            end
        end
    end
end)
end)

local Toggle = Tabs.Main:AddToggle("InstakillToggle2", {Title = "Instant Kill Mobs 2", Default = false })

Toggle:OnChanged(function()
    if Toggle.Value then
        getgenv().instakill2 = true
        task.spawn(function()
            while getgenv().instakill2 do
                task.wait(0.1)
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then
                    task.wait(0.1)  
                else
                    for _, mob in pairs(game:GetService("Workspace").Objects.Mobs:GetChildren()) do
                        local mobHead = mob:FindFirstChild("Head")
                        local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                        if mobHead and mobHRP then
                            local distance = (mobHRP.Position - character.HumanoidRootPart.Position).Magnitude
                            if distance <= 100 then
                                pcall(function()
                                    mobHead:Destroy()
                                end)
                            end
                        end
                    end
                end
            end
        end)
    else
        getgenv().instakill2 = false
    end
end)

local BringMobs = Tabs.Main:AddSection("Bring Mobs")

getgenv().Bring = false
local distanciaLimite = 100
local distanciaMinima = 5 

local DistanciaMaxSlider = Tabs.Main:AddSlider("DistanciaMaxSlider", {
    Title = "Max Bring Distance",
    Description = "",
    Default = distanciaLimite,
    Min = 30,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        distanciaLimite = Value
    end
})

local DistanciaMinSlider = Tabs.Main:AddSlider("DistanciaMinSlider", {
    Title = "Distance From Player",
    Description = "",
    Default = distanciaMinima,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = function(Value)
        distanciaMinima = Value
    end
})

local Toggle = Tabs.Main:AddToggle("BringMobs", {
    Title = "Bring Mobs",
    Default = false
})

Toggle:OnChanged(function()
    getgenv().Bring = Toggle.Value
    if getgenv().Bring then
    else
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().Bring then
        local localPlayer = game.Players.LocalPlayer
        local jogador = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

        if jogador then
            for _, mob in pairs(workspace.Objects.Mobs:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") then
                    local distancia = (mob.HumanoidRootPart.Position - jogador.Position).magnitude
                    if distancia < distanciaLimite then
                        mob.HumanoidRootPart.CanCollide = false
                        local direcao = (mob.HumanoidRootPart.Position - jogador.Position).unit
                        local novaPosicao = jogador.Position + direcao * distanciaMinima
                        mob.HumanoidRootPart.CFrame = CFrame.new(novaPosicao)
                    end
                end
            end
        end
    end
end)


local Tabs = {
    Main = Window:AddTab({ Title = "Player Options", Icon = "settings" }),
}

local Toggle = Tabs.Main:AddToggle("AutoTalisman", {Title = "Auto Collect Drops", Default = false})

local function teleportToNextItem()
    while getgenv().autotalisma do
        local items = workspace.Objects.Drops:GetChildren()
        local foundCollect = false

        for _, item in pairs(items) do
            local collectPart = item:FindFirstChild("Collect")

            if collectPart then
                foundCollect = true
                local itemRoot = item:FindFirstChild("Root")

                if itemRoot then
                    local player = game.Players.LocalPlayer
                    local humanoidRootPart = workspace.Objects.Characters[player.Name].HumanoidRootPart
                    humanoidRootPart.CFrame = itemRoot.CFrame
                    wait(0.5)

                    for i, v in pairs(item:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then 
                            fireproximityprompt(v, 1, true)
                        end 
                    end
                end
            end
        end

        if not foundCollect then
            wait(1)
        end
    end
end

Toggle:OnChanged(function()
    getgenv().autotalisma = Toggle.Value

    if getgenv().autotalisma then
        teleportToNextItem() 
    end
end)

local BringMobs = Tabs.Main:AddSection("Skill")

local skillsFolder = game:GetService("ReplicatedStorage").Skills
local oldCooldownValues = {}

local Toggle = Tabs.Main:AddToggle("NoCooldown", { Title = "Skill No Cooldown", Default = false })

Toggle:OnChanged(function()
    if Toggle.Value then
        for _, skill in pairs(skillsFolder:GetChildren()) do
            if skill:IsA("Folder") and skill:FindFirstChild("Cooldown") then
                local cooldownValue = skill.Cooldown
                if cooldownValue:IsA("NumberValue") then
                    oldCooldownValues[skill.Name] = cooldownValue.Value
                    cooldownValue.Value = 0
                end
            end
        end
    else
        for skillName, oldValue in pairs(oldCooldownValues) do
            local skill = skillsFolder:FindFirstChild(skillName)
            if skill and skill:FindFirstChild("Cooldown") then
                local cooldownValue = skill.Cooldown
                if cooldownValue:IsA("NumberValue") then
                    cooldownValue.Value = oldValue
                end
            end
        end
    end
end)

Tabs.Main:AddButton({
    Title = "No Cooldown 2",
    Description = "No Cooldown",
    Callback = function()
        local ohString1 = "0 COOLDOWN FOR DEBUGGING"
        game:GetService("ReplicatedStorage").Remotes.Server.Combat.Skill:FireServer(ohString1)
    end
})

local BringMobs = Tabs.Main:AddSection("Local Player")

local jumpPower = 77
local walkSpeed = 16
local JumpPowerSlider = Tabs.Main:AddSlider("JumpPowerSlider", {
    Title = "Jump Power",
    Description = "Define a altura do pulo do jogador",
    Default = jumpPower,
    Min = 77,
    Max = 350,
    Rounding = 0,
    Callback = function(Value)
        jumpPower = Value
        local localPlayer = game.Players.LocalPlayer
        local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = jumpPower
        end
    end
})
local WalkSpeedSlider = Tabs.Main:AddSlider("WalkSpeedSlider", {
    Title = "Walk Speed",
    Description = "Define a velocidade de caminhada do jogador",
    Default = walkSpeed,
    Min = 40,
    Max = 350,
    Rounding = 0,
    Callback = function(Value)
        walkSpeed = Value
        local localPlayer = game.Players.LocalPlayer
        local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = walkSpeed
        end
    end
})
game:GetService("RunService").Heartbeat:Connect(function()
    local localPlayer = game.Players.LocalPlayer
    local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")

    if humanoid then
        humanoid.JumpPower = jumpPower
        humanoid.WalkSpeed = walkSpeed
    end
end)

local Tabs = {
    Main = Window:AddTab({ Title = "Spin Options", Icon = "settings" }),
}
local BringMobs = Tabs.Main:AddSection("Player Innate")

local InnateParagraph1 = BringMobs:AddParagraph({
    Title = "Innate 1",
    Content = "Actual Innate: "..tostring(game:GetService("Players").LocalPlayer.ReplicatedData.innates["1"].Value)
})

spawn(function()
    while wait(0.001) do  
        local value = game:GetService("Players").LocalPlayer.ReplicatedData.innates["1"].Value
        InnateParagraph1:SetDesc("Innate Value: "..tostring(value))
    end
end)

Tabs.Main:AddButton({
    Title = "Fast Spin Innate 1",
    Description = "Quickly spin Innate 1",
    Callback = function()
        local args = {
            [1] = 1
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Data"):WaitForChild("InnateSpin"):InvokeServer(unpack(args))
    end
})

local InnateParagraph2 = BringMobs:AddParagraph({
    Title = "Innate 2",
    Content = "Actual Innate: "..tostring(game:GetService("Players").LocalPlayer.ReplicatedData.innates["2"].Value)
})

spawn(function()
    while wait(0.001) do  
        local value = game:GetService("Players").LocalPlayer.ReplicatedData.innates["2"].Value
        InnateParagraph2:SetDesc("Innate Value: "..tostring(value))
    end
end)

Tabs.Main:AddButton({
    Title = "Fast Spin Innate 2",
    Description = "Quickly spin Innate 2",
    Callback = function()
        local args = {
            [1] = 2
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Data"):WaitForChild("InnateSpin"):InvokeServer(unpack(args))
    end
})

local Tabs = {
    Main = Window:AddTab({ Title = "Visual | UI", Icon = "settings" }),
}

local player = game:GetService("Players").LocalPlayer

local characterSlotsGui = player.PlayerGui:FindFirstChild("CharacterSlots")
local curseMarketGui = player.PlayerGui:FindFirstChild("CurseMarket")
local customizationGui = player.PlayerGui:FindFirstChild("Customization")

if characterSlotsGui then
    local characterSlotsToggle = Tabs.Main:AddToggle("CharacterSlotsToggle", {Title = "Character Slots", Default = false })

    characterSlotsToggle:OnChanged(function()
        characterSlotsGui.Enabled = characterSlotsToggle.Value
    end)
end

if curseMarketGui then
    local curseMarketToggle = Tabs.Main:AddToggle("CurseMarketToggle", {Title = "Curse Market (Might Be Broken)", Default = false })

    curseMarketToggle:OnChanged(function()
        curseMarketGui.Enabled = curseMarketToggle.Value
    end)
end

if customizationGui then
    local customizationToggle = Tabs.Main:AddToggle("CustomizationToggle", {Title = "Customization", Default = false })

    customizationToggle:OnChanged(function()
        customizationGui.Enabled = customizationToggle.Value
    end)
end
local player = game:GetService("Players").LocalPlayer
local exitPromptGui = player.PlayerGui:FindFirstChild("ExitPrompt")

if exitPromptGui then
    local exitPromptToggle = Tabs.Main:AddToggle("ExitPromptToggle", {Title = "Return To Frozen Zen", Default = false })

    exitPromptToggle:OnChanged(function()
        exitPromptGui.Enabled = exitPromptToggle.Value
    end)
end
local player = game:GetService("Players").LocalPlayer
local gamemodeWaitGui = player.PlayerGui:FindFirstChild("GamemodeWait")

if gamemodeWaitGui then
    local toggle = Tabs.Main:AddToggle("GamemodeWaitToggle", {Title = "Black Screen (RGB = FPS 🤓)", Default = false })

    toggle:OnChanged(function()
        local isEnabled = toggle.Value
        
        gamemodeWaitGui.Enabled = isEnabled

        local spinner = gamemodeWaitGui:FindFirstChild("Spinner")
        if spinner then
            spinner.Visible = not isEnabled
        end

        local textLabel = gamemodeWaitGui:FindFirstChild("TextLabel")
        if textLabel then
            if isEnabled then
                textLabel.Text = "Universe Hub"
                textLabel.Size = UDim2.new(1, 0, 0.05, 0)

                local tweenService = game:GetService("TweenService")
                local colors = {
                    Color3.fromRGB(255, 0, 0),      
                    Color3.fromRGB(0, 255, 0),      
                    Color3.fromRGB(0, 0, 255)       
                }

                local index = 1
                local function changeTextColorSmooth()
                    local nextColor = colors[index]
                    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
                    local goal = {TextColor3 = nextColor}
                    local tween = tweenService:Create(textLabel, tweenInfo, goal)
                    tween:Play()

                    index = index + 1
                    if index > #colors then
                        index = 1
                    end
                end

                while toggle.Value do
                    changeTextColorSmooth()
                    wait(1)
                end
            else
                textLabel.Text = ""
            end
        end
    end)
end
local toggle = Tabs.Main:AddToggle("VignetteToggle", {Title = "Vignette", Default = false})

toggle:OnChanged(function()
    local vignette = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Vignette")
    if vignette then
        vignette.Enabled = not toggle.Value 
    end
end)
local toggle = Tabs.Main:AddToggle("MainToggle", {Title = "Gui", Default = false})

toggle:OnChanged(function()
    local mainGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main")
    if mainGui then
        mainGui.Enabled = not toggle.Value  
    end
end)
local toggleWhiteScreen = Tabs.Main:AddToggle("WhiteScreenToggle", {Title = "White Screen Boost FPS", Default = false})

toggleWhiteScreen:OnChanged(function()
    _G.WhiteScreen = toggleWhiteScreen.Value

    if _G.WhiteScreen then
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    else
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
end)

local Tabs = {
    Main = Window:AddTab({ Title = "Teleports", Icon = "settings" }),
}

local function createButtonForNPC(npcName)
    Tabs.Main:AddButton({
        Title = npcName,
        Description = "Teleport to " .. npcName,
        Callback = function()
            local npcFound = nil
            for _, npc in pairs(workspace.Objects.NPCs:GetChildren()) do
                if npc.Name == npcName then
                    npcFound = npc
                    break
                end
            end
            
            if npcFound then
                local player = game.Players.LocalPlayer
                local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.CFrame = CFrame.new(npcFound.HumanoidRootPart.Position)
                end
            end
        end
    })
end

local npcList = {
    DailyQuest = {
        "Camp Sorcerer", "Cabbage Merchant", "Curse Slayer", "Fort Alchemist", 
        "Grave Digger", "Lazy Sorcerer", "Mr. Snow", "Temple Master"
    },
    OneTimeQuest = {
        "Apple Girl", "Brave Kid", "Climber", "Concerned Woman", "Fort Soldier", 
        "Frustrated Homeowner", "Ivana Coffin", "Janitor", "Jealous Joe", "Lender", 
        "Normal Person", "Swamp Wader"
    },
    HeavenlyRestriction = {
        "Sorcerer Killer"
    },
    Storyline = {
        "Storyline"
    },
    Sandbox = {
        "Sandbox"
    },
    Comedian = {
        "Comedian"
    },
    CurseMarket = {
        "Curse Market"
    },
    ClanHead = {
        "Clan Head Jujutsu High", "Clan Head Town1", "Clan Head Town2", 
        "Clan Head Town3", "Clan Head Town4", "Clan Head Town5"
    },
    FortressCommander = {
        "Fortress Commander"
    }
}

for sectionName, npcNames in pairs(npcList) do
    local sectionTitle = sectionName:gsub("([a-z])([A-Z])", "%1 %2")
    local section = Tabs.Main:AddSection(sectionTitle)

    for _, npcName in ipairs(npcNames) do
        createButtonForNPC(npcName)
    end
end

local Farm  = Tabs.Main:AddSection("W.I.P")

local Tabs = {
    Main = Window:AddTab({ Title = "Server | Script", Icon = "settings" }),
}

local Toggle = Tabs.Main:AddToggle("AutoScript", {Title = "Auto Load Script", Default = false})

local function loadScript()
    pcall(function()
        repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

        local queue_on_teleport = queue_on_teleport or syn.queue_on_teleport

        queue_on_teleport([[
            repeat wait() until game.Players.LocalPlayer:FindFirstChild("ReplicatedData")
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Maybie/Jujutsu-Infinite/refs/heads/main/JujutsuInfinite.lua', true))()
        ]])
    end)
end

Toggle:OnChanged(function()
    if Toggle.Value then
        loadScript()
    else
    end
end)

local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end

function TPReturner1()
    local Site
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end

    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end

    local lowestPlayers = math.huge
    local bestServerID = nil

    for i, v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _, Existing in pairs(AllIDs) do
                if ID == tostring(Existing) then
                    Possible = false
                    break
                end
            end

            if Possible then
                local playersInServer = tonumber(v.playing)
                if playersInServer < lowestPlayers then
                    lowestPlayers = playersInServer
                    bestServerID = ID
                end
            end
        end
    end

    if bestServerID then
        table.insert(AllIDs, bestServerID)
        pcall(function()
            writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
            wait()
            game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, bestServerID, game.Players.LocalPlayer)
        end)
        wait(4)
    end
end

function Teleport1()
    while wait() do
        pcall(function()
            TPReturner1()
            if foundAnything ~= "" then
                TPReturner1()
            end
        end)
    end
end

Tabs.Main:AddButton({
    Title = "Teleport Low Server",
    Description = "Teleport to the server with least players",
    Callback = function()
        Teleport1()
    end
})


local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""

local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, os.date("!*t").hour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end

function TPReturner()
    local Site
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end

    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end

    local serverID = nil
    for _, v in pairs(Site.data) do
        serverID = tostring(v.id) 
        break
    end

    if serverID then
        table.insert(AllIDs, serverID)
        pcall(function()
            writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
            wait()
            game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, serverID, game.Players.LocalPlayer)
        end)
        wait(4)
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

Tabs.Main:AddButton({
    Title = "Server Hop", 
    Description = "Normal Server Hop", 
    Callback = function()
        Teleport()
    end
})

local Tabs = {
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })    
}

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("UniverseHub")
SaveManager:SetFolder("UniverseHub/JJI")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})
SaveManager:LoadAutoloadConfig()
