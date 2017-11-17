AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

GM.HoleEntity = nil

function GM:PlayerSpawn( ply )
	self:PlayerSpawnAsSpectator( ply )
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
    local hole = (GetGlobalInt( 'RoundNumber', 1 ) % 8) + 1
    for k,v in pairs( ents.FindByClass('mg_ballspawn') ) do
        if v:GetHole() == hole then
            spawn = v
            break
        end
    end
    
    for k,v in pairs( ents.FindByClass('mg_hole') ) do
        if v:GetHole() == hole then
            GAMEMODE.HoleEntity = v
            SetGlobalInt( 'CurrentPAR', v:GetPar() or 3 )
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
        local c = Color( 52, 152, 219 )
        local cstring = v:GetInfo('fluffy_playercolor') or '52,152,219'
        cstring = string.Split( cstring, ',' )
        if #cstring == 3 then
            local r = tonumber( cstring[1] )
            local g = tonumber( cstring[2] )
            local b = tonumber( cstring[3] )
            if r and g and b then
                c = Color( math.Clamp(r,0,255), math.Clamp(g,0,255), math.Clamp(b,0,255) )
            end
        end
        ball:SetColor( c )
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