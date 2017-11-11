DeriveGamemode('fluffy_base')

GM.Name = 'Capture the Flag'
GM.Author = 'AlbinoBlackHawk'

-- Yeah, this is literally it
-- All this fun stuff is handled in the base
GM.TeamBased = true	-- Is the gamemode FFA or Teams?

GM.RoundNumber = 1
GM.RoundTime = 600

GM.RedFlagSpawns = {}
GM.RedFlagSpawns['gm_forestforts'] = Vector(-5000, 0, 64)

function GM:Initialize()

end
