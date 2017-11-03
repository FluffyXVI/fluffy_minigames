
ENT.Type 			= "anim"
ENT.PrintName		= "Turret"
ENT.Author			= "Upset"

ENT.Spawnable		= true

ENT.RenderGroup		= RENDERGROUP_BOTH

function ENT:SetupDataTables()

	self:NetworkVar("String",0,"Trait")

end