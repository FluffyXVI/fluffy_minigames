--[[
This file deals with spawnpoint overrides for certain gamemodes
Slightly hacky.
--]]

-- This is ripped from the base PlayerSelectSpawn, with mild adjustments
-- This is only for team based gamemodes, since FFA gamemodes seem to work naturally??
hook.Add('PlayerSelectSpawn', 'Overridesarecoolyo', function( ply )
    if GetGlobalString( 'RoundState' ) != 'InRound' and GetGlobalString( 'RoundState' ) != 'PreRound' then return end
    
    if !SpawnpointOverrideTable then return end
    if !GAMEMODE.TeamBased then return end
    
    -- Select spawn entity based on team
    local spawnclass = nil
    if ply:Team() == TEAM_RED then
        spawnclass = 'info_player_counterterrorist'
    elseif ply:Team() == TEAM_BLUE then
        spawnclass = 'info_player_terrorist'
    end
    
    -- Blame Garry for this, not me
    if !spawnclass then return end
    local spawnpoints = ents.FindByClass( spawnclass )
    for i=0,6 do
        local choose = table.Random( spawnpoints )
        if hook.Call( "IsSpawnpointSuitable", GAMEMODE, ply, choose, i == 6 ) then return choose end
    end
    
    return
end )

-- Remove any old spawn entities
-- This could be probably moved to a table loop system, but meh
function ClearOldSpawns()
	for k,v in pairs(ents.FindByClass( "info_player_start" )) do
		v:Remove()
	end
    for k,v in pairs(ents.FindByClass( "info_player_deathmatch" )) do
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

-- Create the entities in the locations, as given in the
function AddNewSpawns()
    print('Adding new spawns..')
    if !SpawnpointOverrideTable then return end
    for k,v in pairs( SpawnpointOverrideTable ) do
        local class = v[1]
        local pos = v[2]
        local spawn = ents.Create( class )
        spawn:SetPos( pos )
    end
end

-- Load a spawn file into the game
local function HandleSpawnFile( fname )
    print('Loading ' .. fname )
    local data = file.Read( fname, 'DATA' )
    SpawnpointOverrideTable = util.JSONToTable( data )
    PrintTable( SpawnpointOverrideTable )
    
    -- Reset spawns every round
    hook.Add('PreRoundStart', 'SpawnpointOverride', function()
        ClearOldSpawns()
        AddNewSpawns()
    end )
    
end

-- On map load: check if spawn file exists, and override if so
hook.Add('InitPostEntity', 'OverrideSpawns', function()
    local map = game.GetMap()
    print('Searching for spawns..')
    if GAMEMODE.TeamBased then
        if file.Exists( 'custom_spawnpoints/' .. map .. '_TEAM.txt', 'DATA' ) then
            HandleSpawnFile( 'custom_spawnpoints/' .. map .. '_TEAM.txt' )
        elseif file.Exists( 'custom_spawnpoints/' .. map .. '.txt', 'DATA' ) then
            HandleSpawnFile( 'custom_spawnpoints/' .. map .. '.txt' )
        end
    else
        if file.Exists( 'custom_spawnpoints/' .. map .. '_FFA.txt', 'DATA' ) then
            HandleSpawnFile( 'custom_spawnpoints/' .. map .. '_FFA.txt' )
        elseif file.Exists( 'custom_spawnpoints/' .. map .. '.txt', 'DATA' ) then
            HandleSpawnFile( 'custom_spawnpoints/' .. map .. '.txt' )
        end
    end
end )