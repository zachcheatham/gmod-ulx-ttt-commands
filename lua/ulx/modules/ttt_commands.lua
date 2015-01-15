local PDATA_KEY = "ttt_pending_slay"

--[[local function findRagdoll(ply)
	for _, ent in pairs( ents.FindByClass( "prop_ragdoll" )) do
		if ent.uqid == ply:UniqueID() and IsValid(ent) then
			return ent or false
		end
	end
end

local function identifyBody(ply)
	if not CORPSE.GetFound(rag, false) then
		ply:SetNWBool("body_found", true)
		
		if ply:GetTraitor() then
			SendConfirmedTraitors(GetInnocentFilter(false))
		end
		
		local ragdoll = findRagdoll(ply)
		if ragdoll then
			--hook.Call("TTTBodyFound", GAMEMODE, ply, ply, ragdoll)
			CORPSE.SetFound(ragdoll, true)
		end
	end
end]]--

local function getSlayInfo(ply)
	local slayString = ply:GetPData(PDATA_KEY, false)

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
				ply:RemovePData(PDATA_KEY)
				return 0, false
			end
		else
			ply:RemovePData(PDATA_KEY)
			return 0, false
		end
	end
end

local function roundBegin()
	for _, ply in pairs(player.GetAll()) do
		if ply:Alive() then
			local slays, reason = getSlayInfo(ply)
			
			if slays > 0 then
				-- Kill
				ply:Kill()
				-- Identifing the body seems to fuck with the scoreboard
				--timer.Simple(1, function() identifyBody(ply) end)
			
				-- Save data for next round
				slays = slays - 1
				if slays > 0 then
					local slayString = slays .. ";" .. reason
					ply:SetPData(PDATA_KEY, slayString)
				else
					ply:RemovePData(PDATA_KEY)
				end
				
				-- Tell everyone what happened and maybe they won't kill each other
				ULib.tsayColor(nil, false, Color(255,0,0), ply:Nick(), Color(205, 205, 205), " has been killed for " .. reason .. " in a previous round.")
			end
		end
	end
end
hook.Add("TTTBeginRound", "ULXSlayList", roundBegin)