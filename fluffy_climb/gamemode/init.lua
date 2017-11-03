resource.AddWorkshop("999854920")

AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
AddCSLuaFile('sh_move.lua')

include('shared.lua')
include('sv_levelgen.lua')

jumpBlockTable = {}

function GM:PlayerLoadout( ply )
    ply:SetMaxJumpLevel(1)
end

function GM:GetWinningPlayer()
    return nil
end

function GM:PlayerSelectSpawn(pl)

	local spawns = ents.FindByClass( "info_player_start" )

	for k, v in pairs(spawns) do
		trace = util.TraceHull({
			start = v:GetPos(),
			endpos = v:GetPos() + Vector(0,0,1),
			filter = player.GetAll(),
			mins = Vector(-16,-16,0),
			maxs = Vector(16,16,72)
		})
		if trace.Hit then
			table.remove(spawns,k)
		end
	end

	local random_entry = math.random( #spawns )

	return spawns[ random_entry ]

end

function GM:PlayerTick(pl, move)
	local shootPos = pl:GetShootPos()
	if shootPos.z + 6 > JUMPBLOCKGAMEDATA.playfieldMaxs.z then
        if GetGlobalString('RoundState', 'GameNotStarted') != 'GameNotStarted' then
            if pl:Alive() and pl:GetObserverMode() == OBS_MODE_NONE then
                GAMEMODE:EndRound( pl )
            end
        end
	end
end

hook.Add('PreRoundStart', 'GenerateBlocks', function()
    if !IsValid( jumpGameLava ) then
        local ent = ents.Create("jump_lava")
        ent:SetPos(Vector(0,0,-10000))
        ent:Spawn()
        jumpGameLava = ent
    end
	local genData = CreateWorldGenTable()
	blockGen(genData.numStrands)
end )