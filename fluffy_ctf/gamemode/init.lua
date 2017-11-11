AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

--[[
    Is it too late to say sorry?
--]]

-- General override in Fluffy Shop addon
-- Some gamemodes have their own overrides

hook.Add('PreRoundStart', 'ResetOBRank', function()
    print("hook")
    self:SpawnRedFlag()
end )

function GM:SpawnRedFlag()
    print("spawn")
    local spawnpos = self.RedFlagSpawns[ game.GetMap() ]
    if spawnpos then
        local flag = ents.Create('ent_flag')
        flag:SetPos( spawnpos )
        flag:Spawn()
        --SetGlobalEntity('OddballEntity', ball )
    else
        print('Fatal error; no spawns are on this map.')
    end
end