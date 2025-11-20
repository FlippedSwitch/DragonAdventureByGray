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
        cam.CameraType = Enum.CameraType.Fixed
        task.wait(0.1)
    end
    cam.CameraType = Enum.CameraType.Custom
end

-- 
-- 
-- 
-- GUI
-- 
-- 
-- 

local Window = Rayfield:CreateWindow({
   Name = "Gray Script",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Gray",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K",
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
local fixedCameraToggleNote = settingsTab:CreateParagraph({
    Title = "Note",
    Content = "Enabling Fixed Camera will reduce lag by bypassing camera tweening and effects during teleports."
})
