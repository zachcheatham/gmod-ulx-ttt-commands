function ulx.identify(calling_ply, target_ply, unidentify)
	body = findCorpse(target_ply)
	if not body then
		ULib.tsayError(calling_ply, target_ply:Nick() .. "'s corpse does not exist!", true)
	else
		if not unidentify then
			ulx.fancyLogAdmin(calling_ply, "#A identified #T's body!", target_ply)
			CORPSE.SetFound(body, true)
			target_ply:SetNWBool("body_found", true)
			
			if target_ply:GetRole() == ROLE_TRAITOR then
				SendConfirmedTraitors(GetInnocentFilter(false))
				SCORE:HandleBodyFound(calling_ply, target_ply)
			end
		else
			ulx.fancyLogAdmin(calling_ply, "#A unidentified #T's body!", target_ply)
			CORPSE.SetFound(body, false)
			target_ply:SetNWBool("body_found", false)
			SendFullStateUpdate()
		end
	end
end
local identify = ulx.command("TTT", "ulx identify", ulx.identify, "!identify")
identify:addParam{type=ULib.cmds.PlayerArg}
identify:addParam{type=ULib.cmds.BoolArg, invisible=true}
identify:defaultAccess(ULib.ACCESS_SUPERADMIN)
identify:setOpposite("ulx unidentify", {_, _, true}, "!unidentify", true)
identify:help("Identifies a target's body.")

function ulx.removebody(calling_ply, target_ply)
	body = findCorpse(target_ply)
	if not body then
		ULib.tsayError(calling_ply, target_ply:Nick() .. "'s corpse does not exist!", true)
	else
		ulx.fancyLogAdmin(calling_ply, "#A removed #T's body!", target_ply)
		if string.find(body:GetModel(), "zm_", 6, true) then
			body:Remove()
		elseif body.player_ragdoll then
			body:Remove()
		end
	end
end
local removebody = ulx.command("TTT", "ulx removebody", ulx.removebody, "!removebody")
removebody:addParam{type=ULib.cmds.PlayerArg}
removebody:defaultAccess(ULib.ACCESS_SUPERADMIN)
removebody:help("Removes a target's body.")