AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.Spawnable = true
SWEP.PrintName = 'Oddball'

SWEP.ViewModelFOV	= 45
SWEP.ViewModelFlip	= false
SWEP.ViewModel	= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel	= "models/weapons/w_grenade.mdl"
SWEP.UseHands = true

SWEP.Primary.Ammo = false
SWEP.Primary.Damage = 25
SWEP.Secondary.Ammo = false

function SWEP:Initialize()
    self:SetHoldType( 'melee' )
end

function SWEP:Deploy()
    self:SetHoldType( 'melee' )
end

local sound_single = Sound("Weapon_Crowbar.Single")

function SWEP:PrimaryAttack()
    self:EmitSound(sound_single)
    
    --Lagcomp before trace
    self.Owner:LagCompensation(true)
    
    --Trace to see what we hit if anything
    local ShootPos = self.Owner:GetShootPos()
    local ShootDest = ShootPos + (self.Owner:GetAimVector() * 70)
    local tr_main = util.TraceLine({start=ShootPos, endpos=ShootDest, filter=self.Owner, mask=MASK_SHOT_HULL})
    local tr_hull = util.TraceHull({start=ShootPos, endpos=ShootDest, mins=Vector(-8,-8,-8), maxs=Vector(8,8,8), filter=self.Owner, mask=MASK_SHOT_HULL})
    
    local HitEnt = IsValid(tr_main.Entity) and tr_main.Entity or tr_hull.Entity
    
    --Trace is done, turn off lagcomp
    self.Owner:LagCompensation(false)
    
    --If we hit something (including world)
    if IsValid(HitEnt) or tr_main.HitWorld then
    
        --Animate view model
        self:SendWeaponAnim( ACT_VM_HITCENTER )
    
        --Only do once/server
        if not (CLIENT and (not IsFirstTimePredicted())) then
            --Setup effect
            local edata = EffectData()
            edata:SetStart(ShootPos)
            edata:SetOrigin(tr_main.HitPos)
            edata:SetNormal(tr_main.Normal)
            edata:SetEntity(HitEnt)
            --Hit ragdoll or player, do blood
            if HitEnt:IsPlayer() or HitEnt:IsNPC() or HitEnt:GetClass() == "prop_ragdoll" then
                util.Effect("BloodImpact", edata)
                -- do a bullet for blood decals
                self.Owner:FireBullets({Num=1, Src=ShootPos, Dir=self.Owner:GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=0})
            else
                --Hit something other than player or ragdoll
                util.Effect("Impact", edata)
            end
        end
    else
        --Didn't hit anything, miss animation
        self:SendWeaponAnim( ACT_VM_MISSCENTER )
    end
    
    --Animate
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    
    --Damage entity
    if HitEnt and HitEnt:IsValid() then
        local dmg = DamageInfo()
        dmg:SetDamage(self.Primary.Damage)
        dmg:SetAttacker(self.Owner)
        dmg:SetInflictor(self)
        dmg:SetDamageForce(self.Owner:GetAimVector() * 1500)
        dmg:SetDamagePosition(self.Owner:GetPos())
        dmg:SetDamageType(DMG_CLUB)
        HitEnt:DispatchTraceAttack(dmg, ShootPos + (self.Owner:GetAimVector() * 3), ShootDest)
        HitEnt:SetVelocity(HitEnt:GetVelocity() + (self.Owner:GetAimVector() + Vector(0, 0, 0.1) * 2000) )
    end
    
    self:SendWeaponAnim( ACT_VM_HITCENTER )
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    
    self:SetNextPrimaryFire( CurTime() + 0.5 )
end

function SWEP:SecondaryAttack()

end

if CLIENT then
    SWEP.WorldSkullRotation = Angle(-45,90,0)
    SWEP.WorldSkullOffset = Vector(0,2.8,-0.2)
    
    SWEP.ViewSkullRotation = Angle(0,-160,180)
    SWEP.ViewSkullOffset = Vector(4.5,-3,-1)
    
    SWEP.VM_Lowered_Offset = Vector(0,0,1)
    SWEP.VM_Raised_Offset = Vector(8,2,0)
    
    SWEP.VM_Lowered_AngleOffset = Angle(5,0,0)
    SWEP.VM_Raised_AngleOffset = Angle(17,0,0)
    
    function SWEP:DrawWorldModel()
        
        --if we don't have a model then make it
        if not IsValid(self.SkullModel) then
            self.SkullModel = ClientsideModel("models/Gibs/HGIBS.mdl", RENDERGROUP_OPAQUE)
            self.SkullModel:SetNoDraw(true)
        end
        
        --Make sure we still have the model
        if IsValid(self.SkullModel) then
        
            --Default shit for fallback
            local HandPos = self:GetPos()
            local HandAng = self:GetAngles()
            
            --Get the players hand
            if IsValid(self.Owner) then
                local AttID = self.Owner:LookupAttachment('anim_attachment_RH')
                if AttID then
                --We have an ID so we should definitely be able to get the attachment
                    local Att = self.Owner:GetAttachment( AttID )
                    if Att then
                        --print("Using attachment ",AttID,Att)
                        HandPos,HandAng = Att.Pos,Att.Ang
                        
                        --Store directions before rotation
                        local HandFwd = HandAng:Forward()
                        local HandRight = HandAng:Right()
                        local HandUp = HandAng:Up()
                        
                        --Rotate by offset
                        HandAng:RotateAroundAxis(HandAng:Right(), self.WorldSkullRotation.p)
                        HandAng:RotateAroundAxis(HandAng:Up(), self.WorldSkullRotation.y)
                        HandAng:RotateAroundAxis(HandAng:Forward(), self.WorldSkullRotation.r)
                        
                        --Position by offset
                        HandPos = HandPos + HandAng:Forward()*self.WorldSkullOffset.y + HandAng:Right()*self.WorldSkullOffset.x + HandAng:Up()*self.WorldSkullOffset.z
                    else
                        --How the fuck did we get here, we managed to lookup the attachment id but then failed to get the attachment! wtf!
                        print("SKULL WEAPON FAILURE WTF! Tell whiterabbit about this error. Copy and paste it. >> AttachmentID is "..tostring(AttID).." and the resulting attachment is "..tostring(Att).." from the model "..self.Owner:GetModel().." <<")
                    end
                else
                    --where the fuck do we draw?
                end
            end
        
            --Draw it at the position and angle we worked out
            self.SkullModel:SetPos(HandPos)
            self.SkullModel:SetAngles(HandAng)
            self.SkullModel:DrawModel()
            
        end
        
    end
    
    function SWEP:Holster()
        if IsValid(self.SkullModel) then
            self.SkullModel:Remove()
        end
        self.SkullModel = nil
        
        --restore viewmodel material backup (it should have already been restored in post draw view model)
        if IsValid(self.Owner) and IsValid(self.Owner:GetViewModel()) then
            self.Owner:GetViewModel():SetMaterial("")
        end
    end

    function SWEP:OwnerChanged()
        --remove skull when it is picked up, so it gets recreated
        if IsValid(self.SkullModel) then
            self.SkullModel:Remove()
        end
        self.SkullModel = nil
    end

    function SWEP:PreDrawViewModel(vm,ply,wep)
        --Hide the crowbar, but keep our c_hands
        vm:SetMaterial( "engine/occlusionproxy" )
    end
    
    function SWEP:PostDrawViewModel(vm,ply,wep)
        --Restore the viewmodel material since
        vm:SetMaterial("")
        
        --if we don't have a model then make it
        if not IsValid(self.SkullModel) then
            self.SkullModel = ClientsideModel("models/Gibs/HGIBS.mdl", RENDERGROUP_OPAQUE)
            self.SkullModel:SetNoDraw(true)
        end
        
        --Make sure we still have the model
        if IsValid(self.SkullModel) then
            --Default shit for fallback
            local HandPos = self:GetPos()
            local HandAng = self:GetAngles()
            
            --Get the players hand
            if IsValid(self.Owner) then
                if IsValid(self.Owner:GetViewModel()) then
                    --local Att = self.Owner:GetViewModel():GetBonePosition(23) -- GetAttachment(1)
                    HandPos,HandAng = self.Owner:GetViewModel():GetBonePosition(23) -- Att.Pos,Att.Ang
                    
                    --Store directions before rotation
                    local HandFwd = HandAng:Forward()
                    local HandRight = HandAng:Right()
                    local HandUp = HandAng:Up()
                    
                    --Rotate by offset
                    HandAng:RotateAroundAxis(HandAng:Right(), self.ViewSkullRotation.p)
                    HandAng:RotateAroundAxis(HandAng:Up(), self.ViewSkullRotation.y)
                    HandAng:RotateAroundAxis(HandAng:Forward(), self.ViewSkullRotation.r)
                    
                    --Position by offset
                    HandPos = HandPos + HandAng:Forward()*self.ViewSkullOffset.y + HandAng:Right()*self.ViewSkullOffset.x + HandAng:Up()*self.ViewSkullOffset.z
                else
                    --where the fuck do we draw?
                end
            end
        
            --Draw it at the position and angle we worked out
            self.SkullModel:SetPos(HandPos)
            self.SkullModel:SetAngles(HandAng)
            self.SkullModel:DrawModel()
        end
    end
    
    function SWEP:GetViewModelPosition(pos,Ang)
        local ang = Ang
        pos = pos + Ang:Forward()*self.VM_Raised_Offset.y + Ang:Right()*self.VM_Raised_Offset.x + Ang:Up()*self.VM_Raised_Offset.z
		
		ang:RotateAroundAxis(ang:Right(),self.VM_Raised_AngleOffset.p)
		ang:RotateAroundAxis(ang:Up(),self.VM_Raised_AngleOffset.y)
		ang:RotateAroundAxis(ang:Forward(),self.VM_Raised_AngleOffset.r)
        return pos, ang
    end
end