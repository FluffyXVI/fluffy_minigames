AddCSLuaFile()

ENT.Base = "base_brush"
ENT.Type = "brush"

if CLIENT then return end

function ENT:SetBounds(min, max)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(min, max)
	self:SetTrigger(true)
end

function ENT:StartTouch(ent)
	if ent:GetClass() == "mg_ball" then
		ent.Inbounds = true
	end
    print( 'Ball is in bounds [ST]' )
end

--[[
function ENT:Touch(ent)
	if ent:GetClass() == "mg_ball" then
		ent.Inbounds = true
	end
    print( 'Ball is in bounds [T]' )
end
--]]

function ENT:EndTouch( ent)
	if ent:GetClass() == "mg_ball" then
		ent.Inbounds = false
	end
    print( 'Ball is out of bounds [ET]' )
end