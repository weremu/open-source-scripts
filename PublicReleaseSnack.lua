--/// PUBLIC RELEASE SNACK
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Snack", "BloodTheme")
local CharacterTab = Window:NewTab("Character")
local PlayerTab = Window:NewTab("Player")
local SettingsTab = Window:NewTab("Settings")
local MovementSection = CharacterTab:NewSection("Movement")
local CharacterSection = CharacterTab:NewSection("Character")
local AimingSection = PlayerTab:NewSection("Aiming Section")
local SettingsSection = SettingsTab:NewSection("Settings")
local StarterGui = game:GetService("StarterGui")
local mouse = game.Players.LocalPlayer:GetMouse()
local sconnections = {}
local loopbreak = false
local CFrameSpeedTP = 0 -- // Default CFrame TP Speed
local JumpPower = 50 --// Default Jump Power
local njcs = false --// No Jump Cooldown
local infj = false --// Infinite Jump
local circfov = 250 --// Silent Aim Circle FOV
local cs  --// RunService Stepped Connection
local c1  --// CFrame TP
local c2  --// Anti Stomp
local c3  --// Noclip
local c4  --// JumpPower Loop
local c5  --// Infinite Jump
local c7  --// Silent Aim
local circle  --// Circle FOV
do
    --// Spoof the Current Da Hood Modded Anti Cheat
    local function ACThing()
        for I, V in pairs(getgc(true)) do
            if type(V) == "function" then
                if getfenv(V).script and getfenv(V).script.name == "Camera" then
                    for I2, V2 in pairs(getupvalues(V)) do
                        if type(V2) == "table" and rawget(V2, "DoThings") then
                            rawset(V2, "Break", true)
                            rawset(
                                V2,
                                "DoThings",
                                function()
                                end
                            )
                        end
                    end
                end
            end
        end
    end
    ACThing()
    game.Players.LocalPlayer.CharacterAdded:connect(ACThing)

    --// Creates the Circle
    circle = Drawing.new("Circle")
    circle.Transparency = 1
    circle.Thickness = 1
    circle.Radius = 100
    circle.Filled = false
    circle.Color = Color3.new(255, 255, 255)
    circle.Visible = true

    --// Silent Aim
    local oldh
    oldh =
        hookmetamethod(
        game,
        "__index",
        function(Self, Index)
            if Self:IsA("Mouse") and Index == "Hit" and c7 then
                local target
                local raycastlimit = 9e9
                for _, V in pairs(workspace.Characters:GetChildren()) do
                    if
                        V.Name ~= game.Players.LocalPlayer.Name and V:FindFirstChild("Head") and
                            V:FindFirstChild("HumanoidRootPart") and
                            V:FindFirstChild("I_LOADED_I") and
                            V.I_LOADED_I:FindFirstChild("K.O") and
                            not V.I_LOADED_I:FindFirstChild("K.O").Value
                     then
                        local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(V.HumanoidRootPart.Position)
                        if vis then
                            local m =
                                (Vector2.new(
                                game.Players.LocalPlayer:GetMouse().X,
                                game.Players.LocalPlayer:GetMouse().Y
                            ) - Vector2.new(pos.X, pos.Y)).Magnitude
                            if m < raycastlimit and m < circfov then
                                local humanoid = V.Humanoid
                                humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                                humanoid.HealthDisplayDistance = 5000
                                humanoid.NameDisplayDistance = 5000
                                target = V
                                raycastlimit = m
                            else
                                local humanoid = V.Humanoid
                                humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                                humanoid.HealthDisplayDistance = 100
                                humanoid.NameDisplayDistance = 100
                            end
                        end
                    end
                end

                if target then
                    local head = target.Head
                    returningvalue = head.CFrame + (head.Velocity * .20)
                    return Index == "Hit" and returningvalue
                end
            end
            return oldh(Self, Index)
        end
    )

    --// Remove Wait() Cooldown
    local old
    old =
        hookfunction(
        wait,
        function(a)
            local oldarg = a
            if njcs or infj then
                a = 0
                return old(a)
            else
                return old(a)
            end
        end
    )
end
--//

cs =
    game:GetService("RunService").Stepped:connect(
    function()
        --// RunService Stepped
        if c1 then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame +
                game.Players.LocalPlayer.Character.Humanoid.MoveDirection * CFrameSpeedTP
        end
        if c3 then
            for I, V in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if V:IsA("BasePart") and V.CanCollide == true then
                    V.CanCollide = false
                end
            end
        end
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = JumpPower
    end
)
table.insert(sconnections, cs)

--// while true do loop
coroutine.wrap(
    function()
        --// Avoid yielding
        while true do
            task.wait()
            if loopbreak then
                break
            end
            pcall(
                function()
                    --// Move the Circle's Position to Mouse
                    if c7 then
                        circle.Visible = true
                        circle.Position = Vector2.new(mouse.X, mouse.Y + 40)
                        circle.Radius = circfov
                    else
                        circle.Visible = false
                    end
                    --// Anti Stomp
                    if c2 then
                        if game.Players.LocalPlayer.Character.Humanoid.Health <= 10 then
                            game.Players.LocalPlayer.Character.I_LOADED_I:Destroy()
                            wait(5)
                            game.Players.LocalPlayer.Character.Humanoid.RigType = Enum.HumanoidRigType.R6
                        end
                    end
                end
            )
        end
    end
)()

MovementSection:NewToggle(
    "CFrame TP",
    "Teleports you to your move direction",
    function(state)
        c1 = state
    end
)

MovementSection:NewSlider(
    "CFrame TP Speed",
    "Defines how fast you teleport to your move direction",
    5,
    0,
    function(s) -- 5 (MaxValue) | 0 (MinValue)
        CFrameSpeedTP = s
    end
)

MovementSection:NewToggle(
    "No Jump Cooldown",
    "Allows you to jump without having cooldown",
    function(state)
        njcs = state
    end
)

MovementSection:NewToggle(
    "Infinite Jump",
    "Allows you to jump infinitely",
    function(state)
        infj = state
        if state then
            c5 =
                game.Players.LocalPlayer:GetMouse().KeyDown:connect(
                function(k)
                    if infj and k == " " then
                        game.Players.LocalPlayer.Character.Humanoid:ChangeState(3)
                    end
                end
            )
            table.insert(sconnections, c5)
        else
            c5:Disconnect()
        end
    end
)

MovementSection:NewSlider(
    "Jump Power",
    "Defines how high you jump",
    350,
    50,
    function(state)
        JumpPower = state
    end
)

CharacterSection:NewToggle(
    "Anti Stomp",
    "Doesnt allow you to get stomped or grabbed",
    function(state)
        if state then
            c2 = true
        else
            c2 = false
        end
    end
)

CharacterSection:NewToggle(
    "Noclip",
    "Disables collisions for your bodyparts",
    function(state)
        c3 = state
    end
)

CharacterSection:NewButton(
    "Die",
    "Die",
    function()
        for I, V in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if V:IsA("BasePart") and not V.Anchored then
                V.Anchored = true
            end
        end
        game.Players.LocalPlayer.Character.Head:ClearAllChildren()
    end
)

AimingSection:NewToggle(
    "Silent Aim",
    "Shoots people inside the Circle FOV",
    function(state)
        c7 = state
    end
)

AimingSection:NewSlider(
    "Circle FOV",
    "Silent Aim Circle FOV",
    1000,
    10,
    function(state)
        circfov = state
    end
)

SettingsSection:NewKeybind(
    "Toggle UI",
    "Toggle the Menu",
    Enum.KeyCode.M,
    function()
        xpcall(
            function()
                Library:ToggleUI()
            end,
            function()
                for i, v in pairs(sconnections) do
                    v:Disconnect()
                end
                loopbreak = true
                task.wait()
                table.clear(sconnections)
                warn("Snack is no longer running!")
            end
        )
    end
)
