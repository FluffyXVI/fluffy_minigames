AddCSLuaFile()

SWEP.Spawnable = true
SWEP.Category = 'Sticks and Stones'
SWEP.PrintName = 'Crossbow'

SWEP.ViewModelFOV = 50
SWEP.ViewModel = "models/weapons/c_crossbow.mdl" 
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.UseHands = true

SWEP.HoldType = 'crossbow'

SWEP.Primary.Sound			= Sound( "Weapon_Crossbow.Single" )
SWEP.Primary.Reload			= Sound( "Weapon_Crossbow.Reload" )
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 5		
SWEP.Primary.Ammo			= "XBowBolt"
SWEP.Primary.Velocity       = 4000

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "None"

function SWEP:Deploy()
	if ( self.Weapon:Clip1() <= 0 ) then
		self.Weapon:SendWeaponAnim( ACT_CROSSBOW_DRAW_UNLOADED )
		return self:SetDeploySpeed( self.Weapon:SequenceDuration() )
	end
    self:SetSkin( 1 )
    
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return self:SetDeploySpeed( self.Weapon:SequenceDuration() )

end

function SWEP:Reload()
	if self.Weapon:DefaultReload( ACT_VM_RELOAD ) then
		return true
	end

	return false
end

function SWEP:PrimaryAttack()
    if !self:CanPrimaryAttack() then return end
    
    if self.Weapon:Clip1() <= 0 and self.Primary.ClipSize > -1 then
		if self:Ammo1() > 0 then
			self:Reload()
		else
			self.Weapon:SetNextPrimaryFire( 0.15 )
		end

		return
	end
    
    if CLIENT then return end
    
    self:FireBolt()
    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self:ShootEffects()
    self:EmitSound( self.Primary.Sound )
    
    self:SetNextPrimaryFire( CurTime() + 0.2 )
    self:TakePrimaryAmmo( 1 )
end

function SWEP:FireBolt()
    local pos = self.Owner:GetShootPos()
    local aim = self.Owner:GetAimVector()
    local ang = aim:Angle()
    
    local bolt = ents.Create('sas_bolt')
    bolt:SetPos( pos + (aim*12) ) 
    bolt:SetAngles( ang )
    bolt.Owner = self.Owner
    bolt:Spawn()
    bolt:Activate()
    
    bolt:GetPhysicsObject():SetVelocity( aim * self.Primary.Velocity )
end

function SWEP:SecondaryAttack()

end