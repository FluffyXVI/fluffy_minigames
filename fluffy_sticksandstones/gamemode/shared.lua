--[[
Configuration file for each gamemode
Not all settings are listed here because I'm a bad person
--]]

DeriveGamemode('fluffy_base')

GM.Name = 'Sticks and Stones'
GM.Author = 'AlbinoBlackHawk'

GM.RoundNumber = 3      -- How many rounds?
GM.RoundTime = 300      -- Seconds each round lasts for
GM.RoundCooldown = 5    -- Cooldown between rounds - (double this, once preround, once postround)
AXE_MAX = 3				-- Max amount of Tommahawks a player can carry.
KNIFE_MAX = 4			-- Max amount of Ballistic Knives a player can have.
NORMAL_SCORE = 10		-- Points awarded for crossbow and ballitic knife kills
EASY_SCORE = 5			-- Points awarded for tomahawk and melee kills
WIN_FRAGS = 5			-- Frags awarded for winning a round
BONUS_SCALE = 3			-- Scale factor for how many bonus frags player gets for reseting another player
DESPAWN_TIME = 30		-- Time before a thrown knife or axe despawns

WEAPON_PRIZES = {}
WEAPON_PRIZES['env_explosion'] = NORMAL_SCORE
WEAPON_PRIZES['sas_bolt'] = NORMAL_SCORE
WEAPON_PRIZES['sas_knife'] = NORMAL_SCORE
WEAPON_PRIZES['sas_ent_tomahawk'] = EASY_SCORE

function GM:Initialize()

end