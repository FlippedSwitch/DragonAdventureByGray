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

local farmTab = Window:CreateTab("Farm", "bot")
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

    if game.PlaceId == 4869039553 then
        -- Teleport the dragon to the starting ring
        dragon:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-191, 436, -1689)

        rings = {"1","2","4","9","10", "11", "12", "13", 
                "14", "35", "34", "33","32", "31", "30", "29", "28", "27", "26", 
                "25", "24", "23", "22", "21", "20", "19", "18", "17", "16", 
                "15", "36", "37", "7", "8", "38", "6", 
                "39", "5", "40", "3"}
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

local g = getgenv()
g.ScriptLoopId = (g.ScriptLoopId or 0) + 1
local scriptOldId = g.ScriptLoopId

while scriptOldId == g.ScriptLoopId do
    if ridingFarmToggle.CurrentValue then
        startRidingFarm()
    end
    task.wait(0.5)
end

