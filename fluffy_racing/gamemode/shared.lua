DeriveGamemode('fluffy_base')

GM.Name = 'Go Karts!'
GM.Author = 'FluffyXVI'

GM.TeamBased = false	-- Is the gamemode FFA or Teams?
GM.Elimination = false

GM.RoundNumber = 5      -- How many rounds?
GM.RoundTime = 240     -- Seconds each round lasts for

function GM:Initialize()

end

GM.CarTypes = {}
--GM.CarTypes['gmr_ldt_nevada_v2'] = 'gokart'

GM.CarAngles = {}
GM.CarAngles['gmr_ldt_nevada_v2'] = Angle(0, -90, 0)
GM.CarAngles['gm_bgc_track01_pak'] = Angle(0, -180, 0)
GM.CarAngles['gm_bgc_track02_pak'] = Angle(0, 90, 0)
GM.CarAngles['gmr_bowserscastle_v2'] = Angle(0, 90, 0)
GM.CarAngles['gm_tinytown_pak'] = Angle(0, 90, 0)

GM.Checkpoints = {}
GM.Checkpoints['gm_track_rijeka'] = {
    Vector( -3440 , 7885, 0 ),
    Vector( 1526, 3040, 0 ),
    Vector( 860, 450, 0 ),
    Vector( 1050, -2922, 0 ),
    Vector( 4412, -5916, 0 ),
    Vector( 2030, -9335, 0 ),
    Vector( -4373, -8926, 0 ),
    Vector( 967, -7416, 0 ),
    Vector( -1024, 0, 0 ),
}

GM.Checkpoints['gm_track_bresse'] = {
    Vector( 11568.811523, 8362.560547, 0.031254   ),
    Vector( 5757.719727, 11658.731445, 0.031250   ),
    Vector( -2778.373291, 12013.554688, 0.031250  ),
    Vector( 4386.956055, 8190.115234, 0.031250    ),
    Vector( 1356.719971, 4510.215820, 0.031250    ),
    Vector( 287.927155, 1239.914185, 0.031250     ),
    Vector( -4990.748047, -4064.750977, 0.031250  ),
    Vector( -4698.336914, 5941.145508, 0.031250   ),
    Vector( -2076.364258, 8907.772461, 0.031250   ),
    Vector( -6996.282227, 12368.855469, 0.031250  ),
    Vector( -9648.127930, 12080.584961, 0.031250  ),
    Vector( -11663.794922, 4649.933594, 0.031250  ),
    Vector( -11223.333008, -2449.525391, 0.031250 ),
    Vector( -8229.892578, -12381.841797, 0.031250 ),
    Vector( -641.891724, -13973.442383, 0.031250  ),
    Vector( 8713.667969, -13575.820313, 0.031250  ),
    Vector( 1733.320557, -10452.126953, 0.031250  ),
    Vector( -1083.661865, -6432.125977, 0.031250  ),
    Vector( 5547.914063, 955.219116, 0.031254     ),
}

GM.Checkpoints['gmr_ldt_nevada_v2'] = {
    Vector( 7011.901367, 6142.620605, 1.031250     ),
    Vector( 8444.951172, 2495.331055, 1.031250     ),
    Vector( 4487.936523, 1020.777710, -230.968765  ),
    Vector( 3040.916016, -4772.692871, -1022.968750),
    Vector( -639.375854, -6144.782227, -1022.968750),
    Vector( -7295.811035, -6123.242188, -510.968750),
    Vector( -8693.824219, -1192.577881, 1.031235   ),
    Vector( -8722.178711, 3611.626953, 1.031250    ),
    Vector( -6176.499023, 6152.852051, 1.031258    ),
    Vector( 118.830963, 6143.599609, 1.031250      ),
}

GM.Checkpoints['gmr_bowserscastle_v2'] = {
    Vector( 175, -6857, -715 ),
    Vector( -4503, -3414, -715 ),
    Vector( -5719, 785, -715 ),
    Vector( -9859, 7510, -715 ),
    Vector( -4057, 7493, -295 ),
    Vector( -2461, 3398, -295 ),
    Vector( 1173, -126, -715 ),
    Vector( 4002, 4591, -715 ),
    Vector( 8766, 5061, -133 ),
    Vector( 8448, -6859, -715 ),
    Vector( 4389, -6860, -715 ),
}


GM.Checkpoints['gm_bgc_track01_pak'] = {
    Vector( 504, -2424, 5 ),
    Vector( 1525, -1031, 381 ),
    Vector( 1547, 2145, 381 ),
    Vector( -1233, 3032, 381 ),
    Vector( -1566, 676, 8 ),
    Vector( -1573, -4254, 5 ),
    Vector( -2791, -3156, 5 ),
    Vector( -2822, 1676, 5 ),
    Vector( -246, 5718, 5 ),
    Vector( -40, -195, 5 ),
}

GM.Checkpoints['gm_bgc_track02_pak'] = {
    Vector( -3022, 5282, 8 ),
    Vector( -3109, 4078, 8 ),
    Vector( 87, 2119, 8 ),
    Vector( 75, -2726, 8 ),
    Vector( 2656, -4760, 380 ),
    Vector( -1472, -5487, 384 ),
    Vector( -4622, -2511, 8 ),
    Vector( -2225, -393, 9 ),
    Vector( 2371, -368, 9 ),
    Vector( 3712, 780, 8 ),
    Vector( 296, 5272, 8 ),
}

GM.Checkpoints['gm_tinytown_pak'] = {
    Vector( 864, 5250, -896 ),
    Vector( -1967, 6014, -896 ),
    Vector( -2291, 7148, -896 ),
    Vector( -1031, 7684, -896 ),
    Vector( 1129, 8819, -896 ),
    Vector( 3238, 8419, -896 ),
    Vector( 2027, 7803, -640 ),
    Vector( 3623, 6026, -768 ),
    Vector( 6064, 7405, -896 ),
    Vector( 6931, 6668, -768 ),
    Vector( 6260, 5890, -640 ),
    Vector( 3971, 4580, -896 ),
    Vector( 1351, 4214, -678 ),
}
