local function setULXGag(ply, gagged)
	ply.ulx_gagged = gagged
	ply:SetNWBool("ulx_gagged", gagged)
end

ulx.nextRoundSilent = false
ulx.inSilentRound = false

local gaggedPlayers = {}

function ulx.initiateSilentRound()
	if not ulx.inSilentRound then
		ulx.inSilentRound = true
		table.Empty(gaggedPlayers)
		
		for _, ply in ipairs(player.GetAll()) do
			if not ply.ulx_gagged then
				table.insert(gaggedPlayers, ply)
				setULXGag(ply, true)
			end
		end
		
		ULib.tsayColor(nil, false, Color(201, 155, 255), "Silent round initialized. ", Color(255, 255, 255), "You will not be able to voice chat until the end of the round.")
	end
end

local function vsrRoundBegin()
	if ulx.nextRoundSilent then
		ulx.nextRoundSilent = false
		ulx.initiateSilentRound()
	end
end
hook.Add("TTTBeginRound", "ULXVoteSilentRound", vsrRoundBegin)

local function vsrRoundEnd()
	if ulx.inSilentRound then
		ulx.inSilentRound = false
		
		for _, ply in ipairs(gaggedPlayers) do
			if IsValid(ply) then
				setULXGag(ply, false)
			end
		end
		
		table.Empty(gaggedPlayers)
		ULib.tsayColor(nil, false, Color(100, 255, 0), "Silent round ended. ", Color(255, 255, 255), "You may now use voice chat.")
	end
end
hook.Add("TTTEndRound", "ULXVoteSilentRound", vsrRoundEnd)