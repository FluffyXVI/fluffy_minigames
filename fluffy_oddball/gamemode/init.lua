AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

function GM:GetWinningPlayer()
    if GAMEMODE.TeamBased then return nil end
    if GAMEMODE.Elimination then return nil end
    
    -- Loop through all players and return the one with the most frags
    local bestscore = 0
    local bestplayer = nil
    for k,v in pairs( player.GetAll() ) do
        local frags = v:GetNWInt('OB_Progress', 0)
        if frags > bestscore then
            bestscore = frags
            bestplayer = v
        end
    end
    
    return bestplayer
end

hook.Add('PreRoundStart', 'ResetOBRank', function()
    for k,v in pairs( player.GetAll() ) do
        v:SetNWInt('OB_Progress', 0 )
    end
    
    GAMEMODE:RespawnOddball()
    
    timer.Create( 'OddballTimer', 1, 0, function()
        local ent = GetGlobalEntity('OddballEntity')
        if !IsValid( ent ) then return end
        if ent:GetClass() == 'player' then
            ent:SetNWInt('OB_Progress', ent:GetNWInt('OB_Progress', 0) + 1 ) -- chaining commands is cool yo
        end
    end )
end )

hook.Add('RoundEnd', 'RemoveOBTimer', function()
    for k,v in pairs( player.GetAll() ) do
        v:AddFrags( v:GetNWInt('OB_Progress', 0) )
        if FLUFFY_CURRENCY then
            local score = math.floor( v:GetNWInt('OB_Progress') / 10 )
            v:QueueXP( score )
        end
    end
    timer.Remove('OddballTimer')
end )

function GM:RespawnOddball()
    local spawnpos = self.BallSpawns[ game.GetMap() ]
    if spawnpos then
        local ball = ents.Create('ent_oddball')
        ball:SetPos( spawnpos )
        ball:Spawn()
        SetGlobalEntity('OddballEntity', ball )
    else
        local ply = table.Random( player.GetAll() )
        ply:Give( ODDBALL_WEAPON )
        SetGlobalEntity('OddballEntity', ply )
    end
end

function GM:PlayerLoadout( ply )
    ply:StripWeapons()
    ply:Give('weapon_rpg')
    ply:GiveAmmo(100, 'RPG_Round')
    ply:SetWalkSpeed( 300 )
    ply:SetRunSpeed( 500 )
    ply:SetJumpPower( 200 )
end

function GM:CollectOddball( ply )
    ply:StripWeapons()
    ply:Give( ODDBALL_WEAPON )
    SetGlobalEntity('OddballEntity', ply )
    ply:SetWalkSpeed( 575 )
    ply:SetRunSpeed( 575 )
    ply:SetJumpPower( 275 )
end

function GM:DoPlayerDeath(ply)
    ply:CreateRagdoll()
    if ply:HasWeapon( ODDBALL_WEAPON ) or GetGlobalEntity('OddballEntity') == ply then
        local vel = ply:EyeAngles():Forward():GetNormalized() * 800
        local ball = ents.Create('ent_oddball')
        ball:SetPos( ply:GetPos() + Vector(0, 0, 16) )
        ball:Spawn()
        ball:GetPhysicsObject():Wake()
        ball:GetPhysicsObject():EnableMotion( true )
        ball:GetPhysicsObject():SetVelocity( vel )
        SetGlobalEntity('OddballEntity', ball )
    end
end

