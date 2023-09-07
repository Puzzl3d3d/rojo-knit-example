local FirstRunTick = os.clock()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Packages, Services = ReplicatedStorage.Packages, ServerStorage.Server.Services

local Knit = require(Packages.Knit)

Knit.AddServices(Services)

Knit.Start():andThen(function()
    print(("Knit Server Loaded 🧶! Latency: %.1fms"):format((os.clock() - FirstRunTick) * 1000))
end):catch(warn)