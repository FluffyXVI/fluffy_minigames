
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	for i, v in ipairs(player.GetAll()) do
		self:SetPreventTransmit( v, true )
	end
	self:SetModel("models/platformmaster/jumppad.mdl")
	self:PhysicsInitShadow( false, false )
	self:SetSolid(SOLID_NONE)
	self:SetTrigger( true )
	self:UseTriggerBounds( true, 8 )
	local newAng = Angle(math.random(-35,-90), 0, 0)
	newAng:RotateAroundAxis(Vector(0,0,1),math.random() * 360)
	self:SetAngles(newAng)
	self:SetPos(self.spawnPos)
	self:SetMaterial( "models/debug/debugwhite", true )
	self.isTouched = false
	self.touchTimer = 0
	self.basePos = self:GetPos()
	self.baseAngle = self:GetAngles()
	local height = (self.basePos.z - JUMPBLOCKGAMEDATA.playfieldMins.z) / math.abs(JUMPBLOCKGAMEDATA.playfieldMins.z - JUMPBLOCKGAMEDATA.playfieldMaxs.z)
	local saturation = ((height * 360) + (math.sin(self.basePos.x * 0.002) * 60) + (math.sin(self.basePos.y * 0.002) * 60) + (math.sin(self.basePos.z * 0.002) * 60)) % 360
	self.randomColor = HSVToColor(saturation,0.3 + (height * 0.2),1)
	self:SetColor(self.randomColor)

end

function ENT:Think()
	if self.isTouched then
		local percent = (self.touchTimer - CurTime()) * 4
		self:SetColor(Color(self.randomColor.r,self.randomColor.g,self.randomColor.b, 255 * percent))
		if CurTime() > self.touchTimer then
			self:Remove()
			return
		end
		self:NextThink(CurTime())
		return true
	end

	for i, v in ipairs(player.GetAll()) do
		if self:GetPos():DistToSqr(v:GetPos()) <= 3600000 then
			self:SetPreventTransmit( v, false )
		else
			self:SetPreventTransmit( v, true )
		end
	end

	if self.firstThink == true then
		self.firstThink = false
		self:NextThink(CurTime() + 1 + self.perfTimer)
		return true
	else
		self:NextThink(CurTime() + 1)
		return true
	end
end

function ENT:Touch(ent)
	if ent:IsPlayer() and not self.isTouched then
		self.touchTimer = CurTime() + 0.25
		self.isTouched = true
		self:SetModelScale(2,0.25)
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self:NextThink(CurTime())
		local oldVel = ent:GetVelocity()
		local normal = self:GetAngles():Forward()
		local newVel = oldVel - (oldVel * normal)
		ent:SetGroundEntity(nil)
		ent:SetVelocity(-oldVel + (newVel * 0.5) + (normal * 750))
		ent:SetJumpLevel(0)
		ent:AllowCornerClip()
	end
end