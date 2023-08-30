local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Packages, Services = ReplicatedStorage.Packages, ServerStorage.Server.Services

local Knit = require(Packages.Knit)

Knit.AddServices(Services)

Knit.Start():andThen(function()
    print("Knit server started!")

    local MoneyService = Knit.GetService("MoneyService")

    while task.wait(0.5) do
        MoneyService:GiveMoney(game.Players.Puzzled3d, math.random(3,5))
    end
end):catch(warn)