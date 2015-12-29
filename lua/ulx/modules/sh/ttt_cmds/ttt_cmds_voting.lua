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