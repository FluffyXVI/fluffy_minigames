AddCSLuaFile()
ENT.Type = "anim"
ENT.Magnitude = 125
ENT.ExplodeTime = 3

if CLIENT then 
    function ENT:Draw()
        --self:DrawModel()
        local angel = self:GetAngles()
        render.Model( {model='models/crossbow_bolt.mdl', pos=self:GetPos(), angle=angel } )
    end


    return 
end

function ENT:Initialize()
    self:SetModel('models/hunter/blocks/cube025x025x025.mdl')
    self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
    self:DrawShadow( false )
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake()
		phys:EnableGravity(false)
        phys:SetDragCoefficient( -0.2 )
	end
    
    self.Angle = self:GetAngles()
    
    timer.Simple( self.ExplodeTime, function()
        if IsValid(self) then self:Explode() end
    end )
end

function ENT:Think()
    if IsValid( self.HitPlayer ) then
        if !self.HitPlayer:Alive() then self:Remove() end
    end
end

function ENT:PhysicsCollide(data, phys)
    if data.HitEntity == self.Owner then return end
    phys:EnableMotion( false )
    phys:Sleep()
    
    if data.HitEntity:IsValid() then
        if data.HitEntity:IsPlayer() then
            --self:SetPos( self:GetPos() + data.HitNormal * 16 )
            self:SetParent( data.HitEntity )
            self.HitPlayer = data.HitEntity
            data.HitEntity:TakeDamage( 50, self.Owner, self )
        end
        
        phys:EnableMotion( true )
        phys:Wake()
    end
    
end

function ENT:Explode()
    local explode = ents.Create('env_explosion')
    explode:SetPos( self:GetPos() )
    explode:SetOwner( self.Owner )
    explode:Spawn()
    explode:SetKeyValue('iMagnitude', self.Magnitude )
    explode:Fire('Explode', 0, 0)
     
    self:Remove()
end