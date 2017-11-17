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
    self:NetworkVar( "Int",	0, "Par", { KeyName = "par" } )
end

function ENT:KeyValue( key, value )
	if key == "hole" then
		self:SetHole(value)
	elseif key == "par" then
        self:SetPar(value)
    end
end