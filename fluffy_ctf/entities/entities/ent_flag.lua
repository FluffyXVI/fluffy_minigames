AddCSLuaFile()
--ENT.Type = 'anim'
ENT.Spawnable = true

function ENT:Initialize()
    self:SetModel( 'models/custom/flag.mdl' )
    self:SetModelScale( 1 )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    
    self:GetPhysicsObject():EnableMotion( false )
    
    self:Activate()
    
    --[[timer.Simple( RESPAWN_TIME or 10, function() 
        if GetGlobalEntity('OddballEntity'):GetClass() != 'player' then
            GAMEMODE:RespawnOddball() 
        end
        if IsValid(self) then self:Remove() end 
    end )]]
end

function ENT:Use( ply )
    GAMEMODE:CollectOddball( ply )
    self:Remove()
end
