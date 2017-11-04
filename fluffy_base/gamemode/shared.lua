--[[
Configuration file for each gamemode
Not all settings are listed here because I'm a bad person
--]]

DeriveGamemode('base')
include('player_class/player_default.lua')

GM.Name = 'Fluffy Base'
GM.Author = 'FluffyXVI'

GM.TeamBased = false	-- Is the gamemode FFA or Teams?
GM.Elimination = false  -- Should players respawn when killed?

GM.TeamSurvival = false -- Suicide Barrels style gamemode
GM.HunterTeam = nil     -- Used for Team Survival gamemodes
GM.SurvivorTeam = nil   -- Used for Team Survival gamemodes

GM.RoundNumber = 3      -- How many rounds?
GM.RoundTime = 150      -- Seconds each round lasts for
GM.RoundCooldown = 5    -- Cooldown between rounds - (double this, once preround, once postround)

GM.CanSuicide    = true -- Should players be able to commit suicide?
GM.AllowAutoTeam = true -- This should work but it doesn't

function GM:Initialize()

end

-- These teams should work fantastically for most gamemodes
TEAM_RED = 1
TEAM_BLUE = 2

function GM:CreateTeams()
	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_RED, "Red Team", Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_RED, {"info_player_counterterrorist", "info_player_rebel"} )
	
	team.SetUp( TEAM_BLUE, "Blue Team", Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, {"info_player_terrorist", "info_player_combine"} )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_combine" } ) 
end