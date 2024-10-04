---@diagnostic disable: undefined-global
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

Ext.Osiris.RegisterListener("UsingSpell", 5, "before", function(_, spell, _, _, _)
    if spell == "BendalloyBubble_End" then
        local combatParticipants = Osi["DB_Is_InCombat"]:Get(nil, nil)
        for _, row in pairs(combatParticipants) do
            local participantTpl = row[1]
            local participantGUID = string.sub(participantTpl, -36)
            local participantEntity = Ext.Entity.Get(participantGUID)
            if Osi.HasActiveStatus(participantTpl,"BENDALLOY_HASTE") == 1 then
                Osi.ApplyStatus(participantTpl,"TIMEBUBBLE_LETHARGY_IMMUNITY",1)
                participantEntity:Replicate("CombatParticipant")
            end
        end
    end
    if spell == "CadmiumBubble_End" then
        local combatParticipants = Osi["DB_Is_InCombat"]:Get(nil, nil)
        for _, row in pairs(combatParticipants) do
            local participantTpl = row[1]
            local participantGUID = string.sub(participantTpl, -36)
            local participantEntity = Ext.Entity.Get(participantGUID)
            if Osi.HasActiveStatus(participantTpl,"CADMIUM_SLOW") == 1 then
                Osi.ApplyStatus(participantTpl,"TIMEBUBBLE_LETHARGY_IMMUNITY",1)
                participantEntity:Replicate("CombatParticipant")
            end
        end
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

Ext.Osiris.RegisterListener("StartedPreviewingSpell", 4, "before", function(caster, spell, _, _, _)
    if string.match(spell,"Iron") or string.match(spell,"Steel") or string.match(spell,"CoinShot") then
        Osi.ApplyStatus(caster,"ALLOMANCY_AURA",-1)
    end
end)
