if (SERVER) then

	SWEP.Weight				= 5
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom		= false
end

if ( CLIENT ) then
	SWEP.PrintName			= "Ballistic Knives" 
    SWEP.Author		= "AlbinoBlackHawk"
    SWEP.Category	= "Sticks and Stones" 
	SWEP.ViewModelFOV			= 65
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes		= true
	SWEP.Slot				= 2
	SWEP.SlotPos			= 0
end

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel 				= "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel 			= "models/weapons/w_knife_t.mdl" 
SWEP.UseHands               = true

SWEP.Primary.ClipSize			= 1
SWEP.Primary.Damage			    = -1
SWEP.Primary.DefaultClip		= KNIFE_MAX
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo			    = "357"


SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Damage			= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			    = "none"




---------------------------------------------------------
--Think
---------------------------------------------------------*/
function SWEP:Think()
	if self.Idle and CurTime()>=self.Idle then
		self.Idle = nil
		self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
	end
end


--------------------------------------------------------
--Initialize
---------------------------------------------------------*/
function SWEP:Initialize() 
	self:SetWeaponHoldType( "knife" )
end 

---------------------------------------------------------
--Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:EmitSound( "Weapon_Knife.Deploy" )
	return true
end

---------------------------------------------------------
--Throw
---------------------------------------------------------
function SWEP:ThrowKnife(force)
	if SERVER then
		local ent = ents.Create("sas_knife")
		ent:SetOwner(self.Owner)
		ent:SetPos(self.Owner:GetShootPos())
		local knife_ang = Angle(-28,0,0) + self.Owner:EyeAngles()
		--knife_ang:RotateAroundAxis(knife_ang:Right(), -90)
		ent:SetAngles(knife_ang)
		ent:Spawn()


		local phys = ent:GetPhysicsObject()
		phys:SetVelocity(self.Owner:GetAimVector() * (force * 1000 + 200))
		phys:AddAngleVelocity(Vector(0, 1500, 0))
	end
end

---------------------------------------------------------
--PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	if self:Clip1() > 0 then
		self:TakePrimaryAmmo(1)
		self:ThrowKnife(10000)
		self:Reload()
	end
end

function SWEP:Reload()
 
	if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
 
	if ( self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
 
		self:DefaultReload( ACT_VM_DRAW )
        local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
        self.ReloadingTime = CurTime() + AnimationTime
        self:SetNextPrimaryFire(CurTime() + AnimationTime)
        self:SetNextSecondaryFire(CurTime() + AnimationTime)
 
	end
 
end

---------------------------------------------------------
--SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.4)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then
		dmg = 500

		if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
			self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = dmg
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( "Weapon_Knife.Hit" )
		else
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = dmg
			self.Owner:FireBullets(bullet)
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
			self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self.Weapon:EmitSound( "Weapon_Knife.HitWall" )

		end
	else
		self.Weapon:EmitSound("Weapon_Knife.Slash")
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
end

function SWEP:EntityFaceBack(ent)
	local angle = self.Owner:GetAngles().y -ent:GetAngles().y
	if angle < -180 then angle = 360 +angle end
	if angle <= 90 and angle >= -90 then return true end
	return false
end

function SWEP:DoImpactEffect( tr, nDamageType )
	util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)	
	return true;
	
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true --//draw the display?
	if self.Primary.ClipSize > 0 then
		self.AmmoDisplay.PrimaryClip = self:Clip1()--//amount in clip
		self.AmmoDisplay.PrimaryAmmo = self:Ammo1()--//amount in reserve
	end
	--if self.Secondary.ClipSize > 0 then
	--	self.AmmoDisplay.SecondaryClip = self:Clip2()
	--	self.AmmoDisplay.SecondaryAmmo = self:Ammo2()
	--end

	return self.AmmoDisplay --//return the table
end