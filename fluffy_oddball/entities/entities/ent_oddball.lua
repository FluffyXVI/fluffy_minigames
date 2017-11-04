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
    
    self:Activate()
    
    timer.Simple( RESPAWN_TIME or 20, function() if IsValid(self) then self:Remove() GAMEMODE:RespawnOddball() end end )
end

function ENT:Use( ply )
    GAMEMODE:CollectOddball( ply )
    self:Remove()
end
