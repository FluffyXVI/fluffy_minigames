AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')
include('sv_spawns.lua')

--[[
    Is it too late to say sorry?
--]]

-- General override in Fluffy Shop addon
-- Some gamemodes have their own overrides
function GM:PlayerSetModel( ply )
    ply:SetModel('models/player/Group01/male_09.mdl')
end

-- Stop suicide in some gamemodes
function GM:CanPlayerSuicide()
    return self.CanSuicide
end

-- Called each time a player spawns
function GM:PlayerSpawn( ply )
    local state = GetGlobalString('RoundState', 'GameNotStarted')
    
    -- Set to team color
	if self.TeamBased then
		local color = team.GetColor( ply:Team() )
		ply:SetPlayerColor( Vector( color.r/255, color.g/255, color.b/255 ) )
        
        if ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED or state == 'GameNotStarted' then
            self:PlayerSpawnAsSpectator( ply )
            return
        end
	end
    
    -- If elimination, block respawns during round
    if state != 'PreRound' and GAMEMODE.Elimination == true then
        self:PlayerSpawnAsSpectator( ply )
        return
    end
    
    -- Spectators should be spawned as spectators (duh)
    if ply:Team() == TEAM_SPECTATOR then
        self:PlayerSpawnAsSpectator( ply )
        return
    end
    
    -- Make sure players have a team
    if GAMEMODE.TeamBased and ( ply:Team() == TEAM_UNASSIGNED or ply:Team() == 0 ) then
        self:PlayerSpawnAsSpectator( ply )
        return
    end
    
    -- Call functions to setup model and loadout
	hook.Call('PlayerLoadout', GAMEMODE, ply )
    hook.Call('PlayerSetModel', GAMEMODE, ply )
    ply:SetupHands()
    
    -- Exit out of spectate
    ply:UnSpectate()
    ply.Spectating = false
end

-- Called when a player joins for the first time
function GM:PlayerInitialSpawn( ply )
    -- If team survival, put new players on hunters
    if GAMEMODE.TeamSurvival then
        ply:SetTeam( GAMEMODE.HunterTeam )
    else
        -- Teamy stuff
        if ply:IsBot() then
            self:PlayerRequestTeam( ply, team.BestAutoJoinTeam() )
        elseif GAMEMODE.TeamBased then
            ply:ConCommand( "gm_showteam" )
        else
            ply:SetTeam( TEAM_UNASSIGNED )
        end
    end

end

-- Fairly self-explanatory
function GM:PlayerSpawnAsSpectator( ply )
	ply:StripWeapons()
	ply.Spectating = true
    ply:Spectate( OBS_MODE_ROAMING )
    --if !GAMEMODE.TeamBased then ply:SetTeam( TEAM_SPECTATOR ) end
end

-- Convenience function to get number of living players
-- This isn't fantastically efficient don't overuse
function GM:GetLivingPlayers()
    local alive = 0
    for k,v in pairs( player.GetAll() ) do
        if v:Alive() and v:Team() != TEAM_SPECTATOR and !v.Spectating then alive = alive + 1 end
    end
    return alive
end

-- Convenience function to get number of non-spectators
-- I don't think there is actually a need for this anymore, but it's here
function GM:NumNonSpectators()
    local num = 0
    for k,v in pairs( player.GetAll() ) do
        if GAMEMODE.TeamBased then
            if v:Team() != TEAM_SPECTATOR and v:Team() != TEAM_UNASSIGNED and v:Team() != 0 then num = num + 1 end
        else
            if v:Team() != TEAM_SPECTATOR then num = num + 1 end
        end
    end

    return num
end

-- Convenience function to get number of living players in a team
function GM:GetTeamLivingPlayers( t )
    local alive = 0
    for k,v in pairs( team.GetPlayers( t ) ) do
        if v:Alive() and !v.Spectating then alive = alive + 1 end
    end
    return alive
end

-- Pick a random player
function GM:GetRandomPlayer()
    local ply = table.Random( player.GetAll() )
    while ply:Team() == TEAM_SPECTATOR do
        ply = table.Random( player.GetAll() )
    end
    
    return ply
end

function GM:Think()
    local state = GetGlobalString('RoundState', 'GameNotStarted')
    -- Check if the game is ready to start
    if state == 'GameNotStarted' then
        if self:CanRoundStart() then
            self:StartPreRound()
        end
    end
    
    -- Check win conditions if respawning is disabled
    if GAMEMODE.Elimination then
        -- If there's only one person left in an applicable gamemode, give them the win
        if GAMEMODE.WinBySurvival then
            if GAMEMODE:GetLivingPlayers() <= 1 then
                for k,v in pairs( player.GetAll() ) do
                    if v:Alive() and !v.Spectating then
                        GAMEMODE:EndRound( v )
                        return
                    end
                end
            end
        -- If one team is eliminated, give them the win
        elseif GAMEMODE.TeamBased then
            if GAMEMODE:GetTeamLivingPlayers( 1 ) == 0 then
                GAMEMODE:EndRound( 2 )
            elseif GAMEMODE:GetTeamLivingPlayers( 2 ) == 0 then
                GAMEMODE:EndRound( 1 )
            end
        else
            -- Relocate this to fix the pitfall bug?
            if GAMEMODE:GetLivingPlayers() == 0 then
                GAMEMODE:EndRound( 'Everyone died. Nobody wins.' )
            end
        end
    end
    
    -- Check if Hunter wins in Hunter vs Hunted gamemodes
    if GAMEMODE.TeamSurvival then
        if GAMEMODE:GetTeamLivingPlayers( GAMEMODE.SurvivorTeam ) == 0 then
            GAMEMODE:EndRound( GAMEMODE.HunterTeam )
        end
    end
    
end

-- Get a winner in certain gamemodes
-- Can be overridden for special cases
function GM:GetWinningPlayer()
    if GAMEMODE.TeamBased then return nil end
    if GAMEMODE.Elimination then return nil end
    
    -- Loop through all players and return the one with the most frags
    local bestscore = 0
    local bestplayer = nil
    for k,v in pairs( player.GetAll() ) do
        local frags = v:Frags()
        if GAMEMODE_NAME == 'fluffy_gungame' then frags = v:GetNWInt('GG_Progress', 0 ) end
        if frags > bestscore then
            bestscore = frags
            bestplayer = v
        end
    end
    
    return bestplayer
end

-- This is for rewarding melons at the end of a game
function GM:GetMVP()
	if !IsValid(fluffy_scoreboard) then return end
	
	local tbl = player.GetAll()
	local count = #tbl
	table.sort( tbl, function(a, b) return a:Frags()*-50 + a:EntIndex() < b:Frags()*-50 + b:EntIndex() end )
    return tbl[1]
end

-- Check if there are enough players to start a round
function GM:CanRoundStart()
    -- If team based, check there is at least player on each team
    -- ( Override this function if there is ever a four-team gamemode )
    if self.TeamBased and !self.TeamSurvival then
        if #team.GetPlayers(1) >= 1 and #team.GetPlayers(2) >= 1 then
            return true
        else
            return false
        end
    -- If FFA, check there's at least two people not spectating
    else
        if GAMEMODE:NumNonSpectators() >= 2 then
            return true
        else
            return false
        end
    end
end

function GM:StartRound()
    -- Unfreeze all players
    for k,v in pairs( player.GetAll() ) do
        v:Freeze( false )
    end
    
    -- Set global round data
	SetGlobalString( 'RoundState', 'InRound' )
	SetGlobalFloat( 'RoundStart', CurTime() )
    
    -- yay hooks
    hook.Call('RoundStart')
    
    -- End the round after a certain time
    timer.Create('GamemodeTimer', GAMEMODE.RoundTime, 0, function()
        self:EndRound('TimeEnd')
    end )
end

local deathmatch_remove = {
    ['item_healthcharger'] = true,
    ['item_suitcharger'] = true,
    ['weapon_crowbar'] = true,
    ['weapon_stunstick'] = true,
    ['weapon_ar2'] = true,
    ['weapon_357'] = true,
    ['weapon_pistol'] = true,
    ['weapon_crossbow'] = true,
    ['weapon_shotgun'] = true,
    ['weapon_frag'] = true,
    ['weapon_rpg'] = true,
    ['item_ammo_357'] = true,
    ['item_ammo_357_large'] = true,
    ['item_ammo_pistol'] = true,
    ['item_ammo_crossbow'] = true,
    ['item_ammo_smg1_grenade'] = true,
    ['item_rpg_round'] = true,
    ['item_box_buckshot'] = true,
    ['item_healthkit'] = true,
    ['item_battery'] = true,
    ['item_ammo_ar2'] = true,
    ['item_ammo_ar2_large'] = true,
    ['item_ammo_ar2_altfire'] = true,
}
function CleanUpDMStuff()
    for k,v in pairs( ents.GetAll() ) do
        if deathmatch_remove[ v:GetClass() ] then v:Remove() end
    end
end

function GM:StartPreRound()
    local round = GetGlobalInt('RoundNumber', 0 )
    
    if !GAMEMODE:CanRoundStart() then SetGlobalString('RoundState', 'GameNotStarted'); return end
    
    -- Reset things
    game.CleanUpMap()
    CleanUpDMStuff()
    GAMEMODE.TeamKills = {}
    GAMEMODE.TeamKills[1] = 0
    GAMEMODE.TeamKills[2] = 0
    
    -- End the game if enough rounds have been played
    if round >= GAMEMODE.RoundNumber then
        TriggerGameEnd()
        return
    end
    
    -- Roundy stuff
    SetGlobalInt('RoundNumber', round + 1 )
    SetGlobalString( 'RoundState', 'PreRound' )
	SetGlobalFloat( 'RoundStart', CurTime() )
    hook.Call('PreRoundStart')
    
    -- If team survival pick one player to be a hunter
    if GAMEMODE.TeamSurvival then
        for k,v in pairs( player.GetAll() ) do
            if v:Team() == TEAM_SPECTATOR then continue end
            v:SetTeam( GAMEMODE.SurvivorTeam )
        end
        GAMEMODE:GetRandomPlayer():SetTeam( GAMEMODE.HunterTeam )
    end
    
    -- Spawn and freeze all players
    timer.Simple( 0.5, function()
        for k,v in pairs( player.GetAll() ) do
            if !GAMEMODE.TeamBased then v:SetTeam( TEAM_UNASSIGNED ) end
            v:Spawn()
            v:Freeze( true )
        end
        -- Fix that stupid incoming bug
        if GAMEMODE_NAME == 'fluffy_incoming' then game.CleanUpMap() end
    end )
    
    -- Start the round after a short cooldown
    timer.Simple( GAMEMODE.RoundCooldown, function() GAMEMODE:StartRound() end )
end

-- End the round
-- Messy due to all different win conditions
function GM:EndRound( reason )
    if GetGlobalString('RoundState') != 'InRound' then return end
    timer.Remove('GamemodeTimer')

    -- Display who round the round
    local msg = 'The round has ended!'
    -- If time ends
    if reason == 'TimeEnd' then
        -- If team survival gamemode and time is up, survivors win
        if GAMEMODE.TeamSurvival then
            msg = team.GetName( GAMEMODE.SurvivorTeam ) .. ' win the round!'
            team.AddScore( GAMEMODE.SurvivorTeam, 1 )
            
            -- 10XP to anyone alive at the end of a round
            if FLUFFY_CURRENCY then
                for k,v in pairs(team.GetPlayers(1)) do
                    if v:Alive() then v:QueueXP( 8 ) else v:QueueXP( 4 ) end
                end
            end
        end
        
        -- If team based, give to the team with the most frags
        if GAMEMODE.TeamBased then
            if GAMEMODE.TeamKills[1] > GAMEMODE.TeamKills[2] then
                msg = team.GetName(1) .. ' win the round!'
                team.AddScore( 1, 1 )
                
                if FLUFFY_CURRENCY then
                    for k,v in pairs(team.GetPlayers(1)) do
                        v:QueueXP( 5 )
                    end
                end
            else
                msg = team.GetName(2) .. ' win the round!'
                team.AddScore( 2, 1 )
                
                if FLUFFY_CURRENCY then
                    for k,v in pairs(team.GetPlayers(2)) do
                        v:QueueXP( 5 )
                    end
                end
            end
        else
            -- Award to the regular winner
            local winner = GAMEMODE:GetWinningPlayer()
            if winner then
                msg = winner:Nick() .. ' wins the round!'
            else
                msg = 'Time\'s up! Nobody wins.'
            end
        end
    -- If ended outside of a time up:
    -- Give it to the player
    elseif IsEntity( reason ) then
        if reason:IsPlayer() then
            msg = reason:Nick() .. ' wins the round!'
            reason:AddFrags( 1 )
            
            if FLUFFY_CURRENCY then
                reason:QueueXP( 10 )
            end
        end
    -- Give it to the team
    elseif GAMEMODE.TeamBased then
        msg = team.GetName( reason ) .. ' wins the round!'
        team.AddScore( reason, 1 )
    else
        msg = reason
    end
    
    -- Send round end message to players
    net.Start('EndRound')
        net.WriteString( msg )
    net.Broadcast()
    
    -- Move to next round
    hook.Call('RoundEnd')
	SetGlobalString( 'RoundState', 'EndRound' )
    timer.Simple( GAMEMODE.RoundCooldown, function() GAMEMODE:StartPreRound() end )
end

-- Handling of scoring for various different gamemodes
-- This is complicated because of the huge variety running on the same based
-- please forgive <3
function GM:DoPlayerDeath( ply, attacker, dmginfo )
    -- Do not count deaths unless in round
    if GetGlobalString( 'RoundState' ) != 'InRound' then return end
    
    -- Create a ragdoll and add deaths
	ply:CreateRagdoll()
	ply:AddDeaths( 1 )
    -- If killed by a player
	if attacker:IsValid() and attacker:IsPlayer() then
        -- Subtract one kill if suicide
		if attacker == ply and attacker:Team() != TEAM_UNASSIGNED and attacker:Team() != TEAM_SPECTATOR and !GAMEMODE.NoSuicidePenalty then
			--attacker:AddFrags( -1 )
            
        -- Award kill to the killer and respective team
		elseif attacker != ply then
			attacker:AddFrags( 1 )
            -- If currency is installed, queue XP properly
            if FLUFFY_CURRENCY then
                -- Unpleasant stuff here
                if GAMEMODE.TeamBased then
                    if GAMEMODE.TeamSurvival then
                        if attacker:Team() == GAMEMODE.HunterTeam then
                            -- Hunter kills survivor
                            -- Medium bonus
                            attacker:QueueXP( 3 )
                        elseif attacker:Team() == GAMEMODE.SurvivorTeam then
                            -- Survivor kills hunter
                            -- Small bonus
                            attacker:QueueXP( 1 )
                        end
                    elseif GAMEMODE.Elimination then
                        -- Medium/large bonus
                        attacker:QueueXP( 5 )
                    else
                        -- Medium bonus
                        attacker:QueueXP( 3 )
                    end
                else
                    -- Too lazy to deal with FFA
                    attacker:QueueXP( 3 )
                end
            end
            
            -- Track team kills independently of each player
            if GAMEMODE.TeamBased then
                if !GAMEMODE.TeamKills then 
                    GAMEMODE.TeamKills = {}
                    GAMEMODE.TeamKills[1] = 0
                    GAMEMODE.TeamKills[2] = 0
                end
                local team = attacker:Team()
                if team == TEAM_SPECTATOR then return end
                GAMEMODE.TeamKills[team] = GAMEMODE.TeamKills[team] + 1
            end
            
		end
	end
    
end

-- Disable friendly fire
function GM:PlayerShouldTakeDamage( victim, ply )
    if !GAMEMODE.TeamBased then return true end
    if !ply:IsPlayer() then return true end
    if ply:Team() == victim:Team() then return false end
    return true
end

-- Stop players switching from hunter team to survivor team
function GM:PlayerCanJoinTeam( ply, team )
    if GAMEMODE.TeamSurvival then 
        if ply:Team() == GAMEMODE.HunterTeam then return false end
    end
    return true
end