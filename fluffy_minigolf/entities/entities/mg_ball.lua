AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Ball"

function ENT:SetupDataTables()
	self:NetworkVar( 'Bool', 0, 'CanShoot' )
    self:NetworkVar( 'Vector', 0, 'FakeVelocity' )
end

function ENT:GetShootTable()
	local newAng = self:GetOwner():EyeAngles()
	local shootTable = {}
	shootTable.dir = Angle(0,newAng.y,0)
	shootTable.power = 1 - ((newAng.p + 89) / 178)
	return shootTable
end

if CLIENT then
    function ENT:Draw()
        if self:GetOwner() == LocalPlayer() and self:GetCanShoot() then
            local shootTable = self:GetShootTable()
            render.ClearDepth()
            render.SetColorMaterial()
            render.DrawQuadEasy(self:GetPos() + (shootTable.dir:Forward() * (shootTable.power + 0.05) * 200),Vector(0,0,1),6,6,Color(255,255,255), shootTable.dir.y)
            render.DrawQuadEasy(self:GetPos() + (shootTable.dir:Forward() * (shootTable.power + 0.025) * 100),Vector(0,0,1),2,(shootTable.power * 200) + 8,Color(255,255,255), shootTable.dir.y)
        end
        
        local fakeVel = self:GetFakeVelocity()
        if !self.angle then self.angle = Angle(0, 0, 0) end
        self.angle:RotateAroundAxis(-fakeVel:Angle():Right(),fakeVel:Length() * FrameTime() * 10)
        self:SetRenderAngles(self.angle)
        self:DrawModel()
        render.OverrideDepthEnable(false,false)
    end
end

if SERVER then
    local bounce_sounds = {
        'physics/concrete/concrete_impact_soft1.wav',
        'physics/concrete/concrete_impact_soft2.wav',
        'physics/concrete/concrete_impact_soft3.wav',
    }
    function ENT:Initialize()
        self:SetModel( "models/XQM/Rails/gumball_1.mdl" )
        self:SetModelScale( 0.15, 0 )
        self:PhysicsInitSphere(1, "metal_bouncy" )
        self:GetOwner():SetNWEntity( "ball", self )
        self:SetCustomCollisionCheck(true)
        local phys = self:GetPhysicsObject()
        phys:Wake()
        
        self.Inbounds = true
        self:SetCanShoot(true)
    end
    
    function ENT:PhysicsCollide(data, phys)
        local oldVel = phys:GetVelocity()
        local newVel = oldVel + (data.HitNormal * oldVel * 0.25)
        if newVel:LengthSqr() > oldVel:LengthSqr() then
            newVel = oldVel - (data.HitNormal * oldVel * 0.25)
        end
        phys:SetVelocity(Vector(newVel.x, newVel.y, newVel.z * 0.4))
        
        if data.HitNormal == Vector(-0, -0, -1) then return end
        self:EmitSound( 'physics/concrete/concrete_impact_soft1.wav' )
    end
    
    function ENT:Shoot()
        if !self:GetCanShoot() then return end
        local phys = self:GetPhysicsObject()
        local tbl = self:GetShootTable()
        phys:SetVelocity( tbl.dir:Forward() * math.max(tbl.power * 2000, 20) )
        self:SetCanShoot(false)
    end
    
    function ENT:Think()
        self:NextThink(CurTime())
        local tr = util.TraceLine({
            start = self:GetPos(),
            endpos = self:GetPos() - Vector(0,0,10),
            filter = self
        })
        
        if tr.Hit then
            local phys = self:GetPhysicsObject()
            local vel = phys:GetVelocity()
            local friction = (1.1 * FrameTime()) + 1
            local newVel = vel / friction
            phys:SetVelocity(newVel)
            self:SetFakeVelocity(newVel)
            if vel:LengthSqr() <= 30 and not self:GetCanShoot() then
                local hole = GAMEMODE.HoleEntity
                if hole then
                    if self:GetPos():DistToSqr( hole:GetPos() ) < 256 then
                        self:Remove()
                        GAMEMODE:CheckHole()
                    end
                end
                if not self.Inbounds and self.lastCheckpoint then
                    self:SetPos(self.lastCheckpoint)
                end
                phys:SetVelocity(Vector(0,0,0))
                phys:Sleep()
                self:SetCanShoot(true)
                self.lastCheckpoint = self:GetPos()
            end
        end
        return true
    end
end