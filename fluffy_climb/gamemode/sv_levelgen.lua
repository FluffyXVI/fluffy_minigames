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

function GetRandomBlocks()
	modelTable = {}
	local curID = 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/1x1x1.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/2x1x1.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/2x2x1.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x1x1.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x2x2.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x1.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x2.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/2x2x1l.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/2x2x2l.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/3x2x1t.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/3x2x2t.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/3x3x1c.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/3x3x2c.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x1l.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x2l.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/6x4x1t.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/6x4x2t.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/6x6x1c.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/6x6x2c.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/2x2x2cyl.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/2x2x1cyl.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x2cyl.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x1cyl.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/3x2x1l.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/3x2x1z.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/3x2x2l.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/3x2x2z.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x2x4bracket.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x2x4tunnel.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x4benis.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x4bracket.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x4corner.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x4tunnel.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/6x4x1l.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/6x4x1z.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/6x4x2l.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/6x4x2z.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/1x1x1tri.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/1x1x2tri.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/2x2x1tri.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/2x2x2tri.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x1tri.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1
	modelTable[curID] = {}
	modelTable[curID].item = "models/platformmaster/4x4x2tri.mdl"
	modelTable[curID].weight = math.random(0, 100)
	curID = curID + 1

	return modelTable
end

function GetBlockTypes()
	local possibleBlockTable = {}
	possibleBlockTable[1] = {}
	possibleBlockTable[1].blockType = "jump_block"
	possibleBlockTable[1].weight = 100
	possibleBlockTable[2] = {}
	possibleBlockTable[2].blockType = "jump_jumppad"
	possibleBlockTable[2].weight = 6
	return possibleBlockTable
end

function CreateWorldGenTable()
	local tempTable = {}
	tempTable.numStrands = 2
	tempTable.numBlocksPerStrand = 50
	tempTable.blocksPerChunkMin = 1
	tempTable.blocksPerChunkMax = 1
	tempTable.curPosPowerMax = 400
	tempTable.curPosPowerMin = 200
	tempTable.curPosPowerChange = 60
	tempTable.curPosPowerCurrent = math.random(tempTable.curPosPowerMax, tempTable.curPosPowerMin)
	tempTable.curPosAngleChange = 130
	tempTable.curPosAngleCurrent = math.random(0, 360)
	tempTable.randomAddHorizMax = 200
	tempTable.randomAddHorizMin = 100
	tempTable.randomAddVertMax = 120
	tempTable.randomAddVertMin = 50
	tempTable.randomAddHorizChange = 60
	tempTable.randomAddVertChange = 15
	tempTable.randomAddHorizCurrent = math.random(-tempTable.randomAddHorizMax, tempTable.randomAddHorizMax)
	tempTable.randomAddVertCurrent = math.random(-tempTable.randomAddVertMax, tempTable.randomAddVertMax)
	tempTable.angleTable = {}
	tempTable.angleTable[1] = 0
	tempTable.angleTable[2] = 90
	tempTable.angleTable[3] = 180
	tempTable.angleTable[4] = 270
	return tempTable
end

function blockGen(its, randomseed)
	local newSeed = math.Round(SysTime() * 10000, 0)
	if randomseed then
		newSeed = randomseed
		math.randomseed(newSeed + its)
	else
		math.randomseed(newSeed + its)
	end

	local genData = CreateWorldGenTable()
	local possibleBlockTable = GetBlockTypes()
	local num = genData.numBlocksPerStrand
	local iterations = 1
	local mins = JUMPBLOCKGAMEDATA.playfieldMins
	local maxs = JUMPBLOCKGAMEDATA.playfieldMaxs
	local height = math.abs(mins.z - maxs.z)
	local curPos = Vector(math.random(-1650, 1650), math.random(-1650, 1650), mins.z - 300)
	local tempBlockTable = GetRandomBlocks()
	while iterations < num do
		local numBlocksInLoop = math.random(genData.blocksPerChunkMin,genData.blocksPerChunkMax)
		local newXY = Angle(0,genData.curPosAngleCurrent, 0):Forward() * genData.curPosPowerCurrent
		local newZ = height * (numBlocksInLoop * (1 / num))
		local newCurPosAdd = newXY + Vector(0,0,newZ)
		curPos = curPos + newCurPosAdd

		genData.curPosPowerCurrent = genData.curPosPowerCurrent + math.random(-genData.curPosPowerChange, genData.curPosPowerChange)
		genData.curPosPowerCurrent = math.Clamp(genData.curPosPowerCurrent, genData.curPosPowerMin, genData.curPosPowerMax)

		genData.curPosAngleCurrent = (genData.curPosAngleCurrent + math.random(-genData.curPosAngleChange, genData.curPosAngleChange)) % 360

		if not curPos:WithinAABox(mins,maxs) then
			curPos.x = math.Clamp(curPos.x, mins.x, maxs.x)
			curPos.y = math.Clamp(curPos.y, mins.y, maxs.y)
			curPos.z = math.Clamp(curPos.z, mins.z, maxs.z)
			genData.curPosAngleCurrent = math.random(0,360)
		end

		newCurPosAdd.z = 0

		local blockTraitTable = {}
		blockTraitTable[1] = {}
		blockTraitTable[1].item = "normal"
		blockTraitTable[1].weight = 100
		blockTraitTable[2] = {}
		blockTraitTable[2].item = "ice"
		blockTraitTable[2].weight = 0
		blockTraitTable[3] = {}
		blockTraitTable[3].item = "sand"
		blockTraitTable[3].weight = 0

		local blockTrait = WeightedRandom(blockTraitTable)

		for i = 1, numBlocksInLoop, 1 do
			local total = 0
			local total2 = 0
			local choice = ""
			for n, v in ipairs(possibleBlockTable) do
				total = total + v.weight
			end
			--print("total.. " .. total)
			local rand = math.random() * total
			--print("rand.. " .. rand)
			for n, v in ipairs(possibleBlockTable) do
				total2 = total2 + v.weight
				if rand < total2 then choice = v.blockType break end
			end

			local newAdd = 0
			local newMult = 1
			if choice == "jump_jumppad" then
				newAdd = 256
				newMult = 2
			end

			local randomAdd = Vector(
				math.random(-genData.randomAddHorizCurrent,genData.randomAddHorizCurrent) * newMult,
				math.random(-genData.randomAddHorizCurrent,genData.randomAddHorizCurrent) * newMult,
				math.random(-genData.randomAddVertCurrent,genData.randomAddVertCurrent) + newAdd)
			jumpBlockTable[i] = ents.Create(choice)
			jumpBlockTable[i].perfTimer = (1 / num) * (i + iterations)
			jumpBlockTable[i].spawnPos = curPos + randomAdd
			jumpBlockTable[i].spawnRotation = genData.curPosAngleCurrent
			jumpBlockTable[i].trait = blockTrait
			jumpBlockTable[i].blockType = WeightedRandom(tempBlockTable)
			jumpBlockTable[i]:Spawn()
		end
		genData.randomAddHorizCurrent = genData.randomAddHorizCurrent + math.random(-genData.randomAddHorizChange, genData.randomAddHorizChange)
		genData.randomAddHorizCurrent = math.Clamp(genData.randomAddHorizCurrent, genData.randomAddHorizMin, genData.randomAddHorizMax)

		genData.randomAddVertCurrent = genData.randomAddVertCurrent + math.random(-genData.randomAddVertChange, genData.randomAddVertChange)
		genData.randomAddVertCurrent = math.Clamp(genData.randomAddVertCurrent, genData.randomAddVertMin, genData.randomAddVertMax)

		iterations = iterations + numBlocksInLoop
	end
	if its > 1 then
		blockGen(its - 1, newSeed)
	end
end