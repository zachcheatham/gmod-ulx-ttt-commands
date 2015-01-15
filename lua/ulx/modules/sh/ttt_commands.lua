local PDATA_KEY = "ttt_pending_slay"
local DEFAULT_SLAY_REASON = "RDMing"

local function addSlay(calling_ply, target_ply, slays, reason, remove_slay)
	local currentSlay = target_ply:GetPData(PDATA_KEY, false)
	if remove_slay then
		if not currentSlay then
			ULib.tsayError(calling_ply, target_ply:Nick() .. " isn't being slain next round.")
		else
			target_ply:RemovePData(PDATA_KEY)
			ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslay"), "#A removed #T from the slay list.", target_ply)
		end
	else
		if not currentSlay then
			local slayReason = reason
			if not slayReason or string.len(slayReason) == 0 or slayReason == "Reason" then
				slayReason = DEFAULT_SLAY_REASON
			end
			local slayString = slays .. ";" .. slayReason
			
			target_ply:SetPData(PDATA_KEY, slayString)
			
			if slays > 1 then
				ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslay"), "#A will slay #T for the next " .. slays .. " rounds.", target_ply)
			else
				ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslay"), "#A will slay #T next round.", target_ply)
			end
		else
			ULib.tsayError(calling_ply, target_ply:Nick() .. " is already being slain next round.")
		end
	end
end
local addslay = ulx.command("TTT", "ulx addslay", addSlay, "!addslay", true)
addslay:addParam{type=ULib.cmds.PlayerArg}
addslay:addParam{type=ULib.cmds.NumArg, default=1, max=3, hint="Rounds", ULib.cmds.optional, ULib.cmds.round}
addslay:addParam{type=ULib.cmds.StringArg, hint="Reason",  ULib.cmds.optional}
addslay:addParam{type=ULib.cmds.BoolArg, invisible=true}
addslay:defaultAccess(ULib.ACCESS_ADMIN)
addslay:help("Slays target for a number of rounds.")
addslay:setOpposite("ulx rslay", {_, _, _, _, true}, "!rslay", true)

local function addSlayID(calling_ply, steamID, slays, reason, remove_slay)
	if not ULib.isValidSteamID(steamID) then
		ULib.tsayError(calling_ply, "Invalid Steam ID: \"" .. steamID .. "\" specified.")
		return
	end
	
	local onlinePly = ZCore.Util.getOnlinePlayer(steamID)
	if onlinePly then
		addSlay(calling_ply, onlinePly, slays, reason, remove_slay)
		return
	end

	local currentSlay = util.GetPData(steamID, PDATA_KEY, false)
	if remove_slay then
		if not currentSlay then
			ULib.tsayError(calling_ply, steamID .. " isn't being slain next round.")
		else
			util.RemovePData(steamID, PDATA_KEY)
			ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslayid"), "#A removed #s from the slay list.", steamID)
		end
	else
		if not currentSlay then
			local slayReason = reason
			if not slayReason or string.len(slayReason) == 0 or slayReason == "Reason" then
				slayReason = DEFAULT_SLAY_REASON
			end
			local slayString = slays .. ";" .. slayReason
			
			util.SetPData(steamID, PDATA_KEY, slayString)
			
			if slays > 1 then
				ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslayid"), "#A will slay #s for the next " .. slays .. " rounds.", steamID)
			else
				ulx.fancyLogAdmin(calling_ply, ZCore.ULX.getPlayersWithPermission("ulx addslayid"), "#A will slay #s next round.", steamID)
			end
		else
			ULib.tsayError(calling_ply, steamID .. " is already being slain next round.")
		end
	end
end
local addslayid = ulx.command("TTT", "ulx addslayid", addSlayID, "!addslayid", true)
addslayid:addParam{type=ULib.cmds.StringArg, hint="SteamID"}
addslayid:addParam{type=ULib.cmds.NumArg, default=1, max=3, hint="Rounds", ULib.cmds.optional, ULib.cmds.round}
addslayid:addParam{type=ULib.cmds.StringArg, hint="Reason",  ULib.cmds.optional}
addslayid:addParam{type=ULib.cmds.BoolArg, invisible=true}
addslayid:defaultAccess(ULib.ACCESS_ADMIN)
addslayid:help("Slays target for a number of rounds.")
addslayid:setOpposite("ulx rslayid", {_, _, _, _, true}, "!rslayid", true)

local function spectate(calling_ply, target_ply, unspec)
	if unspec then
		target_ply:ConCommand("ttt_spectator_mode 0")
	else
		target_ply:ConCommand("ttt_spectator_mode 1")
		target_ply:ConCommand("ttt_cl_idlepopup")
	end
end
local spec = ulx.command("TTT", "ulx spec", spectate, "!spec", true)
spec:addParam{type=ULib.cmds.PlayerArg}
spec:addParam{type=ULib.cmds.BoolArg, invisible=true}
spec:defaultAccess(ULib.ACCESS_ADMIN)
spec:setOpposite("ulx unspec", {_, _, true}, "!unspec")
spec:help("Forces a player to/from spectator.")