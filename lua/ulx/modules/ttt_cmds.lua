function GetLoadoutWeapons(r)
	local tbl = {
		[ROLE_INNOCENT] = {},
		[ROLE_TRAITOR]  = {},
		[ROLE_DETECTIVE]= {}
	};
	for k, w in pairs(weapons.GetList()) do
		if w and type(w.InLoadoutFor) == "table" then
			for _, wrole in pairs(w.InLoadoutFor) do
				table.insert(tbl[wrole], WEPS.GetClass(w))
			end
		end
	end
	return tbl[r]
end

function RemoveBoughtWeapons(ply)
	for _, wep in pairs(weapons.GetList()) do
		local wep_class = WEPS.GetClass(wep)
		if wep and type(wep.CanBuy) == "table" then
			for _, weprole in pairs(wep.CanBuy) do
				if weprole == ply:GetRole() and ply:HasWeapon(wep_class) then
					ply:StripWeapon(wep_class)
				end
			end
		end
	end
end

function RemoveLoadoutWeapons(ply)
	local weps = GetLoadoutWeapons(GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetRole())
	for _, cls in pairs(weps) do
		if ply:HasWeapon(cls) then
			ply:StripWeapon(cls)
		end
	end
end

function GiveLoadoutWeapons(ply)
	local r = GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetRole()
	local weps = GetLoadoutWeapons(r)
	if not weps then return end

	for _, cls in pairs(weps) do
		if not ply:HasWeapon(cls) then
			ply:Give(cls)
		end
	end
end

function GiveLoadoutItems(ply)
	local items = EquipmentItems[ply:GetRole()]
	if items then
		for _, item in pairs(items) do
			if item.loadout and item.id then
				ply:GiveEquipmentItem(item.id)
			end
		end
	end
end

function findCorpse(v)
	for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
		if ent.uqid == v:UniqueID() and IsValid(ent) then
			return ent or false
		end
	end
end

function removeCorpse(corpse)
	CORPSE.SetFound(corpse, false)
	if string.find(corpse:GetModel(), "zm_", 6, true) then
        player.GetByUniqueID(corpse.uqid):SetNWBool("body_found", false)
        corpse:Remove()
        SendFullStateUpdate()
	elseif corpse.player_ragdoll then
        player.GetByUniqueID(corpse.uqid):SetNWBool("body_found", false)
		corpse:Remove()
        SendFullStateUpdate()
	end
end

function idCorpse(corpse)
	if corpse then
		local ply = player.GetByUniqueID(corpse.uqid)
		ply:SetNWBool("body_found", true)
		CORPSE.SetFound(corpse, true)
	end
end