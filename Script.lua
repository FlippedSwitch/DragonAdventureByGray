local g = getgenv()
g.ScriptLoopId = (g.ScriptLoopId or 0) + 1
local scriptOldId = g.ScriptLoopId

-- Global Variables
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local ridingFarmSpeed = 1
local ridingFarmEnable = false
local getBondAmount = 0
local getTrackingAmount = 0
local treasureIndex = 0
local autoFarmEnable = false
local autofarmFoodAmountTarget = 10000
local isAutoFarmScriptExecuted = false
local worldPlaceIds = {
        ["Overworld"] = 3475397644, 
        ["GrassLand"] = 3475419198, 
        ["Jungle"] = 3475422608,
        ["Volcano"] = 3487210751,
        ["Tundra"] = 3623549100,
        ["Underwater"] = 3737848045,
        ["Desert"] = 3752680052,
        ["Fantasy"] = 4174118306,
        ["WasteLand"] = 4728805070,
        ["Prehistoric"] = 4869039553,
        ["Shinrin"] = 125804922932357,
    }

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

local function getLocalPlayer()
    return game:GetService("Players").LocalPlayer
end

local function getDragon() 
    local name = getLocalPlayer().Name
    local workspaceCharacter = workspace.Characters:WaitForChild(name, 10) or workspace.Characters:WaitForChild(name)
    local workspaceDragons = workspaceCharacter:WaitForChild("Dragons"):GetChildren()
    if #workspaceDragons < 1 then
        notifyWarning("Farm Failed", "You have no dragon equiped")
        return
    elseif #workspaceDragons > 1 then
        notifyWarning("Farm Failed", "You have multiple dragons equipped")
        return
    end    
    return workspaceDragons[1]
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

            local ring = workspace.Interactions.RidingRings.Flying:WaitForChild(ringId, 5)
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
    local player = getLocalPlayer()
    local equippedDragon = getDragon()
    if not equippedDragon then 
        return
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

local function trackingFarm()
    for i = 1, getTrackingAmount do
        local args = {
            [1] = "EggNest",
            [2] = game:GetService("Players").LocalPlayer.Settings.CurrentEggs:FindFirstChild("1")
        }
        game:GetService("ReplicatedStorage").Remotes.PoppedDiscoverIndicatorRemote:FireServer(unpack(args))
    end   
end

local function teleportToTreasure(direction) 
    local worldPlaceIdIndex = {
        [3475397644] = 1, --Overworld
        [3475419198] = 2, --GrassLand
        [3475422608] = 3, --Jungle
        [3487210751] = 4, --Volcano
        [3623549100] = 5, --Tundra
        [3737848045] = 6, --Underwater
        [3752680052] = 7, --Desert
        [4174118306] = 8, --Fantasy
        [4728805070] = 9, --WasteLand
        [4869039553] = 10, --Prehistoric
        [125804922932357] = 11, --Shinrin
    }
    local worldIndex = worldPlaceIdIndex[game.PlaceId]
    if not worldIndex then 
        notifyWarning("Error", "Unknown World")
        return
    end

    local targetPosition = nil
    local treasures = {
        {
        [1] = Vector3.new(1538, 480, 1906),
        [2] = Vector3.new(2244, 504, 705),
        [3] = Vector3.new(2014, 504, 1191),
        [4] = Vector3.new(201, 555, 1837),
        [5] = Vector3.new(-886, 306, 1862),
        [6] = Vector3.new(-2366, 546, -454),
        [7] = Vector3.new(-1019, 272, -1858),
        [8] = Vector3.new(1031, 491, -2106),
        [9] = Vector3.new(-751, 65, -225),
        [10] = Vector3.new(-2475, -61, 494),
        [11] = Vector3.new(-1812, -28, 471),
        [12] = Vector3.new(1999, 189, -572),
        [13] = Vector3.new(1107, 89, -1429),
        [14] = Vector3.new(1034, 167, -2134),
        [15] = Vector3.new(2349, 238, 482),
        [16] = Vector3.new(-1721, -42, -137),
        [17] = Vector3.new(203, 310, 2186),
        [18] = Vector3.new(-760, -159, -602)
        },
        {
        [1] = Vector3.new(1365, 330, -1057),
        [2] = Vector3.new(1272, 204, 415),
        [3] = Vector3.new(-1320, 162, 1294),
        [4] = Vector3.new(-837, 232, 1405),
        [5] = Vector3.new(1177, 370, 356),
        [6] = Vector3.new(862, 117, -1005),
        [7] = Vector3.new(-144, 145, -1333),
        [8] = Vector3.new(-783, 150, -231),
        [9] = Vector3.new(-1340, 124, -196),
        [10] = Vector3.new(-1536, 161, 513),
        [11] = Vector3.new(598, 118, 323),
        [12] = Vector3.new(-155, 248, -1406),
        [13] = Vector3.new(-604, 778, -754),
        [14] = Vector3.new(-379, 454, 1728),
        [15] = Vector3.new(-1112, 603, 1463),
        },
        {
        [1] = Vector3.new(592, -60, 545),
        [2] = Vector3.new(873, 24, 380),
        [3] = Vector3.new(-496, 24, -897),
        [4] = Vector3.new(1392, 108, -92),
        [5] = Vector3.new(-721, 21, 693),
        [6] = Vector3.new(-628, 34, 852),
        [7] = Vector3.new(119, -95, -244),
        [8] = Vector3.new(-870, 35, 251),
        [9] = Vector3.new(-87, -68, 696),
        [10] = Vector3.new(-221, 41, 882),
        [11] = Vector3.new(-663, -37, -532),
        },
        {   
        [1] = Vector3.new(735, 94, 474),
        [2] = Vector3.new(-374, 140, -1072),
        [3] = Vector3.new(-943, -144, 1161),
        [4] = Vector3.new(-711, 278, -968),
        [5] = Vector3.new(-1281, -4, 1014),
        [6] = Vector3.new(-75, -116, 1368),
        [7] = Vector3.new(1312, 108, 630),
        [8] = Vector3.new(338, 97, 75),
        [9] = Vector3.new(790, 158, -349),
        [10] = Vector3.new(-2651, 116, -1052),
        [11] = Vector3.new(-2229, 87, 276),
        },
        {
        [1] = Vector3.new(906, 1016, 731),
        [2] = Vector3.new(1248, 799, 652),
        [3] = Vector3.new(-1165, 1399, 1389),
        [4] = Vector3.new(770, 1549, -742),
        [5] = Vector3.new(163, 2460, 1896),
        [6] = Vector3.new(2091, 2156, 422),
        [7] = Vector3.new(-1412, 1453, -748),
        [8] = Vector3.new(-356, 2299, 2074),
        [9] = Vector3.new(1548, 1794, 452),
        [10] = Vector3.new(1025, 1507, 1268),
        [11] = Vector3.new(1453, 1645, 90),
        [12] = Vector3.new(622, 1463, 2223),
        },
        {
        [1] = Vector3.new(-865, -14, 807),
        [2] = Vector3.new(-148, 158, 32),
        [3] = Vector3.new(-102, -106, 92),
        [4] = Vector3.new(668, 390, 510),
        [5] = Vector3.new(-503, 188, 584),
        [6] = Vector3.new(113, 42, 1558),
        [7] = Vector3.new(183, 243, 1437),
        [8] = Vector3.new(-535, -93, 1236),
        [9] = Vector3.new(471, 12, 203),
        [10] = Vector3.new(510, -308, 490),
        [11] = Vector3.new(344, -246, -58),
        },
        {
            [1] = Vector3.new(-1571, 78, -1061),
            [2] = Vector3.new(110, 90, -1701),
            [3] = Vector3.new(532, 382, -1995),
            [4] = Vector3.new(-12, 173, -134),
            [5] = Vector3.new(-3, 196, 2224),
            [6] = Vector3.new(1651, 321, -839),
            [7] = Vector3.new(-1604, 69, 722),
            [8] = Vector3.new(-1501, 319, -836),
            [9] = Vector3.new(-2284, 248, 1343),
            [10] = Vector3.new(2348, 563, -506),
            [11] = Vector3.new(420, 402, -1574),
            [12] = Vector3.new(-958, 603, -413),
            [13] = Vector3.new(865, 286, 1845),
            [14] = Vector3.new(-1497, 392, -2096),
            [15] = Vector3.new(2130, 283, -932),
            [16] = Vector3.new(-1731, 556, 411),
        },
        {
            [1] = Vector3.new(620, 52, 181),
            [2] = Vector3.new(1367, 238, 139),
            [3] = Vector3.new(-115, 194, -53),
            [4] = Vector3.new(-1705, 225, 482),
            [5] = Vector3.new(-678, 88, 1689),
            [6] = Vector3.new(-673, 92, 1047),
            [7] = Vector3.new(-913, 83, 2241),
            [8] = Vector3.new(-675, 452, -1673),
            [9] = Vector3.new(66, 46, 189),
            [10] = Vector3.new(901, 30, -400),
            [11] = Vector3.new(291, 147, 406),
        },
        {
            [1] = Vector3.new(-2159, 273, -1393),
            [2] = Vector3.new(-1585, 307, 1408),
            [3] = Vector3.new(-677, 300, 2106),
            [4] = Vector3.new(424, 140, 1634),
            [5] = Vector3.new(2290, 309, 338),
            [6] = Vector3.new(-2090, 425, 1078),
            [7] = Vector3.new(-820, 664, -1526),
            [8] = Vector3.new(-1146, 94, -1790),
            [9] = Vector3.new(-290, -137, -2214),
            [10] = Vector3.new(625, 325, 2335),
            [11] = Vector3.new(-1589, 333, -1467),
            [12] = Vector3.new(368, 1177, -2596),
        },
        {
            [1] = Vector3.new(-304, 462, -577),
            [2] = Vector3.new(341, 92, -211),
            [3] = Vector3.new(-1003, 400, -506),
            [4] = Vector3.new(-715, 144, 297),
            [5] = Vector3.new(-255, 148, 38),
            [6] = Vector3.new(-868, 167, -1151),
            [7] = Vector3.new(1055, 243, 852),
            [8] = Vector3.new(-895, 490, -875),
            [9] = Vector3.new(329, 524, -1147),
            [10] = Vector3.new(942, 161, 1036),
            [11] = Vector3.new(386, 146, -796),
            [12] = Vector3.new(317, 405, -64),
        },
        {
            [1] = Vector3.new(1182, 138, -913),
            [2] = Vector3.new(-2555, 542, -2847),
            [3] = Vector3.new(2358, 615, -4633),
            [4] = Vector3.new(-748, 633, -3472),
            [5] = Vector3.new(-2441, 1207, -4764),
            [6] = Vector3.new(-374, 554, 411),
            [7] = Vector3.new(-3003, 523, -2031),
            [8] = Vector3.new(2751, 575, -1008),
            [9] = Vector3.new(-757, 460, -4951),
            [10] = Vector3.new(-2825, 646, -311),
            [11] = Vector3.new(2442, 205, -877),
            [12] = Vector3.new(-2585, 291, -2853),
            [13] = Vector3.new(-78, 536, 471),
        }
    }
    

    local equippedDragon = getDragon()
    if not equippedDragon then
        return
    end
    
    while true do
        if direction == "Next" then
            treasureIndex = treasureIndex + 1
        else
            treasureIndex = treasureIndex - 1
        end
        
        if treasureIndex > #treasures[worldIndex] then
            treasureIndex = 1
        end
        if treasureIndex < 1 then
            treasureIndex = #treasures[worldIndex]
        end

        targetPosition = CFrame.new(treasures[worldIndex][treasureIndex])
        equippedDragon.HumanoidRootPart.CFrame = targetPosition
        local chest = workspace:WaitForChild("Interactions"):WaitForChild("Nodes"):WaitForChild("Treasure"):WaitForChild(treasureIndex)
        if #chest:GetChildren() > 1 then
            break
        end
        task.wait(0.2)
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

local function teleportTo(placeId)
    local args = {
        placeId,
        {}
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WorldTeleportRemote"):InvokeServer(unpack(args))
end

local function getPlayers()
    return game:GetService("Players")
end

local function autoFarm()
    local targetResources = {"Edamame", "KajiFruit", "MistSudachi"}
    local sellItem = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote", 5)
    local teleportIndex = 1
    local teleportPosition = {
        [1] = Vector3.new(-1609, 602, 337),
        [2] = Vector3.new(-1726, 620, -1807),
        [3] = Vector3.new(-1720, 765, -4530),
        [4] = Vector3.new(52, 786, -4055),
        [5] = Vector3.new(1633, 649, -3858),
        [6] = Vector3.new(1703, 518, -2140),
        [7] = Vector3.new(1787, 538, -350),
        [8] = Vector3.new(-401, 509, -414),
        [9] = Vector3.new(-255, 445, -2327),
    }
    local player = getLocalPlayer()
    local dragon = getDragon()
    if not dragon or not player then
        return
    end
    local resources = player:WaitForChild('Data'):WaitForChild("Resources")

    if game.PlaceId == worldPlaceIds["Overworld"] then
        while autoFarmEnable do 
            for i = 1, #targetResources do
                if resources[targetResources[i]].Value > 0 then
                    local Args = {
                        ItemName = targetResources[i], 
                        Amount = resources[targetResources[i]].Value
                    }
                    sellItem:FireServer(Args)
                end
            end

            for timer = 10, 0, -1 do
                if not autoFarmEnable then
                    return
                end
                notifyWarning("Teleporting", "Shinrin in " .. timer)
                task.wait(1)
            end
        end
        teleportTo(worldPlaceIds["Shinrin"])
    end
      
    if game.PlaceId == worldPlaceIds["Shinrin"] then
        task.spawn(function()
            -- Teleport you around Shinrin
            while autoFarmEnable do
                if isAutoFarmScriptExecuted then
                    if teleportIndex > #teleportPosition then
                        teleportIndex = 1
                    end
                    dragon.HumanoidRootPart.CFrame = CFrame.new(teleportPosition[teleportIndex])
                    teleportIndex = teleportIndex + 1
                end
                task.wait(10)
            end
        end)    

        while autoFarmEnable do 
            local isGoalReached = true
            for i = 1, #targetResources do
                if resources[targetResources[i]].Value < autofarmFoodAmountTarget then
                    isGoalReached = false
                end
            end

            if isGoalReached then
                notifyWarning("Teleporting", "Overworld")
                task.wait(10)
                teleportTo(worldPlaceIds["Overworld"])
            end
            
            if not isAutoFarmScriptExecuted and #getPlayers():GetChildren() == 1 then
                task.spawn(function()
                    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/34824c86db1eba5e5e39c7c2d6d7fdfe.lua"))()
                end)
                isAutoFarmScriptExecuted = true
            end

            -- Rejoin if other players is present
            if isAutoFarmScriptExecuted and #getPlayers():GetChildren() > 1 then
                teleportTo(worldPlaceIds["Shinrin"])
            end    
            task.wait(1)
        end
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

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GrayScript", -- Create a custom folder for your hub/game
        FileName = "Dragon Adventure.asdf"
    },
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
    Flag = "ridingFarmSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        ridingFarmSpeed = Value
    end,
})
local ridingFarmToggle = farmTab:CreateToggle({
    Name = "Start Riding Farm",
    CurrentValue = false,
    Flag = "ridingFarmToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        ridingFarmEnable = Value
        if Value then
            task.spawn(function()
                startRidingFarm()
            end)
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
    Flag = "trackingFarmInput",
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
local farmTabDivider4 = farmTab:CreateDivider()
local treasureLabel = farmTab:CreateLabel("Treasure Chest Location Teleport", "archive")
local treasureIndexLabel = farmTab:CreateLabel("Current Chest 0")
local treasureButtonNext = farmTab:CreateButton({
   Name = "Teleport Next Location",
   Callback = function()
        teleportToTreasure("Next")
        treasureIndexLabel:Set("Current Chest " .. treasureIndex)
   end,
})
local treasureButtonPrevious = farmTab:CreateButton({
   Name = "Teleporst Previous Location",
   Callback = function()
        teleportToTreasure("Previous")
        treasureIndexLabel:Set("Current Chest " .. treasureIndex)
   end,
})

-- AutoFarm Tab
local autoFarmTab = Window:CreateTab("AutoFarm", "bot")
local autoFarmTabDivider1 = autoFarmTab:CreateDivider()
local autoFarmToggle = autoFarmTab:CreateToggle({
   Name = "Start Autofarm",
   CurrentValue = false,
   Flag = "automaticfarmToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        autoFarmEnable = Value
        if Value then
            task.spawn(function()
                autoFarm()
            end)
        end
   end,
})
local getAutoFarmFoodTargetAmount = autoFarmTab:CreateInput({
    Name = "Auto Farm Food Target Amount",
    CurrentValue = "10000",
    PlaceholderText = "Amount",
    RemoveTextAfterFocusLost = false,
    Flag = "autoFarmFoodTargetAmount",
    Callback = function(Text)
        if tonumber(Text) then
            autofarmFoodAmountTarget = math.max(0, tonumber(Text))
        else
            notifyWarning("Warning", "Invalid Input")    
        end
    end,
})
-- Settings Tab

local settingsTab = Window:CreateTab("Settings", "settings")
local settingsTabDivider1 = settingsTab:CreateDivider()
local fixedCameraToggle = settingsTab:CreateToggle({
    Name = "Change Camera type to fixed",
    CurrentValue = false,
    Flag = "fixedCamToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        setCamToFixed(Value)
    end,
})
local fixedCameraToggleNote = settingsTab:CreateParagraph({
    Title = "Note",
    Content = "Enabling Fixed Camera will reduce lag by bypassing camera tweening and effects during teleports."
})

Rayfield:LoadConfiguration()
