AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

GunGame_Progression = {
    'weapon_ar2',
    'weapon_rpg',
    'weapon_crossbow',
    
    'weapon_smg1',
    'weapon_shotgun',
    'weapon_357',
    
    'weapon_pistol',
    'weapon_slam',
    'weapon_crowbar',
}

GunGame_Progression_CSS = {
    'weapon_p90',
    'weapon_mp5navy',
    'weapon_famas',
    
    'weapon_ak47',
    'weapon_m249',
    'weapon_xm1014',
    
    'weapon_elite',
    'weapon_fiveseven',
    'weapon_glock',
    'weapon_knife',
}

function GM:PlayerLoadout( ply )
    local stage = math.floor( ply:GetNWInt('GG_Progress', 0 ) / 2 ) + 1
    local kill = nil
    if IsValid( ply:GetActiveWeapon() ) then kill = ply:GetActiveWeapon():GetClass() end
    local prog = GunGame_Progression
    if GetGlobalString( 'GunGame_Mode' ) == 'css' then prog = GunGame_Progression_CSS end
    if stage > #prog then
        GAMEMODE:EndRound( ply )
        return
    end
    
    local wep = prog[ stage ]
    local last = prog[ #prog ]
    if ply:HasWeapon( wep ) and wep != last then return end
    
    ply:RemoveAllAmmo()
    ply:StripWeapons()
    
    ply:GiveAmmo( 1000, 'SMG1', true )
    ply:GiveAmmo( 1000, 'Buckshot', true )
    ply:GiveAmmo( 1000, 'pistol', true )
    ply:GiveAmmo( 1000, 'RPG_Round', true )
    ply:GiveAmmo( 1000, 'Grenade', true )
    ply:GiveAmmo( 20, 'slam', true )
    ply:GiveAmmo( 1000, '357', true )
    ply:GiveAmmo( 1000, 'AR2', true )
    ply:GiveAmmo( 1000, 'XBowBolt', true )
    
    ply:GiveAmmo( 1000, 'css_12gauge', true )
    ply:GiveAmmo( 1000, 'css_57mm', true )
    ply:GiveAmmo( 1000, 'css_45acp', true )
    ply:GiveAmmo( 1000, 'css_9mm', true )
    ply:GiveAmmo( 1000, 'css_50ae', true )
    ply:GiveAmmo( 1000, 'css_556mm', true )
    ply:GiveAmmo( 1000, 'css_762mm', true )
    ply:GiveAmmo( 1000, 'css_338', true )
    ply:GiveAmmo( 1000, 'css_357sig', true )
    
    
    ply:Give( last, true )
    local given = ply:Give( wep )
    if kill != last then 
        ply:SelectWeapon( wep ) 
        --given:Deploy()
        --if kill then timer.Simple( 0.1, function() given:PrimaryAttack() end ) end
    end
end

hook.Add('PreRoundStart', 'ResetGGRank', function()
    for k,v in pairs( player.GetAll() ) do
        v:SetNWInt('GG_Progress', 0 )
    end
    
    local mode = math.random()
    if mode >= 0.3 then mode = 'css' else mode = 'hl2' end
    SetGlobalString( 'GunGame_Mode', mode )
    GetConVar("sv_css_enable_drops"):SetBool( false )
    GetConVar("sv_css_damage_scale"):SetFloat( 0.6 )
end )

function GM:DoPlayerDeath( ply, attacker, dmginfo )
    -- Do not count deaths unless in round
    ply:CreateRagdoll()
    if GetGlobalString( 'RoundState' ) != 'InRound' then return end
    
	ply:AddDeaths( 1 )
    -- If killed by a player
	if attacker:IsValid() and attacker:IsPlayer() then
        -- Subtract one kill if suicide
		if attacker == ply then
			attacker:AddFrags( -1 )
            attacker:SetNWInt('GG_Progress', math.Clamp( attacker:GetNWInt('GG_Progress') - 1, 0, 100 ) )
            
        -- Award kill to the killer and respective team
		else
			attacker:AddFrags( 1 )
            attacker:SetNWInt('GG_Progress', attacker:GetNWInt('GG_Progress') + 1 )
            GAMEMODE:PlayerLoadout( attacker )
            if FLUFFY_CURRENCY then
                attacker:QueueXP( 1 )
            end
        end
    end
end