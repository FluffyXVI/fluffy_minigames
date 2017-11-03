
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local function WeightedRandom(randTable)
	local total = 0
	local total2 = 0
	local choice = nil
	for k, v in pairs(randTable) do
		total = total + v.weight
	end
	--print("total.. " .. total)
	util.SharedRandom("sharedrand",0,1,CurTime())
	local rand = math.random() * total
	--print("rand.. " .. rand)
	for k, v in pairs(randTable) do
		total2 = total2 + v.weight
		if rand < total2 then choice = v.item break end
	end
	return choice
end

function ENT:Initialize()
	for i, v in ipairs(player.GetAll()) do
		self:SetPreventTransmit( v, true )
	end

	local blockType = self.blockType

	if JUMPBLOCKGAMEDATA.curMutator == 3 then
		local randomHL2ModelTable = {}
		local tempID = 1
		randomHL2ModelTable[tempID] = {}
		randomHL2ModelTable[tempID].item = "models/props_junk/wood_crate001a.mdl"
		randomHL2ModelTable[tempID].weight = 25
		tempID = tempID + 1
		randomHL2ModelTable[tempID] = {}
		randomHL2ModelTable[tempID].item = "models/props_junk/wood_crate002a.mdl"
		randomHL2ModelTable[tempID].weight = 25
		tempID = tempID + 1
		randomHL2ModelTable[tempID] = {}
		randomHL2ModelTable[tempID].item = "models/props_lab/blastdoor001b.mdl"
		randomHL2ModelTable[tempID].weight = 25
		tempID = tempID + 1
		randomHL2ModelTable[tempID] = {}
		randomHL2ModelTable[tempID].item = "models/props_lab/blastdoor001c.mdl"
		randomHL2ModelTable[tempID].weight = 50
		tempID = tempID + 1
		randomHL2ModelTable[tempID] = {}
		randomHL2ModelTable[tempID].item = "models/props_c17/FurnitureCouch001a.mdl"
		randomHL2ModelTable[tempID].weight = 50
		tempID = tempID + 1
		randomHL2ModelTable[tempID] = {}
		randomHL2ModelTable[tempID].item = "models/props_junk/TrashDumpster01a.mdl"
		randomHL2ModelTable[tempID].weight = 100
		tempID = tempID + 1
		randomHL2ModelTable[tempID] = {}
		randomHL2ModelTable[tempID].item = "models/props_junk/TrashDumpster02.mdl"
		randomHL2ModelTable[tempID].weight = 100
		tempID = tempID + 1
		randomHL2ModelTable[tempID] = {}
		randomHL2ModelTable[tempID].item = "models/props_interiors/VendingMachineSoda01a.mdl"
		randomHL2ModelTable[tempID].weight = 100
		tempID = tempID + 1
		randomHL2ModelTable[tempID] = {}
		randomHL2ModelTable[tempID].item = "models/props_wasteland/cargo_container01.mdl"
		randomHL2ModelTable[tempID].weight = 10
		self.trait = "normal"

		blockType = WeightedRandom(randomHL2ModelTable)
	end

	self:SetModel(blockType)
	local angleTable = {}
	curID = 1
	angleTable[curID] = {}
	angleTable[curID].item = 0
	angleTable[curID].weight = 100
	curID = curID + 1
	angleTable[curID] = {}
	angleTable[curID].item = 90
	angleTable[curID].weight = 50
	curID = curID + 1
	angleTable[curID] = {}
	angleTable[curID].item = 180
	angleTable[curID].weight = 100
	curID = curID + 1
	angleTable[curID] = {}
	angleTable[curID].item = 270
	angleTable[curID].weight = 50
	if JUMPBLOCKGAMEDATA.curMutator == 3 then
		curID = curID + 1
		angleTable[curID] = {}
		angleTable[curID].item = 45
		angleTable[curID].weight = 25
		curID = curID + 1
		angleTable[curID] = {}
		angleTable[curID].item = 135
		angleTable[curID].weight = 25
		curID = curID + 1
		angleTable[curID] = {}
		angleTable[curID].item = 225
		angleTable[curID].weight = 25
		curID = curID + 1
		angleTable[curID] = {}
		angleTable[curID].item = 315
		angleTable[curID].weight = 25
	end

	local angleTable2 = {}
	curID = 1
	angleTable2[curID] = {}
	angleTable2[curID].item = 0
	angleTable2[curID].weight = 100
	curID = curID + 1
	angleTable2[curID] = {}
	angleTable2[curID].item = 90
	angleTable2[curID].weight = 50
	curID = curID + 1
	angleTable2[curID] = {}
	angleTable2[curID].item = 180
	angleTable2[curID].weight = 100
	curID = curID + 1
	angleTable2[curID] = {}
	angleTable2[curID].item = 270
	angleTable2[curID].weight = 50

	if JUMPBLOCKGAMEDATA.curMutator == 3 then
		curID = curID + 1
		angleTable2[curID] = {}
		angleTable2[curID].item = 45
		angleTable2[curID].weight = 25
		curID = curID + 1
		angleTable2[curID] = {}
		angleTable2[curID].item = 135
		angleTable2[curID].weight = 25
		curID = curID + 1
		angleTable2[curID] = {}
		angleTable2[curID].item = 225
		angleTable2[curID].weight = 25
		curID = curID + 1
		angleTable2[curID] = {}
		angleTable2[curID].item = 315
		angleTable2[curID].weight = 25
	end


	local randAng1 = WeightedRandom(angleTable)
	local randAng2 = WeightedRandom(angleTable)
	local randAng3 = WeightedRandom(angleTable)
	local randAng4 = WeightedRandom(angleTable2)
	local newAng = Angle(randAng1,randAng2,randAng3)
	newAng:RotateAroundAxis(Vector(0,0,1),randAng4)
	self:SetAngles(newAng)
	self:PhysicsInitShadow( false, false )
	self:SetSolid(SOLID_VPHYSICS)
	self:SetPos(self.spawnPos)
	self.firstThink = true
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor(255,255,255,0)
	self:SetTrait(self.trait)
	if JUMPBLOCKGAMEDATA.curMutator ~= 3 then
		self:SetMaterial( "jumpbox", true )
		if self.trait == "sand" then
			self:SetMaterial("sand")
		end
		if self.trait == "ice" then
			self:SetMaterial("ice")
		end
	end
end

function ENT:Think()
	local pos = self:GetPos()
	for i, v in ipairs(player.GetAll()) do
		local dist = v:GetInfoNum("pm_renderdistance",2000)
		dist = dist + 500
		if pos:DistToSqr(v:GetPos()) <= dist * dist then
			self:SetPreventTransmit( v, false )
		else
			self:SetPreventTransmit( v, true )
		end
	end

	if pos.z < jumpGameLava:GetLavaHeight() - 256 then
		self:Remove()
	end
	if self.firstThink == true then
		self.firstThink = false
		self:NextThink(CurTime() + 0.5 + self.perfTimer)
		return true
	else
		self:NextThink(CurTime() + 0.5)
		return true
	end
end