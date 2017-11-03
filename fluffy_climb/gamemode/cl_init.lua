include('shared.lua')

local lavaMat = Material("lava")
local shadowMat = Material("shadow.png")
local rainMat = Material("rain.png", "smooth")

function GM:PostDrawTranslucentRenderables(bool, bool)
    if !JUMPBLOCKGAMEDATA then return end
    if !IsValid( jumpGameLava ) then return end
    
    render.SetMaterial(lavaMat)
    render.DrawQuadEasy( Vector(0,0,jumpGameLava:GetLavaHeight()),Vector(0,0,1), 8192, 8192)
    
    render.SetColorMaterial()
	render.DrawQuadEasy(Vector(0,0,JUMPBLOCKGAMEDATA.playfieldMaxs.z),Vector(0,0,-1),24000,24000,Color(80,200,80,100),0)
	render.DrawQuadEasy(Vector(0,0,JUMPBLOCKGAMEDATA.playfieldMaxs.z),Vector(0,0,1),24000,24000,Color(80,200,80,100),0)
end

--[[
function GM:PostDrawTranslucentRenderables(bool, bool)
    if !JUMPBLOCKGAMEDATA then return end
    if !IsValid( jumpGameLava ) then return end
    
	render.SetShadowColor( 255,255,255 )
	render.OverrideDepthEnable( true, true )
	render.SetMaterial(lavaMat)
	local bright = ((math.sin(CurTime() * 2) + 1) * 0.5) * 80
	render.DrawQuadEasy( Vector(0,0,jumpGameLava:GetLavaHeight()),Vector(0,0,1), 8192, 8192)
	render.SetColorMaterial()
	render.DrawQuadEasy(Vector(0,0,JUMPBLOCKGAMEDATA.playfieldMaxs.z),Vector(0,0,-1),24000,24000,Color(80,200,80,100),0)
	render.DrawQuadEasy(Vector(0,0,JUMPBLOCKGAMEDATA.playfieldMaxs.z),Vector(0,0,1),24000,24000,Color(80,200,80,100),0)
	render.SetColorMaterial()
	render.DrawQuadEasy( Vector(0,0,jumpGameLava:GetLavaHeight() + 2),Vector(0,0,1), 8192, 8192, Color(0,0,0,bright), 0 )
	if EyePos().z < jumpGameLava:GetLavaHeight() then
		render.DrawQuadEasy( Vector(0,0,jumpGameLava:GetLavaHeight()),Vector(0,0,-1), 8192, 8192)
	end
	local pl = LocalPlayer()
	local tr = util.TraceHull({
		start = pl:GetPos(),
		endpos = pl:GetPos() + Vector(0,0,-2048),
		filter = pl,
		mins = pl:OBBMins(),
		maxs = pl:OBBMaxs()
	})

	local eyepos = EyePos()
	local eyevec = EyeVector()
	local eyeang = EyeAngles()
	eyeang.p = 0
	eyevec.z = 0
	render.OverrideDepthEnable( true, false )
end
--]]