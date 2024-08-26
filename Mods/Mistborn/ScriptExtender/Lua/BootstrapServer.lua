Ext.Require("Mistborn_Additions.lua")

StatPaths={
    "Public/Mistborn/Stats/Generated/Data/ActionResource_MetalReserves.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Physical_Iron.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Physical_Steel.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Physical_Tin.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Physical_Pewter.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Mental_Zinc.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Mental_Brass.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Mental_Bronze.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Mental_Copper.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Temporal_Gold.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Temporal_Electrum.txt",
    "Public/Mistborn/Stats/Generated/Data/Passives_Metals.txt",
}

local function on_reset_completed()
    for _, statPath in ipairs(StatPaths) do
        Ext.Stats.LoadStatsFile(statPath,1)
    end
    _P('Reloading stats!')
end

Ext.Events.ResetCompleted:Subscribe(on_reset_completed)