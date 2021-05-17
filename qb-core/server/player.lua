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
				self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype]+amount
				self.Functions.UpdatePlayerData()
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
					if self.PlayerData.money[moneytype] ~= nil then
						for _, mtype in pairs(QBCore.Config.Money.DontAllowMinus) do
							if mtype == moneytype then
								if self.PlayerData.money[moneytype] - amount < 0 then return false end
							end
						end
						self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
						self.Functions.UpdatePlayerData()
						return true
					else
						return false
					end
				end
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
			return true
		end
		return false
	end
