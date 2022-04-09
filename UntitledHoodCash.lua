--// INF AMMO (LOCAL PLAYER) (MAX AMMO) THE MAX AMMO THING LOCALLY WHERE U HAVE INF AMMO BUT U STILL NEED TO RELOAD UNLOADED BULLETS [INVENTORY BULLETS]
game.ReplicatedStorage:FindFirstChild(".gg/untitledhood"):FireServer(
    "Reload",
    {
        Name = "[Revolver]", --// reminder: [Double-Barrel SG] or [Revolver] works for any gun but i put it here so i can just copy and paste whenever i want to
        Ammo = {Value = math.huge*9e9},
        MaxAmmo = {Value = 0}
    }
)
task.wait(1.7)
--// MAX CURRENCY
game.ReplicatedStorage:FindFirstChild(".gg/untitledhood"):FireServer(
    "Reload",
    {
        Name = "[Revolver]",
        Ammo = game:GetService("Players").LocalPlayer.DataFolder.Currency,
        MaxAmmo = {Value = 999999999999999999 * 2}
    }
) 
