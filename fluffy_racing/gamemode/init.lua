AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

function GM:CanExitVehicle()
    return
end

function GM:GetWinningPlayer()
    return nil
end

local function CreateCar( ply, ang )
    local car = nil
    local car_type = GAMEMODE.CarTypes[ game.GetMap() ] or 'jeep'
    if car_type == 'gokart' then
        car = ents.Create('prop_vehicle_jeep')
        car:SetModel( "models/steelemancars/shifterkart/shifterkart.mdl" )
        car:SetKeyValue("vehiclescript", "scripts/vehicles/fluffy/fluffy_gokart.txt")
        local KU = constraint.Keepupright( car, Angle(), 0, 45 )
    elseif car_type == 'jeep' then
        car = ents.Create('prop_vehicle_jeep_old')
        car:SetModel( "models/buggy.mdl" )
        car:SetKeyValue("vehiclescript", "scripts/vehicles/jeep_test.txt")
    end
    car:SetPos( ply:GetPos() )
    if ang then
        car:SetAngles( ang )
        ply:SetEyeAngles( ang + Angle( 0, 180, 0 ) )
    else
        car:SetAngles( GAMEMODE.CarAngles[ game.GetMap() ] or Angle( 0, 0, 0 ) )
        ply:SetEyeAngles( GAMEMODE.CarAngles[ game.GetMap() ] or Angle( 0, 0, 0 ) )
    end
    car:Spawn()
    car:Activate()
    timer.Simple( 0.25, function() if !IsValid(ply) or !IsValid(car) then return end ply:EnterVehicle( car ) end )
    ply.Vehicle = car
end

hook.Add('PreRoundStart', 'ResetCheckpoints', function()
    for k,v in pairs( player.GetAll() ) do
        v:SetNWInt('Checkpoint', 1)
        v.LastAngle = nil
    end
end )

function GM:PlayerSpawn( ply )
    local state = GetGlobalString('RoundState', 'GameNotStarted')
    
    if ply:Team() == TEAM_SPECTATOR then
        self:PlayerSpawnAsSpectator( ply )
        return
    end
    
    if ply:GetNWInt('Checkpoint', 0) > 1 then
        local num = ply:GetNWInt('Checkpoint', 0) - 1
        local pos = GAMEMODE.Checkpoints[ game.GetMap() ][ num ]
        ply:SetPos( pos + Vector(0, 0, 128) )
    end
    CreateCar( ply, ply.LastAngle )
    
    if state == 'GameNotStarted' then
        self:PlayerSpawnAsSpectator( ply )
        return
    end
	hook.Call('PlayerLoadout', GAMEMODE, ply )
    hook.Call('PlayerSetModel', GAMEMODE, ply )
    
    ply:UnSpectate()
    ply.Spectating = false
    ply:SetupHands()
end

function GM:PlayerPostThink( ply )
    local num = ply:GetNWInt('Checkpoint')
    if num == 0 then return end
    
    local pos = GAMEMODE.Checkpoints[ game.GetMap() ][ num ]
    local distance = pos:Distance( ply:GetPos() )
    if distance < 384 then
        ply:SetNWInt('Checkpoint', num + 1 )
        ply:EmitSound( 'garrysmod/content_downloaded.wav' )
        if ply.Vehicle then ply.LastAngle = ply.Vehicle:GetAngles() end
        if num == #GAMEMODE.Checkpoints[ game.GetMap() ] then
            GAMEMODE:EndRound( ply )
            ply:SetNWInt('Checkpoint', 0 )
        end
    end
end

hook.Add('DoPlayerDeath', 'RemoveCar', function( ply )
    if !IsValid( ply.Vehicle ) then return end
    ply.Vehicle:Remove()
end )