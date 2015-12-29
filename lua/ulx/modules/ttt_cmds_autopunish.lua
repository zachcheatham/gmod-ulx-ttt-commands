local SLAY_PDATA_KEY = "ttt_pending_slay"
local IMPAIR_PDATA_KEY = "ttt_pending_impair"

function ulx.getSlayInfo(ply)
	local slayString = ply:GetPData(SLAY_PDATA_KEY, false)

	if not slayString then
		return 0, false
	else
		local data = string.Explode(";", slayString)
		if table.Count(data) > 1 then
			local slays = tonumber(data[1])
			
			if slays > 0 then
				local reason = data[2]
				
				for i=3,table.Count(data) do
					reason = reason .. data[i]
				end
				
				return slays, reason
			else
				ply:RemovePData(SLAY_PDATA_KEY)
				return 0, false
			end
		else
			ply:RemovePData(SLAY_PDATA_KEY)
			return 0, false
		end
	end
end

function ulx.getImpairInfo(ply)
	local impairString = ply:GetPData(IMPAIR_PDATA_KEY, false)

	if not impairString then
		return 0, false
	else
		local data = string.Explode(";", impairString)
		if table.Count(data) > 1 then
			local damage = tonumber(data[1])
			
			if damage > 0 then
				local reason = data[2]
				
				for i=3,table.Count(data) do
					reason = reason .. data[i]
				end
				
				return damage, reason
			else
				ply:RemovePData(IMPAIR_PDATA_KEY)
				return 0, false
			end
		else
			ply:RemovePData(IMPAIR_PDATA_KEY)
			return 0, false
		end
	end
end

local function beginRound()
	for _, ply in pairs(player.GetAll()) do
		if ply:Alive() then
			local damage, damageReason = ulx.getImpairInfo(ply)
			local slays, slayReason = ulx.getSlayInfo(ply)
			
			if damage > 0 then
				-- Damage
				ply:TakeDamage(damage)
				
				-- Delete damage
				ply:RemovePData(IMPAIR_PDATA_KEY)
				
				-- Tell everyone what happened
				ULib.tsayColor(nil, false, Color(255,0,0), ply:Nick(), Color(205, 205, 205), " has been damaged " .. damage .. " hp for " .. damageReason .. " in a previous round.")
			end
			
			if slays > 0 then
				-- Kill
				ply:Kill()
				
				-- Save data for next round
				slays = slays - 1
				if slays > 0 then
					local slayString = slays .. ";" .. slayReason
					ply:SetPData(SLAY_PDATA_KEY, slayString)
				else
					ply:RemovePData(SLAY_PDATA_KEY)
				end
				
				-- Tell everyone what happened and maybe they won't kill each other
				ULib.tsayColor(nil, false, Color(255,0,0), ply:Nick(), Color(205, 205, 205), " has been killed for " .. slayReason .. " in a previous round.")
			end
		end
	end
end
hook.Add("TTTBeginRound", "ULXSlayImpairList", beginRound)