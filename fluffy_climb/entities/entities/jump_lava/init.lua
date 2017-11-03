
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube1x1x1.mdl")
	self:PhysicsInitShadow( false, false )
	self:SetSolid(SOLID_VPHYSICS)
	self.firstThink = true
	self:SetLavaHeight(JUMPBLOCKGAMEDATA.lavaStartHeight)
	jumpGameLava = self
	self.hurtTimer = {}
end
--[[
local function mySetupVis( pl )
	AddOriginToPVS( jumpGameLava:GetPos() )
end
hook.Add( "SetupPlayerVisibility", "AddLava", mySetupVis )
--]]

function ENT:Think()
	if self.hurtTimer == nil then
		self.hurtTimer = {}
	end
	local lowest = 2500
	local allPL = player.GetAll()
	if #allPL > 0 then
		for i, v in ipairs(allPL) do
			if self.hurtTimer[v] == nil then
				self.hurtTimer[v] = CurTime() + 0.5
			end
			if v:GetPos().z <= self:GetLavaHeight() - 72 and CurTime() > self.hurtTimer[v] then
				self.hurtTimer[v] = CurTime() + 0.5
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(100)
				dmginfo:SetDamageType(DMG_BURN)
				dmginfo:SetInflictor(self)
				dmginfo:SetAttacker(self)
				v:TakeDamageInfo(dmginfo)
			end
			if v:GetPos().z <= self:GetLavaHeight() and CurTime() > self.hurtTimer[v] then
				self.hurtTimer[v] = CurTime() + 0.5
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(5)
				dmginfo:SetDamageType(DMG_BURN)
				dmginfo:SetInflictor(self)
				dmginfo:SetAttacker(self)
				v:TakeDamageInfo(dmginfo)
			end
			if v:Alive() and v:GetObserverMode() == OBS_MODE_NONE and v:GetPos().z - self:GetLavaHeight() < lowest and not v.gameWon then
				lowest = v:GetPos().z - self:GetLavaHeight()
			end
		end
		local raiseSpeed = math.max(20 * (lowest * 0.01), 20)
		self:NextThink(CurTime())
		local world = game.GetWorld()
        if GetGlobalString('RoundState', 'GameNotStarted') != 'GameNotStarted' then
            if CurTime() - GetGlobalFloat('RoundStart') > JUMPBLOCKGAMEDATA.lavaStartTime then
                self:SetLavaHeight(self:GetLavaHeight() + (raiseSpeed * FrameTime()))
            end
        end
		return true
	end
end