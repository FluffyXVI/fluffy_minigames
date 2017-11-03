include('shared.lua')

local racer_icon = Material('icon16/flag_green.png', 'noclamp smooth')
local racer_icon_last = Material('icon16/star.png', 'noclamp smooth')

hook.Add('HUDPaint', 'PaintCheckpoints', function()
    local num = LocalPlayer():GetNWInt('Checkpoint')
    if num == 0 then return end
    local check = GAMEMODE.Checkpoints[ game.GetMap() ][ num ] + Vector( 0, 0, 48 )
    local pos = check:ToScreen()
    local distance = math.floor( check:Distance( LocalPlayer():GetPos() ) / 16 ) 
    
    draw.SimpleText( 'Checkpoint #' .. num, 'Default', pos.x, pos.y, color_white, TEXT_ALIGN_CENTER )
    draw.SimpleText( distance .. 'm', 'Default', pos.x, pos.y + 16, color_white, TEXT_ALIGN_CENTER )
    
    surface.SetDrawColor( color_white )
    if num == #GAMEMODE.Checkpoints[ game.GetMap() ] then surface.SetMaterial( racer_icon_last ) else surface.SetMaterial( racer_icon ) end
    
    surface.DrawTexturedRect( pos.x - 8, pos.y - 24, 16, 16 )
end )

surface.CreateFont('RacingFont', { font='Coolvetica', size=32 } )

ScoreRefreshPlayers = timer.Create('RefreshPlayers', 3, 0, function()
    if !ScorePane then return end
    local scores = {}
    for k,v in pairs( player.GetAll() ) do
        local score = v:GetNWInt('Checkpoint', 0 )
        table.insert( scores, {v, score} )
    end
    table.sort( scores, function( a, b ) return a[2] > b[2] end )
    
    ScorePane:Clear()
    local count = ScrW()*0.5 / 68
    count = math.floor( count )
    
    local n = math.min( #scores, count )
    local xx = ScrW()*0.25 - (n*34)
    
    for k,v in pairs(scores) do
        if k > count then return end
        ScorePane:CreatePlayer( v[1], xx )
        xx = xx + 68
    end
end )

function CreateScoringPane()
    local Frame = vgui.Create('DPanel')
    Frame:SetSize( ScrW() * 0.5, 96 )
    Frame:SetPos( ScrW() * 0.25, ScrH() - 72 )
    
    function Frame:CreatePlayer( ply, x )
        local p = vgui.Create('DPanel', Frame )
        p:SetPos( x, 0 )
        p:SetSize( 64, 64 )
        function p:Paint()
            local icons = wepchain

            local score = ply:GetNWInt('Checkpoint', 0 ) - 1
            draw.SimpleText( math.Clamp( score, 0, 100 ), 'RacingFont', 32, 40, color_white, TEXT_ALIGN_CENTER )
        end
        
        local Avatar = vgui.Create('AvatarImage', p )
        Avatar:SetSize( 36, 36 )
        Avatar:SetPos( 14, 0 )
        Avatar:SetPlayer( ply, 64 )
    end
    
    function Frame:Paint()
    
    end
    ScorePane = Frame
end

hook.Add('HUDPaint', 'RacingCoolHUD', function()
    if !IsValid( ScorePane ) then CreateScoringPane() end
end )