include('shared.lua')

surface.CreateFont('SASFont', { font='Coolvetica', size=32 } )

ScoreRefreshPlayers = timer.Create('RefreshPlayers', 3, 0, function()
    if !ScorePane then return end
    local scores = {}
    for k,v in pairs( player.GetAll() ) do
        local score = v:GetNWInt('SAS_Progress', 0 )
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
            local score = ply:GetNWInt('SAS_Progress', 0 )
            draw.SimpleText( score, 'SASFont', 32, 40, color_white, TEXT_ALIGN_CENTER )
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

local axe_material = Material('fluffy/tomahawk_outline.png', 'noclamp smooth')

hook.Add('HUDPaint', 'SASCoolHUD', function()
    if !IsValid( ScorePane ) then CreateScoringPane() end
    
    local axes = LocalPlayer():GetNWInt('AxeCount', 0)
    if axes < 1 then return end
    
    local xx = 128
    surface.SetMaterial( axe_material )
    surface.SetDrawColor( color_white )
    for i=1,axes do
        surface.DrawTexturedRect( ScrW() - 72, ScrH() - xx, 64, 64 )
        xx = xx + 64
    end
end )