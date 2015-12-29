function ulx.karma(calling_ply, target_plys, amount)
	for _, ply in pairs(target_plys) do
		ply:SetBaseKarma(amount)
		ply:SetLiveKarma(amount)
	end
	ulx.fancyLogAdmin(calling_ply, "#A set the karma for #T to #i", target_plys, amount)
end
local karma = ulx.command("TTT", "ulx karma", ulx.karma, "!karma")
karma:addParam{type=ULib.cmds.PlayersArg}
karma:addParam{type=ULib.cmds.NumArg, min=0, max=10000, default=1000, hint="Karma", ULib.cmds.optional, ULib.cmds.round}
karma:defaultAccess(ULib.ACCESS_SUPERADMIN)
karma:help("Changes the <target(s)> Karma.")