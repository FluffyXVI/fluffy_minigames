AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

PlatformPositions = {}
PlatformPositions['pf_ocean'] = Vector(0, 0, 1500)
PlatformPositions['pf_ocean_d'] = Vector(0, 0, 1500)
PlatformPositions['gm_flatgrass'] = Vector(0, 0, 0)
PlatformPositions['pf_midnight_v1_fix'] = Vector(0, 0, 0)
PlatformPositions['pf_midnight_v1'] = Vector(0, 0, 0)
PlatformPositions['pf_test1'] = Vector(0, 0, 0)
PlatformPositions['pf_volcanic'] = Vector(0, 0, 0)
PlatformPositions['pf_volcanic2'] = Vector(0, 0, 0)

function GM:PlayerLoadout( ply )
    ply:Give( 'weapon_platformbreaker' )
    ply:SetWalkSpeed( 350 )
    ply:SetRunSpeed( 360 )
end

function GM:PlayerSelectSpawn( pl )
    local spawns = ents.FindByClass( "info_player_start" )
    if(#spawns <= 0) then return false end
    local selected = table.Random( spawns )
    while selected.spawnUsed do
        selected = table.Random( spawns )
    end
    
    selected.spawnUsed = true
    return selected
end

function GM:GetFallDamage( ply, vel )
    return vel/7
end

local blockoptions = {
    'circle',
    'square',
    --'triangle',
    'mixed',
    --'props',
}

hook.Add('PreRoundStart', 'CreatePlatforms', function()
    local gametype = table.Random( blockoptions )
    SetGlobalString( 'PitfallType', gametype )
    
    GAMEMODE:ClearLevel()
    GAMEMODE:SpawnPlatforms()
end )

function GM:ClearLevel()
	for k,v in pairs(ents.FindByClass( "pf_platform" )) do
		v:Remove()
	end
	for k,v in pairs(ents.FindByClass( "info_player_start" )) do
		v:Remove()
	end
	for k,v in pairs(ents.FindByClass( "gmod_player_start" )) do
		v:Remove()
	end
	for k,v in pairs(ents.FindByClass( "info_player_terrorist" )) do
		v:Remove()
	end
	for k,v in pairs(ents.FindByClass( "info_player_counterterrorist" )) do
		v:Remove()
	end
end

function GM:SpawnPlatforms()
    local pos = PlatformPositions[ game.GetMap() ]
    if !pos then return end
    local players = #player.GetAll()
    players = math.ceil( players/3 )
    local num = 3 + (players*2)
    local size = 200
    
    local px = pos.x - (size*num)/2
    local py = pos.y - (size*num)/2
    local pz = pos.z
    
    for row = 1,num do
        for col=1,num do
            self:SpawnPlatform( Vector( px, py, pz ) )
            py = py + size
        end
        
        px = px + size
        py = pos.y - (size*num)/2
    end
    
end

function GM:SpawnPlatform(pos)
	local prop = ents.Create( "pf_platform" )
	if ( !prop ) then return end
	prop:SetAngles( Angle( 0, 0, 0 ) )
	prop:SetPos( pos )
	prop:Spawn()
	prop:Activate()

	local spawn = ents.Create("info_player_start")
	if ( !spawn ) then return end
	
	local center = prop:GetCenter()
	center.z = center.z + 15
	spawn:SetPos(center)
	spawn.spawnUsed = false
    
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
    ply:CreateRagdoll()
end