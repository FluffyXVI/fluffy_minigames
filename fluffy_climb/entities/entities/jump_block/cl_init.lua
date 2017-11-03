include("shared.lua")

function ENT:Initialize()
	self:DestroyShadow()
	self.basePos = self:GetPos()
	self.baseAngle = self:GetAngles()
	local height = (self.basePos.z - JUMPBLOCKGAMEDATA.playfieldMins.z) / math.abs(JUMPBLOCKGAMEDATA.playfieldMins.z - JUMPBLOCKGAMEDATA.playfieldMaxs.z)
	local saturation = ((height * 360) + (math.sin(self.basePos.x * 0.002) * 40) + (math.sin(self.basePos.y * 0.002) * 40) + (math.sin(self.basePos.z * 0.002) * 40)) % 360
	self.randomColor = HSVToColor(saturation,0.5 + (height * 0.2),0.85 + (height * 0.15))
	self:SetModelScale(1,0)
	self.dark = (self.basePos.z - jumpGameLava:GetLavaHeight()) * 0.005
	self.dark = math.Clamp(self.dark, 0.5, 1)
	self.drawNum = 250
	self.curAlpha = 0
	if self:GetTrait() ~= "normal" then
		self.randomColor = HSVToColor(saturation,0.2 + (height * 0.15),0.85 + (height * 0.15))
	end
	if JUMPBLOCKGAMEDATA.curMutator == 3 then
		self.randomColor = Color(255,255,255)
	end
end

function ENT:Draw()
	render.SetLightingOrigin( Vector(0,0,-10000))
	render.SetLightingMode( 1 )
	self.dark = (self.basePos.z - jumpGameLava:GetLavaHeight()) * 0.005
	self.dark = math.Clamp(self.dark, 0.5, 1)
	local dist = self.basePos:Distance(EyePos())
	local maxDist = 2000 --GetConVar("pm_renderdistance"):GetInt() or 2000
	if maxDist < 5000 then
		if dist < maxDist then
			local scale = math.Clamp(dist - (maxDist - 250), 0, 255)
			self:SetModelScale(1 - (scale / 1000),0)
			if self.curAlpha ~= math.min(dist, 255) - scale or self.dark ~= self.olddark or self.drawNum ~= 0 then
				self.curAlpha = 255 - scale
				if LocalPlayer():ShouldDrawLocalPlayer() then
					self.curAlpha = math.min(dist, 255) - scale
				end
				if self:GetTrait() == "ice" then 
					self.curAlpha = self.curAlpha * 0.8
				end
				self:SetColor(Color(self.randomColor.r * self.dark,self.randomColor.g * self.dark,self.randomColor.b * self.dark,self.curAlpha))
			end
			self:DrawModel()
		end
	else
		self.curAlpha = 255
		if self.curAlpha ~= math.min(dist, 255) or self.dark ~= self.olddark or self.drawNum ~= 0 then
			if LocalPlayer():ShouldDrawLocalPlayer() then
				self.curAlpha = math.min(dist, 255)
			end
			if self:GetTrait() == "ice" then 
				self.curAlpha = self.curAlpha * 0.8
			end
			self:SetColor(Color(self.randomColor.r * self.dark,self.randomColor.g * self.dark,self.randomColor.b * self.dark,self.curAlpha))
		end
		self:DrawModel()
	end
	self.drawNum = math.max(self.drawNum - 1, 0)
	self.olddark = self.dark
	render.SetLightingMode( 0 )
end

function ENT:Think()
	self:NextThink(CurTime() + 100)
	return true
end