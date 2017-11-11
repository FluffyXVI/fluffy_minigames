include('shared.lua')

include('cl_hud')

--[[
    HOLY MACARONI SOMETHING IS IN THIS FILE NOW :O
    
    The HUD is still somewhere else. Sorry.
--]]

hook.Add("PlayerBindPress", "ThirdpersonToggle", function(pl, bind, pressed)
    if bind == "gm_showspare1" and pressed == true then
        if !GAMEMODE.ThirdpersonEnabled and !LocalPlayer():IsSuperAdmin() then return end
        if !LocalPlayer().Thirdperson then LocalPlayer().Thirdperson = false end
        LocalPlayer().Thirdperson = !( LocalPlayer().Thirdperson )
    end
end)


function GM:CalcView(pl, pos, angles, fov)
    if !self.ThirdpersonEnabled and !LocalPlayer():IsSuperAdmin() then return end
    local view = {}
    angles = pl:EyeAngles()
    if pl:Alive() and pl:GetObserverMode() == OBS_MODE_NONE and ( LocalPlayer().Thirdperson ) then
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