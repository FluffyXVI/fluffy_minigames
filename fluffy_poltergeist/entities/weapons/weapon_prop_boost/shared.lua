if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= false
	
	SWEP.PrintName = "Thruster"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	end
	
end

SWEP.WorldModel		= ""
SWEP.ViewModel      = ""

SWEP.Primary.Sound			= Sound("ambient/machines/machine1_hit1.wav")

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1

function SWEP:Initialize()
	
end

function SWEP:Deploy()
    self.Owner:DrawViewModel(false)
    
	if SERVER then
		self.Owner:DrawWorldModel( false )
	end

	return true
	
end  

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()
	
	return true
	
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 5 )
	self.Weapon:EmitSound( self.Primary.Sound )	
	
	if CLIENT then return end
	
	local prop = self.Owner:GetProp()
	if not prop or not prop:IsValid() then return end
	
	local phys = prop:GetPhysicsObject()
	if not phys or not phys:IsValid() then return end
	
	phys:SetVelocityInstantaneous( self.Owner:GetAimVector() * 5000 )
	
end

function SWEP:Think()	

	if self.TickTime and self.TickTime < CurTime() then
	
		self.TickTime = CurTime() + 1
		self.Ticks = self.Ticks + 1
	
		if self.Ticks >= 3 and SERVER then
			
            local ply = self.Owner
			self.TickTime = CurTime() + 1
            local boom = ents.Create( "env_explosion" )
            boom:SetPos( self.Owner:GetProp():GetPos() ) 
            boom:SetOwner( self.Owner )
            boom:Spawn()
            boom:SetKeyValue( "iMagnitude", "150" ) 
            boom:Fire( "Explode", 0, 0 ) 
			
			if self.Owner:Alive() then
				self.Owner:Kill()
			end
			
		elseif self.Ticks < 3 then
		
			self.Weapon:EmitSound( self.Primary.Sound, 100, 150 + self.Ticks * 20 )
			
		end
	
	end

end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 10 )
	
	self.Ticks = 0
	self.TickTime = CurTime() + 1
	
	self.Weapon:EmitSound( self.Primary.Sound, 100, 150 )	

end

function SWEP:DrawHUD()
	
end

