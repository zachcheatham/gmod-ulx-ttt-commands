local SLAY_PDATA_KEY = "ttt_pending_slay"
local IMPAIR_PDATA_KEY = "ttt_pending_impair"
local DEFAULT_SLAY_REASON = "RDMing"

local function addSlay(calling_ply, target_ply, args, remove_slay)
	local currentSlay = target_ply:GetPData(SLAY_PDATA_KEY, false)
	if remove_slay then
		if not currentSlay then
			ULib.tsayError(calling_ply, target_ply:Nick() .. " isn't being slain next round.")
		else
			target_ply:RemovePData(SLAY_PDATA_KEY)
			ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslay"), "#A removed #T from the slay list.", target_ply)
		end
	else
		if not currentSlay then
			local reason = DEFAULT_SLAY_REASON
			local slays = 1
			
			if args and string.len(args) > 0 and args ~= "Reason" then
				if tonumber(args) then
					slays = tonumber(args)
				else
					local explode = string.Explode(" ", args)
					if tonumber(explode[1]) then
						slays = tonumber(explode[1])
						table.remove(explode, 1)
						reason = string.Implode(" ", explode)
					elseif tonumber(explode[#explode]) then
						slays = tonumber(explode[#explode])
						table.remove(explode, #explode)
						reason = string.Implode(" ", explode)
					else
						reason = args
					end
				end
			end
			
			if slays > 3 then
				ULib.tsayError(calling_ply, "You may not slay for more than 3 rounds.")
				return
			end
			
			local slayString = slays .. ";" .. reason
			target_ply:SetPData(SLAY_PDATA_KEY, slayString)
			
			if slays > 1 then
				ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslay"), "#A will slay #T for the next #s rounds for #s.", target_ply, slays, reason)
			else
				ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslay"), "#A will slay #T next round for #s.", target_ply, reason)
			end
		else
			ULib.tsayError(calling_ply, target_ply:Nick() .. " is already being slain next round.")
		end
	end
end
local addslay = ulx.command("TTT", "ulx addslay", addSlay, "!addslay", true)
addslay:addParam{type=ULib.cmds.PlayerArg}
addslay:addParam{type=ULib.cmds.StringArg, hint="Reason", ULib.cmds.takeRestOfLine, ULib.cmds.optional}
addslay:addParam{type=ULib.cmds.BoolArg, invisible=true}
addslay:defaultAccess(ULib.ACCESS_ADMIN)
addslay:help("Slays target and the beginning of the next round.")
addslay:setOpposite("ulx rslay", {_, _, _, true}, "!rslay", true)

local function addSlayID(calling_ply, steamID, args, remove_slay)
	if not ULib.isValidSteamID(steamID) then
		ULib.tsayError(calling_ply, "Invalid Steam ID: \"" .. steamID .. "\" specified.")
		return
	end
	
	local onlinePly = ZCore.Util.getOnlinePlayer(steamID)
	if onlinePly then
		addSlay(calling_ply, onlinePly, args, remove_slay)
		return
	end

	local currentSlay = util.GetPData(steamID, SLAY_PDATA_KEY, false)
	if remove_slay then
		if not currentSlay then
			ULib.tsayError(calling_ply, steamID .. " isn't being slain next round.")
		else
			util.RemovePData(steamID, SLAY_PDATA_KEY)
			ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslayid"), "#A removed #s from the slay list.", steamID)
		end
	else
		if not currentSlay then
			local reason = DEFAULT_SLAY_REASON
			local slays = 1
			
			if args and string.len(args) > 0 and args ~= "Reason" then
				if tonumber(args) then
					slays = tonumber(args)
				else
					local explode = string.Explode(" ", args)
					if tonumber(explode[1]) then
						slays = tonumber(explode[1])
						table.remove(explode, 1)
						reason = string.Implode(" ", explode)
					elseif tonumber(explode[#explode]) then
						slays = tonumber(explode[#explode])
						table.remove(explode, #explode)
						reason = string.Implode(" ", explode)
					else
						reason = args
					end
				end
			end
			
			if slays > 3 then
				ULib.tsayError(calling_ply, "You may not slay for more than 3 rounds.")
				return
			end
			
			local slayString = slays .. ";" .. reason
			util.SetPData(steamID, SLAY_PDATA_KEY, slayString)
			
			if slays > 1 then
				ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslayid"), "#A will slay #s for the next #s rounds for #s.", steamID, slays, reason)
			else
				ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslayid"), "#A will slay #s next round for #s.", steamID, reason)
			end
		else
			ULib.tsayError(calling_ply, steamID .. " is already being slain next round.")
		end
	end
end
local addslayid = ulx.command("TTT", "ulx addslayid", addSlayID, "!addslayid", true)
addslayid:addParam{type=ULib.cmds.StringArg, hint="SteamID"}
addslayid:addParam{type=ULib.cmds.StringArg, hint="Reason", ULib.cmds.takeRestOfLine, ULib.cmds.optional}
addslayid:addParam{type=ULib.cmds.BoolArg, invisible=true}
addslayid:defaultAccess(ULib.ACCESS_ADMIN)
addslayid:help("Slays target and the beginning of the next round.")
addslayid:setOpposite("ulx rslayid", {_, _, _, true}, "!rslayid", true)

local function addImpair(calling_ply, target_ply, damage, reason, remove)
	local currentImpair = target_ply:GetPData(IMPAIR_PDATA_KEY, false)
	if remove then
		if not currentImpair then
			ULib.tsayError(calling_ply, target_ply:Nick() .. " isn't being damaged next round.")
		else
			target_ply:RemovePData(IMPAIR_PDATA_KEY)
			ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addimpair"), "#A removed #T from the impair list.", target_ply)
		end
	else
		if not currentImpair then
			if not reason or string.len(reason) == 0 or reason == "Reason" then
				reason = DEFAULT_SLAY_REASON
			end
			
			local impairString = damage .. ";" .. reason
			target_ply:SetPData(IMPAIR_PDATA_KEY, impairString)
			
			ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addimpair"), "#A will damage #T next round #s hp for #s.", target_ply, damage, reason)
		else
			ULib.tsayError(calling_ply, target_ply:Nick() .. " is already being damaged next round.")
		end
	end
end
local addimpair = ulx.command("TTT", "ulx addimpair", addImpair, "!addimpair", true)
addimpair:addParam{type=ULib.cmds.PlayerArg}
addimpair:addParam{type=ULib.cmds.NumArg, default=25, min=1, max=100, hint="Damage", ULib.cmds.optional, ULib.cmds.round}
addimpair:addParam{type=ULib.cmds.StringArg, hint="Reason", ULib.cmds.takeRestOfLine, ULib.cmds.optional}
addimpair:addParam{type=ULib.cmds.BoolArg, invisible=true}
addimpair:defaultAccess(ULib.ACCESS_ADMIN)
addimpair:help("Damages a player at the beginning of the next round.")
addimpair:setOpposite("ulx rimpair", {_, _, _, _, true}, "!rimpair", true)

local function spectate(calling_ply, target_ply, unspec)
	if unspec then
		target_ply:ConCommand("ttt_spectator_mode 0")
		ulx.fancyLogAdmin(calling_ply, "#A has moved #T from spectate.", target_ply)
	else
		target_ply:ConCommand("ttt_spectator_mode 1")
		target_ply:ConCommand("ttt_cl_idlepopup")
		ulx.fancyLogAdmin(calling_ply, "#A has forced #T to spectate.", target_ply)
	end
end
local spec = ulx.command("TTT", "ulx spec", spectate, "!spec", true)
spec:addParam{type=ULib.cmds.PlayerArg}
spec:addParam{type=ULib.cmds.BoolArg, invisible=true}
spec:defaultAccess(ULib.ACCESS_ADMIN)
spec:setOpposite("ulx unspec", {_, _, true}, "!unspec")
spec:help("Forces a player to/from spectator.")

local function voteSilentRound(calling_ply)
	if ulx.voteInProgress then
		ULib.tsayError(calling_ply, "There is already a vote in progress.")
		return
	end
	
	if GAMEMODE.round_state == ROUND_ACTIVE then
		ULib.tsayError(calling_ply, "You may not start a silent round vote during the round.")
		return
	end
	
	local title = "Silent Next Round?"
	if GAMEMODE.round_state == ROUND_PREP then
		local title = "Silent Round?"
	end
	
	ulx.doVote(title, {"Yes", "No"}, function(vote)
		local yesCount = vote.results[1] or 0
		local noCount = vote.results[2] or 0
		
		if yesCount >= noCount then
			if GAMEMODE.round_state == ROUND_ACTIVE then
				ulx.initiateSilentRound()
			else
				ulx.nextRoundSilent = true
				ULib.tsay(_, "Silent round vote successful.")
			end
		else
			ULib.tsay(_, "Silent round vote failed.")
		end
	end, 20, _, false)
end
local votesilentround = ulx.command("Voting", "ulx votesilentround", voteSilentRound, "!votesilentround")
votesilentround:defaultAccess(ULib.ACCESS_ALL)
votesilentround:help("Starts a vote to gag everyone in the next round.")

local function voteSpec(calling_ply, target_ply)
	if ulx.voteInProgress then
		ULib.tsayError(calling_ply, "There is already a vote in progress.")
		return
	end
	
	if target_ply:IsSpec() then
		ULib.tsayError(calling_ply, "You cannot vote to move a person in spectator to spectator.")
		return
	end
	
	ulx.doVote("Move " .. target_ply:Nick() .. " to specator?", {"Yes", "No"}, function(vote)
		if IsValid(target_ply) then
			if not target_ply:IsSpec() then
				local yesVotes = vote.results[1] or 0
				local total = yesVotes + (vote.results[2] or 0)
				local ratio = yesVotes / total
				local neededRatio = GetConVarNumber("ulx_votekickSuccessratio") -- Using votekick's ratio
				
				if ratio >= neededRatio then
					target_ply:ConCommand("ttt_spectator_mode 1")
					target_ply:ConCommand("ttt_cl_idlepopup")
					ULib.tsay(_, "Vote result: Player has been moved to spectator.")
				else
					ULib.tsay(_, "Vote result: Player will not be moved to spectator. (" .. yesVotes .. "/" .. total .. ")")
				end
			else
				ULib.tsay(_, "Vote result: Player voted to be moved to spectator, but was moved during the vote.")
			end
		else
			ULib.tsay(_, "Vote result: Player voted to be moved to spectator, but left the server.")
		end
	end, 20, _, false)
end
local votespec = ulx.command("Voting", "ulx votespec", voteSpec, "!votespec")
votespec:addParam{type=ULib.cmds.PlayerArg}
votespec:defaultAccess(ULib.ACCESS_ALL)
votespec:help("Starts a vote to move a target to spectator.")

local function voteAddSlay(calling_ply, target_ply)
	if ulx.voteInProgress then
		ULib.tsayError(calling_ply, "There is already a vote in progress.")
		return
	end
	
	local targetSteamID = target_ply:SteamID()
	
	local current_slays = ulx.getSlayInfo(target_ply)
	if current_slays > 0 then
		ulx.tsayError(target_ply:Nick() .. " is already being slain next round.")
	else
		ulx.doVote("Slay " .. target_ply:Nick() .. " next round?", {"Yes", "No"}, function(vote)
			local yesVotes = vote.results[1] or 0
			local total = yesVotes + (vote.results[2] or 0)
			local ratio = yesVotes / total
			local neededRatio = GetConVarNumber("ulx_votekickSuccessratio") -- Using votekick's ratio
		
			if ratio >= neededRatio then
				if IsValid(target_ply) then
					local current_slays = ulx.getSlayInfo(target_ply)
					if current_slays > 0 then
						ULib.tsay(_, "Vote result: Slay vote successful, but an admin will already slay them next round.")
					else
						target_ply:SetPData(SLAY_PDATA_KEY, "1;voted by players")
						
						ULib.tsay(_, "Vote result: Player will be slain next round.")
					end
				else
					ULib.tsay(_, "Vote result: Slay vote successful, but the player left the server.")
				end
			else
				ULib.tsay(_, "Vote result: Player will not be slain next round. (" .. yesVotes .. "/" .. total .. ")")
			end
		end, 20, _, false)
	end
end
local voteaddslay = ulx.command("Voting", "ulx voteaddslay", voteAddSlay, "!voteaddslay")
voteaddslay:addParam{type=ULib.cmds.PlayerArg}
voteaddslay:defaultAccess(ULib.ACCESS_ALL)
voteaddslay:help("Starts a vote to add a target to the slay list.")