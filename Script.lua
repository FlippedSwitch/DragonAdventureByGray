local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Dragon Adventure Script",
    Icon = "swords", -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Loading Script...",
    LoadingSubtitle = "by Mr.Gray",
    ShowText = "Dragon Adventure", -- for mobile users to unhide rayfield, change if you'd like
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
    ToggleUIKeybind = "K",
})

-- 
-- 
-- 
-- Farm Tab
-- 
-- 
-- 

local farmTab = Window:CreateTab("Farm", "bot")
local farmTabDivider1 = farmTab:CreateDivider()
local ridingFarmLabel = farmTab:CreateLabel("Riding Farm", "torus") -- Title, Icon
local ridingFarmSlider = farmTab:CreateSlider({
    Name = "Riding Speed",
    Range = {0.1, 1},
    Increment = 0.1,
    Suffix = "Seconds",
    CurrentValue = 1,
    Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        end,
})

local ridingFarmToggle = farmTab:CreateToggle({
    Name = "Start Riding Farm",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
    end,
})

local function startRidingFarm()
    speed = ridingFarmSlider.CurrentValue

    local rings = {}
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local allDragon = workspace.Characters:WaitForChild(player.Name):WaitForChild("Dragons", 3):GetChildren()

    if #allDragon < 1 then
        Rayfield:Notify({
            Title = "Farm Failed",
            Content = "You have no dragon equiped",
            Duration = 3,
            Image = "circle-alert",
        })
        return
    elseif #allDragon > 1 then
        Rayfield:Notify({
            Title = "Farm Failed",
            Content = "You have multiple dragons equiped",
            Duration = 3,
            Image = "circle-alert",
        })
        return    
    end
    local dragon = allDragon[1]

    if game.PlaceId == 3475397644 then 
        -- Overworld
        dragon:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2441, 642, -17)

        rings = {"1","2","3","4","5","6", "11", "12", "13","14","15","16", "17","57", "56", "55", "54", "53", "52", "51", "82", "49", "48", "47", "46", "45", "44", "43", "42", "41", "40",
                "39", "38", "37", "36", "35", "34", "33", "32", "31", "30",
                "29", "28", "27", "26", "25", "24", "23", "22", "21", "20",
                "19", "18", "10", "9","8", "7"}
    elseif game.PlaceId == 4869039553 then
        -- Prehistoric
        dragon:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2390, 636, 64)

        rings = {"1","2","3","4","5","6", "11", "12", "13","14","15","16", "17","57", "56", "55", "54", "53", "52", "51", "82", "49", "48", "47", "46", "45", "44", "43", "42", "41", "40",
                "39", "38", "37", "36", "35", "34", "33", "32", "31", "30",
                "29", "28", "27", "26", "25", "24", "23", "22", "21", "20",
                "19", "18", "10", "9","8", "7"}
    else
        Rayfield:Notify({
            Title = "Farm Failed",
            Content = "Unknown World",
            Duration = 3,
            Image = "circle-x",
        })
        return
    end

    for _, ringId in ipairs(rings) do
        if ridingFarmToggle.CurrentValue == false then
            return
        end

        -- Assigning the tween
        local tweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(
            ridingFarmSlider.CurrentValue,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out,
            0,
            false,
            0
        )

        ring = workspace.Interactions.RidingRings.Flying:WaitForChild(ringId, 5)
        if not ring then
            Rayfield:Notify({
                Title = "Farm Failed",
                Content = "Ring Number" .. ringId .. " is not found",
                Duration = 3,
                Image = "circle-x",
            })
            return
        end

        local ringPos = ring.CFrame.Position
        local ringCFrame = {CFrame = CFrame.new(ringPos)}
        local tween = tweenService:Create(dragon.HumanoidRootPart, tweenInfo, ringCFrame)
        tween:Play()
        tween.Completed:Wait()
    end
end

local farmTabDivider2 = farmTab:CreateDivider()
local bondFarmLabel = farmTab:CreateLabel("Bond Farm", "heart") -- Title, Icon
local bondFarmSpeedSlider = farmTab:CreateSlider({
    Name = "Get bond speed",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = "Seconds",
    CurrentValue = 0.5,
    Flag = "Slider1",
    Callback = function(Value)
        -- Optional: You can handle slider changes here
    end,
})

local function bondFarm()
    while bondFarmToggle.CurrentValue do
        local player = game:GetService("Players").LocalPlayer
        local workspaceDragons = workspace.Characters:WaitForChild(player.Name):WaitForChild("Dragons"):GetChildren()

        if #workspaceDragons < 1 then
            Rayfield:Notify({
                Title = "Farm Failed",
                Content = "You have no dragon equipped",
                Duration = 3,
                Image = "circle-alert",
            })
            return
        elseif #workspaceDragons > 1 then
            Rayfield:Notify({
                Title = "Farm Failed",
                Content = "You have multiple dragons equipped",
                Duration = 3,
                Image = "circle-alert",
            })
            return
        end

        local equippedDragon = workspaceDragons[1]
        local dragonData = player:WaitForChild("Data"):WaitForChild("Dragons"):WaitForChild(equippedDragon.Name)

        local args = {
            dragonData,
            "Dirty"
        }
        
        player:WaitForChild("Remotes"):WaitForChild("BondingExpRemote"):FireServer(unpack(args))
        task.wait(bondFarmSpeedSlider.CurrentValue)
    end
end

bondFarmToggle = farmTab:CreateToggle({
    Name = "Start bond farm",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        if Value then
            task.spawn(bondFarm)
        end
    end,
})

local function getBurstBond(amount)
    local player = game:GetService("Players").LocalPlayer
    local workspaceDragons = workspace.Characters:WaitForChild(player.Name):WaitForChild("Dragons"):GetChildren()

    if #workspaceDragons < 1 then
        Rayfield:Notify({
            Title = "Farm Failed",
            Content = "You have no dragon equipped",
            Duration = 3,
            Image = "circle-alert",
        })
        return
    elseif #workspaceDragons > 1 then
        Rayfield:Notify({
            Title = "Farm Failed",
            Content = "You have multiple dragons equipped",
            Duration = 3,
            Image = "circle-alert",
        })
        return
    end

    local equippedDragon = workspaceDragons[1]
    local dragonData = player:WaitForChild("Data"):WaitForChild("Dragons"):WaitForChild(equippedDragon.Name)

    local args = {
        dragonData,
        "Dirty"
    }
    
    local bondRemote = player:WaitForChild("Remotes"):WaitForChild("BondingExpRemote")

    for i = 1, amount do
        bondRemote:FireServer(unpack(args))
    end
end


local getBurstBondInput = farmTab:CreateInput({
    Name = "Amount of bond",
    CurrentValue = "",
    PlaceholderText = "Amount",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1",
    Callback = function(Text)
    end,
})

local  getBurstBondButton = farmTab:CreateButton({
    Name = "Get Bond",
    Callback = function()
        amount = tonumber(getBurstBondInput.CurrentValue)
        if not amount then
            Rayfield:Notify({
                Title = "Failed",
                Content = "You put invalid amount",
                Duration = 3,
                Image = "circle-alert",
            })
        else
            getBurstBond(amount)
        end    
    end,
})

local bondFarmNote = farmTab:CreateParagraph({
    Title = "Important Note",
    Content = "You must open bond and choose the pet option to work"
})

local farmTabDivider3 = farmTab:CreateDivider()
local trackingFarmLabel = farmTab:CreateLabel("Tracking Farm", "search") -- Title, Icon
local trackingFarmSpeedSlider = farmTab:CreateSlider({
    Name = "Get tracking speed",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = "Seconds",
    CurrentValue = 0.5,
    Flag = "Slider1",
    Callback = function(Value)
        -- Optional: You can handle slider changes here
    end,
})

local function trackingFarm()
    while trackingFarmToggle.CurrentValue do
        local args = {
            [1] = "EggNest",
            [2] = game:GetService("Players").LocalPlayer.Settings.CurrentEggs:FindFirstChild("1")
        }
        game:GetService("ReplicatedStorage").Remotes.PoppedDiscoverIndicatorRemote:FireServer(unpack(args))
        task.wait(trackingFarmSpeedSlider.CurrentValue)
    end   
end

trackingFarmToggle = farmTab:CreateToggle({
    Name = "Start tracking farm",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        if Value then
            task.spawn(trackingFarm)
        end
    end,
})

local getBurstTrackingInput = farmTab:CreateInput({
    Name = "Amount of tracking",
    CurrentValue = "",
    PlaceholderText = "Amount",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1",
    Callback = function(Text)
    end,
})

local function getBurstTracking(amount)
    local args = {
        [1] = "EggNest",
        [2] = game:GetService("Players").LocalPlayer.Settings.CurrentEggs:FindFirstChild("1")
    }
    for i = 0, amount do
        game:GetService("ReplicatedStorage").Remotes.PoppedDiscoverIndicatorRemote:FireServer(unpack(args))
    end
end

local getBurstTrackingButton = farmTab:CreateButton({
    Name = "Get Tracking",
    Callback = function()
        amount = tonumber(getBurstTrackingInput.CurrentValue)
        if not amount then
            Rayfield:Notify({
                Title = "Failed",
                Content = "You put invalid amount",
                Duration = 3,
                Image = "circle-alert",
            })
        else
            getBurstTracking(amount)
        end    
    end,
})


-- 
-- 
-- 
-- Settings Tab
-- 
-- 
-- 

local settingsTab = Window:CreateTab("Settings", "settings")
local settingsTabDivider1 = settingsTab:CreateDivider()
local fixedCameraToggle = settingsTab:CreateToggle({
    Name = "Change Camera type to fixed",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        local cam = workspace.CurrentCamera
        if Value then
            cam.CameraType = Enum.CameraType.Fixed
        else
            cam.CameraType = Enum.CameraType.Custom
        end
    end,
})

local fixedCameraToggleNote = settingsTab:CreateParagraph({
    Title = "Note",
    Content = "Enabling Fixed Camera will reduce lag by bypassing camera tweening and effects during teleports."
})

local function safeDestroy(parent, childName, timeout)
    local obj = parent:WaitForChild(childName, timeout or 5)
    if obj then
        obj:Destroy()
    end
end

local function antiLag()
    local env = workspace:WaitForChild("Environment")

    if game.PlaceId == 3475397644 then
        safeDestroy(env, "Foliage")
        safeDestroy(env, "EventArea")
        safeDestroy(env.Caves, "MysticWoodsDungeon")

    elseif game.PlaceId == 125804922932357 then
        safeDestroy(env, "Flora")
        safeDestroy(env, "Bones")
        safeDestroy(env, "VFX")
        safeDestroy(env, "Rocks")
    end
end

local settingsTabDivider2 = settingsTab:CreateDivider()
local Button = settingsTab:CreateButton({
    Name = "Good Anti Lag",
    Callback = function()
        antiLag()
    end,
})

-- 
-- 
-- 
-- Main Function
-- 
-- 
-- 

local g = getgenv()
g.ScriptLoopId = (g.ScriptLoopId or 0) + 1
local scriptOldId = g.ScriptLoopId

while scriptOldId == g.ScriptLoopId do
    if ridingFarmToggle.CurrentValue then
        startRidingFarm()
    end
    task.wait(0.5)
end

