local g = getgenv()
g.ScriptLoopId = (g.ScriptLoopId or 0) + 1
local scriptOldId = g.ScriptLoopId

-- Global Variables
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local ridingFarmSpeed = 1
local ridingFarmEnable = false
local getBondAmount = 0
local getTrackingAmount = 0

-- 
-- 
-- 
-- Functions
-- 
-- 
-- 
local function notifyWarning(title, content) 
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = 3,
        Image = "circle-alert",
    })
end

local function startRidingFarm()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local allDragon = workspace.Characters:WaitForChild(player.Name):WaitForChild("Dragons"):GetChildren()
    local dragon = nil
    local rings = {}
    
    if #allDragon < 1 then
        notifyWarning("Farm Failed", "You have no dragon equiped")
        return
    elseif #allDragon > 1 then
        notifyWarning("Farm Failed", "You have multiple dragons equiped")
        return
    else
        dragon = allDragon[1]
    end

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
        notifyWarning("Farm Failed", "Unknown World")
        return
    end

    while ridingFarmEnable do
        for _, ringId in ipairs(rings) do
            if not ridingFarmEnable or scriptOldId ~= g.ScriptLoopId then 
                return
            end
            -- Assigning the tween
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(
                ridingFarmSpeed,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out,
                0,
                false,
                0
            )

            ring = workspace.Interactions.RidingRings.Flying:WaitForChild(ringId, 5)
            if not ring then
                notifyWarning("Farm Failed", "Ring Number" .. ringId .. " is not found")
                return
            end

            local ringPos = ring.CFrame.Position
            local ringCFrame = {CFrame = CFrame.new(ringPos)}
            local tween = tweenService:Create(dragon.HumanoidRootPart, tweenInfo, ringCFrame)
            tween:Play()
            tween.Completed:Wait()
        end
    end    
end

local function getBurstBond()
    local player = game:GetService("Players").LocalPlayer
    local workspaceDragons = workspace.Characters:WaitForChild(player.Name):WaitForChild("Dragons"):GetChildren()
    local equippedDragon = nil
    if #workspaceDragons < 1 then
        notifyWarning("Farm Failed", "You have no dragon equiped")
        return
    elseif #workspaceDragons > 1 then
        notifyWarning("Farm Failed", "You have multiple dragons equipped")
        return
    else
        equippedDragon = workspaceDragons[1]
    end

    local dragonData = player:WaitForChild("Data"):WaitForChild("Dragons"):WaitForChild(equippedDragon.Name)
    local args = {
        dragonData,
        "Dirty"
    }
    
    local bondRemote = player:WaitForChild("Remotes"):WaitForChild("BondingExpRemote")
    for i = 1, getBondAmount do
        bondRemote:FireServer(unpack(args))
    end
end

local function getBurstTracking()
    local args = {
        [1] = "EggNest",
        [2] = game:GetService("Players").LocalPlayer.Settings.CurrentEggs:FindFirstChild("1")
    }
    for i = 0, amount do
        game:GetService("ReplicatedStorage").Remotes.PoppedDiscoverIndicatorRemote:FireServer(unpack(args))
    end
end

local function trackingFarm()
    for i = 1, getTrackingAmount do
        local args = {
            [1] = "EggNest",
            [2] = game:GetService("Players").LocalPlayer.Settings.CurrentEggs:FindFirstChild("1")
        }
        game:GetService("ReplicatedStorage").Remotes.PoppedDiscoverIndicatorRemote:FireServer(unpack(args))
    end   
end

local function setCamToFixed(value)
    local cam = workspace.CurrentCamera
    if value then
        cam.CameraType = Enum.CameraType.Fixed
    else
        cam.CameraType = Enum.CameraType.Custom
    end
end
-- 
-- 
-- 
-- Gui Functions
-- 
-- 
-- 

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
   
   ToggleUIKeybind = "K",
})
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
        ridingFarmSpeed = Value
    end,
})
local ridingFarmToggle = farmTab:CreateToggle({
    Name = "Start Riding Farm",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        ridingFarmEnable = Value
        if Value then
            startRidingFarm()
        end
    end,
})

local farmTabDivider2 = farmTab:CreateDivider()
local bondFarmLabel = farmTab:CreateLabel("Bond Farm", "heart") -- Title, Icon
local getBondInput = farmTab:CreateInput({
    Name = "Set bond",
    CurrentValue = "",
    PlaceholderText = "Amount",
    RemoveTextAfterFocusLost = false,
    Flag = "bondAmountInput",
    Callback = function(Text)
        if tonumber(Text) then
            getBondAmount = math.max(0, tonumber(Text))
        else
            notifyWarning("Warning", "Invalid Input")    
        end
    end,
})
local getBondButton = farmTab:CreateButton({
    Name = "Get bond",
    Callback = function()
        getBurstBond()
    end,
})
local bondFarmNote = farmTab:CreateParagraph({
    Title = "Important Note",
    Content = "You must open bond and choose the pet option to work"
})

local farmTabDivider3 = farmTab:CreateDivider()

local getBurstTrackingInput = farmTab:CreateInput({
    Name = "Get tracking",
    CurrentValue = "",
    PlaceholderText = "Amount",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1",
    Callback = function(Text)
        if tonumber(Text) then
            getTrackingAmount = math.max(0, tonumber(Text))
        else
            notifyWarning("Warning", "Invalid Input")    
        end
    end,
})
local getBurstTrackingButton = farmTab:CreateButton({
    Name = "Get Tracking",
    Callback = function()
        trackingFarm()
    end,
})

local settingsTab = Window:CreateTab("Settings", "settings")
local settingsTabDivider1 = settingsTab:CreateDivider()
local fixedCameraToggle = settingsTab:CreateToggle({
    Name = "Change Camera type to fixed",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        setCamToFixed(Value)
    end,
})
local fixedCameraToggleNote = settingsTab:CreateParagraph({
    Title = "Note",
    Content = "Enabling Fixed Camera will reduce lag by bypassing camera tweening and effects during teleports."
})
