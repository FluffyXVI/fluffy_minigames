AddCSLuaFile()
ENT.Type = 'anim'

if CLIENT then
    local glow_material = Material('sprites/light_ignorez')
    function ENT:Draw()
        self:DrawModel()
        
        render.SetMaterial( glow_material )
        render.DrawSprite( self:GetPos(), 24, 24, Color( 255, 0, 0 ) )
    end
    
    return
end

function ENT:Initialize()
    self:SetModel( 'models/Gibs/HGIBS.mdl' )
    self:SetModelScale( 2 )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    
    self:GetPhysicsObject():EnableMotion( false )
    
    self:SetTrigger( true )
    self:Activate()
    
    timer.Simple( RESPAWN_TIME or 10, function() 
        if GetGlobalEntity('OddballEntity'):GetClass() != 'player' then
            GAMEMODE:RespawnOddball() 
        end
        if IsValid(self) then self:Remove() end 
    end )
end

function ENT:Use( ply )
    if !ply:Alive() then return end
    GAMEMODE:CollectOddball( ply )
    self:Remove()
end

function ENT:Touch( ent )
    if ent:IsPlayer() then
        self:Use( ent, ent, USE_ON, 1 )
    end
end