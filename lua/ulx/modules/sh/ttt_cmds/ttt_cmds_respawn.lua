function ulx.respawn(calling_ply, target_plys, should_silent)
	if GetRoundState() == 1 then
	    ULib.tsayError(calling_ply, "Waiting for players!", true)
		return
	end

	for _, ply in pairs(target_plys) do	
		if ply:Alive() then
			ULib.tsayError(calling_ply, ply:Nick() .. " is already alive!", true) 
		else
			local corpse = findCorpse(ply)
			if corpse then removeCorpse(corpse) end

			ply:SpawnForRound(true)
			ply:SetCredits(((ply:GetRole() == ROLE_INNOCENT) and 0) or GetConVarNumber("ttt_credits_starting"))
			
			ply:ChatPrint("You have been respawned.")
		end
	end
	
	ulx.fancyLogAdmin(calling_ply, should_silent ,"#A respawned #T!", target_plys)
end
local respawn = ulx.command("TTT", "ulx respawn", ulx.respawn, "!respawn")
respawn:addParam{type=ULib.cmds.PlayersArg}
respawn:addParam{type=ULib.cmds.BoolArg, invisible=true}
respawn:defaultAccess(ULib.ACCESS_SUPERADMIN)
respawn:setOpposite("ulx srespawn", {_, _, true}, "!srespawn", true)
respawn:help("Respawns <target(s)>.")