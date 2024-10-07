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

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee,_)
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
    if (status == "CHARMED_BRASS" or status == "MENTAL_DURALUMIN_EMOTIONLESS" or status == "FRIGHTENED_ZINC" or status == "FEARED_ZINC") and (Osi.HasPassive(causee,'Class_Feature_Spreading_Hysteria')==1 and Osi.HasActiveStatus(causee,'HYSTERIA_COOLDOWN')~=1) then
        local smallest1,smallest2,smallest3 = math.huge,math.huge,math.huge
        local smallestob1,smallestob2,smallestob3 = "","",""
        for k, v in pairs(Osi.DB_Is_InCombat:Get(nil, Osi.CombatGetGuidFor(Ext.Entity.Get(object).Uuid.EntityUuid))) do
            if(IsEnemy(v[1],causee) == 1 and v[1] ~= object) then
                local distance = Osi.GetDistanceTo(object, v[1])
                if (distance <= 10) then
                    if distance < smallest1 then
                        smallest3 = smallest2
                        smallest2 = smallest1
                        smallest1 = distance
                        smallestob3 = smallestob2
                        smallestob2 = smallestob1
                        smallestob1 = v[1]
                    elseif distance < smallest2 then
                        smallest3 = smallest2
                        smallest2 = distance
                        smallestob3 = smallestob2
                        smallestob2 = v[1]
                    elseif distance < smallest3 then
                        smallest3 = distance
                        smallestob3 = v[1]
                    end
                end
            end
        end
        if (Osi.HasPassive(causee,'Class_Feature_Mass_Hysteria')==1) then
            if (status == "CHARMED_BRASS") then
                if (smallestob3 ~= "") then
                    Osi.ApplyStatus(smallestob3,"CHARMED_BRASS_ATTEMPT",1,100,causee)
                end
                if (smallestob2 ~= "") then
                    Osi.ApplyStatus(smallestob2,"CHARMED_BRASS_ATTEMPT",1,100,causee)
                end
                if (smallestob1 ~= "") then
                    Osi.ApplyStatus(smallestob1,"CHARMED_BRASS_ATTEMPT",1,100,causee)
                end
            end
            if (status == "MENTAL_DURALUMIN_EMOTIONLESS") then
                if (smallestob3 ~= "") then
                    Osi.ApplyStatus(smallestob3,"MENTAL_DURALUMIN_EMOTIONLESS_ATTEMPT",1,100,causee)
                end
                if (smallestob2 ~= "") then
                    Osi.ApplyStatus(smallestob2,"MENTAL_DURALUMIN_EMOTIONLESS_ATTEMPT",1,100,causee)
                end
                if (smallestob1 ~= "") then
                    Osi.ApplyStatus(smallestob1,"MENTAL_DURALUMIN_EMOTIONLESS_ATTEMPT",1,100,causee)
                end
            end
            if (status == "FRIGHTENED_ZINC") then
                if (smallestob3 ~= "") then
                    Osi.ApplyStatus(smallestob3,"FRIGHTENED_ZINC_ATTEMPT",1,100,causee)
                end
                if (smallestob2 ~= "") then
                    Osi.ApplyStatus(smallestob2,"FRIGHTENED_ZINC_ATTEMPT",1,100,causee)
                end
                if (smallestob1 ~= "") then
                    Osi.ApplyStatus(smallestob1,"FRIGHTENED_ZINC_ATTEMPT",1,100,causee)
                end
            end
            if (status == "FEARED_ZINC") then
                if (smallestob3 ~= "") then
                    Osi.ApplyStatus(smallestob3,"FEARED_ZINC_ATTEMPT",1,100,causee)
                end
                if (smallestob2 ~= "") then
                    Osi.ApplyStatus(smallestob2,"FEARED_ZINC_ATTEMPT",1,100,causee)
                end
                if (smallestob1 ~= "") then
                    Osi.ApplyStatus(smallestob1,"FEARED_ZINC_ATTEMPT",1,100,causee)
                end
            end
        elseif (Osi.HasPassive(causee,'Class_Feature_Spreading_Hysteria')==1) then
            if (status == "CHARMED_BRASS" and smallestob1 ~= "") then
                Osi.ApplyStatus(smallestob1,"CHARMED_BRASS_ATTEMPT",1,100,causee)
            end
            if (status == "MENTAL_DURALUMIN_EMOTIONLESS" and smallestob1 ~= "") then
                Osi.ApplyStatus(smallestob1,"MENTAL_DURALUMIN_EMOTIONLESS_ATTEMPT",1,100,causee)
            end
            if (status == "FRIGHTENED_ZINC" and smallestob1 ~= "") then
                Osi.ApplyStatus(smallestob1,"FRIGHTENED_ZINC_ATTEMPT",1,100,causee)
            end
            if (status == "FEARED_ZINC" and smallestob1 ~= "") then
                Osi.ApplyStatus(smallestob1,"FEARED_ZINC_ATTEMPT",1,100,causee)
            end
        end
        Osi.ApplyStatus(causee,'HYSTERIA_COOLDOWN',1,100)
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