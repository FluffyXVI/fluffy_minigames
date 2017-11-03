if SERVER then
   AddCSLuaFile()
end

SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Deagle"
   SWEP.Slot				= 0
   SWEP.SlotPos			= 0
   SWEP.IconLetter			= "f"
   
   surface.CreateFont("CSKillIcons", { font="csd", weight="500", size=ScreenScale(30),antialiasing=true,additive=true })
   killicon.AddFont( "weapon_oitc_pistol", "CSKillIcons", "f", Color( 255, 80, 0, 255 ) )
end

SWEP.Primary.Recoil	= 0
SWEP.Primary.Damage = 1000
SWEP.Primary.Delay = 0.32
SWEP.Primary.Cone = 0.0
SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 1
SWEP.Primary.ClipMax = 1
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = 'weapons/deagle/deagle-1.wav'

SWEP.ViewModel			= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD

function SWEP:CanPrimaryAttack()

	if ( self.Weapon:Clip1() <= 0 ) then
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:Reload()
		return false

	end

	return true
end

function SWEP:Reload()
    self.Weapon:DefaultReload( self.ReloadAnim )
end

function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    
    if !self:CanPrimaryAttack() then return end
    
    self.Weapon:EmitSound( self.Primary.Sound )
    
    local bullet = {}
    bullet.Num = 1; bullet.spread = Vector( self.Primary.Cone, self.Primary.Cone, 0 ); bullet.Damage = self.Primary.Damage; bullet.Force = 5;
    bullet.Src = self.Owner:GetShootPos(); bullet.Dir = self.Owner:GetAimVector();
    
    self.Owner:FireBullets( bullet )
    self.Weapon:SendWeaponAnim( self.PrimaryAnim )
    self.Owner:MuzzleFlash()
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    
    self:TakePrimaryAmmo( 1 )
    self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
end

function SWEP:SecondaryAttack()

end