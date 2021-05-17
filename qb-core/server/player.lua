	self.Functions.AddMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end

		if moneytype == 'cash' then
			self.Functions.AddItem('cash', amount)
			self.Functions.UpdatePlayerData()
		else
			if self.PlayerData.money[moneytype] ~= nil then
				-- if moneytype == 'cash' then
				-- 	self.Functions.AddItem('cash', amount)
				-- 	TriggerClientEvent('inventory:client:ItemBox', self.PlayerData.source, QBCore.Shared.Items['cash'], 'add', amount)
				-- end
				self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype]+amount
				self.Functions.UpdatePlayerData()
				-- TriggerEvent("qb-log:server:sendLog", self.PlayerData.citizenid, "moneyadded", {amount=amount, moneytype=moneytype, newbalance=self.PlayerData.money[moneytype], reason=reason})
				if amount > 100000 then
					TriggerEvent("qb-log:server:CreateLog", source,  "playermoney", "AddMoney", "lightgreen",  "$"..amount .. " ("..moneytype..") eklendi, yeni "..moneytype.." parası: "..self.PlayerData.money[moneytype], true)
				else
					TriggerEvent("qb-log:server:CreateLog", source,  "playermoney", "AddMoney", "lightgreen", "$"..amount .. " ("..moneytype..") eklendi, yeni "..moneytype.." parası: "..self.PlayerData.money[moneytype])
				end
				-- TriggerClientEvent("hud:client:OnMoneyChange", self.PlayerData.source, moneytype, amount, false)
				return true
			end
		end
		return false
	end
	
	self.Functions.RemoveMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		-- if self.PlayerData.money[moneytype] ~= nil then
			-- if self.Functions.GetItemByName('cash') ~= nil then
				if moneytype == 'cash' then
					if self.Functions.GetItemByName('cash') ~= nil then
						if self.Functions.GetItemByName('cash').amount >= amount then
							self.Functions.RemoveItem('cash', amount)
							self.Functions.UpdatePlayerData()
							-- TriggerEvent("qb-log:server:sendLog", self.PlayerData.citizenid, "moneyremoved", {amount=amount, moneytype=moneytype, newbalance=self.PlayerData.money[moneytype], reason=reason})
							if amount > 100000 then
								TriggerEvent("qb-log:server:CreateLog", source,  "playermoney", "RemoveMoney", "red", "€"..amount .. " ("..moneytype..") silindi, yeni "..moneytype.." bakiyesi: "..self.PlayerData.money[moneytype], true)
							else
								TriggerEvent("qb-log:server:CreateLog", source,  "playermoney", "RemoveMoney", "red", "€"..amount .. " ("..moneytype..") silindi, yeni "..moneytype.." bakiyesi: "..self.PlayerData.money[moneytype])
							end
							-- TriggerClientEvent("hud:client:OnMoneyChange", self.PlayerData.source, moneytype, amount, true)
							-- TriggerClientEvent('qb-phone_new:client:RemoveBankMoney', self.PlayerData.source, amount)
							return true
						else
							return false
						end
					else
						return false
					end
				else
					if self.PlayerData.money[moneytype] ~= nil then
						for _, mtype in pairs(QBCore.Config.Money.DontAllowMinus) do
							if mtype == moneytype then
								if self.PlayerData.money[moneytype] - amount < 0 then return false end
							end
						end
						self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
						self.Functions.UpdatePlayerData()
						-- TriggerEvent("qb-log:server:sendLog", self.PlayerData.citizenid, "moneyremoved", {amount=amount, moneytype=moneytype, newbalance=self.PlayerData.money[moneytype], reason=reason})
						if amount > 100000 then
							TriggerEvent("qb-log:server:CreateLog", source,  "playermoney", "RemoveMoney", "red", "€"..amount .. " ("..moneytype..") removed, new "..moneytype.." balance: "..self.PlayerData.money[moneytype], true)
						else
							TriggerEvent("qb-log:server:CreateLog", source,  "playermoney", "RemoveMoney", "red", "€"..amount .. " ("..moneytype..") removed, new "..moneytype.." balance: "..self.PlayerData.money[moneytype])
						end
						-- TriggerClientEvent("hud:client:OnMoneyChange", self.PlayerData.source, moneytype, amount, true)
						-- TriggerClientEvent('qb-phone_new:client:RemoveBankMoney', self.PlayerData.source, amount)
						return true
					else
						return false
					end
				end
			-- end
		-- end
		-- return false
	end

	self.Functions.SetMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if moneytype == 'cash' then
			if self.Functions.GetItemByName('cash') ~= nil then
				local pgggagamtestte = self.Functions.GetItemByName('cash').amount
				self.Functions.RemoveItem('cash', pgggagamtestte)
				self.Functions.AddItem('cash', amount)
				self.Functions.UpdatePlayerData()
				return true
			else
				self.Functions.AddItem('cash', amount)
				self.Functions.UpdatePlayerData()
				return true
			end
		elseif self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = amount
			self.Functions.UpdatePlayerData()
			-- TriggerEvent("qb-log:server:sendLog", self.PlayerData.citizenid, "moneyset", {amount=amount, moneytype=moneytype, newbalance=self.PlayerData.money[moneytype], reason=reason})
			TriggerEvent("qb-log:server:CreateLog", source,  "playermoney", "SetMoney", "green", "€"..amount .. " ("..moneytype..") gezet, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype])
			return true
		end
		return false
	end
