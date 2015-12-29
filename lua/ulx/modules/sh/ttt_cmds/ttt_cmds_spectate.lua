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