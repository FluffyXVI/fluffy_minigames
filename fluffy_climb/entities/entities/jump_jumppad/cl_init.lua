include("shared.lua")

function ENT:Initialize()
	self:DestroyShadow()
	self.normal = self:GetAngles():Forward()
	self.baseAngle = self:GetAngles() + Angle(90,0,0)
	self.basePos = self:GetPos()
	self:SetRenderOrigin(self.basePos + Vector(0,0,32))
end

function ENT:Draw()
	render.SetLightingMode( 1 )
	self.baseAngle:RotateAroundAxis(self:GetAngles():Up(),FrameTime() * 40)
	self:SetRenderAngles(self.baseAngle)
	self:DrawModel()
	render.SetLightingMode( 0 )
end

function ENT:Think()

end