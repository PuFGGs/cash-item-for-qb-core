self.Functions.AddMoney = function(moneytype, amount, reason)
    reason = reason or 'unknown'
    local moneytype = moneytype:lower()
    local amount = tonumber(amount)
    if amount < 0 then return end
    if self.PlayerData.money[moneytype] then
        if moneytype == 'cash' then
            self.Functions.AddItem('cash', amount)
			self.Functions.UpdatePlayerData()
            return true
        else
            self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype], true)
            else
                TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype])
            end
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, false)
            return true
        end
    end
    return false
end

self.Functions.RemoveMoney = function(moneytype, amount, reason)
    reason = reason or 'unknown'
    local moneytype = moneytype:lower()
    local amount = tonumber(amount)
    if amount < 0 then return end
    if self.PlayerData.money[moneytype] then
        for _, mtype in pairs(QBCore.Config.Money.DontAllowMinus) do
            if mtype == moneytype then
                if self.PlayerData.money[moneytype] - amount < 0 then
                    return false
                end
            end
        end
        if moneytype == 'cash' then
            if self.Functions.GetItemByName('cash') ~= nil then
                if self.Functions.GetItemByName('cash').amount >= amount then
                    self.Functions.RemoveItem('cash', amount)
                    self.Functions.UpdatePlayerData()
                    return true
                else
                    return false
                end
            else
                return false
            end
        else
            self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype], true)
            else
                TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype])
            end
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
            if moneytype == 'bank' then
                TriggerClientEvent('qb-phone:client:RemoveBankMoney', self.PlayerData.source, amount)
            end
            return true
        end
    end
    return false
end

self.Functions.SetMoney = function(moneytype, amount, reason)
    reason = reason or 'unknown'
    local moneytype = moneytype:lower()
    local amount = tonumber(amount)
    if amount < 0 then return end
    if moneytype == 'cash' then
        if self.Functions.GetItemByName('cash') ~= nil then
            local activeAmount = self.Functions.GetItemByName('cash').amount
            self.Functions.RemoveItem('cash', activeAmount)
            self.Functions.AddItem('cash', amount)
            self.Functions.UpdatePlayerData()
            return true
        else
            self.Functions.AddItem('cash', amount)
            self.Functions.UpdatePlayerData()
            return true
        end
    else
        if self.PlayerData.money[moneytype] then
            self.PlayerData.money[moneytype] = amount
            self.Functions.UpdatePlayerData()
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'SetMoney', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') set, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype])
            return true
        end
        return false
    end
end

self.Functions.GetMoney = function(moneytype)
    if self.PlayerData.money[moneytype] then
        if moneytype == 'cash' then
            if self.Functions.GetItemByName('cash') ~= nil then
                return self.Functions.GetItemByName('cash').amount
            else
                return 0
            end
        end
        local moneytype = moneytype:lower()
        return self.PlayerData.money[moneytype]
    end
    return false
end