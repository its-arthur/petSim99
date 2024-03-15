--------------------------------------------------
------------------- Init Data --------------------
--------------------------------------------------
--#region Init Data
local SCRIPTNAME = "Artemis"
local SCRIPTVERSION = "1.0.0"
--#endregion

--#region UI & Tab
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = SCRIPTNAME .. " " .. SCRIPTVERSION,
    SubTitle = "by lazyarthur",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,                        -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "focus" }),
    Eggs = Window:AddTab({ Title = "Eggs", Icon = "egg" }),
    Items = Window:AddTab({ Title = "Items", Icon = "boxes" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "mountain" }),
    Rewards = Window:AddTab({ Title = "Rewards", Icon = "gift" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "apple" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
--#endregion

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = SCRIPTNAME .. " " .. SCRIPTVERSION,
        Content = "Script has been loaded.",
        Duration = 3
    })

    --#region [AutoLoot] Main
    local ToggleAutoLoot = Tabs.Main:AddToggle("AutoLootValue", { Title = "Auto Loot", Default = false })

    ToggleAutoLoot:OnChanged(function()
        while Options.AutoLootValue.Value do
            wait(1)
            AutoLoot()
        end
    end)

    Options.AutoLootValue:SetValue(false)
    --#endregion

    --#region [AutoUlt] Main
    local ToggleAutoUlt = Tabs.Main:AddToggle("AutoUltValue", { Title = "Auto Ult", Default = false })

    ToggleAutoUlt:OnChanged(function()
        while Options.AutoUltValue.Value do
            wait(1)
            AutoLoot()
        end
    end)

    Options.AutoUltValue:SetValue(false)
    --#endregion

    --#region [Pet Speed] Main
    Tabs.Main:AddButton({
        Title = "Boost Pet Speed",
        Description = "Make your pet move in speed of light!",
        Callback = function()
            PetSpeed()
        end
    })
    --#endregion

    Tabs.Misc:AddParagraph({
        Title = "Performance",
        Content = ""
    })
    

    --#region [Playtime Rewards] Rewards
    local ToggleAutoPlayTimeRewards = Tabs.Rewards:AddToggle("AutoPlayTimeRewardsValue", { Title = "Auto Claim Playtime Rewards", Default = false })

    ToggleAutoPlayTimeRewards:OnChanged(function()
        while Options.AutoPlayTimeRewardsValue.Value do
            wait(1)
            AutoPlayTimeRewards()
        end
    end)

    Options.AutoPlayTimeRewardsValue:SetValue(false)

    --#region [Boost FPS] Misc
    Tabs.Misc:AddButton({
        Title = "Boost FPS",
        Description = "Remove all effects to boost FPS",
        Callback = function()
            BootFps()
        end
    })
    --#endregion

    Tabs.Misc:AddParagraph({
        Title = "Server",
        Content = ""
    })

    --#region [Rejoin] Misc
    Tabs.Misc:AddButton({
        Title = "Rejoin",
        Description = "Rejoins the game",
        Callback = function()
            Window:Dialog({
                Title = "Rejoin",
                Content = "You sure?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            game:GetService("TeleportService"):Teleport(game.PlaceId,
                                game:GetService("Players").LocalPlayer)
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            Fluent:Notify({
                                Title = SCRIPTNAME .. " " .. SCRIPTVERSION,
                                Content = "You have cancelled the rejoin.",
                                Duration = 1
                            })
                        end
                    }
                }
            })
        end
    })
    --#endregion
end

--------------------------------------------------
------------------ Function --------------------
--------------------------------------------------

function AutoPlayTimeRewards()
    task.spawn(function()
        for v = 1,10 do
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(v)
        end
    end)
end

function AutoLoot()
    task.spawn(function()
        workspace["__THINGS"]["Lootbags"].ChildAdded:Connect(function(v)
            task.spawn(function()
                game:GetService("ReplicatedStorage").Network:FindFirstChild("Lootbags_Claim"):FireServer({ [1] = tostring(
                v.Name) })
                task.delay(.1, function()
                    v:Destroy()
                end)
            end)
        end)
        workspace["__THINGS"]["Orbs"].ChildAdded:Connect(function(v)
            task.spawn(function()
                game:GetService("ReplicatedStorage").Network:FindFirstChild("Orbs: Collect"):FireServer({ [1] = tonumber(
                v.Name) })
                task.delay(.1, function()
                    v:Destroy()
                end)
            end)
        end)
    end)
end

function BootFps()
    for _, v in pairs(game:GetService("ReplicatedStorage").Assets.Particles:GetChildren()) do
        if
            v.Name == "Chest Click"
            or v.Name == "Chest Explode"
            or v.Name == "Chest Falling"
            or v.Name == "Coin Bonus"
            or v.Name == "Coin Damage"
            or v.Name == "Coin Explode"
            or v.Name == "Lightning"
            or v.Name == "LootbagsCurrency"
            or v.Name == "Lootbags"
            or v.Name == "Orbs"
        then
            for _, x in pairs(v:GetDescendants()) do
                if x:IsA("ParticleEmitter") or x:IsA("Beam") or x:IsA("Trail") or v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    x:Destroy()
                end
            end
        end
    end

    local pets = game.Workspace["__THINGS"]["Pets"]:GetChildren()
    for _, v in pairs(pets) do
        if v.Name ~= 'Highlight' then
            local pet = game.Workspace["__THINGS"]["Pets"][v.Name][v.Name]
            if pet:FindFirstChild("__RAINBOWFX") then pet.__RAINBOWFX:Destroy() end
            if pet:FindFirstChild("Mesh") then
                pet.Mesh.MeshType = "Brick"; pet.Mesh.Scale = Vector3.new(0.25, 0.25, 0.25)
            end
            for _, x in pairs(pet:GetDescendants()) do
                if x:IsA("ParticleEmitter") then
                    pcall(function()
                        x:Destroy()
                    end)
                end
            end
        end
    end

    game.Workspace["__THINGS"]["Pets"].ChildAdded:Connect(function(v)
        task.wait(1)
        local pet = game.Workspace["__THINGS"]["Pets"][v.Name][v.Name]
        if pet:FindFirstChild("__RAINBOWFX") then pet.__RAINBOWFX:Destroy() end
        if pet:FindFirstChild("Mesh") then
            pet.Mesh.MeshType = "Brick"; pet.Mesh.Scale = Vector3.new(0.25, 0.25, 0.25)
        end
        for _, x in pairs(pet:GetDescendants()) do
            if x:IsA("ParticleEmitter") then
                pcall(function()
                    x:Destroy()
                end)
            end
        end
    end)

    task.spawn(function()
        while task.wait() do
            for _, v in pairs(game.Workspace["__DEBRIS"]:GetChildren()) do
                if v.Name == "host" then
                    for _, x in pairs(v:GetDescendants()) do
                        if x:IsA("ParticleEmitter") then
                            x:Destroy()
                        elseif x.Name == "HUDAdornee" then
                            x.HUD.Damages.Visible = false
                            x.HUD.Progress.Visible = false
                        end
                    end
                elseif v.Name == "Explosion FX" or v.Name == "Bonus Particle" or v.Name == "Part" then
                    v:Destroy()
                end
            end
        end
    end)
end

function PetSpeed()
    local Client = require(game:GetService("ReplicatedStorage").Library:WaitForChild("Client"))
    Client.PlayerPet.CalculateSpeedMultiplier = function(...)
        return 999
    end
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(2)

Fluent:Notify({
    Title = SCRIPTNAME .. " " .. SCRIPTVERSION,
    Content = "Settings have been restored.",
    Duration = 3
})

SaveManager:LoadAutoloadConfig()
