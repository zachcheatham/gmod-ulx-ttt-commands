ulx.target_role = {}
function updateRoles()
	table.Empty(ulx.target_role)
	    
    table.insert(ulx.target_role, "traitor")
    table.insert(ulx.target_role, "detective")
    table.insert(ulx.target_role, "innocent")
end
hook.Add(ULib.HOOK_UCLCHANGED, "ULXRoleNamesUpdate", updateRoles)
updateRoles()

local modules, dirs = file.Find("ulx/modules/sh/ttt_cmds/*lua", "LUA")

for _, fileName in ipairs(modules) do
	if SERVER then
		AddCSLuaFile("ulx/modules/sh/ttt_cmds/" .. fileName)
		include("ulx/modules/sh/ttt_cmds/" .. fileName)
	else
		include("ulx/modules/sh/ttt_cmds/" .. fileName)
	end
end