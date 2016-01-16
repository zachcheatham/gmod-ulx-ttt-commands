ulx.target_role = {}
function updateRoles()
	table.Empty(ulx.target_role)
	    
    table.insert(ulx.target_role, "traitor")
    table.insert(ulx.target_role, "detective")
    table.insert(ulx.target_role, "innocent")
end
hook.Add(ULib.HOOK_UCLCHANGED, "ULXRoleNamesUpdate", updateRoles)
updateRoles()

-- This isn't working on Linux
--local modules, dirs = file.Find("ulx/modules/sh/ttt_cmds/*lua", "LUA")

local modules = {
    -- "ttt_cmds_autopunish.lua", -- We have a new addon for this :)
    "ttt_cmds_corpses.lua",
    "ttt_cmds_force_role.lua",
    "ttt_cmds_karma.lua",
    "ttt_cmds_respawn.lua",
    "ttt_cmds_spectate.lua",
    "ttt_cmds_voting.lua"
}

for _, fileName in ipairs(modules) do
	if SERVER then
		AddCSLuaFile("ulx/modules/sh/ttt_cmds/" .. fileName)
		include("ulx/modules/sh/ttt_cmds/" .. fileName)
	else
		include("ulx/modules/sh/ttt_cmds/" .. fileName)
	end
end