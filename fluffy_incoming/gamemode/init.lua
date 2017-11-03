AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

-- Nobody wins in Incoming
function GM:GetWinningPlayer()
    return nil
end

INCMaps = {}
DefaultProps = {}

-- Default model list
DefaultProps = {
	"models/clannv/incoming/box/box1.mdl",
	"models/clannv/incoming/box/box2.mdl",
	"models/clannv/incoming/box/box3.mdl",
	
	"models/clannv/incoming/cone/cone1.mdl",
	"models/clannv/incoming/cone/cone2.mdl",
	"models/clannv/incoming/cone/cone3.mdl",
	
	"models/clannv/incoming/cylinder/cylinder1.mdl",
	"models/clannv/incoming/cylinder/cylinder2.mdl",
	"models/clannv/incoming/cylinder/cylinder3.mdl",
	
	"models/clannv/incoming/hexagon/hexagon1.mdl",
	"models/clannv/incoming/hexagon/hexagon2.mdl",
	"models/clannv/incoming/hexagon/hexagon3.mdl",
	
	"models/clannv/incoming/pentagon/pentagon1.mdl",
	"models/clannv/incoming/pentagon/pentagon2.mdl",
	"models/clannv/incoming/pentagon/pentagon3.mdl",
	
	"models/clannv/incoming/sphere/sphere1.mdl",
	"models/clannv/incoming/sphere/sphere2.mdl",
	"models/clannv/incoming/sphere/sphere3.mdl",
	
	"models/clannv/incoming/triangle/triangle1.mdl",
	"models/clannv/incoming/triangle/triangle2.mdl",
	"models/clannv/incoming/triangle/triangle3.mdl"
}

-- Configurations for each map
INCMaps[ "inc_duo" ] = {
	[ "PropSpawnDelay" ] = 1.5,
	[ "FallingProps" ] = {},
	[ "Spot" ] = Vector( -1650, 5950, 6656 ),
	[ "Distance" ] = 9000
}

INCMaps[ "inc_rectangular" ] = {
	[ "PropSpawnDelay" ] = 1.5,
	[ "FallingProps" ] = {},
	[ "Spot" ] = Vector( 158, 1027, 3815 ),
	[ "Distance" ] = 8420
}

INCMaps[ "inc_linear" ] = {
	[ "PropSpawnDelay" ] = 2,
	[ "FallingProps" ] = {},
	[ "Spot" ] = Vector( 0, 4991, 3456 ),
	[ "Distance" ] = 12500
}

-- Register default props to each map
for k, v in pairs( INCMaps ) do
	table.Add( INCMaps[ k ][ "FallingProps" ], DefaultProps )
end

-- No weapons
function GM:PlayerLoadout( ply )

end

-- Prop
INCPropSpawnTimer = 0
local Delay = INCMaps[ game.GetMap() ].PropSpawnDelay
local Props = INCMaps[ game.GetMap() ].FallingProps
hook.Add("Tick", "TickPropSpawn", function()
    if GetGlobalString('RoundState') != 'InRound' then return end
    
	if ( INCPropSpawnTimer < CurTime() ) then
		for k, v in pairs( ents.FindByClass( "inc_prop_spawner" ) ) do
			INCPropSpawnTimer = CurTime() + Delay
			local Ent = ents.Create( "prop_physics" )
			Ent:SetModel( Props[ math.random( 1, #Props ) ] )
			Ent:SetPos( v:GetPos() )
			Ent:Spawn()
			Ent:GetPhysicsObject():SetMass( 40000 )
		end
	end
end )



-- Network resources
function IncludeResFolder( dir )

	local files = file.Find( dir.."*", "GAME" )
	local FindFileTypes = 
	{
		".mdl",
		".vmt",
		".vtf",
		".dx90",
		".dx80",
		".phy",
		".sw",
		".vvd",
		".wav",
		".mp3",
	}
	
	for k, v in pairs( files ) do
		for k2, v2 in pairs( FindFileTypes ) do
			if ( string.find( v, v2 ) ) then
				resource.AddFile( dir .. v )
			end
		end
	end
end

IncludeResFolder( "materials/models/clannv/incoming/" )

IncludeResFolder( "models/clannv/incoming/box/" )
IncludeResFolder( "models/clannv/incoming/cone/" )
IncludeResFolder( "models/clannv/incoming/cylinder/" )
IncludeResFolder( "models/clannv/incoming/hexagon/" )
IncludeResFolder( "models/clannv/incoming/pentagon/" )
IncludeResFolder( "models/clannv/incoming/sphere/" )
IncludeResFolder( "models/clannv/incoming/triangle/" )