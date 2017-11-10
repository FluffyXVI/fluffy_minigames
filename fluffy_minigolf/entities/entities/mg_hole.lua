AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Hole"

if CLIENT then
    function ENT:Draw()
        return
    end
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int",	0, "Hole", { KeyName = "hole" } )
end

function ENT:KeyValue( key, value )
	if key == "hole" then
		self:SetHole(value)
	end
end