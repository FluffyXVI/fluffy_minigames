surface.CreateFont( "FS_16", {
	font = "Coolvetica",
	size = 20,
} )
surface.CreateFont( "FS_24", {
	font = "Coolvetica",
	size = 24,
} )
surface.CreateFont( "FS_32", {
	font = "Coolvetica",
	size = 32,
} )
surface.CreateFont( "FS_40", {
	font = "Coolvetica",
	size = 40,
} )
surface.CreateFont( "FS_60", {
	font = "Coolvetica",
	size = 48,
} )
surface.CreateFont( "FS_64", {
	font = "Coolvetica",
	size = 64,
} )

fs_col1 = Color(236, 240, 241)
fs_col2 = Color(52, 152, 219)
fs_col3 = Color(41, 128, 185)

include('drawarc.lua')
DEFINE_BASECLASS( 'base' )

local function drawCircle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondayAmmo = true,
    CHudCrosshair = true
} 

hook.Add( "HUDShouldDraw", "FluffyHideHUD", function( name )
	if ( hide[ name ] ) then return false end
end )

function GM:HUDPaint()
    local shouldDraw = GetConVar('cl_drawhud'):GetBool()
    if !shouldDraw then return end
    
    self:DrawRoundState()
    self:DrawHealth()
    self:DrawAmmo()
    
    hook.Run( "HUDDrawTargetID" )
	hook.Run( "HUDDrawPickupHistory" )
    hook.Run( "DrawDeathNotice", 0.85, 0.04 )
    
end

function GM:DrawRoundState()
    draw.NoTexture()
    local GAME_STATE = GetGlobalString('RoundState', 'GameNotStarted')
    local RoundTime = GetGlobalFloat('RoundStart')
    
    -- Only draw this if the game hasn't yet started
    if GAME_STATE == 'GameNotStarted' then
        draw.SimpleTextOutlined( 'Waiting For Players...', "FS_40", 4, 4, fs_col1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
        return
    end
    
    -- Draw message for end of rounds (if applicable)
    if EndGameMessage then
        draw.SimpleTextOutlined( EndGameMessage, "FS_32", ScrW()/2, 32, fs_col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
    
    -- Draw spectating message on bottom (very rare)
    if LocalPlayer():Team() == TEAM_SPECTATOR then
        draw.SimpleTextOutlined( 'You are a spectator', "FS_32", ScrW()/2, ScrH() - 32, fs_col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
    
    -- Draw the cool round timer
    if !RoundTime then return end
    if GAME_STATE == 'EndRound' then return end
    
	local tmax = GAMEMODE.RoundTime or 60
	if GAME_STATE == 'PreRound' then tmax = GAMEMODE.RoundCooldown or 5 end
	
	draw.Arc( 52, 52, 48, 48, 0, 360, 6, fs_col2 )
	
	local t = tmax - (CurTime() - RoundTime)
	if t < 0 then t = 0 end

	draw.Arc( 52, 52, 42, 18, math.Round((t/tmax * -360) + 90), 90, 1, fs_col1 )
	draw.SimpleTextOutlined( math.floor(t), "FS_40", 52, 52, fs_col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
	
	local round = GetGlobalInt('RoundNumber') or 1
	local rmax = GAMEMODE.RoundNumber or 5
    
	if round == rmax then
		draw.SimpleTextOutlined( 'Final Round!', "FS_24", 52, 116, fs_col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
	else
		draw.SimpleTextOutlined( round .. " / " .. rmax, "FS_24", 52, 116, fs_col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
	end
end

-- Bigger things are planned, I promise
function GM:DrawHealth()
    draw.SimpleTextOutlined( LocalPlayer():Health(), "FS_60", 4, ScrH()-4, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )
end

-- awful crosshair code
local function DrawCrosshair()
    local x = ScrW() / 2
    local y = ScrH() / 2
    
    local thick = 1
    local gap = 8
    local size = 8
    
    surface.SetDrawColor( color_white )
	surface.DrawRect(x - (thick/2), y - (size + gap/2), thick, size )
	surface.DrawRect(x - (thick/2), y + (gap/2), thick, size )
	surface.DrawRect(x + (gap/2), y - (thick/2), size, thick )
	surface.DrawRect(x - (size + gap/2), y - (thick/2), size, thick )
end

function GM:DrawAmmo()
    -- Check the player is alive and playing the game
    if !LocalPlayer():Alive() then return end
    if GAMEMODE_NAME != 'sandbox' then
        if GAMEMODE.TeamBased then
            if LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():Team() == TEAM_UNASSIGNED or LocalPlayer():Team() == 0 then return end
        end
    end
    
    -- There is room for improvement here! Weapons have lots of unusual cases
    -- Figure out the ammo and draw it
    local wep = LocalPlayer():GetActiveWeapon()
    if !IsValid( wep ) then return end
    if !wep.DoDrawCrosshair then DrawCrosshair() end
    
    local ammo = {}
    ammo['PrimaryClip'] = wep:Clip1()
    ammo['SecondaryClip'] = wep:Clip2()
    ammo['PrimaryAmmo'] = LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() )
    ammo['SecondaryAmmo'] = LocalPlayer():GetAmmoCount( wep:GetSecondaryAmmoType() )
    if wep.CustomAmmoDisplay then
        if wep:CustomAmmoDisplay() != nil then ammo = wep:CustomAmmoDisplay() end
    end
    if !ammo then return end
    if ammo['PrimaryClip'] == -1 then return end
    
    draw.SimpleTextOutlined( ammo['PrimaryClip'], "FS_60", ScrW()-60, ScrH()-4, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( ammo['PrimaryAmmo'],  "FS_24", ScrW()-16, ScrH()-8, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )
end