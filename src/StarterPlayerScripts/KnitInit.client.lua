local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages, Controllers = ReplicatedStorage.Packages, ReplicatedStorage.Shared.Controllers

local Knit = require(Packages.Knit)

Knit.AddControllers(Controllers)

Knit.Start():andThen(function()
    print("Knit client started!")

    local MoneyService = Knit.GetController("MoneyController")

    MoneyService:OnMoneyChanged(function(money)
        print("New money:", money)
    end)
end):catch(warn)