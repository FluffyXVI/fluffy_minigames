DeriveGamemode('fluffy_base')

include('sh_move.lua')

GM.Name = 'Climb'
GM.Author = 'FluffyXVI'

GM.TeamBased = false	-- Is the gamemode FFA or Teams?
GM.Elimination = true

GM.RoundNumber = 10      -- How many rounds?
GM.RoundTime = 150      -- Seconds each round lasts for

GM.ThirdpersonEnabled = true

function GM:Initialize()

end

JUMPBLOCKGAMEDATA = {}
JUMPBLOCKGAMEDATA.playfieldHeight = 2000
JUMPBLOCKGAMEDATA.playfieldMins = Vector(-3000,-3000,-14848)
JUMPBLOCKGAMEDATA.playfieldMaxs = Vector(3000,3000,JUMPBLOCKGAMEDATA.playfieldMins.z + JUMPBLOCKGAMEDATA.playfieldHeight)
JUMPBLOCKGAMEDATA.lavaStartHeight = -15000
JUMPBLOCKGAMEDATA.lavaStartTime = 30
JUMPBLOCKGAMEDATA.curMutator = 0