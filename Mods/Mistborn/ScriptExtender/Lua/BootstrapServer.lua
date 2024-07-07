StatPaths={
    "Public/Mistborn/Stats/Generated/Data/ActionResource_MetalSlots.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Phy_Iron.txt",
    "Public/Mistborn/Stats/Generated/Data/Allomancy_Phy_Steel.txt",
    "Public/Mistborn/Stats/Generated/Data/Passives_Metals.txt",
}

local function on_reset_completed()
    for _, statPath in ipairs(StatPaths) do
        Ext.Stats.LoadStatsFile(statPath,1)
    end
    _P('Reloading stats!')
end

Ext.Events.ResetCompleted:Subscribe(on_reset_completed)