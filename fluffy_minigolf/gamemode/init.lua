AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

GAMEMODE.HoleEntity = nil

function GM:PlayerSpawn( ply )
	GAMEMODE:PlayerSpawnAsSpectator( ply )
	ply:SetObserverMode(OBS_MODE_CHASE)
end

function GM:ShouldCollide( ent1, ent2 )

	if IsValid( ent1 ) and IsValid( ent2 ) and ent1:GetClass() == "mg_ball" and ent2:GetClass() == "mg_ball" then return false end

	return true
end

function GM:CheckHole()
    if #ents.FindByClass('mg_ball') <= 1 then
        self:EndRound('Hole Complete!')
    end
end

hook.Add('PreRoundStart', 'SpawnBalls', function() 
    print( 'Spawning Balls' )  
    local spawn = nil
    local hole = (GetGlobalInt( 'RoundNumber', 1 ) % 2) + 1
    for k,v in pairs( ents.FindByClass('mg_ballspawn') ) do
        if v:GetHole() == hole then
            spawn = v
            break
        end
    end
    
    for k,v in pairs( ents.FindByClass('mg_hole') ) do
        if v:GetHole() == hole then
            GAMEMODE.HoleEntity = v
            break
        end
    end
    
    if !spawn then return end
    local spawnpos = spawn:GetPos() + Vector(0, 0, 20)
    for k,v in pairs( player.GetAll() ) do
        local ball = ents.Create('mg_ball')
        ball:SetPos( spawnpos )
        ball:SetOwner( v )
        ball:Spawn()
        v:SpectateEntity( ball )
        local c = v:GetPlayerColor()
        timer.Simple( 1, function() ball:SetColor( Color( c[1] * 255, c[2] * 255, c[3] * 255 ) ) end )
    end
end )

hook.Add('KeyPress', 'ShootBall', function(pl, key)
	if key == IN_ATTACK then
		local ball = pl:GetNWEntity('ball', nil )
		if ball:IsValid() then
			ball:Shoot()
		end
	end
end)