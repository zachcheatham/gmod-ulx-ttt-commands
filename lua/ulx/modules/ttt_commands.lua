-----------------
-- TTT AddSlay --
-----------------

local SLAY_PDATA_KEY = "ttt_pending_slay"

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

local function slayListRoundBegin()
	for _, ply in pairs(player.GetAll()) do
		if ply:Alive() then
			local slays, reason = ulx.getSlayInfo(ply)
			
			if slays > 0 then
				-- Kill
				ply:Kill()
				
				-- Save data for next round
				slays = slays - 1
				if slays > 0 then
					local slayString = slays .. ";" .. reason
					ply:SetPData(SLAY_PDATA_KEY, slayString)
				else
					ply:RemovePData(SLAY_PDATA_KEY)
				end
				
				-- Tell everyone what happened and maybe they won't kill each other
				ULib.tsayColor(nil, false, Color(255,0,0), ply:Nick(), Color(205, 205, 205), " has been killed for " .. reason .. " in a previous round.")
			end
		end
	end
end
hook.Add("TTTBeginRound", "ULXSlayList", slayListRoundBegin)

-----------------------
-- Vote Silent Round --
-----------------------
local function setULXGag(ply, gagged)
	ply.ulx_gagged = gagged
	ply:SetNWBool("ulx_gagged", gagged)
end

ulx.nextRoundSilent = false
ulx.inSilentRound = false

local gaggedPlayers = {}

function ulx.initiateSilentRound()
	if not ulx.inSilentRound then
		ulx.inSilentRound = true
		table.Empty(gaggedPlayers)
		
		for _, ply in ipairs(player.GetAll()) do
			if not ply.ulx_gagged then
				table.insert(gaggedPlayers, ply)
				setULXGag(ply, true)
			end
		end
		
		ULib.tsayColor(nil, false, Color(201, 155, 255), "Silent round initialized. ", Color(255, 255, 255), "You will not be able to voice chat until the end of the round.")
	end
end

local function vsrRoundBegin()
	if ulx.nextRoundSilent then
		ulx.nextRoundSilent = false
		ulx.initiateSilentRound()
	end
end
hook.Add("TTTBeginRound", "ULXVoteSilentRound", vsrRoundBegin)

local function vsrRoundEnd()
	if ulx.inSilentRound then
		ulx.inSilentRound = false
		
		for _, ply in ipairs(gaggedPlayers) do
			if IsValid(ply) then
				setULXGag(ply, false)
			end
		end
		
		table.Empty(gaggedPlayers)
		ULib.tsayColor(nil, false, Color(100, 255, 0), "Silent round ended. ", Color(255, 255, 255), "You may now use voice chat.")
	end
end
hook.Add("TTTEndRound", "ULXVoteSilentRound", vsrRoundEnd)
