PersistentVars = {}

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(_, target, spell, _, _, _)
    if Osi.HasActiveStatus(target,"IRONREDIRECTION_PROTECTION") == 1 then
        if not PersistentVars['IronRedirectionSpellBlocked'] then
            PersistentVars['IronRedirectionSpellBlocked'] = nil
        end
        PersistentVars['IronRedirectionSpellBlocked'] = spell
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, _,_)
    if status == "IRONREDIRECTION_ACTIVATED" then
        Osi.UseSpell(object, PersistentVars['IronRedirectionSpellBlocked'],PersistentVars['IronRedirectionAuraOwner'])
        Osi.RemoveStatus(object,"IRONREDIRECTION_ACTIVATED","")
    end
    if status == "IRONREDIRECTION_AURA" then
        if not PersistentVars['IronRedirectionAuraOwner'] then
            PersistentVars['IronRedirectionAuraOwner'] = nil
        end
        PersistentVars['IronRedirectionAuraOwner']=object
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, _, _, _)
    if string.match(spell,"AlterFightingStyle") then
        local entity = Ext.Entity.Get(caster)
        local levelups = entity.CCLevelUp.LevelUps
        for _,levelup in ipairs(levelups) do
            local passives = levelup.Upgrades.Passives
            for i,passive in ipairs(passives) do
                if passive.PassiveList == "923d687c-af54-45d8-898f-6d498a037a53" then
                    passives[i] = nil
                    
                end
            end
        end
        entity:Replicate("CCLevelUp")
    end
end)

Ext.Osiris.RegisterListener("StartedPreviewingSpell", 4, "after", function(caster, spell, isMostPowerful, hasMultipleLevels)
    
end)


--[[
Ext.Osiris.RegisterListener("StartedPreviewingSpell", 4, "before", function(_caster, _spell, _, _, _)
    -- print("Init spell preview listener: ", _caster, _spell);
    local uuid = GetGUIDFromTpl(_caster)
    local isNecromancySpellSchool = Ext.Stats.Get(_spell).SpellSchool == "Necromancy";
    local hasGreaterNecromancyPassive = Osi.HasPassive(uuid, "CursedTome_TheBegining_GreaterNecromancy_Passive") == 1;
    local hasGreaterNecromancyBuff = Osi.HasActiveStatus(uuid, "CURSEDTOME_THEBEGINING_GREATERNECROMANCY_BUFF") == 1;
    -- print("Is Necromancy: ", isNecromancySpellSchool);
    -- print("Has greater necromancy passive: ", hasGreaterNecromancyPassive);
    -- print("Has greater necromancy buff: ", hasGreaterNecromancyBuff);

    if not isNecromancySpellSchool and hasGreaterNecromancyPassive then
        -- print ("Removing greater necromancy buff")
        Osi.RemoveStatus(uuid, "CURSEDTOME_THEBEGINING_GREATERNECROMANCY_BUFF");
        return
    end

    if isNecromancySpellSchool and hasGreaterNecromancyPassive and not hasGreaterNecromancyBuff  then
        -- print("Applying greater necromancy buff");
        Osi.ApplyStatus(uuid, "CURSEDTOME_THEBEGINING_GREATERNECROMANCY_BUFF", -1);
    end
end)
--]]

