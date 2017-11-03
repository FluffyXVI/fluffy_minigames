AddCSLuaFile()


if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType = "melee"
	
end

if ( CLIENT ) then
	SWEP.PrintName	= "Tomahawk"	 
	SWEP.Author		= "AlbinoBlackHawk"
	SWEP.Category	= "Sticks and Stones" 
    SWEP.PrintName	= "Tomahawk"	 
    SWEP.Author		= "AlbinoBlackHawk"
    SWEP.Category	= "Sticks and Stones" 
    SWEP.Slot		= 0					 
    SWEP.SlotPos	= 1
    SWEP.DrawAmmo   = false					 
    SWEP.IconLetter	= "w"
end

SWEP.Base				= "weapon_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel		= "models/tiggomods/weapons/ACIII/v_Tomahawk.mdl"	 
SWEP.WorldModel		= "models/tiggomods/weapons/ACIII/w_Tomahawk.mdl"
SWEP.DrawCrosshair              = true

SWEP.ViewModelFOV = 57

SWEP.ViewModelFlip = true


SWEP.Weight				= 1			 
SWEP.AutoSwitchTo		= true		 
SWEP.AutoSwitchFrom		= false	
SWEP.CSMuzzleFlashes		= false	

SWEP.Secondary.ClipSize		= -1			
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Damage			= 0		 
SWEP.Secondary.Automatic		= false		 
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()

	self:SetWeaponHoldType( "melee" )

end


SWEP.MissSound 				= Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound 				= Sound("weapons/TiggoMods/ACIII/Tomahawk.wav")
local ShootSound = Sound("weapons/knife/knife_slash1.wav")

--/*---------------------------------------------------------
--PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	
end

function SWEP:Think()
	self.BaseClass.Think(self)
	if !self.Owner:KeyDown(IN_USE) then
		self:throw_attack("models/tiggomods/weapons/ACIII/w_Tomahawk.mdl")
		if SERVER then 
            self.Owner:SelectWeapon(self.Owner.PreviousWeapon)
            self:Remove()
        end
	end
end

--/*---------------------------------------------------------
--Reload
---------------------------------------------------------*/
function SWEP:Reload()

	return false
end

--/*---------------------------------------------------------
--OnRemove
---------------------------------------------------------*/
function SWEP:OnRemove()

return true
end

--/*---------------------------------------------------------
--Holster
---------------------------------------------------------*/
function SWEP:Holster()

	return true
end

--/*---------------------------------------------------------
--SecondaryAttack
---------------------------------------------------------*/
function SWEP:throw_attack (model_file)

	local tr = self.Owner:GetEyeTrace()

	self:EmitSound(ShootSound)
	self.BaseClass.ShootEffects(self)
    self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	
	if (!SERVER) then return end
 
	local ent = ents.Create("sas_ent_tomahawk")
	if !IsValid(ent) then
		print("FAIL")
		return
	end
	ent:SetModel(model_file)

	ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
	ent:SetAngles(self.Owner:EyeAngles())
	ent.Owner = self.Owner
    ent:SetOwner( self.Owner )
	ent:Spawn()
 
	local phys = ent:GetPhysicsObject()
 
	if !(phys && IsValid(phys)) then ent:Remove() return end
 
local velocity = self.Owner:GetAimVector()
	velocity = velocity * 30000
	velocity = velocity + ( VectorRand() * 10 ) -- a random element
	phys:ApplyForceCenter( velocity )
 
	cleanup.Add(self.Owner, "entities", ent)
 
	undo.Create ("Thrown_SWEP_Entity")
		undo.AddEntity (ent)
		undo.SetPlayer (self.Owner)
	undo.Finish()
end

function SWEP:SecondaryAttack()

	--self:throw_attack("models/tiggomods/weapons/ACIII/w_Tomahawk.mdl")
end


