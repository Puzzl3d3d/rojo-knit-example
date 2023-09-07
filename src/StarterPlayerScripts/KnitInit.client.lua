local FirstRunTick = os.clock()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages, Controllers = ReplicatedStorage.Packages, ReplicatedStorage.Shared.Controllers

local Knit = require(Packages.Knit)

Knit.AddControllers(Controllers)

Knit.Start():andThen(function()
    print(("Knit Client Loaded 🧶! Latency: %.1fms"):format((os.clock() - FirstRunTick) * 1000))
end):catch(warn)