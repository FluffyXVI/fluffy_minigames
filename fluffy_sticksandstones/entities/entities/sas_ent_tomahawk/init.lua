--[[
	Last Modified: 29/10/17
	Author: AlbinoBlackHawk
	This is a weapon which I downloaded of the workshop then tweaked,
	most the code is not mine. What changes I have made have been noted
	in the comments below.
]]

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

-----------------------------------------------------------
--Initialize
-----------------------------------------------------------
function ENT:Initialize()
	self.CanBePickedUP = false
	self:SetModel( "models/tiggomods/weapons/ACIII/w_Tomahawk.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	self.NextThink = CurTime() +  1

	if ( phys:IsValid() ) then
		phys:Wake()
		phys:SetMass( 10 )
	end

	util.PrecacheSound("physics/metal/metal_grenade_impact_hard3.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet2.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet3.wav")

	self.Hit = { 
	Sound( "physics/metal/metal_grenade_impact_hard1.wav" ),
	Sound( "physics/metal/metal_grenade_impact_hard2.wav" ),
	Sound( "physics/metal/metal_grenade_impact_hard3.wav" ) };
	self.FleshHit = { 
	Sound( "physics/flesh/flesh_impact_bullet1.wav" ),
	Sound( "physics/flesh/flesh_impact_bullet2.wav" ),
	Sound( "physics/flesh/flesh_impact_bullet3.wav" ) }

	if (IsValid(phys)) then
		phys:SetMass( 2 )
	end
end

-----------------------------------------------------------
--PhysicsCollided
-----------------------------------------------------------
function ENT:PhysicsCollide( data, phys )
	local Ent = data.HitEntity
	if !(IsValid( Ent ) || Ent:IsWorld()) then return end
	if Ent:IsPlayer() and self.CanBePickedUP then
        local axe = Ent:GetNWInt('AxeCount', 0)
		if axe < AXE_MAX then
			Ent:SetNWINt('AxeCount', axe + 1)
		end
		self:Remove()
	end
	if Ent:GetOwner() == self:GetOwner()  then return end --There was a bug where the player could kill themselves, fixed it

	if Ent:IsWorld() then
		util.Decal( "ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal )
		self:EmitSound( self.Hit[math.random(1,#self.Hit)] );
		--There used to be a disable method, with activated a despawn timer, I removed that. On second thoughts, I may consider reading it.
	elseif Ent.Health then
		if not(Ent:IsPlayer() || Ent:IsNPC() || Ent:GetClass() == "prop_ragdoll") then 
			util.Decal( "ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal )
			self:EmitSound( self.Hit[math.random(1,#self.Hit)] );
		end

		Ent:TakeDamage( 100, self:GetOwner(), self )

		if (Ent:IsPlayer() || Ent:IsNPC() || Ent:GetClass() == "prop_ragdoll") then 
			local effectdata = EffectData()
			effectdata:SetStart( data.HitPos )
			effectdata:SetOrigin( data.HitPos )
			effectdata:SetScale( 1 )
			util.Effect( "BloodImpact", effectdata )

			self:EmitSound( self.FleshHit[math.random(1,#self.Hit)] );
			--Entitie used to delete itself here, removed this, so now you can pick up axes off dead bodies
		end
	end
end

-----------------------------------------------------------
--Think
-----------------------------------------------------------
function ENT:Think()
	if !self.CanBePickedUP then
		if self:GetVelocity():Length2D() < 1.5 then
			self.CanBePickedUP = true
			self.Entity:SetOwner( NUL )
			self:Disable()
		end
	else
		self.lifetime = self.lifetime or CurTime() + 20
		if CurTime() > self.lifetime then
			self:Remove()
		end
	end
end

-----------------------------------------------------------
--Disable
-----------------------------------------------------------
function ENT:Disable()
	self.lifetime = CurTime() + DESPAWN_TIME
end

-----------------------------------------------------------
--Use
-----------------------------------------------------------\
--This method used to give ammo. Seeming as the tomahawk is half weapon, half entity,
--I replaced it with calls to my own ammo management stystem.
function ENT:Use( activator, caller )
	self.Entity:Remove()
	if ( activator:IsPlayer() and activator:GetNWInt('AxeCount', 0) < AXE_MAX) then
		activator:SetNWInt('AxeCount', activator:GetNWInt('AxeCount') + 1 )
	end
end
