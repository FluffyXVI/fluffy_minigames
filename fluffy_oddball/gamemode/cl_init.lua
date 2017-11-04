include('shared.lua')

surface.CreateFont('OBFont', { font='Coolvetica', size=32 } )

ScoreRefreshPlayers = timer.Create('RefreshPlayers', 1.5, 0, function()
    if !ScorePane then return end
    local scores = {}
    for k,v in pairs( player.GetAll() ) do
        local score = v:GetNWInt('OB_Progress', 0 )
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
            local score = ply:GetNWInt('OB_Progress', 0 )
            draw.SimpleText( score, 'OBFont', 32, 40, color_white, TEXT_ALIGN_CENTER )
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

hook.Add('HUDPaint', 'OBCoolHUD', function()
    if !IsValid( ScorePane ) then CreateScoringPane() end
    
    -- Draw Oddball overlay here
    local ball = GetGlobalEntity('OddballEntity')
    if !IsValid( ball ) then return end
    if ball == LocalPlayer() then return end
    
    local off = Vector( 0, 0, 12 )
    if ball:GetClass() == 'player' then off = Vector( 0, 0, 76 ) end
    local pos = ( ball:GetPos() + off ):ToScreen()
    draw.SimpleText( 'Oddball', 'DermaDefault', pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end )