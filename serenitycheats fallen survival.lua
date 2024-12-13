if Game.PlaceId == 10228136016 then

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    --key system
    local Window = Rayfield:CreateWindow({
   Name = "Fallen Survival🏹 | Serenity.Cheats",
   LoadingTitle = "Serenity.Cheats",
   LoadingSubtitle = "by Deju",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "FALLEN"
   },
   Discord = {
      Enabled = True,
      Invite = "DKyzwuXMtP", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = True, -- Set this to true to use our key system
   KeySettings = {
      Title = "Fallen keySystem",
      Subtitle = "Key System",
      Note = "JOIN DISCORD FOR HELP",
      FileName = "FallenKey", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = False, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = True, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/keys"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

    --Tabs
local MainTab = Window:CreateTab("😎Main", nil) -- Title, Image
    local MainSection = MainTab:CreateSection("Main")


--Notify

Rayfield:Notify({
   Title = "Serenity.Cheats",
   Content = "This is the first version of Serenity.Cheats",
   Duration = 5.5,
   Image = nils,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "rd bet / okay",
         Callback = function()
         print("The user tapped Okay!")
      end
   },
},
})
    --buttons
    
local Button = Tab:CreateButton({
   Name = "aimbot",
   Callback = function()
   local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local target
local lockOnRadius = 50 -- Set the radius for the lock-on circle

-- Function to create a circle part around the player
local function createCircle()
    local circle = Instance.new("Part")
    circle.Shape = Enum.PartType.Cylinder
    circle.Size = Vector3.new(2 * lockOnRadius, 1, 2 * lockOnRadius)
    circle.Anchored = true
    circle.CanCollide = false
    circle.Transparency = 0.5
    circle.Material = Enum.Material.Neon
    circle.Color = Color3.fromRGB(0, 255, 0)
    circle.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(90), 0, 0)
    circle.Parent = workspace

    return circle
end

local function getClosestPlayerInRadius()
    local closestDistance = lockOnRadius
    local closestPlayer = nil

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player then
            local character = v.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = (character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = v
                end
            end
        end
    end

    return closestPlayer
end

mouse.Button2Down:Connect(function() -- Button2Down is the right mouse button
    local closestPlayer = getClosestPlayerInRadius()
    if closestPlayer then
        target = closestPlayer
        print("Locked onto: " .. target.Name)
    else
        print("No players within the radius")
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position)
    end
end)

-- Create and update the circle part around the player
local circlePart = createCircle()

game:GetService("RunService").Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        circlePart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(90), 0, 0)
    end
end)

   end,
})
    --new one
    local Button = MainTab:CreateButton({
   Name = "esp",
   Callback = function()
   local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Function to create ESP for a player
local function createESP(player)
    local function addHighlight(character)
        if not character:FindFirstChild("HumanoidRootPart") then return end

        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0

        -- Remove the highlight when the character is removed
        character.AncestryChanged:Connect(function(_, parent)
            if not parent then
                highlight:Destroy()
            end
        end)
    end

    -- Add ESP when player spawns
    player.CharacterAdded:Connect(addHighlight)
    -- Add ESP if the player already has a character
    if player.Character then
        addHighlight(player.Character)
    end
end

-- Add ESP to all players in the game
Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

-- Add ESP to players already in the game
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

   end,
})
