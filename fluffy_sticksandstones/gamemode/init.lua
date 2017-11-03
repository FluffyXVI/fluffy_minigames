AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

-- Add resources
resource.AddFile('materials/models/tiggomods/weapons/aciii/tomahawk/hand.vmt')
resource.AddFile('materials/models/tiggomods/weapons/aciii/tomahawk/tomahawk_d.vmt')
resource.AddFile('models/tiggomods/weapons/aciii/v_tomahawk.mdl')
resource.AddFile('models/tiggomods/weapons/aciii/w_tomahawk.mdl')

function GM:GetWinningPlayer()
    if GAMEMODE.TeamBased then return nil end
    if GAMEMODE.Elimination then return nil end
    
    -- Loop through all players and return the one with the most frags
    local bestscore = 0
    local bestplayer = nil
    for k,v in pairs( player.GetAll() ) do
        local frags = v:GetNWInt('SAS_Progress', 0)
        if frags > bestscore then
            bestscore = frags
            bestplayer = v
        end
    end
    
    return bestplayer
end

hook.Add('PreRoundStart', 'ResetSASRank', function()
    for k,v in pairs( player.GetAll() ) do
        v:SetNWInt('SAS_Progress', 0 )
    end
end )

function GM:PlayerLoadout( ply )
    ply:StripWeapons()
    ply.Spawning = true
	ply:Give( "weapon_sas_knife" )
	ply:Give( "weapon_sas_crossbow_better" )
	ply.Spawning = false
	ply.AxeCount = 1
end

function GM:PlayerCanPickupWeapon(ply, wep)
	if ply.Spawning then return true end
	local curAmmo = ply:GetAmmoCount(wep.Primary.Ammo)
	if curAmmo < KNIFE_MAX - 1 then
		ply:SetAmmo(curAmmo + 1, wep.Primary.Ammo)
	end
	wep:Remove()
	return false
end

hook.Add( "KeyPress", "keypress_use_tomahawk", function( ply, key )
	if ( key == IN_USE) and ply.AxeCount > 0 then
		CreateAxe(ply, key)
	end
end )

function CreateAxe(ply, key)
	ply.AxeCount = ply.AxeCount - 1
	ply.PreviousWeapon = ply:GetActiveWeapon():GetClass()
	ply.Spawning = true
	ply:Give( "weapon_sas_tomohawk" )
	ply.Spawning = false
	ply:SelectWeapon( "weapon_sas_tomohawk" )
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
    ply:CreateRagdoll()
    if GetGlobalString( 'RoundState' ) != 'InRound' then return end

    local ent = dmginfo:GetInflictor()
    if IsValid(ent) then
    	ent = ent:GetClass()
    end
    
    local prize = EASY_SCORE
    if WEAPON_PRIZES[ent] then
        prize = WEAPON_PRIZES[ent]
    end
    
    ply:AddDeaths( 1 )
    if attacker == ply then
        -- suicide
    elseif attacker:IsValid() and attacker:IsPlayer() then
        if ent == 'sas_ent_tomahawk' then
            attacker:AddFrags(math.Round(ply:GetNWInt('SAS_Progress') / (NORMAL_SCORE * BONUS_SCALE)))
            ply:SetNWInt('SAS_Progress', 0)
        end
        if FLUFFY_CURRENCY then
            attacker:QueueXP( 1 )
        end
        attacker:AddFrags( 1 )
        score = attacker:GetNWInt('SAS_Progress') + prize
        attacker:SetNWInt('SAS_Progress', score)
        
    end
end

