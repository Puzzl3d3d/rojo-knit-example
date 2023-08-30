local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Knit = require(Packages.Knit)

local Config = require(script.Config)

local MoneyService = Knit.CreateService {
    Name = "MoneyService";
    Client = {
        MoneyChanged = Knit.CreateSignal();
    };
    _MoneyPerPlayer = {};
}

function MoneyService:KnitStart()
    print("MoneyService Started!")
end

function MoneyService:KnitInit()
    print("MoneyService Initialised!")

    Players.PlayerRemoving:Connect(function(player)
        self._MoneyPerPlayer[player] = nil
    end)
end

function MoneyService.Client:GetMoney(player: Player): number
    return self.Server:GetMoney(player)
end

function MoneyService:GetMoney(player: Player): number
    local money = self._MoneyPerPlayer[player] or Config.StartingMoney
    return money
end

function MoneyService:GiveMoney(player: Player, amount: number): nil
    local money = self:GetMoney(player)
    local newMoney = money + amount
    self._MoneyPerPlayer[player] = newMoney
    self.Client.MoneyChanged:Fire(player, newMoney)
end

return MoneyService