local function Accelerate(pl, move, wishdir, wishspeed, accel)
	if pl:GetWalljumpTimer() > CurTime() and pl:CanCornerClip() then return end
	local playerVelocity = move:GetVelocity()
	local currentspeed = playerVelocity:Dot(wishdir)
	local addspeed = wishspeed - currentspeed
	if (addspeed <= 0) then return end
    if !pl.accelMult then return end
	local accelspeed = accel * FrameTime() * wishspeed * pl.accelMult

	if (accelspeed > addspeed) then
		accelspeed = addspeed
	end
	playerVelocity = playerVelocity + (wishdir * accelspeed)
	move:SetVelocity(playerVelocity)
end

function DoStepup(pl, move, dist, vel, maxIts)
	if vel == nil then vel = move:GetVelocity() end
	local dir = vel:GetNormalized()
	local trace = util.TraceHull({
		start = move:GetOrigin(),
		endpos = move:GetOrigin() + (dir * dist),
		filter = pl,
		mins = pl:OBBMins(),
		maxs = pl:OBBMaxs()
	})

	if trace.Hit == true and not trace.Entity:IsPlayer() then
		local trace2 = util.TraceHull({
			start = trace.HitPos + dir + Vector(0,0,24),
			endpos = trace.HitPos + dir,
			filter = pl,
			mins = pl:OBBMins(),
			maxs = pl:OBBMaxs()
		})
		if not trace2.AllSolid then
			if vel.z > 80 then
				pl:AllowCornerClip()
				return
			elseif trace2.HitNormal.z > 0.95 then
				move:SetOrigin(trace2.HitPos)
				if vel.z <= 80 then vel.z = 0 end
				if not move:KeyDown(IN_JUMP) then
					move:SetVelocity(Vector(vel.x * 0.4, vel.y * 0.4, vel.z))
				else
					move:SetVelocity(vel)
				end
				if maxIts > 0 and dist > 0 then
					DoStepup(pl, move, dist - 1, vel, maxIts - 1)
				end
			end
		end
	end
end

hook.Add("SetupMove", "AirStepUp", function(pl, move, cmd)
	if not pl:Alive() then cmd:ClearButtons() cmd:ClearMovement() return end
	if pl:OnGround() then return end
	local vel = move:GetVelocity()
	vel.z = 0
	dist = vel:Length() * FrameTime()
	DoStepup(pl, move, dist, move:GetVelocity(), 20)
end)

hook.Add("PlayerTick", "WSpeed", function(pl, move)

	if CurTime() < pl:GetLastWalljump() + 0.3 then return end
	local vel = move:GetVelocity()
	if move:GetForwardSpeed() ~= 0 and move:GetSideSpeed() == 0 then
		move:SetVelocity(vel + (move:GetAngles():Forward() * 80 * FrameTime()))
	end

	if vel.z <= -500 then
		move:SetVelocity(Vector(vel.x, vel.y, -500))
	end

end)

hook.Add("PlayerTick", "CalcPlayerHeight", function(pl, move)
	pl.heightPercent = (pl:GetPos().z + -JUMPBLOCKGAMEDATA.playfieldMins.z) / (JUMPBLOCKGAMEDATA.playfieldHeight - 72)
end)

hook.Add("PlayerTick", "HandleMutators", function(pl, move)

	if JUMPBLOCKGAMEDATA.curMutator == 1 then
		move:SetVelocity(move:GetVelocity() + JUMPBLOCKGAMEDATA.windDir:Forward() * ((pl.heightPercent * 0.75) + 0.25) * FrameTime() * 500)
	end
	if JUMPBLOCKGAMEDATA.curMutator == 2 then
		if pl:GetGravity() ~= 0.4 then
			pl:SetGravity(0.4)
		end
	else
		if pl:GetGravity() ~= 1 then
			pl:SetGravity(1)
		end
	end

end)

hook.Add("PlayerTick", "HandleTraits", function(pl, move)

	if not pl.frictionMult then
		pl.frictionMult = 1
	end
	if not pl.accelMult then
		pl.accelMult = 1
	end

	local tr = util.TraceHull({
		start = pl:GetPos(),
		endpos = pl:GetPos() - Vector(0,0,4),
		filter = pl,
		mins = Vector(-16,-16,0),
		maxs = Vector(16,16,1)
	})

	if pl:OnGround() and tr.Hit and tr.Entity:GetClass() == "jump_block" then
		if tr.Entity:GetTrait() == "normal" then
			pl.frictionMult = 1
			pl.accelMult = 1
		elseif tr.Entity:GetTrait() == "sand" then
			pl.frictionMult = 2
			pl.accelMult = 0.75
		elseif tr.Entity:GetTrait() == "ice" then
			pl.frictionMult = 0.2
			pl.accelMult = 0.2
		end
	else
		pl.accelMult = 1
		pl.frictionMult = 1
	end

end)

hook.Add("PlayerTick", "WallJump", function(pl, move, cmd)
	if not pl:Alive() then pl:SetWalljumpSpeed(0) pl:SetWalljumpTimer(0) pl:SetWalljumpVel(Vector(0,0,0)) pl:SetLastWalljump(0) return end
	if pl:OnGround() then
		pl:SetJumpLevel(0)
		pl:SetWalljumpSpeed(0)
		pl:SetOldWalljumpSpeed(0)
		pl:SetLastWalljump(0)

		return
	end

	local vel = move:GetVelocity()
	local noZ = vel
	noZ.z = 0
	local velLength = noZ:Length()


	if pl:GetOldWalljumpSpeed() ~= nil then
		if velLength < pl:GetOldWalljumpSpeed() and pl:GetOldWalljumpSpeed() - velLength > 100 then
			pl:SetWalljumpTimer(CurTime() + 0.25)
			pl:SetWalljumpSpeed(pl:GetOldWalljumpSpeed())
			pl:SetWalljumpVel(pl:GetOldWalljumpVel())
		end
		if pl:GetWalljumpTimer() < CurTime() then
			pl:SetWalljumpSpeed(velLength)
			pl:SetWalljumpVel(noZ)
		end
		pl:SetOldWalljumpSpeed(velLength)
		pl:SetOldWalljumpVel(noZ)
	else
		pl:SetOldWalljumpSpeed(0)
		pl:SetOldWalljumpVel(Vector(0,0,0))
		pl:SetWalljumpSpeed(0)
		pl:SetWalljumpTimer(0)
		pl:SetWalljumpVel(Vector(0,0,0))
	end
	if not move:KeyPressed(IN_JUMP) then return end
	local ang = pl:GetWalljumpVel():GetNormalized():Angle()
	local didJump = false
	local curVel = move:GetVelocity()
	curVel.z = 0
	for i = 1, 8 do
		local trace = util.TraceHull({
			start = move:GetOrigin(),
			endpos = move:GetOrigin() + (Angle(0, ang.y + ((i - 1) * 45), 0):Forward() * 16) + (curVel * FrameTime()),
			filter = pl,
			mins = pl:OBBMins() + Vector(1, 1, 0),
			maxs = pl:OBBMaxs() - Vector(1, 1, 0)
		})
	
		if trace.Hit and pl:GetWalljumpSpeed() > 300 and pl:GetWalljumpVel():GetNormalized():Dot(trace.HitNormal) < 0.1 and CurTime() > pl:GetLastWalljump() + 0.3 then
			--print(trace.Hit)
			--print(trace.HitNormal)
			local wjVel = pl:GetWalljumpVel()
			local tempVelZ = math.max(vel.z * 0.65,0)
			wjVel.z = 0
			local fixedNormal = trace.HitNormal
			fixedNormal.z = 0
			local reflecVec = -2 * wjVel:Dot(trace.HitNormal) * trace.HitNormal + wjVel
			local newDir = (reflecVec:GetNormalized() + fixedNormal):GetNormalized()
			local sub = 0
			if pl:GetWalljumpTimer() < CurTime() then
				sub = 160
			end
			if math.abs(wjVel:GetNormalized():Dot(trace.HitNormal)) <= 0.6 then
				move:SetVelocity(newDir * (pl:GetWalljumpSpeed() - sub) + Vector(0, 0, 300 + tempVelZ))
			else
				move:SetVelocity(reflecVec:GetNormalized() * (pl:GetWalljumpSpeed() - sub) + Vector(0, 0, 300 + tempVelZ))
			end
			for j = 1, 4 do
				--ParticleEffect("doublejump_smoke", pl:GetPos() + Vector(0, 0, 10), pl:GetAngles(), pl)
			end
			didJump = true
			pl:SetLastWalljump(CurTime())
			pl:AllowCornerClip()
			break
		end
	end
	if didJump == false then
		--print("hey")
		
		local tempVel = move:GetVelocity()
		ang = move:GetMoveAngles()
		local tempVelZ = math.max(tempVel.z * 0.75,0)
		tempVel.z = 0
		ang.p = 0
		local redirect = ((ang:Forward() * move:GetForwardSpeed()) + (ang:Right() * move:GetSideSpeed())):GetNormalized()

		pl:SetJumpLevel(pl:GetJumpLevel() + 1)

		if pl:GetJumpLevel() > pl:GetMaxJumpLevel() then
			--print("no jump")
			return
		end

		local jumpVel = 300


		if tempVel:Length() > (pl:GetWalkSpeed() - 10) then
			move:SetVelocity(tempVel + Vector(0,0,jumpVel + tempVelZ))
			--print("set velocity")
		else
			move:SetVelocity((redirect * pl:GetRunSpeed()) + Vector(0,0,jumpVel + tempVelZ))
			--print("set velocity")
		end
	
		pl:DoCustomAnimEvent(PLAYERANIMEVENT_JUMP , -1)
		pl:AllowCornerClip()

		for i = 1, 4 do
			--ParticleEffect("doublejump_smoke", pl:GetPos() + Vector(0, 0, 10), pl:GetAngles(), pl)
		end
	end
end)

hook.Add("PlayerTick", "CrouchSlide", function(pl, move)
	if not pl:Alive() then return end
	if move:KeyDown(IN_JUMP) then return end
	if not pl:OnGround() then return end
	local vel = move:GetVelocity()
	local velLength = vel:Length2D()

	if velLength ~= 0 then
		local slideMult = 8 * pl.frictionMult
		if move:KeyDown(IN_DUCK) then
			slideMult = 4 * pl.frictionMult
		end
		local drop = velLength * slideMult * FrameTime()
		local newVelLength = velLength * (math.max(velLength - drop, 0) / velLength)
		local dir = vel:GetNormalized()
		local newVel = dir * newVelLength
		move:SetVelocity(newVel)
		return
	end

end)

hook.Add("PlayerTick", "Longjump", function(pl, move)
	if not pl:OnGround() then return end
	if not pl:Alive() then return end
	if move:KeyDown(IN_JUMP) and pl:OnGround() then
		pl:SetGroundEntity(nil)
		local trace = util.TraceHull({
			start = move:GetOrigin(),
			endpos = move:GetOrigin() + (move:GetVelocity() * FrameTime()) - Vector(0,0,4),
			maxs = Vector(16, 16, 1),
			mins = Vector(-16, -16, 0),
			filter = pl
		})

		if trace.Hit then
			local tempVel = move:GetVelocity()
			local normal = tempVel:GetNormalized()
			local len = tempVel:Length()
			local reflecVec = -2 * tempVel:Dot(trace.HitNormal) * trace.HitNormal + tempVel
			reflecVec:Normalize()
			local dot = -normal:Dot(trace.HitNormal)
			if dot <= 0 then
				dot = 1
			else
				dot = 1 - dot
			end

			local tr = util.TraceHull({
				start = pl:GetPos(),
				endpos = pl:GetPos() - Vector(0,0,4),
				filter = pl,
				mins = Vector(-16,-16,0),
				maxs = Vector(16,16,1)
			})

			local moveMult = 1
			if tr.Hit and tr.Entity:GetClass() == "jump_block" and tr.Entity:GetTrait() == "sand" then
				moveMult = 0.75
			end

			--print(dot)

			local newVel = ((normal * dot) + (reflecVec * (1 - dot))) * len
			--print(len, trace.HitNormal)
			move:SetVelocity((newVel + Vector(0,0,360 + math.max(tempVel.z,0))) * moveMult)
			pl:AllowCornerClip()
		end
	end
end)

hook.Add("PlayerTick", "Glide", function(pl, move)

end)

hook.Add("PlayerTick", "Strafejump", function(pl, move)
	if not pl:Alive() then return end
	if not pl:OnGround() then
		local aim = move:GetMoveAngles()
		local forward, right = aim:Forward(), aim:Right()
		local fmove = move:GetForwardSpeed()
		local smove = move:GetSideSpeed()
		forward[3], right[3] = 0, 0
		forward:Normalize()
		right:Normalize()
		local wishvel = forward * fmove + right * smove
		wishvel[3] = 0
		local wishspeed = wishvel:Length()

		if (wishspeed > move:GetMaxSpeed()) then
			wishvel = wishvel * (move:GetMaxSpeed() / wishspeed)
			wishspeed = move:GetMaxSpeed()
		end

		local wishdir = wishvel:GetNormal()
		local strafeAccel = 1.25
		local airAccel = 30
		Accelerate(pl, move, wishdir, wishspeed, strafeAccel)

		if (wishspeed > 50) then
			wishvel = wishvel * (50 / wishspeed)
			wishspeed = 50
		end
		Accelerate(pl, move, wishdir, wishspeed, airAccel)
	end
end)

hook.Add("PlayerTick", "GroundAccelerate", function(pl, move)
	if not pl:Alive() then return end
	if pl:OnGround() then
		local aim = move:GetMoveAngles()
		local forward, right = aim:Forward(), aim:Right()
		local fmove = move:GetForwardSpeed()
		local smove = move:GetSideSpeed()
		forward[3], right[3] = 0, 0
		forward:Normalize()
		right:Normalize()
		local wishvel = forward * fmove + right * smove
		wishvel[3] = 0
		local wishspeed = wishvel:Length()

		if (wishspeed > move:GetMaxSpeed()) then
			wishvel = wishvel * (move:GetMaxSpeed() / wishspeed)
			wishspeed = move:GetMaxSpeed()
		end

		local wishdir = wishvel:GetNormal()
		local strafeAccel = 10
		Accelerate(pl, move, wishdir, wishspeed, strafeAccel)
	end
end)

hook.Add("PlayerTick", "Ducktap", function(pl, move)
	if not pl:Alive() then return end
	if pl:OnGround() and not pl:Crouching() then
		if move:KeyDown( IN_DUCK ) then
			if pl:GetDuckTime() < CurTime() then
				pl:SetDuckTime(CurTime() + (pl:GetDuckSpeed() + FrameTime()))
			end
		elseif pl:GetDuckTime() > CurTime() then
			pl:SetDuckTime(CurTime())
		end
	end
end)

hook.Add("PlayerTick", "WTurn", function(pl, move)
		if not pl:Alive() then return end
		if pl:OnGround() and not pl:Crouching() then return end
		if CurTime() < pl:GetLastWalljump() + 0.3 then return end
		local fmove = move:GetForwardSpeed() / 10000
		if fmove <= 0 then return end
		local smove = move:GetSideSpeed()
		if smove ~= 0 then return end
		local vel = move:GetVelocity()
		oldZ = vel.z
		vel.z = 0
		local velLength = vel:Length()
		local ang = move:GetAngles()
		ang.p = 0
		local newDir = ang:Forward() * fmove
		local trackspeed = math.abs(fmove) * (41 - math.max(velLength * 0.01, 1)) * FrameTime() * 75
		local airTurnMult = 1
		if pl:OnGround() then trackspeed = trackspeed * 2
		elseif pl:Crouching() then trackspeed = trackspeed * airTurnMult * 0.5
		else trackspeed = trackspeed * airTurnMult end
		local posTrack = newDir * trackspeed
		vel = vel + posTrack
		vel:Normalize()
		vel = vel * velLength
		move:SetVelocity(Vector(vel.x, vel.y, oldZ))

end)

hook.Add("Move", "CornerClip", function(pl, move, cmd)
	if not pl:Alive() then pl.knockbackVel = Vector(0,0,0) return end
	if pl.knockbackVel then
		local kvel = pl.knockbackVel
		local velocity = move:GetVelocity()
		move:SetVelocity(velocity + kvel)
		pl.knockbackVel = nil
	end
	if pl:CanCornerClip() then pl:SetCornerClipVel(move:GetVelocity()) end
end)

hook.Add("FinishMove", "CornerClipFinish", function(pl, move, cmd)
	if not pl:Alive() then pl:SetCornerClipVel(Vector(0,0,0)) return end
	if pl:OnGround() then return end
	if pl:CanCornerClip() then move:SetVelocity(pl:GetCornerClipVel() + Vector(0,0,-800 * FrameTime())) end
end)

function GM:Move(pl, move)
end

function GM:FinishMove(pl, move)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:GetLongJumpTime()
	return self:GetDTFloat(16)
end

function PLAYER:SetLongJumpTime(time)
	self:SetDTFloat(16, time)
end

function PLAYER:AllowCornerClip()
	self:SetDTFloat(15, CurTime() + 0.25)
end

function PLAYER:CanCornerClip()
	return self:GetCornerClipTime() > CurTime()
end

function PLAYER:GetCornerClipTime()
	return self:GetDTFloat(15)
end

function PLAYER:SetCornerClipTime(time)
	self:SetDTFloat(15, time)
end

function PLAYER:GetCornerClipVel()
	return self:GetDTVector(14)
end

function PLAYER:SetCornerClipVel(vel)
	self:SetDTVector(14, vel)
end

function PLAYER:GetJumpLevel()
	return self:GetDTInt(23)
end

function PLAYER:SetJumpLevel(level)
	self:SetDTInt(23, level)
end

function PLAYER:GetMaxJumpLevel()
	return self:GetDTInt(24)
end

function PLAYER:SetMaxJumpLevel(level)
	self:SetDTInt(24, level)
end

function PLAYER:GetExtraJumpPower()
	return self:GetDTFloat(25)
end

function PLAYER:SetExtraJumpPower(power)
	self:SetDTFloat(25, power)
end

function PLAYER:GetLastWalljump()
	return self:GetDTInt(28)
end

function PLAYER:SetLastWalljump(var)
	self:SetDTInt(28, var)
end

function PLAYER:GetOldWalljumpSpeed()
	return self:GetDTInt(18)
end

function PLAYER:SetOldWalljumpSpeed(var)
	self:SetDTInt(18, var)
end

function PLAYER:GetOldWalljumpVel()
	return self:GetDTVector(19)
end

function PLAYER:SetOldWalljumpVel(var)
	self:SetDTVector(19, var)
end

function PLAYER:GetWalljumpSpeed()
	return self:GetDTInt(20)
end

function PLAYER:SetWalljumpSpeed(var)
	self:SetDTInt(20, var)
end

function PLAYER:GetWalljumpTimer()
	return self:GetDTFloat(21)
end

function PLAYER:SetWalljumpTimer(var)
	self:SetDTFloat(21, var)
end

function PLAYER:GetWalljumpVel()
	return self:GetDTVector(22)
end

function PLAYER:SetWalljumpVel(var)
	self:SetDTVector(22, var)
end

function PLAYER:GetDuckTime()
	return self:GetDTFloat(31)
end

function PLAYER:SetDuckTime(time)
	self:SetDTFloat(31, time)
end