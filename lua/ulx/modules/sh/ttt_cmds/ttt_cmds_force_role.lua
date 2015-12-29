function ulx.force(calling_ply, target_plys, target_role, should_silent)
	if GetRoundState() == 1 or GetRoundState() == 2 then
		ULib.tsayError(calling_ply, "The round has not begun!", true)
		return
	end
	
	local startingCredits = GetConVarNumber("ttt_credits_starting")
	
	local role
	local roleGammar
	local roleName
	local roleCredits
	
	if target_role == "traitor" or target_role == "t" then
		role = ROLE_TRAITOR
		roleGrammar = "a "
		roleName = "traitor"
		roleCredits = startingCredits
	elseif target_role == "detective" or target_role == "d" then
		role = ROLE_DETECTIVE
		roleGrammar = "a "
		roleName = "detective"
		roleCredits = startingCredits
	elseif target_role == "innocent" or target_role == "i" then
		role = ROLE_INNOCENT
		roleGrammar = "an "
		roleName = "innocent"
		roleCredits = 0
	else
		ULib.tsayError(calling_ply, "Invalid role :\"" .. target_role .. "\" specified", true)
		return
	end
	
	for _, ply in pairs(target_plys) do
		if not ply:Alive() then
			ULib.tsayError(calling_ply, ply:Nick() .. " is dead!", true)
		elseif ply:GetRole() == role then
			ULib.tsayError(calling_ply, ply:Nick() .. " is already " .. roleName, true)
		else
			ply:ResetEquipment()
			RemoveLoadoutWeapons(ply)
			RemoveBoughtWeapons(ply)
			
			ply:SetRole(role)
			ply:SetCredits(startingCredits)
			SendFullStateUpdate()
			
			GiveLoadoutItems(ply)
	        GiveLoadoutWeapons(ply)
			
			ply:ChatPrint("Your role has been forced as " .. roleName .. ".")
		end
	end
	
	ulx.fancyLogAdmin(calling_ply, should_silent, "#A forced #T to be " .. roleGrammar .. "#s.", target_plys, roleName)
end
local force = ulx.command("TTT", "ulx force", ulx.force, "!force")
force:addParam{type=ULib.cmds.PlayersArg}
force:addParam{type=ULib.cmds.StringArg, completes=ulx.target_role, hint="Role"}
force:addParam{type=ULib.cmds.BoolArg, invisible=true}
force:defaultAccess(ULib.ACCESS_SUPERADMIN)
force:setOpposite("ulx sforce", {_, _, _, true}, "!sforce", true)
force:help("Force <target(s)> to become a specified role.")