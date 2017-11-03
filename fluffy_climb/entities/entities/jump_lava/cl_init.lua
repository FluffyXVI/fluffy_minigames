include("shared.lua")

function ENT:Initialize()
	jumpGameLava = self
end

function ENT:Draw()
	--self:SetRenderBounds( Vector(-512,-512,-512), Vector(512,512,512), Vector(8192,8192,8192) )
	--self:DrawModel()
end

function ENT:Think()
end