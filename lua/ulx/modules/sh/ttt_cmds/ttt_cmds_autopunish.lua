/*local SLAY_PDATA_KEY = "ttt_pending_slay"
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
addimpair:setOpposite("ulx rimpair", {_, _, _, _, true}, "!rimpair", true)*/