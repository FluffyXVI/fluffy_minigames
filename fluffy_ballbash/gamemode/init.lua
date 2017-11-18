AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

function GM:PlayerSpawn( ply )
	self:PlayerSpawnAsSpectator( ply )
	ply:SetObserverMode(OBS_MODE_CHASE)
end

hook.Add('PreRoundStart', 'SpawnBalls', function()
    for k,v in pairs( player.GetAll() ) do
        local pos = self:PlayerSelectSpawn( v ):GetPos()
        local bent = ents.Create( 'bb_ball' )
        bent:SetPos( pos )
        bent:Spawn()
        v:SetNWEntity('ball', bent )
    end
end )