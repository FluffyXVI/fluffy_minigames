include('shared.lua')

--[[
    HOLY MACARONI SOMETHING IS IN THIS FILE NOW :O
    
    The HUD is still somewhere else. Sorry.
--]]

local thirdperson = false
hook.Add("PlayerBindPress", "ThirdpersonToggle", function(pl, bind, pressed)
    if !GAMEMODE.ThirdpersonEnabled then return end
    if bind == "gm_showspare1" and pressed == true then
        thirdperson = !thirdperson
    end
end)


function GM:CalcView(pl, pos, angles, fov)
    if !self.ThirdpersonEnabled then return end
    local view = {}
    angles = pl:EyeAngles()
    if pl:Alive() and pl:GetObserverMode() == OBS_MODE_NONE and ( thirdperson or frontperson ) then
        view.fov = GetConVar( "default_fov" ):GetFloat()
        local newP = angles.p
        if angles.p <= -45 then angles.p = (angles.p - 45) * 0.5 newP = (newP - 45) * 0.5 end
        local newAng = Angle(newP, angles.y, angles.r)
        local tr = util.TraceLine({
            start = pos,
            endpos = pos - ( newAng:Forward() * 150 ),
            filter = pl
        })

        if tr.Entity:IsWorld() then
            view.origin = tr.HitPos + Vector(0,0,24)
        else
            view.origin = pos - ( newAng:Forward() * 150 ) + Vector(0,0,24)
        end

        view.angles = angles
        view.drawviewer = true
    else
        view.fov = GetConVar( "default_fov" ):GetFloat()
        view.origin = pos
        view.angles = angles
    end


    return view
end