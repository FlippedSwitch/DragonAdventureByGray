local g = getgenv()
g.ScriptLoopId = (g.ScriptLoopId or 0) + 1
local scriptOldId = g.ScriptLoopId

-- Global Variables
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local fixCameraEnable = false

-- 
-- 
-- 
-- Functions
-- 
-- 
-- 
local function setCameraFixed() 
    while fixCameraEnable do
        local cam = workspace.CurrentCamera
        if Value then
            cam.CameraType = Enum.CameraType.Fixed
        else
            cam.CameraType = Enum.CameraType.Custom
        end
        task.wait(0.1)
    end
end

-- 
-- 
-- 
-- GUI
-- 
-- 
-- 

local fixedCameraToggleNote = settingsTab:CreateParagraph({
    Title = "Note",
    Content = "Enabling Fixed Camera will reduce lag by bypassing camera tweening and effects during teleports."
})
local settingsTab = Window:CreateTab("Settings", "settings")
local settingsTabDivider1 = settingsTab:CreateDivider()
local fixedCameraToggle = settingsTab:CreateToggle({
    Name = "Change Camera type to fixed",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        fixCameraEnable = Value
        if Value then
            task.spawn(setCameraFixed)
        end
    end,
})
