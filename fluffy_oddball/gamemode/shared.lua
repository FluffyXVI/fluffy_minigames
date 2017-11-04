--[[
Configuration file for each gamemode
Not all settings are listed here because I'm a bad person
--]]

DeriveGamemode('fluffy_base')

GM.Name = 'Oddball'
GM.Author = 'FluffyXVI'

GM.RoundNumber = 5      -- How many rounds?
GM.RoundTime = 150      -- Seconds each round lasts for
GM.CanSuicide = false   -- Block suicide

DESPAWN_TIME = 10       -- Time before the ball respawns
ODDBALL_WEAPON = 'wep_oddball'

GM.BallSpawns = {}
GM.BallSpawns['gm_battlegrounds'] = Vector(0, 256, 128)

function GM:Initialize()

end