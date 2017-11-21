AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

-- Nobody wins in Incoming
function GM:GetWinningPlayer()
    return nil
end

-- No weapons
function GM:PlayerLoadout( ply )

end