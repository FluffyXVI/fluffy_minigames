include('shared.lua')

function GM:NextSpectate()
    if !self.SpectateTable then self.SpectateTable = ents.FindByClass('mg_ball') end
    if !self.SpectatePos then self.SpectatePos = 1 end
end

function GM:CalcView( pl, origin, angles, fov, znear, zfar )
    if false then return view end
    
	local view = {}
	view.origin		= origin
	view.angles		= angles
	view.fov		= fov
	view.znear		= znear
	view.zfar		= zfar
	view.drawviewer	= false
	local ball = pl:GetNWEntity( "ball", nil )
	local camera = pl:GetNWEntity( "camera", nil )
	if ball ~= nil and ball:IsValid() then
        if self.SpectateTable then self.SpectateTable = nil end
        if self.SpectatePos then self.SpectatePos = nil end
		angles.p = 15
		view.origin = ball:GetPos() + (-angles:Forward() * 80) + Vector(0,0,24)
		view.angles = angles
		view.fov = 65
    elseif self.SpectatePos then
        local ent = self.SpectateTable[ self.SpectatePos ]
        if !self.SpectateTable then return view end
        if !IsValid( ent ) then return view end
        angles.p = 15
		view.origin = ent:GetPos() + (-angles:Forward() * 80) + Vector(0,0,24)
		view.angles = angles
		view.fov = 65
    else
        self:NextSpectate()
    end
	return view
end

local function StopDisappearBall( ply )
    local ball = ply:GetNWEntity( "ball", nil )
    if ball then AddOriginToPVS( ball:GetPos() ) end
end
hook.Add( "SetupPlayerVisibility", "MinigolfVis", StopDisappearBall )

hook.Add( "PreDrawHalos", "AddHalos", function()
    local ball = LocalPlayer():GetNWEntity( "ball", nil )
    local color = LocalPlayer():GetPlayerColor() *  255
    --if ball then halo.Add( {ball}, Color( color.r, color.g, color.b ), 5, 5, 5, true, true ) end
end )