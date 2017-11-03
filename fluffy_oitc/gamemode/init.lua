AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

-- Give the weapons needed for OITC
function GM:PlayerLoadout( ply )
    ply:StripWeapons()
	ply:Give( "weapon_oitc_knife" )
    ply:Give( "weapon_oitc_pistol" )
    ply:RemoveAllAmmo()
end

-- Award a bullet when a player is killed
hook.Add('PlayerDeath', 'BulletsOnKill', function( ply, attacker, dmginfo )
    if attacker.Owner then attacker.Owner:GiveAmmo( 1, 'Pistol', true ) else attacker:GiveAmmo( 1, 'Pistol', true ) end
end )