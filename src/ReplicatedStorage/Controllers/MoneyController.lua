local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Knit = require(Packages.Knit)

local MoneyController = Knit.CreateController {
    Name = "MoneyController";
}

function MoneyController:KnitStart()
    self._MoneyService = Knit.GetService("MoneyService")
    print("MoneyController started!")
end

function MoneyController:KnitInit()
    print("MoneyController initialised!")
end

function MoneyController:GetMoney(yeild: boolean?): number
    return self._MoneyService:GetMoney() --> Promise
end

function MoneyController:OnMoneyChanged(func)
    self._changedConnection = self._MoneyService.MoneyChanged:Connect(func)
end

function MoneyController:Disconnect()
    if self._changedConnection then
        self._changedConnection:Disconnect()
    end
end

return MoneyController